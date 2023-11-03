//rotta per notifiche
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
var pagopa = require('../pagopa/pagopa');
var auth = require('../utils/auth');
var mail = require('../email/email');
var utils = require('../utils/utils');
var verbali = require('../routes/verbali');
const path = require("path");
const fs = require("fs");
const base64url = require('base64url');

router.get("/getPagatori", function (req, res) {

    try {

        conn.client.safequery(`select * from pagopa.vw_anagrafica_pagatori`, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                res.json(result.rows).end();
            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})

router.post("/insertSanzione", auth.authenticateToken, async function (req, res) {

    //const idNotificante = req.authData.idUtente;
    const sanzione = req.body;
    var idUtente = -1;
    try {
        idUtente = req.authData.idUtente;
    } catch (e) {
        console.log(e);
    }

    console.log(JSON.stringify(sanzione))

    // async/await
    try {
        var ret = { esito: null, msg: null, codiciCreati: null };
        //check cap/comune
        let comune = sanzione.info_pagatore.trasgressore.comune;
        let capsResult = await conn.client.safequery(`SELECT reverse_cap from public.comuni1 where upper(nome) = '${comune.toUpperCase().trim()}'`);
        capsResult.rows.forEach((caps) => {
            let cap = sanzione.info_pagatore.trasgressore.cap.trim();
            if (!caps.reverse_cap.includes(cap)) {
                ret.esito = false;
                ret.msg = `CAP ${cap} errato, i CAP possibili per il comune specificato ${comune} sono (${caps.reverse_cap})`;
                res.json(ret).end();
            }
        })
        if (ret.esito != false) {
            var query = `select * from pagopa.ins_sanzione('${JSON.stringify(sanzione).toUpperCase().replace(/'/g, "''")}', ${idUtente})`;
            console.log(query);
            conn.client.safequery(query, async (err, result) => {
                if (err) {
                    console.log("error in query");
                    console.log(err.stack)
                    res.writeHead(500).end();
                } else {
                    console.log(result.rows);
                    if (result.rows[0].esito) {
                        let codiciCreati = [];
                        let urlAvvisi = [];
                        console.log(result.rows[0].info) //in info ho la lista di pagamenti generati, devo farne gli envelope e inviarli in post a mypay
                        let pagamenti = result.rows[0].info.split(',');
                        var i = 0;
                        for (i = 0; i < pagamenti.length; i++) {
                            let pagamento = await pagopa.creaPagamento(pagamenti[i]);
                            if (pagamento.esito != 'OK') {
                                ret.esito = false;
                                ret.msg = pagamento.codice;
                                res.json(ret).end();
                                break;
                            } else { //OK
                                codiciCreati.push(pagamento.codice);
                                urlAvvisi.push(pagamento.urlFileAvviso);
                            }
                        }
                        if (i != pagamenti.length) { //se non ho iterato su tutti i pagamenti annullo quelli riusciti in precedeneza
                            for (let j = i - 1; j >= 0; j--) {
                                console.log("Annullo il pagamento", pagamenti[j]);
                                await pagopa.annullaPagamento(pagamenti[j])
                            }
                        } else {
                            let avviso = 'Avviso';
                            let creato = 'creato';
                            if (pagamenti.length > 1) {
                                avviso = 'Avvisi';
                                creato = 'creati';
                            }
                            ret.esito = true;
                            ret.msg = avviso + ' di Pagamento ' + creato + ' correttamente con Codice Avviso: 3' + codiciCreati.join("; ");
                            ret.html = avviso + ' di Pagamento ' + creato + ' correttamente con <br> Codice Avviso: 3' + codiciCreati.join("; ");
                            ret.codiciCreati = codiciCreati;

                            // Invia la sanzione tramite PEC
                            /*
                            if (sanzione.info_pagatore.trasgressore.mod_contestazione == 'P')//se contestazione PEC
                                mail.sendEmailAvvisiDiPagamento(sanzione.info_pagatore.trasgressore.email, urlAvvisi)
                            */

                            res.json(ret).end();
                        }
                    } else {
                        ret.esito = false;
                        ret.msg = result.rows[0].msg;
                        res.json(ret).end();
                    }

                }
            })
        }


    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})

router.get("/getSanzioneInfo", function (req, res) {
    try {
        const idSanzione = req.query.idIspezioneFase;
        let query = `select p.id as p_id, identificativo_univoco_dovuto, identificativo_univoco_versamento, importo_singolo_versamento, 
        replace(url_file_avviso, '&amp;', '&') url_file_avviso, 
        stato_pagamento,
        denominazione_attestante,
        denominazione_beneficiario, esito_singolo_pagamento, identificativo_univoco_riscossione,
        singolo_importo_pagato, data_esito_singolo_pagamento, codice_esito_pagamento,
        a.*, n.tipo_notifica, n.data_notifica, codice_avviso,
        p.data_generazione_iuv, p.data_scadenza
        from pagopa.pagopa_pagamenti p
        join pagopa.pagopa_anagrafica_pagatori a on p.id_pagatore = a.id
        left join pagopa.pagopa_sanzioni_pagatori_notifiche n on n.id_pagamento = p.id
        where id_sanzione = ${idSanzione} and esito_invio = 'OK' and p.trashed_date is null`;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                try {

                    let pagamenti = result.rows;
                    let pagato = false;
                    for (let i = 0; i < pagamenti.length; i++) {

                        //controllo se c'è un pagato prima e dopo l'aggioramento, se c'è breakko e annullo gli altri
                        if (pagamenti[i].stato_pagamento != 'PAGAMENTO COMPLETATO') {
                            pagamenti[i] = await pagopa.aggiornaStatoPagamento(pagamenti[i])
                            if (pagamenti[i]?.stato_pagamento == 'PAGAMENTO COMPLETATO')
                                pagato = true;
                        } else {
                            pagato = true;
                        }
                        if (pagato) {
                            console.log("TROVATO PAGATO ", pagamenti[i].p_id)
                            break;
                        }

                    }
                    if (pagato) { //se trovo un pagato, annullo gli altri e ritorno solo il pagato
                        let pagamentoPagato = [];
                        for (let i = 0; i < pagamenti.length; i++) {
                            if (pagamenti[i].stato_pagamento == 'PAGAMENTO COMPLETATO')
                                pagamentoPagato[0] = pagamenti[i];
                            else if (pagamenti[i].stato_pagamento != 'ANNULLATO') {
                                console.log("ANNULLO  ", pagamenti[i].p_id)
                                await pagopa.annullaPagamento(pagamenti[i].p_id);
                            }

                        }
                        res.json(pagamentoPagato).end();
                    } else {
                        res.json(pagamenti).end();
                    }
                } catch (err) {
                    console.log(err.stack)
                    res.writeHead(500).end();
                }
            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})


router.get("/getSanzioniDaAllegare", auth.authenticateToken, function (req, res) {

    const idUtente = req.authData.idUtente;

    try {
        let query = `
            select p.id p_id, p.codice_avviso, i.proc_pen, i.rgnr,
            string_agg(v.punto_verbale_prescrizione, ', ') as punto_verbale_prescrizione, string_agg(v.articolo_violato, ', ') as articolo_violato, string_agg(v.norma, ', ') as norma,
            p.stato_pagamento, i.id_utente,
            p.data_scadenza, p.data_generazione_iuv, i.descrizione, i.n_protocollo, m.descr as verbale, coalesce(n.data_notifica, to_char(p.data_generazione_iuv, 'YYYY-MM-DD')) as data_notifica, n.tipo_notifica,
            replace(url_file_avviso, '&amp;', '&') url_file_avviso
            from pagopa.pagopa_pagamenti p
            join pagopa.pagopa_pagamenti_info_verbale i on p.id = i.id_pagamento
            left join pagopa.violazione v on v.id_pagamento = p.id
            left join gds.vw_moduli m on m.id::text = i.id_modulo::text
            left join pagopa.pagopa_sanzioni_pagatori_notifiche n on n.id_pagamento = p.id
            where i.id_utente = ${idUtente} and esito_invio = 'OK' and (stato_pagamento != 'ANNULLATO' or stato_pagamento is null)
            and p.id_sanzione = -1
            group by 1,2,3,4,8,9,10,11,12,13,14,15,16,17
            order by p.data_generazione_iuv desc`;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                try {
                    let pagamenti = result.rows;
                    for (let i = 0; i < pagamenti.length; i++) {
                        if (pagamenti[i].stato_pagamento != 'PAGAMENTO COMPLETATO')
                            pagamenti[i] = await pagopa.aggiornaStatoPagamento(pagamenti[i])
                    }
                    res.json(pagamenti).end();
                } catch (err) {
                    console.log(err.stack)
                    res.writeHead(500).end();
                }
            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})


router.get("/allegaSanzione", auth.authenticateToken, function (req, res) {

    const idIspezioneFase = req.query.idIspezioneFase;
    const idPagamento = req.query.idPagamento;

    try {
        let query = `
            update pagopa.pagopa_pagamenti set id_sanzione = ${idIspezioneFase} where id = ${idPagamento}`;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                res.json({ esito: true }).end();
                //res.writeHead(200).end();
            }
        })

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})

router.get("/annullaSanzione", auth.authenticateToken, async function (req, res) {

    try {
        const idSanzione = req.query.idIspezioneFase;
        const idPagamento = req.query.idPagamento;

        if (idPagamento != null) {

            let pagamento = { id: idPagamento, esito: null };
            try {
                let esito = await pagopa.annullaPagamento(idPagamento);
                pagamento.esito = esito;
            } catch (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            }
            res.json(pagamento).end();

        } else if (idSanzione != null) {
            let query = `select p.id
            from pagopa.pagopa_pagamenti p
            where id_sanzione = ${idSanzione} and esito_invio = 'OK' and p.trashed_date is null`;
            console.log(query);
            conn.client.safequery(query, async (err, result) => {
                if (err) {
                    console.log(err.stack)
                    res.writeHead(500).end();
                } else {

                    let pagamenti = result.rows;
                    for (let i = 0; i < pagamenti.length; i++) {

                        try {
                            let esito = await pagopa.annullaPagamento(pagamenti[i].id);
                            pagamenti[i].esito = esito;
                        } catch (err) {
                            console.log(err.stack)
                            res.writeHead(500).end();
                        }

                    }
                    res.json(pagamenti).end();
                }
            })
        }


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})


router.get("/modificaDataNotifica", auth.authenticateToken, async function (req, res) {

    try {
        const dataNotifica = req.query.dataNotifica;
        const idPagamento = req.query.idPagamento;
        let tipoNotifica = req.query.tipoNotifica;
        const changeNotifica = (req.query.changeNotifica === 'true');

        let pagamento = { id: idPagamento, esito: null };

        let addSetting = "";
        if (changeNotifica == true) {
            if (tipoNotifica == 'P') {
                addSetting = ", tipo_notifica = 'R'";
                tipoNotifica = 'R';
            }
            else {
                addSetting = ", tipo_notifica = 'P'";
                tipoNotifica = 'P';
            }
        }

        //aggiorno info notifica
        let query = `update pagopa.pagopa_sanzioni_pagatori_notifiche set data_notifica = '${dataNotifica}', notifica_aggiornata = true, 
        note_hd = coalesce(note_hd, '') || 'Notifica aggiornata al ${dataNotifica} il '|| current_timestamp ||' | '${addSetting} where id_pagamento = ${idPagamento}`;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {

            try {
                //se ok aggiorno la scadenza a 30 giorni
                let query = `update pagopa.pagopa_pagamenti set data_scadenza = to_char('${dataNotifica}'::date  + interval '30 day', 'YYYY-MM-DD') 
                    where id = ${idPagamento}`;
                console.log(query);
                conn.client.safequery(query, async (err, result) => {

                    try {
                        //aggiorno pagamento in pagopa
                        let ret = await pagopa.modificaPagamento(idPagamento);
                        pagamento.esito = ret.esito;
                        console.log("pagamento.esito:", pagamento.esito);
                        
                        // Se il tipo Notifica è PEC -> invia email 
                        /*if (pagamento.esito == 'OK' && tipoNotifica == 'P') {
                            
                            // Recupera Email e URL
                            let querySendEmail = `
                                select pp.url_file_avviso, pap.domicilio_digitale, pp.id
                                from pagopa.pagopa_pagamenti pp 
                                join pagopa.pagopa_anagrafica_pagatori pap on pp.id_pagatore = pap.id
                                where pp.id = ${idPagamento};
                            `;
                            console.log(querySendEmail);
                            conn.client.safequery(querySendEmail, async (err, result) => {
                                try {
                                    console.log(result.rows);
                                    const email = result.rows[0].domicilio_digitale;
                                    const URL = result.rows[0].url_file_avviso;

                                    mail.sendEmailAvvisiDiPagamento(email, URL);
                                } catch (err) {
                                    console.log(err.stack);
                                    res.writeHead(500).end();
                                }
                            })
                        }*/
                        pagamento.codice = ret.codice;
                        res.json(pagamento).end();
                    } catch (err) {
                        console.log(err.stack)
                        res.writeHead(500).end();
                    }
                })
            } catch (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            }
        })
    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})


router.get("/controllaPagamentoPagoPa", function (req, res) {

    const iuv = req.query.iuv;

    try {
        let query = `
            select id as p_id, stato_pagamento from pagopa.pagopa_pagamenti where identificativo_univoco_versamento = '${iuv}'
            `;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                try {
                    let pagamenti = result.rows;
                    for (let i = 0; i < pagamenti.length; i++) {
                        if (pagamenti[i].stato_pagamento != 'PAGAMENTO COMPLETATO')
                            pagamenti[i] = await pagopa.aggiornaStatoPagamento(pagamenti[i])
                    }
                    res.json(pagamenti).end();
                } catch (err) {
                    console.log(err.stack)
                    res.writeHead(500).end();
                }
            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})

async function getAvviso(res, idPagamento) {
	let query = `select pdf_avviso, filename_avviso from pagopa.pagamenti_pdf where id_pagamento = ${idPagamento} limit 1`;
	console.log(query);
	conn.client.safequery(query, (err, result) => {
		if (err) {
			console.log(err.stack)
			res.writeHead(500).end();
		} else {
			try {
				console.log("titolo file: " + result.rows[0].filename_avviso);
				let tmp = "static/verbali/tmp/";
				let data = result.rows[0].pdf_avviso;
				let filenamePdf = result.rows[0].filename_avviso;
				const pathnameFile = path.join(tmp, filenamePdf);
				console.log("result.rows[0].dati:", result.rows[0].pdf_avviso);

				fs.writeFileSync(pathnameFile, base64url.toBuffer(data));
				res.set({ "Access-Control-Expose-Headers": 'Content-Disposition' });
				res.download(pathnameFile, filenamePdf, function (err) {
					if (err) {
						console.log(err);
						res.status(500).send(err).end();
					}
					//fs.unlinkSync(pathnameFile)
				});
			} catch (e) {
				console.log(e.stack);
				res.end();
			}
		}
	})
}

router.post("/downloadAvviso", async function (req, res) {

	try {
		var idPagamento = req.query.idPagamento;
		getAvviso(res, idPagamento);
	} catch (err) {
		console.log(err);
		res.status(500).send(err).end();
	}
});



router.post("/downloadRicevutaRT", auth.authenticateToken, function (req, res) {

    const idPagamento = req.query.idPagamento;

    try {
        let query = `
            select xml_rt, pdf_rt, filename_rt from pagopa.pagamenti_pdf where id_pagamento = ${idPagamento} limit 1
            `;
        console.log(query);
        conn.client.safequery(query, async (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                try {
                    if(result.rows[0].filename_rt == null){ //genero file
                        let xml = result.rows[0].xml_rt;
                        valori = {};
                        valori.identificativoDominio = utils.getXmlValueByTagName(xml, 'identificativoDominio');
                        valori.identificativoMessaggioRicevuta = utils.getXmlValueByTagName(xml, 'identificativoMessaggioRicevuta');
                        let dataRicevutaTS = utils.getXmlValueByTagName(xml, 'dataOraMessaggioRicevuta').split('+')[0];
                        valori.dataOraMessaggioRicevuta = dataRicevutaTS.split('T')[0].split('-').reverse().join('-') + ' ' + dataRicevutaTS.split('T')[1];
                        valori.riferimentoMessaggioRichiesta = utils.getXmlValueByTagName(xml, 'riferimentoMessaggioRichiesta');
                        valori.riferimentoDataRichiesta = utils.getXmlValueByTagName(xml, 'riferimentoDataRichiesta').split('+')[0];
                        
                        let xmlAttestante = utils.getNestedXmlValueByTagName(xml, 'identificativoUnivocoAttestante');
                        valori.tipoIdentificativoUnivocoAttestante = utils.getXmlValueByTagName(xmlAttestante, 'tipoIdentificativoUnivoco');
                        valori.codiceIdentificativoUnivocoAttestante = utils.getXmlValueByTagName(xmlAttestante, 'codiceIdentificativoUnivoco');

                        valori.denominazioneAttestante = utils.getXmlValueByTagName(xml, 'denominazioneAttestante');

                        let xmlBeneficiario = utils.getNestedXmlValueByTagName(xml,'identificativoUnivocoBeneficiario');
                        valori.tipoIdentificativoUnivocoBeneficiario = utils.getXmlValueByTagName(xmlBeneficiario, 'tipoIdentificativoUnivoco');
                        valori.codiceIdentificativoUnivocoBeneficiario = utils.getXmlValueByTagName(xmlBeneficiario, 'codiceIdentificativoUnivoco');

                        valori.denominazioneBeneficiario = utils.getXmlValueByTagName(xml, 'denominazioneBeneficiario');
                        valori.indirizzoBeneficiario = utils.getXmlValueByTagName(xml, 'indirizzoBeneficiario');
                        valori.civicoBeneficiario = utils.getXmlValueByTagName(xml, 'civicoBeneficiario');
                        valori.capBeneficiario = utils.getXmlValueByTagName(xml, 'capBeneficiario');
                        valori.localitaBeneficiario = utils.getXmlValueByTagName(xml, 'localitaBeneficiario');
                        valori.provinciaBeneficiario = utils.getXmlValueByTagName(xml, 'provinciaBeneficiario');
                        valori.nazioneBeneficiario = utils.getXmlValueByTagName(xml, 'nazioneBeneficiario');

                        let xmlPagatore = utils.getNestedXmlValueByTagName(xml,'identificativoUnivocoPagatore');
                        valori.tipoIdentificativoUnivocoPagatore = utils.getXmlValueByTagName(xmlPagatore, 'tipoIdentificativoUnivoco');
                        valori.codiceIdentificativoUnivocoPagatore = utils.getXmlValueByTagName(xmlPagatore, 'codiceIdentificativoUnivoco');

                    
                        valori.anagraficaPagatore = utils.getXmlValueByTagName(xml, 'anagraficaPagatore');
                        valori.indirizzoPagatore = utils.getXmlValueByTagName(xml, 'indirizzoPagatore');
                        valori.civicoPagatore = utils.getXmlValueByTagName(xml, 'civicoPagatore');
                        valori.capPagatore = utils.getXmlValueByTagName(xml, 'capPagatore');
                        valori.localitaPagatore = utils.getXmlValueByTagName(xml, 'localitaPagatore');
                        valori.provinciaPagatore = utils.getXmlValueByTagName(xml, 'provinciaPagatore');
                        valori.nazionePagatore = utils.getXmlValueByTagName(xml, 'nazionePagatore');
                        valori.emailPagatore = utils.getXmlValueByTagName(xml, 'e-mailPagatore');
                        valori.codiceEsitoPagamento = utils.getXmlValueByTagName(xml, 'codiceEsitoPagamento');
                        valori.importoTotalePagato = utils.getXmlValueByTagName(xml, 'importoTotalePagato');
                        valori.identificativoUnivocoVersamento = utils.getXmlValueByTagName(xml, 'identificativoUnivocoVersamento');
                        valori.codiceContestoPagamento = utils.getXmlValueByTagName(xml, 'codiceContestoPagamento');
                        valori.identificativoUnivocoDovuto = utils.getXmlValueByTagName(xml, 'identificativoUnivocoDovuto');
                        valori.singoloImportoPagato = utils.getXmlValueByTagName(xml, 'singoloImportoPagato');
                        valori.esitoSingoloPagamento = utils.getXmlValueByTagName(xml, 'esitoSingoloPagamento');
                        valori.dataEsitoSingoloPagamento = utils.getXmlValueByTagName(xml, 'dataEsitoSingoloPagamento').split('+')[0];
                        valori.causaleVersamento = utils.getXmlValueByTagName(xml, 'causaleVersamento').split('/')[utils.getXmlValueByTagName(xml, 'causaleVersamento').split('/').length - 1];
                        valori.identificativoUnivocoRiscossione = utils.getXmlValueByTagName(xml, 'identificativoUnivocoRiscossione');
                        valori.datiSpecificiRiscossione = utils.getXmlValueByTagName(xml, 'datiSpecificiRiscossione');
                        valori.indiceDatiSingoloPagamento = utils.getXmlValueByTagName(xml, 'indiceDatiSingoloPagamento');

                        let filename = `MYPAY_RT_${valori.identificativoDominio}_${valori.identificativoUnivocoVersamento}`;
                        verbali.generaRicevutaRT(valori, res, filename, idPagamento);
                    }else{
                        verbali.getRicevutaRT(result.rows[0].pdf_rt, result.rows[0].filename_rt, res);
                    }
                } catch (err) {
                    console.log(err.stack)
                    res.writeHead(500).end();
                }
            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})









module.exports = router;