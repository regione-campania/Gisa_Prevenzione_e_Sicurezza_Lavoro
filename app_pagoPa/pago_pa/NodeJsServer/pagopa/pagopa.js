var conf = require('../config/config.js');
const https = require('https');
var conn = require('../db/connection');
var utils = require('../utils/utils');
const path = require("path");
const fs = require("fs");
const base64url = require('base64url');
const request = require('request');

var pagoPaUtils = {

    inviaPostPromise: function(envelope){
        return new Promise((resolve, reject) => {

            var options = {
                hostname: conf.pagoPaEndpoint,
                path: conf.pagoPaService,
                method: 'POST',
                headers: {
                    'Content-Type': 'application/xml',
                    'Content-Length': envelope.length
                }
            };
            
            const req = https.request(options, function (res) {
                var data = '';
                res.on('data', function (chunk) {
                    data += chunk;
                });
                res.on('end', function () {
                    if (res.statusCode === 200) {
                        try {
                            resolve(data);
                        } catch (e) {
                            console.log(e.stack);
                        }
                    } else {
                        console.log('Status:', res.statusCode);
                        resolve(data);
                    }
                });
            }).on('error', function (err) {
                console.log('Error:', err);
                reject(err);
            });

            req.write(envelope);
            req.end();
        })
    },

    inviaPost: async function (envelope) {
        try {
            let promise = this.inviaPostPromise(envelope);
            return(await promise);
        }
        catch(error) {
            // Promise rejected
            console.log(error);
        }
    },

    creaPagamento: async function(idPagamento) {
        let ret = {esito: null, codice: null, urlFileAvviso: null};
        let query = `select * from pagopa.get_chiamata_ws_pagopa_importa_dovuto('${conf.pagoPaUsername}', '${conf.pagoPaPassword}', ${idPagamento})`;
        console.log(query);
        result = await conn.client.safequery(query);
        console.log(result.rows[0].get_chiamata_ws_pagopa_importa_dovuto);
        let response = await this.inviaPost(result.rows[0].get_chiamata_ws_pagopa_importa_dovuto);
        console.log(response);
        esito = utils.getXmlValueByTagName(response, 'esito');
        if(esito != 'OK' ){
            let codiceErrore = utils.getXmlValueByTagName(response, 'faultString') != null ? utils.getXmlValueByTagName(response, 'faultString') : utils.getXmlValueByTagName(response, 'faultCode');
            await conn.client.safequery(`update pagopa.pagopa_pagamenti set esito_invio = '${esito}',
                 descrizione_errore = '${codiceErrore}' where id = ${idPagamento}`);
            ret.codice = `${codiceErrore}`;
            ret.esito = esito;
            return ret;
        }else{  //OK
            let iuv = utils.getXmlValueByTagName(response, 'identificativoUnivocoVersamento');
            let urlFileAvviso = utils.getXmlValueByTagName(response, 'urlFileAvviso');
            await conn.client.safequery(`update pagopa.pagopa_pagamenti set esito_invio = '${esito}', identificativo_univoco_versamento = '${iuv}', codice_avviso = '3${iuv}',
                    url_file_avviso = '${urlFileAvviso}', data_generazione_iuv = current_timestamp, aggiornato_con_pagopa = true where id = ${idPagamento}`);
            ret.esito = esito;
            ret.codice = iuv;
            ret.urlFileAvviso = urlFileAvviso;
            this.salvaPdfAvviso(urlFileAvviso, idPagamento, `MYPAY_AVVISO_${iuv}.pdf`);
            return ret;
        }
    },

    salvaPdfAvviso: async function(url, idPagamento, filename){

        if(!filename) //da modificha creo un file tmp con nome diverso 
            filename = idPagamento + '_tmp.pdf';
        let tmp = "static/verbali/tmp/";	
		const pathnameFile = path.join(tmp, filename);
        https.get(url.replace(/&amp;/g, '&'), (res) => {
            const fileStream = fs.createWriteStream(pathnameFile);
            res.pipe(fileStream);

            fileStream.on('finish', () => {
                fileStream.close();
                console.log('Download finished')

                let data = fs.readFileSync(pathnameFile);
                conn.client.safequery({
                    text: `insert into pagopa.pagamenti_pdf (id_pagamento, pdf_avviso, filename_avviso) values ($1, $2::bytea, $3)
                    on conflict (id_pagamento) do update 
                    set pdf_avviso = $2::bytea
                   `,
                   values: [idPagamento, data.toString('base64url'), filename]
                }, (err, result) => {
                    if (err) {
                        console.log(err.stack)
                    };
                });
                fs.unlinkSync(pathnameFile);

            });
        })
    },

    aggiornaStatoPagamento: async function(pagamento){
        if(pagamento.stato_pagamento == 'PAGAMENTO COMPLETATO' || pagamento.stato_pagamento == 'PAGAMENTO SCADUTO')
            return pagamento;
        let query = `select * from pagopa.get_chiamata_ws_pagopa_chiedi_pagati('${conf.pagoPaUsername}', '${conf.pagoPaPassword}', ${pagamento.p_id})`;
        console.log(query);
        resultWs = await conn.client.safequery(query);
        console.log(resultWs.rows[0].get_chiamata_ws_pagopa_chiedi_pagati);
        let response = await this.inviaPost(resultWs.rows[0].get_chiamata_ws_pagopa_chiedi_pagati);
        console.log(response);
        let pagato = utils.getXmlValueByTagName(response, 'esito'); //se c'è il campo esito è pagato e sto verififcando un rt push
        if(!pagato){ //altrimenti uso pagati se sto aggiornando lo stato manualmente
            pagato = utils.getXmlValueByTagName(response, 'pagati');
        }
        if(pagato){//OK
            let count = 0;
            do{
                pagato = new Buffer(pagato, 'base64').toString('ascii');
                count++;
            }while(pagato[0] != '<' && count < 5)
            console.log(pagato);
            if(pagato[0]  == '<'){
                let denominazioneAttestante = pagamento.denominazione_attestante = utils.getXmlValueByTagName(pagato, 'denominazioneAttestante');
                let denominazioneBeneficiario = pagamento.denominazione_beneficiario = utils.getXmlValueByTagName(pagato, 'denominazioneBeneficiario');
                let esitoSingoloPagamento = pagamento.esito_singolo_pagamento = utils.getXmlValueByTagName(pagato, 'esitoSingoloPagamento');
                let identificativoUnivocoRiscossione = pagamento.identificativo_univoco_riscossione = utils.getXmlValueByTagName(pagato, 'identificativoUnivocoRiscossione');
                let singoloImportoPagato = pagamento.singolo_importo_pagato = utils.getXmlValueByTagName(pagato, 'singoloImportoPagato');
                let dataEsitoSingoloPagamento = pagamento.data_esito_singolo_pagamento = utils.getXmlValueByTagName(pagato, 'dataEsitoSingoloPagamento').split('+')[0]; //escludo timezone 2023-07-03+02:00 
                let codiceEsitoPagamento = pagamento.codice_esito_pagamento = utils.getXmlValueByTagName(pagato, 'codiceEsitoPagamento');
                pagamento.stato_pagamento = 'PAGAMENTO COMPLETATO';
                await conn.client.safequery(`update pagopa.pagopa_pagamenti set stato_pagamento = 'PAGAMENTO COMPLETATO', denominazione_attestante = '${denominazioneAttestante}',
                denominazione_beneficiario = '${denominazioneBeneficiario}', esito_singolo_pagamento = '${esitoSingoloPagamento}', identificativo_univoco_riscossione = '${identificativoUnivocoRiscossione}',
                singolo_importo_pagato = '${singoloImportoPagato}', data_esito_singolo_pagamento = '${dataEsitoSingoloPagamento}', codice_esito_pagamento = '${codiceEsitoPagamento}'
                where id = ${pagamento.p_id}`);
                await conn.client.safequery(`insert into pagopa.pagamenti_pdf (id_pagamento, xml_rt) values (${pagamento.p_id},
                    '${pagato}')
                    on conflict (id_pagamento) do update 
                    set xml_rt =           
                    '${pagato}'
                   `);
                return pagamento;
            }else{
                return null;
            }
        }else{//KO
            let faultCode = utils.getXmlValueByTagName(response, 'faultCode');
            if(faultCode){
                if(faultCode == 'PAA_SYSTEM_ERROR' && utils.getXmlValueByTagName(response, 'description').toUpperCase().startsWith("DOVUTO SCADUTO")) //nuova gestione scaduto flusso 345
                    faultCode = 'PAGAMENTO SCADUTO';
                pagamento.stato_pagamento = faultCode;
                await conn.client.safequery(`update pagopa.pagopa_pagamenti set stato_pagamento = '${faultCode}' where id = ${pagamento.p_id}`);
                return pagamento;
            }   
        }
    },

    annullaPagamento: async function(idPagamento){
        let query = `select * from pagopa.get_chiamata_ws_pagopa_importa_dovuto_annulla('${conf.pagoPaUsername}', '${conf.pagoPaPassword}', ${idPagamento})`;
        console.log(query);
        resultWs = await conn.client.safequery(query);
        console.log(resultWs.rows[0].get_chiamata_ws_pagopa_importa_dovuto_annulla);
        let response = await this.inviaPost(resultWs.rows[0].get_chiamata_ws_pagopa_importa_dovuto_annulla);
        console.log(response);
        let esito = utils.getXmlValueByTagName(response, 'esito');
        if(esito == 'OK'){
            await conn.client.safequery(`update pagopa.pagopa_pagamenti set stato_pagamento = 'ANNULLATO', trashed_date = current_timestamp, note_hd = coalesce(note_hd,'') || '['||current_timestamp||']Pagamento annullato.'
            where id = ${idPagamento}`);
            console.log(`Pagamento ${idPagamento} annullato`);
            return esito;
        }else{
            let faultCode = utils.getXmlValueByTagName(response, 'faultCode');
            if( faultCode == 'PAA_IMPORT_DOVUTO_NON_PRESENTE'){ //già eliminato
                console.log(`Pagamento ${idPagamento} GIA' annullato`);
                await conn.client.safequery(`update pagopa.pagopa_pagamenti set stato_pagamento = 'ANNULLATO', trashed_date = current_timestamp, note_hd = coalesce(note_hd,'') || '['||current_timestamp||']Pagamento gia annullato.'
                where id = ${idPagamento}`);
                return 'OK';
            }else{
                console.log(`Pagamento ${idPagamento} NON annullato`);
                await conn.client.safequery(`update pagopa.pagopa_pagamenti set note_hd = coalesce(note_hd,'') || '['||current_timestamp||']Tentativo annullamento fallito.' where id = ${idPagamento}`);
                return esito;
            }
        }
    },

    modificaPagamento: async function(idPagamento) {
        let ret = {esito: null, codice: null};
        let query = `select * from pagopa.get_chiamata_ws_pagopa_importa_dovuto_aggiorna('${conf.pagoPaUsername}', '${conf.pagoPaPassword}', ${idPagamento})`;
        console.log(query);
        result = await conn.client.safequery(query);
        console.log(result.rows[0].get_chiamata_ws_pagopa_importa_dovuto_aggiorna);
        let response = await this.inviaPost(result.rows[0].get_chiamata_ws_pagopa_importa_dovuto_aggiorna);
        console.log(response);
        esito = utils.getXmlValueByTagName(response, 'esito');
        if(esito != 'OK' ){
            let codiceErrore = utils.getXmlValueByTagName(response, 'faultString') != null ? utils.getXmlValueByTagName(response, 'faultString') : utils.getXmlValueByTagName(response, 'faultCode');
            ret.codice = `${codiceErrore}`;
            ret.esito = esito;
            return ret;
        }else{  //OK
            //new modifica per new col mypay
            let urlFileAvviso = utils.getXmlValueByTagName(response, 'urlFileAvviso'); 
            await conn.client.safequery(`update pagopa.pagopa_pagamenti set url_file_avviso = '${urlFileAvviso}' where id = ${idPagamento}`);
            //
            this.salvaPdfAvviso(urlFileAvviso, idPagamento, null)
            ret.esito = esito;
            return ret;
        }
    },

    jobAggiornaStatoPagamenti: function() {
        console.log('RUNNING TASK DI AGGIORNAMENTO AVVISI PAGOPA');
        try {
            let query = `select p.id as p_id, id_sanzione, stato_pagamento
            from pagopa.pagopa_pagamenti p
            where p.esito_invio = 'OK' and p.trashed_date is null`;
            var operazioneStorico = "[ControllaPagamentiPagoPA] ";
            console.log(query);
            conn.client.safequery(query, async (err, result) => {
                if (err) {
                    console.log(err.stack)
                } else {
                        let pagamenti = result.rows;
                        for (let i = 0; i < pagamenti.length; i++) {
                            try {
                                let pagato = null;
                                conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                    values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Inizio')`);
                                //controllo se c'è un pagato prima e dopo l'aggioramento, se c'è breakko e annullo gli altri
                                if (pagamenti[i].stato_pagamento != 'PAGAMENTO COMPLETATO') {
                                    conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                        values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Tentativo di verifica stato IUV')`);
                                    pagamenti[i] = await this.aggiornaStatoPagamento(pagamenti[i])
                                    conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                        values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Stato pagamento: ${pagamenti[i].stato_pagamento}')`);
                                    if (pagamenti[i].stato_pagamento == 'PAGAMENTO COMPLETATO')
                                        pagato = pagamenti[i];
                                } else {
                                    pagato = pagamenti[i];
                                }
                                if (pagato != null){ //se trovo un pagato e ci sono pagamenti non annullati per la stessa sanzione li annullo, tranne il pagato stesso
                                    let daAnnullare = pagamenti.filter(function(p){
                                        return p.id_sanzione == pagamenti[i].id_sanzione && pagamenti[i].p_id != pagato.p_id;
                                    })
                                    for (let j = 0; j < daAnnullare.length; j++) {
                                        await this.annullaPagamento(daAnnullare[j].p_id);
                                    }
                                }
                            } catch (err) {
                                console.log(err.stack)
                            }
                            conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                    values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Fine')`);
                           
                        }
                }
                console.log('TERMINATO TASK DI AGGIORNAMENTO AVVISI PAGOPA');
                this.jobAnnullaPagmentiScaduti();
            })
        } catch (e) {
            console.log(e.stack);
        }
    },

    jobAnnullaPagamentiScadutiNonNotificati: function() {
        console.log('RUNNING TASK DI ANNULLAMENTO AVVISI PAGOPA SCADUTI');
        try {
            //annullo tutte le raccomandate scadute, senza aggiornamento notifica e che non sono state pagate
            let query = `select p.id as p_id, id_sanzione, p.stato_pagamento
                from pagopa.pagopa_pagamenti p
                join pagopa.pagopa_sanzioni_pagatori_notifiche n on n.id_pagamento = p.id 
                where coalesce(n.notifica_aggiornata, false) is false and tipo_notifica = 'R' and data_scadenza::date < current_date
                    and stato_pagamento not in ('PAA_PAGAMENTO_NON_INIZIATO', 'PAA_PAGAMENTO_IN_CORSO') and p.trashed_date is null and p.esito_invio = 'OK'`;
            var operazioneStorico = "[AnnullaPagamentiScadutiPagoPA] ";
            console.log(query);
            conn.client.safequery(query, async (err, result) => {
                if (err) {
                    console.log(err.stack)
                } else {
                        let pagamenti = result.rows;
                        for (let i = 0; i < pagamenti.length; i++) {
                            try {
                                conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                    values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Inizio')`);
                                
                                let esito = await this.annullaPagamento(pagamenti[i].p_id)
                                conn.client.safequery(`insert into pagopa.pagopa_storico_operazioni_automatiche (entered, id_sanzione, id_pagamento, messaggio)
                                    values (current_timestamp, ${pagamenti[i].id_sanzione}, ${pagamenti[i].p_id}, '${operazioneStorico}Fine con esito: ${esito}')`);
                                    
                            } catch (err) {
                                console.log(err.stack)
                            }
                        }
                }
                console.log('TERMINATO TASK DI ANNULLAMENTO AVVISI PAGOPA SCADUTI');
            })
        } catch (e) {
            console.log(e.stack);
        }
    }

    
}

module.exports = pagoPaUtils;

