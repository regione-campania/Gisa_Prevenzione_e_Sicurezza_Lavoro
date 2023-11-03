const https = require('https');
const conf = require('../config/config.js');

var mapUtilts = {

    geocodePromise: function(address){
        return new Promise((resolve, reject) => {
            var geocodingService = conf.hereMapsGeocodingService;
            geocodingService = geocodingService.replace("[KEY]", conf.hereMapsApiKey);
            geocodingService = geocodingService.replace("[ADDRESS]", address);

            var options = {
                host: conf.hereMapsHost,
                path: encodeURI(geocodingService),
            };
            
            https.get(options, function (res) {
                var json = '';
                res.on('data', function (chunk) {
                    json += chunk;
                });
                res.on('end', function () {
                    if (res.statusCode === 200) {
                        try {
                            resolve(json);
                        } catch (e) {
                            console.log(e.stack);
                        }
                    } else {
                        console.log('Status:', res.statusCode);
                    }
                });
            }).on('error', function (err) {
                console.log('Error:', err);
                reject(err);
            });
        })
    },

    geocode: async function (address) {
        try {
            let promise = this.geocodePromise(address);
            return(await promise);
        }
        catch(error) {
            // Promise rejected
            console.log(error);
        }
    }

    
}

module.exports = mapUtilts;
