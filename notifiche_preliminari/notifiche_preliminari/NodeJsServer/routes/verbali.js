const PizZip = require("pizzip");
const Docxtemplater = require("docxtemplater");
var ImageModule = require('docxtemplater-image-module-free');
const express = require("express");
var router = express.Router();
var conn = require('../db/connection');
var mail = require('../email/email');
const fs = require("fs");
const libre = require('libreoffice-convert');
const http = require('http');
const base64url = require('base64url');
const expressions = require("angular-expressions");
const assign = require("lodash/assign");
const moment = require("moment");

libre.convertAsync = require('util').promisify(libre.convert);

function angularParser(tag) {
    tag = tag
        .replace(/^\.$/, "this")
        .replace(/(’|‘)/g, "'")
        .replace(/(“|”)/g, '"');

    const expr = expressions.compile(tag);
    return {
        get: function (scope, context) {
            let obj = {};
            const scopeList = context.scopeList;
            const num = context.num;
            for (let i = 0, len = num + 1; i < len; i++) {
                obj = assign(obj, scopeList[i]);
            }
            return expr(scope, obj);
        },
    };
}


async function convertNotifica(valori, res, tipoDocumento, id) {

	try {
		result = await conn.client.query(`select filename, email_creazione from gds_ui.verbali_ui where descr = '${tipoDocumento}'`)
		let filename = result.rows[0].filename;
		let sendMail = result.rows[0].email_creazione;

		var opts = {}
		opts.centered = false; //Set to true to always center images
		opts.fileType = "docx"; //Or pptx
		opts.getImage = function (tagValue, tagName) {
			console.log(tagValue, tagName)
			return fs.readFileSync(tagValue);
		}
		opts.getSize = function (img, tagValue, tagName) {
			const maxWidth = 150;
			const maxHeight = 100;
			const sizeOf = require("image-size");
			const sizeObj = sizeOf(img);
			const widthRatio = sizeObj.width / maxWidth;
			const heightRatio = sizeObj.height / maxHeight;
			if (widthRatio < 1 && heightRatio < 1) {
				return [sizeObj.width, sizeObj.height];
			}
			let finalWidth, finalHeight;
			if (widthRatio > heightRatio) {
				finalWidth = maxWidth;
				finalHeight = sizeObj.height / widthRatio;
			} else {
				finalHeight = maxHeight;
				finalWidth = sizeObj.width / heightRatio;
			}
			return [Math.round(finalWidth), Math.round(finalHeight)];
		}

		const content = fs.readFileSync("static/verbali/" + filename, "binary");

		const zip = new PizZip(content);

		const doc = new Docxtemplater(
			zip,
			{
				modules: [new ImageModule(opts)],
				paragraphLoop: true,
				linebreaks: true,
				nullGetter() { return ''; }
			}
		)
		valori.imageRegione = `static/loghiRegione/logoRegione.png`;
		valori.imageAsl = `static/loghiAsl/${valori.cantiere.codiceistatasl}.jpg`;
		doc.render(valori)

		const buf = doc.getZip().generate({
			type: "nodebuffer",
			compression: "DEFLATE",
		});

		const filenamePdf = `${tipoDocumento}_${valori.cantiere.cun}_${valori.cantiere.data_notifica}.pdf`;
		let tmp = "static/verbali/tmp/";
		let data = await libre.convertAsync(buf, ".pdf", undefined);
		fs.writeFileSync(tmp + filenamePdf, data);
		
		conn.client.query(`INSERT INTO gds_notifiche.documenti (tipo, id_interno, cod_documento, titolo, dati)
					VALUES ('${tipoDocumento}', '${id}','', '${filenamePdf}', '${data.toString('base64url')}'::bytea) returning id`), (err, result) => {
				if (err) {
					console.log(err.stack)
					res.writeHead(500).end();
				}
			}


		if(sendMail)
			mail.sendEmailAttivazioneNotifica(filenamePdf, data, valori);

		res.download(tmp + filenamePdf, filenamePdf, function (err) {
			if (err) {
				console.log(err);
				res.status(500).send(err).end();
			}
		});

	} catch (e) {
		console.log(e.stack);
		res.status(500).send(e).end();
	}
}

async function convertVerbale(valori, res, tipoDocumento, id) {

	try {
		result = await conn.client.query(`select filename from gds_ui.verbali_ui where descr = '${tipoDocumento}'`)
		let filename = result.rows[0].filename;

		const content = fs.readFileSync("static/verbali/" + filename, "binary");

		const zip = new PizZip(content);

		const doc = new Docxtemplater(
			zip,
			{
				parser: angularParser,
				paragraphLoop: true,
				linebreaks: true,
				nullGetter() { return ''; },
			}
		)

		//YYYY-MM-DD in DD-MM-YYYY
		for(var k in valori){
			if(valori.hasOwnProperty(k) && moment(valori[k], 'YYYY-MM-DD',true).isValid()){
				console.log(valori[k]);
				let splitted = valori[k].split("-");
				valori[k] = `${splitted[2]}-${splitted[1]}-${splitted[0]}`;
			}
		}
		
		doc.render(valori)


		const buf = doc.getZip().generate({
			type: "nodebuffer",
			compression: "DEFLATE",
		});

		const filenamePdf = `${valori.numero_verbale}.pdf`;
		let tmp = "static/verbali/tmp/";
		let data = await libre.convertAsync(buf, ".pdf", undefined);
		fs.writeFileSync(tmp + filenamePdf, data);
		

		res.download(tmp + filenamePdf, filenamePdf, function (err) {
			if (err) {
				console.log(err);
				res.status(500).send(err).end();
			}
			conn.client.query(`INSERT INTO gds_notifiche.documenti (tipo, id_interno, cod_documento, titolo, dati)
					VALUES ('${tipoDocumento}', '${id}','', '${filenamePdf}', '${data.toString('base64url')}'::bytea) returning id`), (err, result) => {
				if (err) {
					console.log(err.stack)
					res.writeHead(500).end();
				}
			}
		});

	} catch (e) {
		console.log(e.stack);
		res.status(500).send(e).end();
	}
}

