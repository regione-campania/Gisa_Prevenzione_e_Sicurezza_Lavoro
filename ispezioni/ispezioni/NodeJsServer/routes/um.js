//rotta per UserManagement
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
var auth = require('../utils/auth');
var mail = require('../email/email')
const conf = require('../config/config.js');

router.post("/loginByCf", function (req, res) {

    console.log("old idNotificante:" + req.session.idNotificante);
    console.log("req.body:", req.body);
    console.log("req.body.cognome:", req.body.cognome);
    console.log("req.body.nome:", req.body.nome);

    const cf = req.body.cf;
    const nome = req.body.nome;
    const cognome = req.body.cognome;
    const insert = req.body.insert;
    const device = req.body.device;

    try{
        var url = `select * from gds_srv.get_id_notificante_new('${cf}', '${nome.replace(/'/g, "''")}', '${cognome.replace(/'/g, "''")}', ${insert}, gds_srv.get_id_transazione(-1))`;
        console.log(url);
        conn.client.safequery(`SET search_path TO public`);
        conn.client.safequery(url, (err, result) => {
        if (err) {
            console.log(err.stack);
            res.json(err.stack).end();
        } else {
            
            const datiUtente = result.rows[0].get_id_notificante_new;
            console.log("Nuova sessione, idNotificante: " + datiUtente);

            var user = [];
            user.cf = cf;
            user.device = device;
            user.idUtente = JSON.parse(datiUtente).valore;
            if(JSON.parse(JSON.parse(datiUtente).info) != null){
                const info = JSON.parse(JSON.parse(datiUtente).info);
                console.log("info:", info);
                info.forEach((element, i) => {
                    user[i] = {};
                    user[i].cf = cf;
                    user[i].ruoloUtente = element.ruolo;
                    user[i].idAslUtente = element.site_id;
                    user[i].idUtente = user.idUtente;
                    if(!element.ruolo.toUpperCase().includes('NOTIFICATORE')) //in idUtente ho il notificatore, in user_id l'id_utente access, se non viene passato il notificatore passiamo l'id_utente access per le ispezioni
                        user[i].idUtente = element.user_id;
                    user[i].nome = element.nome;
                    user[i].cognome = element.cognome;
                    user[i].endpoint = element.endpoint;
                    user[i].idAmbito = element.id_ambito;
                    user[i].ambito = element.ambito;
                    user[i].asl = element.asl;

                    const token = auth.generateAccessToken(user[i]);
                    user[i].token = token;

                    user[i].id = datiUtente;
                });

                // user.ruoloUtente = JSON.parse(JSON.parse(datiUtente).info).ruolo;
                // user.idAslUtente = JSON.parse(JSON.parse(datiUtente).info).site_id;
                // if(!user.idUtente) //in idUtente ho il notificatore, in user_id l'id_utente access, se non viene passato il notificatore passiamo l'id_utente access per le ispezioni
                //     user.idUtente = JSON.parse(JSON.parse(datiUtente).info).user_id;
                // user.nome = JSON.parse(JSON.parse(datiUtente).info).nome;
                // user.cognome = JSON.parse(JSON.parse(datiUtente).info).cognome;
                // user.endpoint = JSON.parse(JSON.parse(datiUtente).info).endpoint;
            }else{
                user[0] = {};
                user[0].id = datiUtente;
            }


            // const token = auth.generateAccessToken(user);
            // user.token = token;

            //non li metto nel token, li aggiungo dopo
            // user.id = datiUtente;

            console.log(user);
    
            res.json(user).end();
        }
        })
    }catch(e){
        console.log(e.stack)
        res.writeHead(500).end();
    }
  });


  router.get("/getUser", function(req, res){
    auth.getUser(req, res);
  })

  router.get("/getModuloRegistrazioneUrl", function(req, res){
    res.send(conf.moduloRegistrazioneEndpoint).end();
  })


router.post("/sendEmailSupporto", function(req, res){
      
    const nomeSegnalane = req.body.nomeSegnalante;
    const messaggio = req.body.messaggio;
    const emailSegnalante = req.body.emailSegnalante;
    const titolo = req.body.titolo;
    const telefonoSegnalante = req.body.telefonoSegnalante;
    const enteSegnalante = req.body.ente;
    const tipo = req.body.tipo;

    mail.sendEmailSupporto(nomeSegnalane, titolo, messaggio , emailSegnalante, telefonoSegnalante, enteSegnalante, tipo);

    res.end();

})


  router.get('/logout', function (req, res){
    req.session.idNotificante = null;
    /*res.writeHead(307, {
        Location: `/login`
    }).end();*/
  })

  router.checkIsLogged = function(req, res) {
    /*if(req.session.idNotificante == null){
        res.writeHead(307, {
            Location: `/login`
        }).end();
        return false;
    }*/
    return true;
  }



  module.exports = router;
