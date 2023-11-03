var nodemailer = require('nodemailer');
var conf = require('../config/config.js');


function sendEmailAttivazioneNotifica(filename, content, valori) {

  var credentials = {
    host: conf.mailHost,
    port: conf.mailPort,
    secure: conf.mailSecure,
    tls: {
      rejectUnauthorized: false
    },
    auth: {
      user: conf.mailUsername,
      pass: conf.mailPassword
    }
  }

  var transporter = nodemailer.createTransport(credentials);

  const cun = filename.split("_")[1];

  var to = '';
  var destinatariRealiTxt = ''
  if (conf.mailToInvalidator == '') { //invio la mail agli effettivi destinatari solo se l'invalidator è vuoto (a scopo di test), in caso contrario lo invio ai tester
    to = valori.cantiere.indirizzo_mail + `${conf.mailToInvalidator}`; //indirizzo mail dell'asl

    valori.persona_ruoli.forEach(function (persona) { // indirizzo mail del resposabile
      if (persona.id_ruolo == 2)
        to += ", " + persona.pec + `${conf.mailToInvalidator}`;
    })
  } else {
    to = conf.mailCcnTest;

    var destinatariReali = valori.cantiere.indirizzo_mail;
    valori.persona_ruoli.forEach(function (persona) { // indirizzo mail del resposabile
      if (persona.id_ruolo == 2)
        destinatariReali += ", " + persona.pec;
    })

    destinatariRealiTxt = `
    <p>---------</p>
    <p><strong> Questa è una mail di test, i veri destinatari sarebbero stati ${destinatariReali}</strong></p>
    `;
  }



  var mailOptions = {
    from: conf.mailFrom,
    to: to,
    bcc: conf.mailCcnTest,
    subject: `Gisa Sicurezza lavoro - Nuova notifica preliminare - CUN ${cun}`,
    html: `<p>Si allega quanto in oggetto</p>
        <p><strong>GISA - Sicurezza e prevenzione sui luoghi di lavoro</strong></p>
        ${destinatariRealiTxt}`,
    attachments: {
      filename: filename,
      content: content
    }
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log('Email notifica sent: ' + info.response + `, TO: ${to}`);
    }
    //res.end();
  });
}


function sendEmailSupporto(nomeSegnalante, titolo, messaggio, emailSegnalante, telefonoSegnalante, enteSegnalante, tipo){

  var credentials = {
    host: conf.mailHost,
    port: conf.mailPort,
    secure: conf.mailSecure,
    tls: {
      rejectUnauthorized: false
    },
    auth: {
      user: conf.mailUsername,
      pass: conf.mailPassword
    }
  }

  var to_ = '';
  if(tipo == "tecnico")
    to_ = conf.mailToSupportoTecnico;
  else if (tipo == "funzionale")
    to_ = conf.mailToSupportoFunzionale;

  var transporter = nodemailer.createTransport(credentials);

  var mailOptions = {
    from: conf.mailFrom,
    to: to_,
    //bcc: conf.mailCcnTest,
    subject: `Gisa Sicurezza lavoro - SUPPORTO [${titolo}][${nomeSegnalante}]`,
    html: `<p>${messaggio}</p>
          <p>Dati di ricontatto: ${emailSegnalante}  -  ${telefonoSegnalante}  -  ${enteSegnalante}</p>`,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log('Email supporto sent: ' + info.response);
    }
    //res.end();
  });

}



function sendEmailAvvisiDiPagamento(to_, urlAvvisi){

  let URL = typeof urlAvvisi === 'string' ? urlAvvisi : urlAvvisi.join(', ');

  var credentials = {
    host: conf.mailHost,
    port: conf.mailPort,
    secure: conf.mailSecure,
    tls: {
      rejectUnauthorized: false
    },
    auth: {
      user: conf.mailUsername,
      pass: conf.mailPassword
    }
  }

  var transporter = nodemailer.createTransport(credentials);

  var to = '';
  var destinatariRealiTxt = ''
  if (conf.mailToInvalidator == '') { //invio la mail agli effettivi destinatari solo se l'invalidator è vuoto (a scopo di test), in caso contrario lo invio ai tester
    to = to_;
  } else {
    to = conf.mailCcnTest;
    destinatariRealiTxt = `
    <p>---------</p>
    <p><strong> Questa è una mail di test, i veri destinatari sarebbero stati ${to_}</strong></p>
    `;
  }


  var mailOptions = {
    from: conf.mailFrom,
    to: to,
    //bcc: conf.mailCcnTest,
    subject: `Gisa Sicurezza lavoro - Avviso di pagamento PAGOPA`,
    html: `<p>Di seguito l'avviso di pagamento generato:</p>
          <p>${URL}</p>
          <p><strong>GISA - Sicurezza e prevenzione sui luoghi di lavoro</strong></p>
          ${destinatariRealiTxt}`,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log('Email supporto sent: ' + info.response);
    }
    //res.end();
  });

}



exports.sendEmailAttivazioneNotifica = sendEmailAttivazioneNotifica;
exports.sendEmailSupporto = sendEmailSupporto;
exports.sendEmailAvvisiDiPagamento = sendEmailAvvisiDiPagamento;