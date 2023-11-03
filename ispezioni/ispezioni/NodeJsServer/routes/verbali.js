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
const assign = require("lodash.assign");
const moment = require("moment");
var auth = require('../utils/auth');
const path = require("path");

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
		result = await conn.client.safequery(`select filename, email_creazione from gds_ui.verbali_ui where descr = '${tipoDocumento}'`)
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

		conn.client.safequery(`INSERT INTO gds_notifiche.documenti (tipo, id_interno, cod_documento, titolo, dati)
				VALUES ('${tipoDocumento}', '${id}','', '${filenamePdf}', '${data.toString('base64url')}'::bytea) returning id`), (err, result) => {
				if (err) {
					console.log(err.stack)
					res.writeHead(500).end();
				}
			}


		if (sendMail)
			mail.sendEmailAttivazioneNotifica(filenamePdf, data, valori);

		res.download(tmp + filenamePdf, filenamePdf, function (err) {
			if (err) {
				console.log(err);
				res.status(500).send(err).end();
			}
			fs.unlinkSync(tmp + filenamePdf)
		});

	} catch (e) {
		console.log(e.stack);
		res.status(500).send(e).end();
	}
}

async function convertVerbale(valori, res, tipoDocumento, id, filenameTemplate, formato) {

	try {
		console.log("\n\nCONVERT VERBALE!\n\n");
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

		const content = fs.readFileSync("static/verbali/" + filenameTemplate, "binary");

		const zip = new PizZip(content);

		const doc = new Docxtemplater(
			zip,
			{
				modules: [new ImageModule(opts)],
				parser: angularParser,
				paragraphLoop: true,
				linebreaks: true,
				nullGetter() { return ''; },
			}
		)

		//YYYY-MM-DD in DD-MM-YYYY
		for (var k in valori) {
			if (valori.hasOwnProperty(k) && moment(valori[k], 'YYYY-MM-DD', true).isValid()) {
				console.log(valori[k]);
				let splitted = valori[k].split("-");
				valori[k] = `${splitted[2]}-${splitted[1]}-${splitted[0]}`;
			}
		}

		if (valori.ID_ASL) {
			if (valori.ID_ASL == -1)
				valori.imageAsl = `static/loghiRegione/logoRegione.png`;
			else
				valori.imageAsl = `static/loghiAsl/${valori.ID_ASL}.jpg`;
		}else{
			valori.imageAsl = `static/loghiRegione/logoVuoto.png`;
		}
		console.log("valori convertVerbale:", valori);
		doc.render(valori)


		const buf = doc.getZip().generate({
			type: "nodebuffer",
			compression: "DEFLATE",
		});

		const filenamePdf = `${tipoDocumento}.${formato}`;
		// const filenamePdf = `${tipoDocumento}.pdf`;
		let tmp = "static/verbali/tmp/";
		// let data = await libre.convertAsync(buf, ".pdf", undefined);
		let data = await libre.convertAsync(buf, `.${formato}`, undefined);
		console.log(data);
		res.set({ "Access-Control-Expose-Headers": 'Content-Disposition' });
		fs.writeFileSync(tmp + filenamePdf, data);


		res.download(tmp + filenamePdf, filenamePdf, function (err) {
			if (err) {
				console.log(err);
				res.status(500).send(err).end();
			}
			fs.unlinkSync(tmp + filenamePdf)
			/*conn.client.safequery(`INSERT INTO gds_notifiche.documenti (tipo, id_interno, cod_documento, titolo, dati)
					VALUES ('${tipoDocumento}', '${id}','', '${filenamePdf}', '${data.toString('base64url')}'::bytea) returning id`), (err, result) => {
				if (err) {
					console.log(err.stack)
					res.writeHead(500).end();
				}
			}*/
		});

	} catch (e) {
		console.log(e.stack);
		res.status(500).send(e).end();
	}
}

