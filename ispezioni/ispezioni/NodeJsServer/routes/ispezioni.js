//rotta per ispezioni
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
const conf = require('../config/config.js');
const auth = require('../utils/auth.js');
var pagopa = require('../pagopa/pagopa');

// get Macchine Difformi
router.get("/getMacchine", function (req, res) {

    try {

        conn.client.safequery(`select * from gds_srv.vw_macchine`, (err, result) => {
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

// get Tipologie di Macchine Difformi
router.get("/getTipiMacchine", function (req, res) {
    const query = `select * from gds_types.vw_tipi_macchina vtm`;
    try {
        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack);
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

// get Costruttori di Macchine Difformi
router.get("/getCostruttori", function (req, res) {
    const query = `select * from gds_macchine.vw_costruttori vc`;
    try {
        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack);
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

// update Macchine
router.post("/updMacchine", function (req, res) {
    try {
        const stringMacchina = req.query.macchina;
        console.log("stringMacchina:", stringMacchina)

        const file = req.files.file;
        console.log("req.query.file:", file);

        const queryMacchine = `
            select gds_macchine.upd_macchine('${stringMacchina}', ${1}, '${file.data.toString('base64url')}'::bytea);
        `;

        console.log("queryMacchine:", queryMacchine);

        conn.client.safequery(queryMacchine, (err, result) => {
            if (err) {
                console.log(err.stack);
                res.writeHead(500).end();
            } else {
                console.log("result Macchine:", result.rows);
                console.log("result.rows[0].joutput:", result.rows[0].upd_macchine);
                res.json(result.rows[0].upd_macchine);
            }
        })

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }
})

router.get("/getCantieriAttivi", function (req, res) {

    try {

        conn.client.safequery(`select * from gds_srv.vw_cantieri_attivi order by id desc`, (err, result) => {
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


router.get("/getCantiereImpreseSedi", function (req, res) {

    try {

        const idCantiere = req.query.idCantiere;
        const query = `select * from gds_srv.vw_cantIere_impresa_sedi where id_cantiere = ${idCantiere}`;
        console.log(query);

        conn.client.safequery(query, (err, result) => {
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


router.get("/getIspezioni", auth.authenticateToken, async function (req, res) {

    try {
        console.log("getIspezioni");
        if (!conf.ispezioniEnabled) {
            res.writeHead(500).end();
        } else {

            let whereAsl = '';
            let whereIdUser = '';
            let whereServizio = '';
            let whereAmbito = ''
            try {
                // Restituire le ispezioni
                console.log("req.authData:", req.authData);
                const idAsl = req.authData.idAslUtente;
                var idAmbito = req.authData.idAmbito;

                // Controllare id ASL
                if (idAsl != null && idAsl != '' && idAsl != -1) {
                    whereAsl = `where vgi.id_asl = ${idAsl}`;

                    whereServizio = `and '${req.authData.ruoloUtente}' ilike '%'||vgi.servizio||'%'`;

                    // Controllare Se è un Ispettore o un Direttore
                    const idUtente = req.authData.idUtente;
                    if (req.authData.ruoloUtente.toUpperCase().includes("ISPETTORE")) {
                        idAmbito = null //cosi non entro nell'if, vedo tutte le mie indipendnetemente dall ambito
                        whereIdUser = `and id_ispezione in (select id_ispezione from gds.nucleo_ispettori where id_access = ${idUtente})`;
                        whereServizio = '';
                    }


                    if (idAmbito != null && idAmbito != '' && idAmbito != -1)
                        whereAmbito = `and vni.id_ambito = ${idAmbito}`;
                }
            } catch (e) { console.log(e); }

            let query = `
                select  descr_isp, codice_ispezione, id_ispezione, descr_ente_isp,
                        descr_uo_isp, descr_motivo_isp, cantiere_o_impresa, data_ispezione,
                        descr_ente, descr_stato_ispezione, string_agg(ispettore,'-') ispettore, 
                        string_agg(vni.id_utente_access::text,';') id_utente_access,
                        modificabile, vni.servizio, vni.ambito, vni.descr_esito_ispezione,
                        case 
                            when id_esito_ispezione in (select id from gds_types.esiti_chiusura_ispezione where iniziale and enabled_with_ammenda) then true
                            else false
                        end as da_aggiornare_stato
                from gds.vw_get_ispettori vgi
                join gds_srv.vw_nucleo_ispettori vni on vgi.user_id = vni.id_utente_access
                ${whereAsl} ${whereIdUser} ${whereServizio} ${whereAmbito}
                group by descr_isp, codice_ispezione, id_ispezione, descr_ente_isp,
                        descr_uo_isp, descr_motivo_isp, cantiere_o_impresa, data_ispezione,
                        descr_ente, descr_stato_ispezione, modificabile, vni.servizio, vni.data_modifica, vni.ambito, vni.descr_esito_ispezione,
                        vni.id_esito_ispezione
                order by vni.data_modifica desc`;

            console.log("query:", query);

            let result = await conn.client.safequery(query);
                
            await result.rows.forEach(async (isp) => {
                if(isp.da_aggiornare_stato)
                    await jobAggiornaEsitoIspezioniChiuseConPagamento(isp.id_ispezione);
            })
            res.json(result.rows).end();
     
        }

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }
})

router.get("/insertIspezione", function (req, res) {
    // const id_utente = JSON.parse(req.body.id_soggetto_notificante).valore;
    const id_utente = 1
    // async/await
    try {

        var url = `call gds_srv.upd_dati('ins_ispezione', null, ${id_utente}, null)`;
        console.log(url);
        conn.client.safequery(url, (err, result) => {
            if (err) {
                console.log("error in query");
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                console.log(result.rows);
                res.send(result.rows[0].joutput).end();
            }
        })


    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})


router.get("/getIspezioneInfo", async function (req, res) {

    try {

        const idIspezione = req.query.idIspezione;
        var response = {};
        console.log("getIspezioneInfo " + idIspezione);
        var url = `call gds_srv.get_dati('get_ispezione', '{"id": "${idIspezione}"}', 1, null)`;
        console.log(url);
        var result = await conn.client.safequery(url);
        response = JSON.parse(result.rows[0].joutput.info);
        response.ispezione.id_ente_uo_multiple = [];
        var resultEnti = await conn.client.safequery(`select uo.*, eu.descr_ente_uo 
            from gds.ispezione_enti_uo uo
            join gds_types.vw_ente_uo eu on uo.id_ente_uo= eu.id
             where id_ispezione = ${idIspezione}`);
        await resultEnti.rows.forEach((e) => {
            response.ispezione.id_ente_uo_multiple.push(e);
        })

        res.json(response).end();


    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})

router.get("/getIspezioneFasi", async function (req, res) {

    try {
        response = {};
        const idIspezioneFase = req.query.idIspezioneFase;
        console.log("getIspezioneFasi " + idIspezioneFase);
        var url = `call gds_srv.get_dati('get_ispezione_fase', '{"id": "${idIspezioneFase}"}', 1, null)`;
        console.log(url);
        var result = await conn.client.safequery(url);
        response = JSON.parse(result.rows[0].joutput.info);

        var queryVerbaliCompilati = `select * from gds.vw_get_verbale_completo_by_fase where id_ispezione_fase = ${idIspezioneFase}`;
        console.log(queryVerbaliCompilati);
        var result = await conn.client.safequery(queryVerbaliCompilati);
        console.log("result.rows:", result.rows);
        response.verbaleAllegato = result.rows;

        res.json(response).end();

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})

router.get("/getMotiviIspezione", function (req, res) {

    try {
        console.log("getMotiviIspezione");

        conn.client.safequery(`select *
                               from gds_types.vw_motivi_isp order by descr`, (err, result) => {
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

router.get("/getEsitiFaseTree", function (req, res) {

    try {
        //const idIspezione = req.query.idIspezione;
        console.log(`getEsitiFaseTree`);

        const query = `select *
        from gds_types.vw_fasi_esiti order by id_fase, id_esito_per_fase`;
        console.log(query);

        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                var response = [];
                var currFase = {};

                result.rows.forEach(function (row, i) {
                    var fase = {};
                    if (i == 0) { //primo
                        fase.id_fase = row.id_fase;
                        fase.descr = row.descr_fase;
                        fase.children = [];
                        var child = {}
                        child.id_fase_esito = row.id_fase_esito_possibile;
                        child.id_esito_per_fase = row.id_esito_per_fase;
                        child.descr_esito_per_fase = row.descr_esito_per_fase;
                        child.riferimento_fase_esito = row.riferimento_fase_esito;
                    } else {
                        if (row.id_fase == currFase.id_fase) {
                            var child = {}
                            child.id_fase_esito = row.id_fase_esito_possibile;
                            child.id_esito_per_fase = row.id_esito_per_fase;
                            child.descr_esito_per_fase = row.descr_esito_per_fase;
                            child.riferimento_fase_esito = row.riferimento_fase_esito;
                            fase = currFase;
                            fase.children.push(child);
                        } else {
                            response.push(currFase);
                            currFase = {};
                            fase.id_fase = row.id_fase;
                            fase.descr = row.descr_fase;
                            fase.children = [];
                            var child = {}
                            child.id_fase_esito = row.id_fase_esito_possibile;
                            child.id_esito_per_fase = row.id_esito_per_fase;
                            child.descr_esito_per_fase = row.descr_esito_per_fase;
                            child.riferimento_fase_esito = row.riferimento_fase_esito;
                            fase.children.push(child);
                        }
                    }
                    currFase = fase;
                    if (i == result.rowCount - 1) { //ultimo che altrimenti rimarrebbe fuori
                        response.push(currFase);
                    }
                })

                res.json(response).end();

            }
        })


    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }

})


router.get("/getEsitiFase", function (req, res) {

    try {
        console.log("getEsitiFase");

        conn.client.safequery(`select *
                               from gds_types.vw_fasi_esiti order by id_fase, id_esito_per_fase`, (err, result) => {
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


router.post("/updateIspezioneInfo", async function (req, res) {

    req.session.idNotificante = 1; //dovrà essere id_ispettore
    console.log(JSON.stringify(req.body));
    console.log(req.session.idNotificante);

    try {

        var url = `call gds.upd_dati('upd_ispezione','${JSON.stringify(req.body).replace(/'/g, "''")}', '${req.session.idNotificante}', null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        if(result.rows[0].joutput.esito){
            await conn.client.safequery(`delete from gds.ispezione_enti_uo where id_ispezione = ${req.body.ispezione.id}`);
            await req.body.ispezione.id_ente_uo_multiple.forEach(async (m) => {
                await conn.client.safequery(`insert into gds.ispezione_enti_uo values (${req.body.ispezione.id}, ${m.id_ente_uo})`);
            })
        }
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)



    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }

})



router.post("/updateFaseInfo", async function (req, res) {

    req.session.idNotificante = 1; //dovrà essere id_ispettore
    console.log(JSON.stringify(req.body));
    console.log(req.session.idNotificante);

    try {

        var url = `call gds.upd_dati('upd_ispezione_fase','${JSON.stringify(req.body).replace(/'/g, "''")}', '${req.session.idNotificante}', null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)



    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }

})


router.get("/insertIspezioneFase", function (req, res) {

    const id_utente = 1
    const idIspezione = req.query.idIspezione;
    // async/await
    try {

        var url = `call gds_srv.upd_dati('ins_ispezione_fase', '{"id_ispezione" : "${idIspezione}"}', ${id_utente}, null)`;
        console.log(url);
        conn.client.safequery(url, (err, result) => {
            if (err) {
                console.log("error in query");
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                console.log(result.rows);
                res.send(result.rows[0].joutput).end();
            }
        })

    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})


router.get("/getModuli", function (req, res) {

    try {

        conn.client.safequery(`
        select m.*, 
        case when p.id_modulo is null then false else true end as is_pagopa
        from gds_srv.vw_moduli m
        left join pagopa.lookup_moduli_pagopa p on p.id_modulo = m.id
        order by descr`, (err, result) => {
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


router.get("/insertVerbaleFase", async function (req, res) {

    try {

        const idModulo = req.query.idModulo;
        const idIspezioneFase = req.query.idIspezioneFase
        const dataVerbale = req.query.dataVerbale

        var query = `select * from gds.ins_verbale('{"id_modulo":${idModulo},"data_verbale":"'||to_char(current_date, 'YYYY-MM-DD')||'"}', 1)`;
        console.log(query);
        await conn.client.safequery('BEGIN');

        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                if (result.rows[0].esito) {
                    const idVerbale = result.rows[0].valore;
                    query = `select * from gds.ins_fase_verbale('{"id_verbale":"${idVerbale}","id_ispezione_fase":"${idIspezioneFase}"}', 1)`;
                    console.log(query);
                    conn.client.safequery(query, (err, result2) => {
                        if (!result2.rows[0].esito) {
                            conn.client.safequery('ROLLBACK');
                        }
                        conn.client.safequery('COMMIT');
                        res.json(result.rows[0]).end();
                    })
                } else {
                    res.json(result.rows[0]).end();
                }
            }
        })

    } catch (e) {
        console.log(e.stack);
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }

})


router.get("/getIspezioniByIdIspettore", function (req, res) {

    try {
        conn.client.safequery(`select * from gds.vw_ispezioni where id_utente_access = ${req.query.idIspettore} order by id desc`, (err, result) => {
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


router.get("/getIspettoriServizio", auth.authenticateToken, function (req, res) {

    try {
        conn.client.safequery(`select * from gds.vw_get_ispettori
            where id_asl = ${req.authData.idAslUtente} 
            and ruolo ilike '%ISPETTORE%'
            and '${req.authData.ruoloUtente}' ilike '%'||servizio||'%'`, (err, result) => {
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

router.get("/getIspettoriAsl", auth.authenticateToken, function (req, res) {

    try {
        conn.client.safequery(`select * from gds.vw_get_ispettori
            where ruolo ilike '%ISPETTORE%'
            and id_asl = ${req.authData.idAslUtente}`, (err, result) => {
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


router.post("/trasferisciIspezioni", auth.authenticateToken, function (req, res) {

    const da = req.body.idIspettoreDa;
    const a = req.body.idIspettoreA;
    const idIspezioni = req.body.idIspezioni.join(',');

    try {
        const query = `
            update gds.nucleo_ispettori set id_access = ${a}
            where id_access = ${da}
            and id_ispezione in (${idIspezioni});
        `;

        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                res.json(result).end();
            }
        })

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }
})


router.post("/insertCantiere", auth.authenticateToken, async function (req, res) {
    try {
        conn.client.safequery(`SET search_path TO public`);
        var url = `call gds.upd_dati('ins_cantiere','${JSON.stringify(req.body.cantiere).replace(/'/g, "''")}', '${req.authData.idUtente}', null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)
    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }
})

router.post("/updateCantiere", auth.authenticateToken, async function (req, res) {
    try {
        conn.client.safequery(`SET search_path TO public`);
        var url = `call gds.upd_dati('upd_cantiere','${JSON.stringify(req.body.cantiere).replace(/'/g, "''")}', '${req.authData.idUtente}', null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)
    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }
})

router.get("/deleteCantiere", auth.authenticateToken, async function (req, res) {
    try {
        const idUtente = req.authData.idUtente;
        const idCantiere = req.query.idCantiere;
        var query = `update gds_notifiche.cantieri set trashed = current_timestamp where id = ${idCantiere} and id_access_ispettore = ${idUtente}`;
        console.log(query);
        result = await conn.client.safequery(query);
        console.log(result.rows);
        res.json(result.rows)
    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end();
    }
})

router.get("/getCantiereImprese", auth.authenticateToken, function (req, res) {
    const idCantiere = req.query.idCantiere;

    const query = `
        select *, i.ragione_sociale as nome_azienda, imps.id as id_impresa_sede from gds_notifiche.cantieri c 
        join gds_notifiche.cantiere_imprese ci on ci.id_cantiere = c.id 
        join gds.imprese i on i.id = ci.id_impresa
        join gds.impresa_sedi imps on imps.id_impresa = i.id and imps.id_tipo_sede = 0
        where c.id = ${idCantiere}`;

    try {
        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                const risposta = result.rows;
                res.json(risposta).end();
            }
        })
    } catch (error) {
        console.log(error.stack);
        res.writeHead(500).end();
    }
})


router.get("/deleteIspezioneFase", auth.authenticateToken, function (req, res) {
    const idFase = req.query.idFase;

    const query = `
        delete from gds.ispezione_fasi where id = ${idFase}`;

    try {
        conn.client.safequery(query, (err, result) => {
            if (err) {
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                const risposta = result.rows;
                res.json(risposta).end();
            }
        })
    } catch (error) {
        console.log(error.stack);
        res.writeHead(500).end();
    }
})


router.get("/getPersoneIspezione", auth.authenticateToken, function (req, res) {
    const id_cantiere = req.query.idCantiere;

    const query = {
        text: `
            select * from gds_notifiche.cantiere_persona_ruoli cpr
            join gds_types.ruoli r on r.id = cpr.id_ruolo
            join public.opu_soggetto_fisico osf on osf.id = cpr.id_soggetto_fisico
            where id_cantiere = $1 order by cpr.id_ruolo
        `,
        values: [id_cantiere]
    };

    console.log("query:", query);

    conn.client.safequery(query, (err, result) => {
        if (err) {
            console.log(err.stack);
            res.writeHead(500).end();
        } else {
            console.log("result.rows:", result.rows);
            res.json(result.rows).end();
        }
    })

})


router.get('/closeIspezione', auth.authenticateToken, function (req, res) {
    const idIspezione = req.query.idIspezione;
    const idEsitoIspezione = req.query.idEsitoIspezione

    let setEsitoIspezione = '';
    if(idEsitoIspezione)
        setEsitoIspezione = ` , id_esito_ispezione = ${idEsitoIspezione}`

    const query = {
        text: `
        update gds.ispezioni 
        set id_stato_ispezione = (select id from gds_ui.stati_ispezione_ui where label_bottone = 'CHIUSA')
        ${setEsitoIspezione}
        where id = $1
        `,
        values: [idIspezione]
    };

    console.log("query:", query);

    conn.client.safequery(query, (err, result) => {
        if (err) {
            console.log(err.stack);
            res.writeHead(500).end();
        } else {
            console.log("result.rows:", result.rows);
            res.json(result.rows).end();
        }
    })
    
})

jobAggiornaStatoIspezioniProgrammate = function() {
    console.log('START CRON UPDATE ISPEZIONI PROGRAMMATE');
    try {
        conn.client.safequery(
            `update gds.ispezioni 
            set id_stato_ispezione = (select id from gds_types.stati_ispezione where descr = 'IN CORSO')
            where id_stato_ispezione = (select id from gds_types.stati_ispezione where descr = 'PROGRAMMATA')
                and data_ispezione::date <= current_date`
            , (err, result) => {
            if (err) {
                console.log(err.stack)
            } 
        })
    } catch (error) {
        console.log(error.stack);
    }
}

jobAggiornaEsitoIspezioniChiuseConPagamento = async function(idIspezione) {
    if(!idIspezione){ //se arriva con idIspezione non sono ne crontab notturno, cerco l'ispezione puntuale, aggiorno gli avvisi di pagamento e ricontrollo l'esito
        console.log('START CRON UPDATE ISPEZIONI CHIUSE CON PAGAMENTO');
        try {
            let result = await conn.client.safequery(
                `select id from gds.ispezioni 
                where id_esito_ispezione in (select id from gds_types.esiti_chiusura_ispezione where iniziale and enabled_with_ammenda)`);
                
            for(let i = 0; i < result.rows.length; i++){
                let isp = result.rows[i];
                let resultPag = await conn.client.safequery(
                    `select p.id as p_id, p.stato_pagamento  from 
                    gds.ispezioni i
                    join gds.ispezione_fasi f on f.id_ispezione = i.id
                    join pagopa.pagopa_pagamenti p on p.id_sanzione = f.id
                    where esito_invio = 'OK' and trashed_date is null
                    and i.id = ${isp.id}`);
                for(let j = 0; j < resultPag.rows.length; j++){
                    let sanzione = resultPag.rows[j];
                    await pagopa.aggiornaStatoPagamento(sanzione);
                }
                await aggiornaEsitoIspezioneChiusaConPagamento(isp.id);  
            }
        } catch (error) {
            console.log(error.stack);
        }
    }else{
        let resultPag = await conn.client.safequery(
            `select p.id as p_id, p.stato_pagamento  from 
            gds.ispezioni i
            join gds.ispezione_fasi f on f.id_ispezione = i.id
            join pagopa.pagopa_pagamenti p on p.id_sanzione = f.id
            where esito_invio = 'OK' and trashed_date is null
            and i.id = ${idIspezione}`);
        for(let j = 0; j < resultPag.rows.length; j++){
            let sanzione = resultPag.rows[j];
            await pagopa.aggiornaStatoPagamento(sanzione);
        }
        await aggiornaEsitoIspezioneChiusaConPagamento(idIspezione);
    }
}

aggiornaEsitoIspezioneChiusaConPagamento = async function(idIspezione) {
    try {
        console.log("Controllo stati pagamento per ispezione ", idIspezione);
        let result = await conn.client.safequery(
            `select f.id as id_fase, p.stato_pagamento, p.data_scadenza  from 
            gds.ispezioni i
            join gds.ispezione_fasi f on f.id_ispezione = i.id
            join pagopa.pagopa_pagamenti p on p.id_sanzione = f.id
            where esito_invio = 'OK'  and trashed_date is null
            and i.id = ${idIspezione}`);
            try {
                let foundScaduta = false;
                let allPagati = true;
                await result.rows.forEach( (sanzione) => {
                    try{
                        console.log("Controllo stati pagamento per fase ", sanzione.id_fase);
                        if(sanzione.stato_pagamento != 'PAGAMENTO COMPLETATO'){
                            allPagati = false;
                            if(sanzione.stato_pagamento == 'PAGAMENTO SCADUTO') 
                                foundScaduta = true;
                        }
                    }catch(error){
                        console.log(error.stack);
                        allPagati = false; //se va male in ciclo non sono sicuro che tutti gli avvisi siano stati pagati
                    }
                })
                if(foundScaduta){ //se trovo almeno una sanzione scaduta e non pagata
                    await conn.client.safequery(
                        `update gds.ispezioni set id_esito_ispezione = (
                            select id_esito_chiusura_ispezione_if_scaduto 
                            from gds_types.esiti_chiusura_ispezione
                            where id = (
                                select id_esito_ispezione from gds.ispezioni where id = ${idIspezione}
                            )
                        ) where id = ${idIspezione}`
                    );
                }else if(allPagati){ // se non trovo pagamenti scaduti
                    await conn.client.safequery(
                        `update gds.ispezioni set id_esito_ispezione = (
                            select id_esito_chiusura_ispezione_if_pagato  
                            from gds_types.esiti_chiusura_ispezione
                            where id = (
                                select id_esito_ispezione from gds.ispezioni where id = ${idIspezione}
                            )
                        ) where id = ${idIspezione}`
                    );
                }
            }catch(error){
                console.log(error.stack);
            }
            
    } catch (error) {
        console.log(error.stack);
    }
}

module.exports = router;
module.exports.jobAggiornaStatoIspezioniProgrammate = jobAggiornaStatoIspezioniProgrammate;
module.exports.jobAggiornaEsitoIspezioniChiuseConPagamento = jobAggiornaEsitoIspezioniChiuseConPagamento;
