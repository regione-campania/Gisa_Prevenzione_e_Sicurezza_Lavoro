const express = require('express');
const cookieSession = require('express-session')
const cors = require('cors');
const bodyParser = require("body-parser");
const fileUpload = require('express-fileupload');
const fs = require('fs');
const conf = require('../config/config');
const path = require('path');
var httpProxy = require('http-proxy');

if(process.env.NODE_APP_INSTANCE == 0 || process.env.NODE_APP_INSTANCE == undefined && conf.ispezioniEnabled){ //se viene lanciato su pm2 solo il primo processo deve lanciare i cron
    const cron = require('../utils/cron');
    cron.initScheduledJobs();
} 

let proxyPath = '';
if(conf.proxyPath)
    proxyPath = conf.proxyPath;

//rotte
var um = require('../routes/um');
var notifiche = require('../routes/notifiche');
var verbali = require('../routes/verbali');
var anagrafiche = require('../routes/anagrafiche');
var pwa = require('../routes/pwa');

var app = express();

app.enable('trust proxy')

const corsOptionsDelegate = (req, callback) => {
    callback(null, {origin: true, credentials: true})
}

app.use(cors(corsOptionsDelegate)); //per permettere connessioni da angular e passaggio cookie
app.use(cookieSession({
    secret: "mykey",
    resave: false,
    saveUninitialized: true,
    /*cookie: {
        sameSite: 'none',
        secure: false
    }*/
}))
app.set("view options", {layout: false});
app.set('view engine', 'ejs');

//se sul server sono presenti le chiavi ssl per l https ridirigo il traffico https su https
if (fs.existsSync(conf.sslPrivateKeyLocation) && fs.existsSync(conf.sslPublicCertLocation)) {
    app.all('*', function(req, res, next){
        console.log('req start: ',req.secure, `${req.protocol}://${req.get('host')}${req.originalUrl}`);
        if (req.secure) {
            return next();
        }
        res.redirect(307, 'https://'+req.hostname + ':' + conf.httpsPort + req.url); //redirect 307 per POST
    });
}

//creo reversePorxy verso modulo di registrazione, va dichiarato prima di bodyparser perchè corrompe i dati in POST
var apiProxy = httpProxy.createProxyServer();
app.all(proxyPath + '/registrazione/*', function(req, res) {
    console.log('redirecting to REGISTRAZONE');
    apiProxy.web(req, res, {target: conf.moduloRegistrazioneEndpoint});
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// enable files upload
app.use(fileUpload({createParentPath: true}));

//monto rotte
app.use(proxyPath + '/um', um);
app.use(proxyPath + '/notifiche', notifiche);
app.use(proxyPath + '/verbali', verbali);
app.use(proxyPath + '/anagrafiche', anagrafiche);
app.use(proxyPath + '/pwa', pwa);

if(conf.ispezioniEnabled){
    var ispezioni = require('../routes/ispezioni');
    var sanzioni = require('../routes/sanzioni');
    var macchine = require('../routes/macchine');

    app.use(proxyPath + '/ispezioni', ispezioni);
    app.use(proxyPath + '/sanzioni', sanzioni);
    app.use(proxyPath + '/macchine', macchine);
}



//servo l app static angular
app.use(express.static(conf.staticAngularAppPath));
app.get('*', (req,res) =>{
    res.sendFile(path.join(__dirname + '/../' + conf.staticAngularAppPath + 'index.html'));
});




exports.app = app;