async function getDocument(res, tipoDocumento, idIspezioneFase) {
	let query = `select dati, titolo from gds_notifiche.documenti where id_interno = ${idIspezioneFase} and tipo = '${tipoDocumento.replace(/'/g, "''")}' order by id desc limit 1`;
	console.log(query);
	conn.client.safequery(query, (err, result) => {
		if (err) {
			console.log(err.stack)
			res.writeHead(500).end();
		} else {
			try {
				console.log("titolo file: " + result.rows[0].titolo);
				let tmp = "static/verbali/tmp/";
				let data = result.rows[0].dati;
				let filenamePdf = result.rows[0].titolo;
				const pathnameFile = path.join(tmp, filenamePdf);
				console.log("result.rows[0].dati:", result.rows[0].dati);

				// fs.writeFileSync(tmp + filenamePdf, base64url.toBuffer(result.rows[0].dati));
				fs.writeFileSync(pathnameFile, base64url.toBuffer(result.rows[0].dati));
				res.set({ "Access-Control-Expose-Headers": 'Content-Disposition' });
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
		var valori = (req.body);
		console.log(valori);
		const idIspezioneFase = req.query.idIspezioneFase;
		//let query = `SELECT COUNT(*) from gds_notifiche.documenti where id_interno = ${valori.id_verbale} and tipo = '${descrizioneVerbale}'`;
		let query = `select descr, filename from gds_ui.verbali_ui where id_modulo = ${valori.id_modulo} `;
		conn.client.safequery(query, async (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				const descrizioneVerbale = result.rows[0].descr;
				const filenameTemplate = result.rows[0].filename;

				//controllo se c'è un verbale allegato
				resultCount = await conn.client.safequery(`select * from gds_notifiche.documenti 
					where tipo = '${descrizioneVerbale}' and id_interno = ${valori.id_verbale} order by id desc limit 1`);

				if (resultCount.rowCount > 0) {
					console.log("Verbale Allegato!\n");
					getDocument(res, descrizioneVerbale, valori.id_verbale);
				} else {
					console.log("NO Verbale Allegato!\n");
					//recupero eventuali info sulle sanzioni della fase da inserire nel verbale
					result = await conn.client.safequery(`
					select p.importo_singolo_versamento, p.codice_avviso, v.punto_verbale_prescrizione, v.articolo_violato, v.norma  from pagopa.pagopa_pagamenti p 
					join pagopa.pagopa_pagamenti_info_verbale i on p.id = i.id_pagamento
					left join pagopa.violazione v on v.id_pagamento = p.id
					where id_sanzione = ${idIspezioneFase} and esito_invio = 'OK' and trashed_date is null`);
					valori.dati.sanzioni = result.rows;
					console.log("valori getVerbaleCompilato:", valori);
					convertVerbale(valori.dati, res, descrizioneVerbale, valori.id_verbale, filenameTemplate, 'pdf');
				}


			}
		})

	} catch (err) {
		console.log(err);
		res.status(500).send(err).end();
	}
});

router.post("/getVerbaleBianco", auth.authenticateToken, async function (req, res) {

	try {
		console.log(req.body);
		var valori = (req.body);
		console.log(valori);
		const idIspezioneFase = req.query.idIspezioneFase;
		const idIspezione = req.query.idIspezione;
		id_modulo = req.query.idModulo;
		const formato = req.query.formato;
		var valoriCustom = {
			nameUPG: req.authData.cognome + ' ' + req.authData.nome,
			cfUPG: req.authData.cf,
			nameupg2: '______________________________',
			ID_ASL: req.authData.idAslUtente,
			servizio: '_______________',
			cantiere: '_______________',
			impresa: '__________________________________',
			comune_cantiere: '________________',
			indirizzo_cantiere: '_____________________',
			cui: '______________________________',
			congiuntamente_a: '______________________________'
		}

		//let query = `SELECT COUNT(*) from gds_notifiche.documenti where id_interno = ${valori.id_verbale} and tipo = '${descrizioneVerbale}'`;
		let query = `select descr, filename from gds_ui.verbali_ui where id_modulo = ${id_modulo} `;
		conn.client.safequery(query, async (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				const descrizioneVerbale = result.rows[0].descr;
				const filenameTemplate = result.rows[0].filename;

				if (idIspezione != 'null') { //se sono nell 'ispezione

					let query = `
						select distinct                 
							i.id,
							coalesce(s.descr, '_______________') as servizio,
							coalesce(c.cuc, '_______________') as cantiere,
							'__________________________________' as impresa,
							coalesce(oi.comune_testo ||' ('||oi.provincia||')', '________________') as comune_cantiere,   
							coalesce(oi.via || ', '|| oi.civico, '_____________________') as indirizzo_cantiere,
							coalesce(i.codice_ispezione, '______________________________') as cui,
							case when i.id_ente_uo = -1 then i.altro_ente else coalesce(e.descr_ente_uo, '______________________') end as congiuntamente_a,
							coalesce(va.namefirst ||' '||va.namelast , '______________________') as nameupg2
						from gds.ispezioni i
								left join gds.servizi s on s.id = i.id_servizio
								left join gds_notifiche.cantieri c on c.id = i.id_cantiere
								left join public.opu_indirizzo oi on oi.id = c.id_indirizzo
								left join gds_types.vw_ente_uo e on e.id = i.id_ente_uo
								left join gds.nucleo_ispettori ni on ni.id_ispezione = i.id and ni.id_access != 40393
								left join gds.vw_access va on va.id_access = ni.id_access
						where  i.id = ${idIspezione} limit 1`;

					if(idIspezioneFase != 'null'){ //se ho anche la fase cerco ulteriori info aggiuntive
						query = `
						select distinct 		i.id,
							coalesce(s.descr, '_______________') as servizio, 
							coalesce(c.cuc, '_______________') as cantiere, 
							coalesce(i3.ragione_sociale, '__________________________________') as impresa,
							coalesce(oi.comune_testo ||' ('||oi.provincia||')', '________________') as comune_cantiere, 
							coalesce(oi.via || ', '|| oi.civico, '_____________________') as indirizzo_cantiere,
							coalesce(i.codice_ispezione, '______________________________') as cui,
							case when i.id_ente_uo = -1 then i.altro_ente else coalesce(e.descr_ente_uo, '______________________') end as congiuntamente_a,
							coalesce(va.namefirst ||' '||va.namelast , '______________________') as nameupg2
						from gds.ispezioni i
							left join gds.servizi s on s.id = i.id_servizio 
							left join gds_notifiche.cantieri c on c.id = i.id_cantiere 
							left join public.opu_indirizzo oi on oi.id = c.id_indirizzo 
							left join gds.ispezione_fasi i2 on i2.id_ispezione = i.id
							left join gds.impresa_sedi is2 on is2.id = i2.id_impresa_sede 
							left join gds.imprese i3 on i3.id = is2.id_impresa 
							left join gds_types.vw_ente_uo e on e.id = i.id_ente_uo 
							left join gds.nucleo_ispettori ni on ni.id_ispezione = i.id and ni.id_access != ${req.authData.idUtente}
							left join gds.vw_access va on va.id_access = ni.id_access  
						where i2.id = ${idIspezioneFase} limit 1
						`;

						result = await conn.client.safequery(`
							select p.importo_singolo_versamento, p.codice_avviso, v.punto_verbale_prescrizione, v.articolo_violato, v.norma  from pagopa.pagopa_pagamenti p 
							join pagopa.pagopa_pagamenti_info_verbale i on p.id = i.id_pagamento
							left join pagopa.violazione v on v.id_pagamento = p.id
							where id_sanzione = ${idIspezioneFase} and esito_invio = 'OK' and trashed_date is null`);
							valoriCustom.sanzioni = result.rows;
						}
					console.log(query);

					let resultCantiereImpresa = await conn.client.safequery(query);

					valoriCustom.servizio = resultCantiereImpresa.rows[0].servizio;
					valoriCustom.cantiere = resultCantiereImpresa.rows[0].cantiere;
					valoriCustom.impresa = resultCantiereImpresa.rows[0].impresa;
					valoriCustom.comune_cantiere = resultCantiereImpresa.rows[0].comune_cantiere;
					valoriCustom.indirizzo_cantiere = resultCantiereImpresa.rows[0].indirizzo_cantiere;
					valoriCustom.cui = resultCantiereImpresa.rows[0].cui;
					valoriCustom.nameupg2 = resultCantiereImpresa.rows[0].nameupg2;
					valoriCustom.congiuntamente_a = resultCantiereImpresa.rows[0].congiuntamente_a;

		
				}

				if(idIspezioneFase == 'null') {
					valoriCustom.sanzioni = [];
					for (let i = 0; i < 5; i++) {
						valoriCustom.sanzioni.push({
							importo_singolo_versamento: null,
							codice_avviso: null,
							punto_verbale_prescrizione: null,
							articolo_violato: null,
							norma: null
						});
					}
				}

				convertVerbale(valoriCustom, res, descrizioneVerbale, null, filenameTemplate, formato);
			}
		})

	} catch (err) {
		console.log(err);
		res.status(500).send(err).end();
	}
});

