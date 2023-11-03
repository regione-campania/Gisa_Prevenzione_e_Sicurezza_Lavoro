//rotta per UserManagement
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
var auth = require('../utils/auth');
var mail = require('../email/email')

router.post("/loginByCf", function (req, res) {

    console.log("old idNotificante:" + req.session.idNotificante);
    const cf = req.body.cf;
    const nome = req.body.nome;
    const cognome = req.body.cognome;
    const insert = req.body.insert;
    const device = req.body.device;

    try{
        var url = `select * from gds_srv.get_id_notificante_new('${cf}', '${nome.replace(/'/g, "''")}', '${cognome.replace(/'/g, "''")}', ${insert}, gds_srv.get_id_transazione(-1))`;
        console.log(url);
        conn.client.query(url, (err, result) => {
        if (err) {
            console.log(err.stack);
            res.json(err.stack).end();
        } else {
            
            const datiUtente = result.rows[0].get_id_notificante_new;
            console.log("Nuova sessione, idNotificante: " + datiUtente);

            var user = {};
            user.nome = nome;
            user.cognome = cognome;
            user.cf = cf;
            user.device = device;
            user.idUtente = JSON.parse(datiUtente).valore;
            if(JSON.parse(JSON.parse(datiUtente).info) != null){
                user.ruoloUtente = JSON.parse(JSON.parse(datiUtente).info).ruolo;
                user.idAslUtente = JSON.parse(JSON.parse(datiUtente).info).site_id;
            }

            const token = auth.generateAccessToken(user);
            user.token = token;

            //non li metto nel token, li aggiungo dopo
            user.id = datiUtente;

            console.log(user);
    
            res.json(user).end();
        }
        })
    }catch(e){
        console.log(err.stack)
        res.writeHead(500).end();
    }
  });


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
