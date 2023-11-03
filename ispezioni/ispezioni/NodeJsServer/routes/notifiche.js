//rotta per notifiche
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
const mapUtilts = require("../utils/mapUtils");
var auth = require('../utils/auth');

router.get("/getNotifiche", auth.authenticateToken, function (req, res) {
    console.log(req.authData);
    var idNotificante = req.authData.idUtente;
    const ruolo = req.authData.ruoloUtente;
    const idAsl = req.authData.idAslUtente;

    try {
        var url = `select * from gds_srv.vw_notifiche_visibili where id_soggetto_notificante = ${idNotificante}`
        if (ruolo == 'Profilo Amministratore'){ //vede le sue e le altre non in stato bozza
            url += ` or id_stato not in (1,5)`;
        }
        else if (ruolo != 'Profilo Notificatore') {
            url = `select * from gds_srv.vw_notifiche_visibili_regione`;
            if (idAsl != null && idAsl != '' && idAsl != -1) {
                url += ` where codiceistatasl = ${idAsl}::text`;
            }
        }
        console.log(url);
        conn.client.safequery(url, (err, result) => {
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

router.get("/getNotificaInfo", auth.authenticateToken, async function (req, res) {

    const idNotifica = req.query.idNotifica;
    var idNotificante = req.authData.idUtente;
    if(idNotificante == null)
        idNotificante = 1;
    var response = {};
    // async/await
    try {

        var url = `call gds.get_dati('get_notifica','{"id":"${idNotifica}"}', ${idNotificante}, null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        response = JSON.parse(result.rows[0].joutput.info);

        result = await conn.client.safequery(`select * from gds_types.vw_nature_opera`);
        response.nature_opera = result.rows;

        result = await conn.client.safequery(`select * from gds_srv.vw_ruoli`);
        response.ruoli = result.rows;

        res.json(response).end();


    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})

router.post("/insertNotifica", auth.authenticateToken, function (req, res) {

    var idNotificante = req.authData.idUtente;
    if(idNotificante == null)
        idNotificante = 1;

    // async/await
    try {

        var url = `call gds_srv.upd_dati('ins_notifica', '{"id_soggetto_notificante" : "${idNotificante}"}', ${idNotificante}, null)`;
        console.log(url);
        conn.client.safequery(url, (err, result) => {
            if (err) {
                console.log("error in query");
                console.log(err.stack)
                res.writeHead(500).end();
            } else {
                console.log(result.rows);
                res.json(result.rows[0].joutput).end();
            }
        })


    } catch (err) {
        console.log(err.stack)
        res.writeHead(500).end();
    }

})

router.post("/updateNotificaInfo", auth.authenticateToken, async function (req, res) {

    var idNotificante = req.authData.idUtente;
    console.log(JSON.stringify(req.body.notifica));
    if(idNotificante == null)
        idNotificante = 1;

    try {

        //geocode
        try {

           // if (req.body.notifica.cantiere.lat == null && req.body.notifica.cantiere.lng == null) { //se lat e lng sono già valorizzati significa che è stata usata la localizzazione o il geocode già effettuato

                var indirizzo = (req.body.notifica.cantiere.via == null ? '' : req.body.notifica.cantiere.via) + " " +
                    (req.body.notifica.cantiere.civico == null ? '' : req.body.notifica.cantiere.civico) + " " +
                    (req.body.notifica.cantiere.comune == null ? '' : req.body.notifica.cantiere.comune) + " " +
                    (req.body.notifica.cantiere.cap == null ? '' : req.body.notifica.cantiere.cap);

                geocodeVal = JSON.parse(await mapUtilts.geocode(indirizzo));

                //dei possibili item ritornati seleziono solo quello con cap uguale (per evitare falsi positivi)
                if (geocodeVal != null && geocodeVal.items != undefined) {
                    geocodeVal.items.forEach(function (item) {
                        if (item.address.postalCode == req.body.notifica.cantiere.cap.trim()) {
                            console.log(item);
                            req.body.notifica.cantiere.lat = item.position.lat;
                            req.body.notifica.cantiere.lng = item.position.lng;
                        }
                    })
                }
            //}

        } catch (e) {
            console.log(e.stack);
        }

        var url = `call gds.upd_dati('upd_notifica','${JSON.stringify(req.body.notifica).replace(/'/g, "''")}', ${idNotificante}, null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)



    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end().end();
    }

})


router.post("/checkNotifica", auth.authenticateToken, async function (req, res) {

    var idNotificante = req.authData.idUtente;
    console.log(JSON.stringify(req.body.notifica));
    if(idNotificante == null)
        idNotificante = 1;

    try {

        var url = `call gds_srv.check_dati('check_notifica','${JSON.stringify(req.body.notifica).replace(/'/g, "''")}', ${idNotificante}, null)`;
        console.log(url);
        result = await conn.client.safequery(url);
        console.log(result.rows[0].joutput);
        res.json(result.rows[0].joutput)

    } catch (err) {
        console.log(err.stack)
        await conn.client.safequery('ROLLBACK');
        res.writeHead(500).end().end();
    }

})


module.exports = router;