// CALLED ROUTE
router.post("/getVerbaleBiancoCompilato", async function (req, res) {

	try {
		console.log(req.body);
		console.log("idModulo from Route: " + req.query.idModulo);
		console.log("idIspezioneFase from Route: " + req.query.idIspezioneFase);
		console.log("idAllegato: " + req.query.idAllegato);
		const idModulo = req.query.idModulo;
		const idIspezioneFase = req.query.idIspezioneFase;
		const idAllegato = req.query.idAllegato;

		let query = `select tipo from gds_notifiche.documenti where id_interno = ${idIspezioneFase} and tipo = (select descr from gds_types.moduli where id = ${idModulo})`;

		if (idAllegato != 'null') query = query + ` and id = ${idAllegato}`;

		conn.client.safequery(query, async (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				// const descrizioneVerbale = result.rows[0].descr;
				console.log("result row: " + result.rows[0]);
				const tipoVerbale = result.rows[0].tipo;

				// Controllo se c'è un verbale allegato
				resultCount = await conn.client.safequery(`select * from gds_notifiche.documenti 
					where tipo = '${tipoVerbale.replace(/'/g, "''")}' and id_interno = ${idIspezioneFase} order by id desc limit 1`);

				if (resultCount.rowCount > 0) {
					getDocument(res, tipoVerbale, idIspezioneFase);
				}
			}
		})

	} catch (err) {
		console.log("Error from catch: " + err);
		res.status(500).send(err).end();
	}
});