async function getDocument(res, tipoDocumento, id) {
	let query = `select dati, titolo from gds_notifiche.documenti where id_interno = ${id} and tipo = '${tipoDocumento}' order by id desc limit 1`;
	console.log(query);
		conn.client.query(query, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				try {

					let tmp = "static/verbali/tmp/";
					let data = result.rows[0].dati;
					let filenamePdf = result.rows[0].titolo;
					fs.writeFileSync(tmp + filenamePdf, base64url.toBuffer(result.rows[0].dati));

					res.download(tmp + filenamePdf, filenamePdf, function (err) {
						if (err) {
							console.log(err);
							res.status(500).send(err).end();
						}
					});
				} catch (e) {
					console.log(e.stack);
					res.end();
				}
				/*try{
					console.log(result.rows[0].dati);
					res.writeHead(200, {
						'Content-Disposition': `attachment; filename="${result.rows[0].titolo}"`
					})
					res.write(base64url.toBuffer(result.rows[0].dati));
					res.end();
				}catch (e) {
					console.log(e.stack);
					res.writeHead(500).end();
				}*/
			}
		})
}

router.post("/getNotificaCompilata", async function (req, res) {

	try {
		console.log(req.body);
		var descrizioneVerbale = req.query.descrizioneVerbale;
		var isNew = req.query.nuovoPdf;
		var valori = (req.body);
		console.log(valori);
		console.log("Nuova notifica:" + isNew);
		if (isNew == "true")
			convertNotifica(valori, res, descrizioneVerbale, valori.cantiere.id_notifica);
		else
			getDocument(res, descrizioneVerbale, valori.cantiere.id_notifica);
	} catch (err) {
		console.log(err);
		res.status(500).send(err).end();
	}
});

router.post("/getVerbaleCompilato", async function (req, res) {

	try {
		console.log(req.body);
		var descrizioneVerbale = req.query.descrizioneVerbale;
		var valori = (req.body);
		console.log(valori);
		conn.client.query(`SELECT COUNT(*) from gds_notifiche.documenti where id_interno = ${valori.id_verbale} and tipo = '${descrizioneVerbale}'`, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				const count = result.rows[0].count;
				console.log("Gia esistente count: " + count);
				if(count >= 1) //esiste già quindi non lo rigenero
					getDocument(res, descrizioneVerbale, valori.id_verbale);
				else
					convertVerbale(valori, res, descrizioneVerbale, valori.id_verbale);
			}
		})

	} catch (err) {
		console.log(err);
		res.status(500).send(err).end();
	}
});

router.post('/upload', function (req, res) {

	if (!req.files || Object.keys(req.files).length === 0) {
		return res.status(400).send('No files were uploaded.').end();
	}
	let descrizioneVerbale = req.body.descrizioneVerbale;
	let sampleFile = req.files.sampleFile;
	let uploadPath = sampleFile.name;

	sampleFile.mv("static/verbali/" + uploadPath, function (err) {
		if (err)
			return res.status(500).send(err).end();

		conn.client.query(`INSERT INTO gds_ui.verbali (descr, filename)
							VALUES ('${descrizioneVerbale}', '${uploadPath}')
						   ON CONFLICT (descr) DO
							update set filename = '${uploadPath}'`
			, (err, result) => {
				if (err) {
					console.log(err.stack)
					res.writeHead(500).end();
				} else {
					res.status(200).send("Verbale aggiornato").end();
				}
			})

	});
});

router.get("/verbali", function (req, res) {
	res.sendFile('/verbali/index.html', { root: 'views' });
})

router.get("/getVerbali", function (req, res) {
	res.sendFile('/verbali/getVerbali.html', { root: 'views' });
})

router.get("/getJsonVerbale", function (req, res) {
	var idVerbale = req.query.idVerbale;
	try {

		//console.log(`select * from gds_srv.ins_notifica('${idNotificante}')`);
		conn.client.query(`select * from gds_srv.get_verbale_valori(${idVerbale}, 1)`, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				res.json(result.rows[0]).end();
			}
		})

	} catch (err) {
		console.log(err.stack)
		res.writeHead(500).end();
	}

})


router.post("/setJsonVerbale", function (req, res) {
	try {
		const query = `select * from gds_srv.upd_verbale_valori('${JSON.stringify(req.body.verbale).replace(/'/g, "''")}', 1)`;
		//console.log(`select * from gds_srv.ins_notifica('${idNotificante}')`);
		console.log(query);
		conn.client.query(query, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				res.json(JSON.parse(result.rows[0].upd_verbale_valori)).end();
			}
		})

	} catch (err) {
		console.log(err.stack)
		res.writeHead(500).end();
	}

})

router.get("/deleteVerbale", function (req, res) {
	var idVerbale = req.query.idVerbale;
	try {
		const query = `delete from gds.verbali where id = ${idVerbale}`;
		console.log(query);
		conn.client.query(query, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				res.json(JSON.parse(`{"esito": true}`)).end();
			}
		})

	} catch (err) {
		console.log(err.stack)
		res.writeHead(500).end();
	}

})


module.exports = router;