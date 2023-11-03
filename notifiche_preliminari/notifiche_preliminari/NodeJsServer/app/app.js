var express = require('express');
var cookieSession = require('express-session')
const cors = require('cors');
var bodyParser = require("body-parser");
const fileUpload = require('express-fileupload');
var fs = require('fs');
var conf = require('../config/config');
const path = require('path');

//rotte
var um = require('../routes/um');
var notifiche = require('../routes/notifiche');
var verbali = require('../routes/verbali');
var anagrafiche = require('../routes/anagrafiche');
var ispezioni = require('../routes/ispezioni');
var sanzioni = require('../routes/sanzioni');

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

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// enable files upload
app.use(fileUpload({createParentPath: true}));

//monto rotte
app.use('/um', um);
app.use('/notifiche', notifiche);
app.use('/verbali', verbali);
app.use('/anagrafiche', anagrafiche);
app.use('/ispezioni', ispezioni);
app.use('/sanzioni', sanzioni);


//servo l app static angular
app.use(express.static(conf.staticAngularAppPath));
app.get('*', (req,res) =>{
    res.sendFile(path.join(__dirname + '/../' + conf.staticAngularAppPath + 'index.html'));
});
exports.app = app;