// CALLED ROUTE
router.get("/deleteVerbaleBianco", function (req, res) {

	try {
		console.log(req.body);
		const idModulo = req.query.idModulo;
		const idFase = req.query.idIspezioneFase;
		const idAllegato = req.query.idAllegato;

		console.log("\ntypeof idAllegato:", typeof idAllegato);

		let query = `delete from gds_notifiche.documenti where id_interno = ${idFase} and tipo in (select descr from gds_types.moduli where id in (${idModulo}))`;
		// let query = `delete from gds_notifiche.documenti where id_interno = ${idFase}`;
		if (idAllegato != 'null') query = query + ` and id = ${idAllegato}`;

		console.log(query);
		conn.client.safequery(query, (err, result) => {
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

router.post('/allegaVerbaleCompleto', function (req, res) {
	const file = req.files.file;
	const idVerbale = req.query.idVerbale;
	let query = `Select m.descr from gds.verbali v join gds_types.moduli m on m.id = v.id_modulo where v.id = ${idVerbale}`;
	conn.client.safequery(query, (err, result) => {
		try {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				const descrizioneVerbale = result.rows[0].descr;
				let insert = `Insert into gds_notifiche.documenti (tipo, id_interno, titolo, dati)
					values ('${descrizioneVerbale}', ${idVerbale}, '${file.name.replace(/'/g, "''")}', '${file.data.toString('base64url')}'::bytea)`;
				conn.client.safequery(insert)
				res.json({ esito: true }).end();

			}
		} catch (e) {
			console.log(e.stack);
			res.writeHead(500).end();
		}
	})
});

router.post('/allegaVerbaleBianco', function (req, res) {
	const file = req.files.file;
	const idModulo = req.query.idModulo;
	const idIspezioneFase = req.query.idIspezioneFase;
	let query = `Select m.descr from gds_types.moduli m where m.id = ${idModulo}`;
	conn.client.safequery(query, async (err, result) => {
		try {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				const descrizioneVerbale = result.rows[0].descr;
				let insert = `Insert into gds_notifiche.documenti (tipo, id_interno, titolo, dati)
					values ('${descrizioneVerbale.replace(/'/g, "''")}', ${idIspezioneFase}, '${file.name.replace(/'/g, "''")}', '${file.data.toString('base64url')}'::bytea)`;
				await conn.client.safequery(insert)
				res.json({ esito: true }).end();

			}
		} catch (e) {
			console.log(e.stack);
			res.writeHead(500).end();
		}
	})
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

		conn.client.safequery(`INSERT INTO gds_ui.verbali (descr, filename)
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
		conn.client.safequery(`select * from gds_srv.get_verbale_valori(${idVerbale}, 1)`, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				res.json(JSON.parse(result.rows[0].get_verbale_valori)).end();
			}
		})

	} catch (err) {
		console.log(err.stack)
		res.writeHead(500).end();
	}

})


router.post("/setJsonVerbale", function (req, res) {

	const verbale = req.body.verbale;
	const idVerbale = req.body.idVerbale == undefined ? null : req.body.idVerbale;
	const idModulo = req.body.idModulo;
	const idIspezioneFase = req.body.idIspezioneFase;

	try {
		const query = `select * from gds.upd_verbale_valori('${JSON.stringify(verbale).replace(/'/g, "''")}', 1, ${idVerbale}::bigint, ${idModulo}::bigint, ${idIspezioneFase}::bigint)`;
		//console.log(`select * from gds_srv.ins_notifica('${idNotificante}')`);
		console.log(query);
		conn.client.safequery(query, (err, result) => {
			if (err) {
				console.log(err.stack)
				res.writeHead(500).end();
			} else {
				res.json((result.rows[0])).end();
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
		conn.client.safequery(query, (err, result) => {
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


generaRicevutaRT = async function (valori, res, filename, idPagamento) {

	try {
		let formato = 'pdf';
		console.log("\n\nCONVERT VERBALE!\n\n");
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

		const content = fs.readFileSync("static/verbali/template_ricevuta_di_pagamento.docx", "binary");

		const zip = new PizZip(content);

		const doc = new Docxtemplater(
			zip,
			{
				modules: [new ImageModule(opts)],
				parser: angularParser,
				paragraphLoop: true,
				linebreaks: true,
				nullGetter() { return ''; },
			}
		)

		//YYYY-MM-DD in DD-MM-YYYY
		for (var k in valori) {
			if (valori.hasOwnProperty(k) && moment(valori[k], 'YYYY-MM-DD', true).isValid()) {
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

		const filenamePdf = `${filename}.${formato}`;
		// const filenamePdf = `${tipoDocumento}.pdf`;
		let tmp = "static/verbali/tmp/";
		// let data = await libre.convertAsync(buf, ".pdf", undefined);
		let data = await libre.convertAsync(buf, `.${formato}`, undefined);
		res.set({ "Access-Control-Expose-Headers": 'Content-Disposition' });
		fs.writeFileSync(tmp + filenamePdf, data);

		res.download(tmp + filenamePdf, filenamePdf, function (err) {
			if (err) {
				console.log(err);
				res.status(500).send(err).end();
			}
			fs.unlinkSync(tmp + filenamePdf);
			conn.client.safequery(`
				update pagopa.pagamenti_pdf set 
				pdf_rt = '${data.toString('base64url')}'::bytea,
				filename_rt = '${filenamePdf}'
				where id_pagamento = ${idPagamento}`), (err, result) => {
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


getRicevutaRT = async function (data, filenamePdf, res) {
	
	try {
		console.log("nome file: " + filenamePdf);
		let tmp = "static/verbali/tmp/";
		const pathnameFile = path.join(tmp, filenamePdf);

		fs.writeFileSync(pathnameFile, base64url.toBuffer(data));
		res.set({ "Access-Control-Expose-Headers": 'Content-Disposition' });
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

module.exports = router;
module.exports.generaRicevutaRT = generaRicevutaRT;
module.exports.getRicevutaRT = getRicevutaRT;