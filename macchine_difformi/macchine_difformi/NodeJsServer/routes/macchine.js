//rotta per macchine
var express = require('express');
var router = express.Router();
var conn = require('../db/connection');
const base64url = require('base64url');
const path = require("path");
const fs = require("fs");
var auth = require('../utils/auth');

// get Macchine Difformi
router.get("/getMacchine", function (req, res) {
    try {
        const query = `
            select 	vm.id,
                    vm.id_macchina,
                    vm.modello,
                    vm.id_tipo_macchina,
                    vm.id_costruttore,
                    vm.descr_tipo_macchina,
                    vm.descr_costruttore,
                    vm.data_modifica,
                    vm.data_inserimento,
                    vm.id_utente,
                    vm."fName" as filename
            from gds_macchine.vw_macchine vm;
        `;
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

async function getDocument(res, idMacchina) {
	const query = `select * from gds_macchine.vw_macchine vm where vm.id_macchina = ${idMacchina}`;
	console.log(query);
	conn.client.safequery(query, (err, result) => {
		if (err) {
			console.log(err.stack)
			res.writeHead(500).end();
		} else {
			try {
                console.log("result.rows[0]:", result.rows[0]);
                let tmp = "static/verbali/tmp/";
				let filenamePdf = result.rows[0].fName;
				const pathnameFile = path.join(tmp, filenamePdf);
				
				fs.writeFileSync(pathnameFile, base64url.toBuffer(result.rows[0].fileinfo));
				res.set({"Access-Control-Expose-Headers": 'Content-Disposition'});
				res.download(pathnameFile, filenamePdf, function (err) {
					if (err) {
						console.log(err);
						res.status(500).send(err).end();
					}
					fs.unlinkSync(pathnameFile)
				});
			} catch (e) {
				console.log(e.stack);
				res.end();
			}
		}
	})
}

// Download Info File
router.post("/downloadInfoFile", async function (req, res) {
    try {
        const idMacchina = req.query.idMacchina; // id_macchina
        console.log("selMacchina:", idMacchina);
        getDocument(res, idMacchina);
    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }
})

// update Macchine
router.post("/updMacchine", auth.authenticateToken, function (req, res) {
    try {
        const stringMacchina = req.query.macchina;
        console.log("stringMacchina:", stringMacchina)

        const file = req.files.file;
        console.log("req.query.file:", file);

        const filename = req.query.filename;
        console.log("filename:", filename);

        const queryMacchine = `
            select gds_macchine.upd_macchine('${stringMacchina}', ${1}, '${file.data.toString('base64url')}'::bytea, '${filename}', ${req.authData.idUtente});
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


router.post("/eliminaInfoFile", auth.authenticateToken, function (req, res) {
    try {

        const queryMacchine = `
            update gds_macchine.macchine set data_eliminazione = current_timestamp where id = ${req.query.idMacchina};
        `;

        console.log("queryMacchine:", queryMacchine);

        conn.client.safequery(queryMacchine, (err, result) => {
            if (err) {
                console.log(err.stack);
                res.writeHead(500).end();
            } else {
                console.log("result Macchine:", result.rows);
                res.json(result.rows);
            }
        })

    } catch (e) {
        console.log(e.stack);
        res.writeHead(500).end();
    }
})

module.exports = router;
