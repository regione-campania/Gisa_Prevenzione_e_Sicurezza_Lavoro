--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pagopa; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pagopa;


ALTER SCHEMA pagopa OWNER TO postgres;

--
-- Name: get_chiamata_ws_pagopa_chiedi_pagati(text, text, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_chiamata_ws_pagopa_chiedi_pagati(_username text, _password text, _id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
SET SEARCH_PATH = 'pagopa';

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ente="http://www.regione.veneto.it/pagamenti/ente/">
   <soapenv:Header/>
   <soapenv:Body>
      <ente:paaSILChiediPagatiConRicevuta>
         <codIpaEnte>', _username, '</codIpaEnte>
         <password>', _password, '</password>
         <identificativoUnivocoDovuto>', identificativo_univoco_dovuto, '</identificativoUnivocoDovuto>
      </ente:paaSILChiediPagatiConRicevuta>
   </soapenv:Body>
</soapenv:Envelope>') into ret
from pagopa_pagamenti  
where id = _id_pagamento and trashed_date is null;

 RETURN ret;
 END;
$$;


ALTER FUNCTION pagopa.get_chiamata_ws_pagopa_chiedi_pagati(_username text, _password text, _id_pagamento integer) OWNER TO postgres;

--
-- Name: get_chiamata_ws_pagopa_importa_dovuto(text, text, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto(_username text, _password text, _id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
SET SEARCH_PATH = 'pagopa';

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://www.regione.veneto.it/pagamenti/ente/ppthead" xmlns:ente="http://www.regione.veneto.it/pagamenti/ente/">
<soapenv:Header>
<ppt:intestazionePPT>
<codIpaEnte>', _username, '</codIpaEnte>
</ppt:intestazionePPT>
</soapenv:Header>
<soapenv:Body>
<ente:paaSILImportaDovuto>
<password>', _password, '</password>
<dovuto>', (select * from get_pagopa_dovuto(_id_pagamento)) , '</dovuto>
<flagGeneraIuv>true</flagGeneraIuv>
</ente:paaSILImportaDovuto>
</soapenv:Body>
</soapenv:Envelope>') into ret
from pagopa_pagamenti 
where id = _id_pagamento;

 RETURN ret;
 END;
$$;


ALTER FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto(_username text, _password text, _id_pagamento integer) OWNER TO postgres;

--
-- Name: get_chiamata_ws_pagopa_importa_dovuto_aggiorna(text, text, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto_aggiorna(_username text, _password text, _id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
SET SEARCH_PATH = 'pagopa';

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://www.regione.veneto.it/pagamenti/ente/ppthead" xmlns:ente="http://www.regione.veneto.it/pagamenti/ente/">
<soapenv:Header>
<ppt:intestazionePPT>
<codIpaEnte>', _username, '</codIpaEnte>
</ppt:intestazionePPT>
</soapenv:Header>
<soapenv:Body>
<ente:paaSILImportaDovuto>
<password>', _password, '</password>
<dovuto>', (select * from get_pagopa_dovuto_aggiorna(_id_pagamento)) , '</dovuto>
<flagGeneraIuv>true</flagGeneraIuv>
</ente:paaSILImportaDovuto>
</soapenv:Body>
</soapenv:Envelope>') into ret
from pagopa_pagamenti
where id = _id_pagamento;

 RETURN ret;
 END;
$$;


ALTER FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto_aggiorna(_username text, _password text, _id_pagamento integer) OWNER TO postgres;

--
-- Name: get_chiamata_ws_pagopa_importa_dovuto_annulla(text, text, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto_annulla(_username text, _password text, _id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
SET SEARCH_PATH = 'pagopa';

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://www.regione.veneto.it/pagamenti/ente/ppthead" xmlns:ente="http://www.regione.veneto.it/pagamenti/ente/">
<soapenv:Header>
<ppt:intestazionePPT>
<codIpaEnte>', _username, '</codIpaEnte>
</ppt:intestazionePPT>
</soapenv:Header>
<soapenv:Body>
<ente:paaSILImportaDovuto>
<password>', _password, '</password>
<dovuto>', (select * from get_pagopa_dovuto_annulla(_id_pagamento)) , '</dovuto>
<flagGeneraIuv>false</flagGeneraIuv>
</ente:paaSILImportaDovuto>
</soapenv:Body>
</soapenv:Envelope>') into ret
from pagopa_pagamenti 
where id = _id_pagamento;

 RETURN ret;
 END;
$$;


ALTER FUNCTION pagopa.get_chiamata_ws_pagopa_importa_dovuto_annulla(_username text, _password text, _id_pagamento integer) OWNER TO postgres;

--
-- Name: get_pagopa_dovuto(integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_pagopa_dovuto(_id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE  
 ret text;  
 req text;
BEGIN 
SET SEARCH_PATH = 'pagopa';


SELECT regexp_replace(encode (request::bytea, 'base64'), E'[\\n\\r]+', '', 'g' ), request into ret, req FROM (

select distinct
concat(
'<?xml version="1.0" encoding = "UTF-8" standalone = "yes" ?>
<Versamento xmlns="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/" xsi:schemaLocation="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/schema.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<versioneOggetto>6.0</versioneOggetto>
	<soggettoPagatore>
		<identificativoUnivocoPagatore>
			<tipoIdentificativoUnivoco>', paga.tipo_pagatore,'</tipoIdentificativoUnivoco>
			<codiceIdentificativoUnivoco>',paga.piva_cf, '</codiceIdentificativoUnivoco>
		</identificativoUnivocoPagatore>
		<anagraficaPagatore>', regexp_replace(paga.ragione_sociale_nominativo||' '||coalesce(paga.cognome,''),  '[^\w]+',' ','g'), '</anagraficaPagatore>',
		case when paga.indirizzo <> '' then concat('<indirizzoPagatore>', paga.indirizzo, '</indirizzoPagatore>') else '' end,
		case when paga.civico <> '' then concat('<civicoPagatore>', paga.civico, '</civicoPagatore>') else '' end,
		case when paga.cap <> '' then concat('<capPagatore>', paga.cap, '</capPagatore>') else '' end,
		case when paga.comune <> '' then concat('<localitaPagatore>', paga.comune, '</localitaPagatore>') else '' end,
		case when paga.cod_provincia <> '' then concat('<provinciaPagatore>', paga.cod_provincia, '</provinciaPagatore>') else '' end,
		case when paga.nazione <> '' then concat('<nazionePagatore>', paga.nazione, '</nazionePagatore>') else '' end,
		case when paga.domicilio_digitale <> '' then concat('<e-mailPagatore>', paga.domicilio_digitale, '</e-mailPagatore>') else '' end,
        '</soggettoPagatore>
	<datiVersamento>',
	case when pa.data_scadenza <> '' then concat('<dataEsecuzionePagamento>', pa.data_scadenza, '</dataEsecuzionePagamento>') else '' end,
         '<tipoVersamento>', pa.tipo_versamento, '</tipoVersamento>
		<identificativoUnivocoDovuto>', pa.identificativo_univoco_dovuto, '</identificativoUnivocoDovuto>
		<importoSingoloVersamento>', pa.importo_singolo_versamento, '</importoSingoloVersamento>
		<identificativoTipoDovuto>', pa.identificativo_tipo_dovuto, '</identificativoTipoDovuto>
		<causaleVersamento>', pa.causale_versamento, '</causaleVersamento>
		<datiSpecificiRiscossione>', pa.dati_specifici_riscossione, '</datiSpecificiRiscossione>
	</datiVersamento>
	<azione>I</azione>
</Versamento>') as request

from pagopa_pagamenti pa
left join pagopa_anagrafica_pagatori paga on paga.id = pa.id_pagatore
where pa.id = _id_pagamento and pa.trashed_date is null

) aa;

raise info '[PAGOPA REQUEST] %', req;

return ret;

END $$;


ALTER FUNCTION pagopa.get_pagopa_dovuto(_id_pagamento integer) OWNER TO postgres;

--
-- Name: get_pagopa_dovuto_aggiorna(integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_pagopa_dovuto_aggiorna(_id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE  
 ret text;  
 req text;
BEGIN 
SET SEARCH_PATH = 'pagopa';


SELECT regexp_replace(encode (request::bytea, 'base64'), E'[\\n\\r]+', '', 'g' ), request into ret, req FROM (

select distinct
concat(
'<?xml version="1.0" encoding = "UTF-8" standalone = "yes" ?>
<Versamento xmlns="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/" xsi:schemaLocation="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/schema.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<versioneOggetto>6.0</versioneOggetto>
	<soggettoPagatore>
		<identificativoUnivocoPagatore>
			<tipoIdentificativoUnivoco>', paga.tipo_pagatore,'</tipoIdentificativoUnivoco>
			<codiceIdentificativoUnivoco>',paga.piva_cf, '</codiceIdentificativoUnivoco>
		</identificativoUnivocoPagatore>
		<anagraficaPagatore>', regexp_replace(paga.ragione_sociale_nominativo||' '||coalesce(paga.cognome,''),  '[^\w]+',' ','g'), '</anagraficaPagatore>',
		case when paga.indirizzo <> '' then concat('<indirizzoPagatore>', paga.indirizzo, '</indirizzoPagatore>') else '' end,
		case when paga.civico <> '' then concat('<civicoPagatore>', paga.civico, '</civicoPagatore>') else '' end,
		case when paga.cap <> '' then concat('<capPagatore>', paga.cap, '</capPagatore>') else '' end,
		case when paga.comune <> '' then concat('<localitaPagatore>', paga.comune, '</localitaPagatore>') else '' end,
		case when paga.cod_provincia <> '' then concat('<provinciaPagatore>', paga.cod_provincia, '</provinciaPagatore>') else '' end,
		case when paga.nazione <> '' then concat('<nazionePagatore>', paga.nazione, '</nazionePagatore>') else '' end,
		case when paga.domicilio_digitale <> '' then concat('<e-mailPagatore>', paga.domicilio_digitale, '</e-mailPagatore>') else '' end,
        '</soggettoPagatore>
	<datiVersamento>',
	case when pa.data_scadenza <> '' then concat('<dataEsecuzionePagamento>', pa.data_scadenza, '</dataEsecuzionePagamento>') else '' end,
         '<tipoVersamento>', pa.tipo_versamento, '</tipoVersamento>
               <identificativoUnivocoVersamento>', pa.identificativo_univoco_versamento, '</identificativoUnivocoVersamento>
               <identificativoUnivocoDovuto>', pa.identificativo_univoco_dovuto, '</identificativoUnivocoDovuto>
		<importoSingoloVersamento>', pa.importo_singolo_versamento, '</importoSingoloVersamento>
		<identificativoTipoDovuto>', pa.identificativo_tipo_dovuto, '</identificativoTipoDovuto>
		<causaleVersamento>', pa.causale_versamento, '</causaleVersamento>
		<datiSpecificiRiscossione>', pa.dati_specifici_riscossione, '</datiSpecificiRiscossione>
	</datiVersamento>
	<azione>M</azione>
</Versamento>') as request


from pagopa_pagamenti pa
join pagopa_anagrafica_pagatori paga on paga.id = pa.id_pagatore
where pa.id = _id_pagamento and pa.trashed_date is null

) aa;

raise info '[PAGOPA REQUEST] %', req;

return ret;

END $$;


ALTER FUNCTION pagopa.get_pagopa_dovuto_aggiorna(_id_pagamento integer) OWNER TO postgres;

--
-- Name: get_pagopa_dovuto_annulla(integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_pagopa_dovuto_annulla(_id_pagamento integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE  
 ret text;  
 req text;
BEGIN 
SET SEARCH_PATH = 'pagopa';


SELECT regexp_replace(encode (request::bytea, 'base64'), E'[\\n\\r]+', '', 'g' ), request into ret, req FROM (

select distinct
concat(
'<?xml version="1.0" encoding = "UTF-8" standalone = "yes" ?>
<Versamento xmlns="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/" xsi:schemaLocation="http://www.regione.veneto.it/schemas/2012/Pagamenti/Ente/schema.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<versioneOggetto>6.0</versioneOggetto>
	<soggettoPagatore>
		<identificativoUnivocoPagatore>
			<tipoIdentificativoUnivoco>', paga.tipo_pagatore,'</tipoIdentificativoUnivoco>
			<codiceIdentificativoUnivoco>',paga.piva_cf, '</codiceIdentificativoUnivoco>
		</identificativoUnivocoPagatore>
		<anagraficaPagatore>', regexp_replace(paga.ragione_sociale_nominativo||' '||coalesce(paga.cognome,''),  '[^\w]+',' ','g'), '</anagraficaPagatore>',
		case when paga.indirizzo <> '' then concat('<indirizzoPagatore>', paga.indirizzo, '</indirizzoPagatore>') else '' end,
		case when paga.civico <> '' then concat('<civicoPagatore>', paga.civico, '</civicoPagatore>') else '' end,
		case when paga.cap <> '' then concat('<capPagatore>', paga.cap, '</capPagatore>') else '' end,
		case when paga.comune <> '' then concat('<localitaPagatore>', paga.comune, '</localitaPagatore>') else '' end,
		case when paga.cod_provincia <> '' then concat('<provinciaPagatore>', paga.cod_provincia, '</provinciaPagatore>') else '' end,
		case when paga.nazione <> '' then concat('<nazionePagatore>', paga.nazione, '</nazionePagatore>') else '' end,
		case when paga.domicilio_digitale <> '' then concat('<e-mailPagatore>', paga.domicilio_digitale, '</e-mailPagatore>') else '' end,
        '</soggettoPagatore>
	<datiVersamento>',
	case when pa.data_scadenza <> '' then concat('<dataEsecuzionePagamento>', pa.data_scadenza, '</dataEsecuzionePagamento>') else '' end,
         '<tipoVersamento>', pa.tipo_versamento, '</tipoVersamento>
               <identificativoUnivocoDovuto>', pa.identificativo_univoco_dovuto, '</identificativoUnivocoDovuto>
		<importoSingoloVersamento>', pa.importo_singolo_versamento, '</importoSingoloVersamento>
		<identificativoTipoDovuto>', pa.identificativo_tipo_dovuto, '</identificativoTipoDovuto>
		<causaleVersamento>', pa.causale_versamento, '</causaleVersamento>
		<datiSpecificiRiscossione>', pa.dati_specifici_riscossione, '</datiSpecificiRiscossione>
	</datiVersamento>
	<azione>A</azione>
</Versamento>') as request


from pagopa_pagamenti pa
left join pagopa_anagrafica_pagatori paga on paga.id = pa.id_pagatore
where pa.id = _id_pagamento and pa.trashed_date is null

) aa;

raise info '[PAGOPA REQUEST] %', req;

return ret;

END $$;


ALTER FUNCTION pagopa.get_pagopa_dovuto_annulla(_id_pagamento integer) OWNER TO postgres;

--
-- Name: get_sanzione(bigint, bigint); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_sanzione(id_record bigint, idtransazione bigint) RETURNS gds_types.result_type
    LANGUAGE plpgsql
    AS $$
begin
	declare
	ret gds_types.result_type; 
	id_op bigint;   
	proc_name varchar;
	R_S pagopa.pagopa_pagamenti%ROWTYPE;
	rt json;

	begin
		proc_name:='gds.get_ispezione';
		--id_op:=gds_log.start_op(proc_name,idtransazione ,'');
		select * into R_S from pagopa.pagopa_pagamenti where id=id_record;
		rt:=row_to_json(R_S);
	
		ret.valore:= id_record;
	
	    if rt->>'id' is null then 
    		ret.esito:=false;	
    		ret.msg:='id non trovato';
    		ret.info:=null; 
    	else
    		ret.esito:=true;
 			ret.msg:=null;
	 		ret.info:=rt;
	   	end if;

	    --ret:=gds_ui.build_ret(ret,proc_name,R_ISP.id);
	 	return ret;
	end;
	
end;
$$;


ALTER FUNCTION pagopa.get_sanzione(id_record bigint, idtransazione bigint) OWNER TO postgres;

--
-- Name: get_sazione(bigint, bigint); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.get_sazione(id_record bigint, idtransazione bigint) RETURNS gds_types.result_type
    LANGUAGE plpgsql
    AS $$
begin
	declare
	ret gds_types.result_type; 
	id_op bigint;   
	proc_name varchar;
	R_S pagopa.pagopa_pagamenti%ROWTYPE;
	rt json;

	begin
		proc_name:='gds.get_ispezione';
		--id_op:=gds_log.start_op(proc_name,idtransazione ,'');
		select * into R_S from pagopa.pagopa_pagamenti where id=id_record;
		rt:=row_to_json(R_S);
	
		ret.valore:= id_record;
	
	    if rt->>'id' is null then 
    		ret.esito:=false;	
    		ret.msg:='id non trovato';
    		ret.info:=null; 
    	else
    		ret.esito:=true;
 			ret.msg:=null;
	 		ret.info:=rt;
	   	end if;

	    --ret:=gds_ui.build_ret(ret,proc_name,R_ISP.id);
	 	return ret;
	end;
	
end;
$$;


ALTER FUNCTION pagopa.get_sazione(id_record bigint, idtransazione bigint) OWNER TO postgres;

--
-- Name: ins_pagamento(json, text, real, real); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real DEFAULT NULL::real) RETURNS text
    LANGUAGE plpgsql
    AS $$
	declare 
		id_pagatore bigint;
		id_pagamento bigint;
		data_contestazione date;
		ret_pagamenti text;
	begin
		
		raise notice 'Isnert %', j;
		id_pagatore = nextval('pagopa.pagopa_anagrafica_pagatori_id_seq'::regclass);
		insert into pagopa.pagopa_anagrafica_pagatori 
		(id, tipo_pagatore, piva_cf, ragione_sociale_nominativo, indirizzo, civico, cap, comune, cod_provincia, nazione, domicilio_digitale, entered, telefono)
		values 
		(
			id_pagatore,
			j->>'tipo_pagatore',
			j->>'p_iva_o_cod_fiscale',
			j->>'rag_sociale_o_nominativo',
			j->>'indirizzo',
			j->>'civico',
			j->>'cap',
			j->>'comune',
			j->>'cod_provincia',
			j->>'nazione',
			j->>'email',
			current_timestamp,
			j->>'telefono'
		);
	
		id_pagamento = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
		if j->>'mod_contestazione' = 'P' then
			data_contestazione = current_date;
		else --I immediata
			select data_fase::date into data_contestazione from gds.ispezione_fasi where id = id_fase;
			if data_contestazione is null then
				data_contestazione = current_date;
			end if;
		end if;
		
		insert into pagopa.pagopa_pagamenti 
		(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
		identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzione, numero_rate  )
		values
		(id_pagamento, id_fase, id_pagatore, to_char(data_contestazione  + interval '30 day', 'YYYY-MM-DD'), 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo,
		'2023', 'PV N.'||id_fase, '9/8711980576', current_timestamp, false, 1, 'PV', 'R', -1);
	
		ret_pagamenti = id_pagamento;
		
		if importo_ultraridotto is not null null then
			id_pagamento = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
			insert into pagopa.pagopa_pagamenti 
			(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
			identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzion, numero_rate  )
			values
			(id_pagamento, id_fase, id_pagatore,  to_char(data_contestazione + interval '5 day', 'YYYY-MM-DD'), 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo_ultraridotto,
			'2023', 'PV N.'||id_fase, '9/8711980576', current_timestamp, false, 1, 'PV', 'U', -1);
		
			ret_pagamenti = ret_pagamenti ||','||id_pagamento;
		
		end if;
	
		return ret_pagamenti;
	
	END;
$$;


ALTER FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real) OWNER TO postgres;

--
-- Name: ins_pagamento(json, text, real, real, bigint); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real DEFAULT NULL::real, id_fase bigint DEFAULT NULL::bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
	declare 
		id_pagatore bigint;
		id_pagamento bigint;
		data_contestazione date;
		ret_pagamenti text;
	begin
		
		raise notice 'Isnert %', j;
		id_pagatore = nextval('pagopa.pagopa_anagrafica_pagatori_id_seq'::regclass);
	
		insert into pagopa.pagopa_mapping_sanzioni_pagatori (id_sanzione, id_pagatore, trasgressore_obbligato, entered)
		values (id_fase, id_pagatore, trasgressore_o_obbligato, current_timestamp);
	
		insert into pagopa.pagopa_anagrafica_pagatori 
		(id, tipo_pagatore, piva_cf, ragione_sociale_nominativo, indirizzo, civico, cap, comune, cod_provincia, nazione, domicilio_digitale, entered, telefono)
		values 
		(
			id_pagatore,
			j->>'tipo_pagatore',
			coalesce(nullif(j->>'p_iva', ''), j->>'cod_fiscale'),
			coalesce(nullif(j->>'rag_sociale', ''), j->>'nominativo'),
			j->>'indirizzo',
			j->>'civico',
			j->>'cap',
			j->>'comune',
			j->>'cod_provincia',
			j->>'nazione',
			j->>'email',
			current_timestamp,
			j->>'telefono'
		);
	
		id_pagamento = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
		if j->>'mod_contestazione' = 'P' then
			data_contestazione = current_date;
		else --I immediata
			select coalesce(data_fase::date, CURRENT_DATE) into data_contestazione from gds.ispezione_fasi where id = id_fase;
			if data_contestazione is null then
				data_contestazione = current_date;
			end if;	
		end if;
	
		insert into pagopa.pagopa_sanzioni_pagatori_notifiche  (id_sanzione, id_pagatore, entered, tipo_notifica, data_notifica)
		values (id_fase, id_pagatore, current_timestamp, j->>'mod_contestazione', data_contestazione);
		
		insert into pagopa.pagopa_pagamenti 
		(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
		identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzione, numero_rate  )
		values
		(id_pagamento, id_fase, id_pagatore, to_char(data_contestazione  + interval '60 day', 'YYYY-MM-DD'), 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo,
		'2023', 'PV N.'||id_fase, '9/8711980576', current_timestamp, false, 1, 'PV', 'R', -1);
	
		ret_pagamenti = id_pagamento;
		
		if importo_ultraridotto is not null null then
			id_pagamento = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
			insert into pagopa.pagopa_pagamenti 
			(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
			identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzione, numero_rate  )
			values
			(id_pagamento, id_fase, id_pagatore,  to_char(data_contestazione + interval '5 day', 'YYYY-MM-DD'), 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo_ultraridotto,
			'2023', 'PV N.'||id_fase, '9/8711980576', current_timestamp, false, 1, 'PV', 'U', -1);
		
			ret_pagamenti = ret_pagamenti ||','||id_pagamento;
		
		end if;
	
		return ret_pagamenti;
	
	END;
$$;


ALTER FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real, id_fase bigint) OWNER TO postgres;

--
-- Name: ins_pagamento(json, text, real, real, bigint, json, bigint); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real DEFAULT NULL::real, id_fase bigint DEFAULT NULL::bigint, info_verbale json DEFAULT NULL::json, id_utente bigint DEFAULT NULL::bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
	declare 
		id_pagatore bigint;
		id_pag bigint;
		data_scadenza date;
		ret_pagamenti text;
		itemViolazione json;
	begin
		
		raise notice 'Isnert %', j;
		id_pagatore = nextval('pagopa.pagopa_anagrafica_pagatori_id_seq'::regclass);
	
		insert into pagopa.pagopa_mapping_sanzioni_pagatori (id_sanzione, id_pagatore, trasgressore_obbligato, entered)
		values (id_fase, id_pagatore, trasgressore_o_obbligato, current_timestamp);
	
		insert into pagopa.pagopa_anagrafica_pagatori 
		(id, tipo_pagatore, piva_cf, ragione_sociale_nominativo, indirizzo, civico, cap, comune, cod_provincia, nazione, domicilio_digitale, entered, telefono, cognome)
		values 
		(
			id_pagatore,
			upper(trim(j->>'TIPO_PAGATORE')),
			upper(trim(coalesce(nullif(j->>'P_IVA', ''), j->>'COD_FISCALE'))),
			upper(trim(coalesce(nullif(j->>'RAG_SOCIALE', ''), j->>'NOMINATIVO'))),
			upper(trim(j->>'INDIRIZZO')),
			upper(trim(j->>'CIVICO')),
			upper(trim(j->>'CAP')),
			upper(trim(j->>'COMUNE')),
			upper(trim(j->>'COD_PROVINCIA')),
			upper(trim(j->>'NAZIONE')),
			trim(j->>'EMAIL'),
			current_timestamp,
			upper(trim(j->>'TELEFONO')),
			upper(trim(j->>'COGNOME'))
		);
	
		id_pag = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
		
		-- if j->>'MOD_CONTESTAZIONE' = 'P' then --PEC
			-- data_scadenza = to_char(current_date  + interval '30 day', 'YYYY-MM-DD');
		-- elsif j->>'MOD_CONTESTAZIONE' = 'R' then --RACCOMANDATA
			-- data_scadenza = to_char(current_date  + interval '90 day', 'YYYY-MM-DD');
		
		raise notice 'Data Notifica: %', j->>'DATA_NOTIFICA';
	
		-- PEC o RACCOMANDATA
		if j->>'MOD_CONTESTAZIONE' = 'P' or j->>'MOD_CONTESTAZIONE' = 'R' then
			data_scadenza = to_char((j->>'DATA_NOTIFICA')::timestamp + interval '30 day', 'YYYY-MM-DD');
		else --I immediata
			data_scadenza = to_char(current_date  + interval '30 day', 'YYYY-MM-DD');
			-- select coalesce(data_fase::date, CURRENT_DATE) into data_scadenza from gds.ispezione_fasi where id = id_fase;
			-- if data_scadenza is null then
			--end if;	
		end if;
	
		insert into pagopa.pagopa_sanzioni_pagatori_notifiche (id_pagamento, id_pagatore, entered, tipo_notifica, data_notifica)
		values (id_pag, id_pagatore, current_timestamp, j->>'MOD_CONTESTAZIONE', j->>'DATA_NOTIFICA');
	
		-- Inserisce tutte le violazioni ad esso associate
		for itemViolazione in select * from json_array_elements((info_verbale->>'VIOLAZIONI')::json)
		loop
			insert into pagopa.violazione (punto_verbale_prescrizione, articolo_violato, norma, id_pagamento) values (itemViolazione->>'PUNTO_VERBALE_PRESCRIZIONE', itemViolazione->>'ARTICOLO_VIOLATO', itemViolazione->>'NORMA', id_pag);
		end loop;
	
		ret_pagamenti = id_pag;
	
		insert into pagopa.pagopa_pagamenti_info_verbale (id_pagamento, id_utente, proc_pen, rgnr, id_modulo, descrizione, n_protocollo, cantiere_o_impresa, data_verbale)
		values (
			id_pag, id_utente, info_verbale->>'PROC_PEN', info_verbale->>'RGNR', info_verbale->>'TIPO_VERBALE', info_verbale->>'DESCRIZIONE_LIBERA', info_verbale->>'NUMERO_PROTOCOLLO', info_verbale->>'CANTIEREORIMPRESA', info_verbale->>'DATA_VERBALE'
		);
	
		-- Query per creare la causale dell'ammenda
		insert into pagopa.pagopa_pagamenti 
		(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
		identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzione, numero_rate)
		values
		(id_pag, id_fase, id_pagatore, data_scadenza, 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo,
		'2023', coalesce(
				(select 'CUI '|| codice_ispezione  from gds.ispezioni i join gds.ispezione_fasi i2 on i2.id_ispezione = i.id where i2.id = id_fase),
				(select 'Verbale '|| s.descr || ' ASL ' || l.short_description || ' del ' || i.data_verbale ||' '|| string_agg(v.norma, ', ') 
				from pagopa.pagopa_pagamenti_info_verbale i
				join pagopa.violazione v on v.id_pagamento = i.id_pagamento 
				join public.access_ a on a.user_id = i.id_utente 
				join role r on r.role_id=a.role_id 
				join gds.servizi s on r.role ilike '%'||s.descr||'%'
				join public.lookup_site_id l on l.code = a.site_id 
				where i.id_pagamento = id_pag
				group by s.descr, l.short_description , i.data_verbale)
				)
	, '9/8711980576', current_timestamp, false, 1, 'PV', 'R', -1);
	
		/*if importo_ultraridotto is not null null then
			id_pagamento = nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);
			insert into pagopa.pagopa_pagamenti 
			(id, id_sanzione, id_pagatore, data_scadenza, tipo_versamento, identificativo_univoco_dovuto, importo_singolo_versamento,
			identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, entered, inviato, indice, tipo_pagamento, tipo_riduzione, numero_rate  )
			values
			(id_pagamento, id_fase, id_pagatore,  to_char(data_contestazione + interval '5 day', 'YYYY-MM-DD'), 'ALL', pagopa.pagopa_genera_identificativo_dovuto(id_fase::int), importo_ultraridotto,
			'2023', 'PV N.'||id_fase, '9/8711980576', current_timestamp, false, 1, 'PV', 'U', -1);
		
			ret_pagamenti = ret_pagamenti ||','||id_pagamento;
		
		end if;*/
	
		return ret_pagamenti;
	
	END;
$$;


ALTER FUNCTION pagopa.ins_pagamento(j json, trasgressore_o_obbligato text, importo real, importo_ultraridotto real, id_fase bigint, info_verbale json, id_utente bigint) OWNER TO postgres;

--
-- Name: ins_sanzione(character varying, bigint); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.ins_sanzione(v character varying, idtransazione bigint) RETURNS gds_types.result_type
    LANGUAGE plpgsql
    AS $$
begin
	declare
	ret gds_types.result_type; -- START
	id_fase bigint;
	j json;
	ret_pagamenti text;
	importo real;
	importo_ultraridotto real;
	info_verbale json;
	id_utente bigint;
	begin
	
	id_utente = idtransazione;
	--R_PAGATORE:=  json_populate_recordSET(null::RECORD, v::json->'info_pagatore');	
	--R_OBBLIGATO:=  json_populate_record(null::RECORD, v::json->'obbligato_in_solido');	
	id_fase = v::json->>'ID_ISPEZIONE_FASE';
	info_verbale = v::json->>'INFO_VERBALE';
	raise notice 'fase %', id_fase;
	importo = v::json->>'INFO_PAGAMENTO';
	importo_ultraridotto = v::json->'info_pagamento'->>'ULTRA_RIDOTTO';
	ret_pagamenti := '';
	j = v::json->'INFO_PAGATORE'->'TRASGRESSORE';
	if ((trim(j->>'P_IVA') != '' or trim(j->>'COD_FISCALE') != '') and (j->>'TIPO_PAGATORE' = 'G' or j->>'TIPO_PAGATORE' = 'F')) then 
		ret_pagamenti = pagopa.ins_pagamento(j, 'T', importo, importo_ultraridotto, id_fase, info_verbale, id_utente);
	end if;


	j = v::json->'INFO_PAGATORE'->'OBBLIGATO_IN_SOLIDO';
	if (trim(j->>'P_IVA') != '' and j->>'TIPO_PAGATORE' = 'G') or (trim(j->>'COD_FISCALE') != '' and j->>'TIPO_PAGATORE' = 'F') then 
			ret_pagamenti = ret_pagamenti ||','|| pagopa.ins_pagamento(j, 'O', importo, importo_ultraridotto, id_fase, info_verbale, id_utente);
	end if;

	ret.esito:=true;	
   	ret.info:=ret_pagamenti;
   
	if ret_pagamenti = '' then
		ret.esito = false;
		ret.msg = 'Nessun avviso di pagamento inserito!';
	end if;
    
	--id_op:=gds_log.end_op(proc_name,idtransazione ,row_to_json(ret)::varchar);
	return ret;
	end;
END
$$;


ALTER FUNCTION pagopa.ins_sanzione(v character varying, idtransazione bigint) OWNER TO postgres;

--
-- Name: pagopa_aggiorna_sanzioni_barra(integer, integer, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_aggiorna_sanzioni_barra(_rt_progressivo integer, _rt_anno integer, _t_tipo text, _t_nome text, _t_cf text, _t_indirizzo text, _t_civico text, _t_comune text, _t_cap text, _t_provincia text, _o_tipo text, _o_nome text, _o_cf text, _o_indirizzo text, _o_civico text, _o_comune text, _o_cap text, _o_provincia text, _note text) RETURNS text
    LANGUAGE plpgsql
    AS $$
   DECLARE
   
_id_sanzione integer;
_id_pagatore_t integer;
_id_pagatore_o integer;
_old_pagatore_t text;
_old_pagatore_o text;
_data_modifica timestamp without time zone;

   BEGIN
SET SEARCH_PATH = 'pagopa';

_id_sanzione := -1;
_id_pagatore_t := -1;
_id_pagatore_o := -1;
_old_pagatore_t := '';
_old_pagatore_o := '';

SELECT now() into _data_modifica;
SELECT concat('-PROCEDURA BONIFICA DA HD-',_note) into _note;

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] Avvio procedura in data %', _data_modifica;

-- Recupero dati sanzione
select ticketid, trasgressore, obbligatoinsolido into _id_sanzione, _old_pagatore_t, _old_pagatore_o from ticket where ticketid in (select id_sanzione from registro_trasgressori_values where progressivo = _rt_progressivo and anno = _rt_anno);

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] _id_sanzione %', _id_sanzione;
RAISE INFO '[pagopa_aggiorna_sanzioni_barra] vecchio trasgressore %', _old_pagatore_t;
RAISE INFO '[pagopa_aggiorna_sanzioni_barra] vecchio obbligato %', _old_pagatore_o;

IF _id_sanzione is null or _id_sanzione = -1 THEN
return 'KO. Sanzione non trovata';
END IF;

IF _t_nome is null or _t_nome = '' THEN
return 'KO. Il trasgressore non può essere vuoto.';
END IF;

-- Aggiorno trasgressore/obbligato nel dettaglio sanzione
update ticket set 
trasgressore = (case when _t_nome <> '' then _t_nome else 'Nessuno' end), 
obbligatoinsolido = (case when _o_nome <> '' then _o_nome else 'Nessuno' end),
note_internal_use_only = concat(note_internal_use_only, '[', _data_modifica, '] Trasgressore/Obbligato modificato con note: ', _note, '; Precedente Trasgressore/Obbligato: ', _old_pagatore_t, '/', _old_pagatore_o) where ticketid = _id_sanzione;

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] Aggiornati trasgressore e obbligato';

-- Cancello vecchia relazione
update pagopa_mapping_sanzioni_pagatori set trashed_date = now(), note_hd = concat(note_hd, '[', _data_modifica, '] Relazione cancellata con note: ', _note) where id_sanzione = _id_sanzione and trashed_date is null;

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] Cancellato vecchio mapping sanzione pagatori';

IF _t_nome <> '' THEN
-- Anagrafo trasgressore
insert into pagopa_anagrafica_pagatori 
(tipo_pagatore, piva_cf, ragione_sociale_nominativo, indirizzo, civico, cap, comune, cod_provincia, nazione, note_hd) values
(_t_tipo, _t_cf, _t_nome, _t_indirizzo, _t_civico, _t_cap, _t_comune, _t_provincia, 'IT', concat('[', _data_modifica, '] Pagatore inserito con note: ', _note)) returning id into _id_pagatore_t;

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] Inserito in anagrafe pagatori trasgressore: % id: %', _t_nome, _id_pagatore_t;

-- Inserisco mapping tra sanzione e trasgressore

insert into pagopa_mapping_sanzioni_pagatori
(id_sanzione, id_pagatore, trasgressore_obbligato, note_hd)
values
(_id_sanzione,_id_pagatore_t, 'T',  concat('Pagatore inserito con note: ', _note));
END IF;

IF _o_nome <> '' THEN
-- Anagrafo obbligato
insert into pagopa_anagrafica_pagatori 
(tipo_pagatore, piva_cf, ragione_sociale_nominativo, indirizzo, civico, cap, comune, cod_provincia, nazione, note_hd) values
(_o_tipo, _o_cf, _o_nome, _o_indirizzo, _o_civico, _o_cap, _o_comune, _o_provincia, 'IT', concat('[', _data_modifica, '] Pagatore inserito con note: ', _note)) returning id into _id_pagatore_o;

RAISE INFO '[pagopa_aggiorna_sanzioni_barra] Inserito in anagrafe pagatori obbligato: % id: %', _o_nome, _id_pagatore_o;
  
-- Inserisco mapping tra sanzione e obbligato

insert into pagopa_mapping_sanzioni_pagatori
(id_sanzione, id_pagatore, trasgressore_obbligato, note_hd)
values
(_id_sanzione,_id_pagatore_o, 'O',  concat('Pagatore inserito con note: ', _note));
END IF;

return 'OK';

   END
$$;


ALTER FUNCTION pagopa.pagopa_aggiorna_sanzioni_barra(_rt_progressivo integer, _rt_anno integer, _t_tipo text, _t_nome text, _t_cf text, _t_indirizzo text, _t_civico text, _t_comune text, _t_cap text, _t_provincia text, _o_tipo text, _o_nome text, _o_cf text, _o_indirizzo text, _o_civico text, _o_comune text, _o_cap text, _o_provincia text, _note text) OWNER TO postgres;

--
-- Name: pagopa_cerca_pagatore(text, text); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_cerca_pagatore(_nome text, _piva text) RETURNS TABLE(origine text, tipo_pagatore text, piva_cf text, ragione_sociale_nominativo text, indirizzo text, civico text, cap text, comune text, cod_provincia text, nazione text, domicilio_digitale text, telefono text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
SET SEARCH_PATH = 'pagopa';
RETURN QUERY
select 
distinct 'Anagrafe Pagatori' as origine, 
COALESCE(p.tipo_pagatore, '') as tipo_pagatore, 
COALESCE(p.piva_cf, '') as piva_cf, 
COALESCE(p.ragione_sociale_nominativo, '') as ragione_sociale_nominativo, 
COALESCE(p.indirizzo, '') as indirizzo, 
COALESCE(p.civico, '') as civico, 
COALESCE(p.cap, '') as cap, 
COALESCE(p.comune, '') as comune, 
COALESCE(p.cod_provincia, '') as cod_provincia, 
COALESCE(p.nazione, '') as nazione, 
COALESCE(p.domicilio_digitale, '') as domicilio_digitale,
COALESCE(p.telefono, '') as telefono
from pagopa_anagrafica_pagatori p
where 1=1
and ((_nome <> '' and p.ragione_sociale_nominativo ilike '%'||_nome||'%') or (_nome = ''))
and ((_piva <> '' and p.piva_cf ilike '%'||_piva||'%') or (_piva = ''))
and p.trashed_date is null

UNION 

select 
distinct 'Anagrafe GISA' as origine, 
'' as tipo_pagatore, 
COALESCE(r.partita_iva, '') as piva_cf, 
COALESCE(r.ragione_sociale, '') as ragione_sociale_nominativo, 
COALESCE(r.indirizzo, '') as indirizzo, 
'' as civico, 
COALESCE(r.cap_stab, '') as cap, 
COALESCE(r.comune, '') as comune, 
COALESCE(p.cod_provincia, '') as cod_provincia, 
'IT' as nazione, 
'' as domicilio_digitale,
'' as telefono
from ricerche_anagrafiche_old_materializzata r
left join lookup_province p on p.description ilike r.provincia_stab
where 1=1
and ((_nome <> '' and r.ragione_sociale ilike '%'||_nome||'%') or (_nome = ''))
and ((_piva <> '' and r.partita_iva ilike '%'||_piva||'%') or (_piva = ''))

order by 1 asc, 4 asc; 
END;
$$;


ALTER FUNCTION pagopa.pagopa_cerca_pagatore(_nome text, _piva text) OWNER TO postgres;

--
-- Name: pagopa_genera_identificativo_dovuto(integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_genera_identificativo_dovuto(_idsanzione integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
codiceTariffa text;
identificativoUnivocoDovuto text;
maxProgressivo integer;
dataSanzione timestamp without time zone;
BEGIN
SET SEARCH_PATH = 'pagopa';

SELECT COALESCE(max(progressivo), 0)+1 into maxProgressivo from pagopa_identificativo_dovuti_progressivi;

SELECT data_fase into dataSanzione from gds.ispezione_fasi where id = _idsanzione;
if dataSanzione is null then
	dataSanzione = current_date;
end if;

--SELECT l.codice_tariffa into codiceTariffa from norme_violate_sanzioni n join lookup_norme l on l.code = n.id_norma where n.idticket = _idsanzione;

select '2023' into codiceTariffa;

select substring(date_part('year', dataSanzione)::text, 3,2)||codiceTariffa||'01'||( select LPAD(maxProgressivo::text, 7, '0')) into identificativoUnivocoDovuto;
insert into pagopa_identificativo_dovuti_progressivi(progressivo, identificativo_univoco_dovuto) values (maxProgressivo, identificativoUnivocoDovuto);
raise info 'pagopa nuovo identificativo univoco dovuto generato: %', identificativoUnivocoDovuto;
return identificativoUnivocoDovuto;

 END;
$$;


ALTER FUNCTION pagopa.pagopa_genera_identificativo_dovuto(_idsanzione integer) OWNER TO postgres;

--
-- Name: pagopa_genera_pagamento(integer, integer, text, text, text, text, integer, integer, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_genera_pagamento(_idsanzione integer, _idpagatore integer, _importo text, _datascadenza text, _tipopagamento text, _tiporiduzione text, _indice integer, _numerorate integer, _idutente integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE  
idInserito integer;
_causale text;
_datispecifici text;
_identificativotipodovuto text;
_tipoversamento text;
_iud text;
BEGIN
SET SEARCH_PATH = 'pagopa'; 

idInserito:= -1;

IF (_indice<0) THEN
select  COALESCE(max(indice), 0)+1 into _indice from pagopa_pagamenti where id_sanzione = _idsanzione and id_pagatore = _idpagatore and trashed_date is null;
END IF;

_tipoversamento = 'ALL';
_datispecifici = '9/8711980576';
--_identificativotipodovuto = '2040'; --era 1001
SELECT '2023' into _identificativotipodovuto; --from norme_violate_sanzioni n join lookup_norme l on l.code = n.id_norma where n.idticket = _idsanzione;

select concat('PV N. ', t.tipo_richiesta, ' - ', CASE WHEN nucleo.in_dpat THEN 'ASL '::text || asl.description::text ELSE nucleo.description::text END, case when _tipopagamento = 'PV' or _numerorate = 1 then ' - RATA UNICA' when _tipopagamento = 'NO' then ' - RATA '||_indice||' di '||_numerorate else '' end) into _causale from ticket t
left join ticket controllo on controllo.ticketid = t.id_controllo_ufficiale::integer
LEFT JOIN lookup_site_id asl ON asl.code = controllo.site_id
LEFT JOIN nucleo_ispettivo_mv mv_nucleo ON mv_nucleo.id_controllo_ufficiale = controllo.ticketid
LEFT JOIN lookup_qualifiche nucleo ON nucleo.description::text = mv_nucleo.nucleo_ispettivo::text
where t.ticketid = _idsanzione;

select pagopa_genera_identificativo_dovuto into _iud from pagopa_genera_identificativo_dovuto(_idsanzione);

insert into pagopa_pagamenti(id_sanzione, id_pagatore, data_scadenza, importo_singolo_versamento, entered_by, indice, numero_rate, tipo_pagamento, tipo_riduzione, tipo_versamento, identificativo_univoco_dovuto, identificativo_tipo_dovuto, causale_versamento, dati_specifici_riscossione, stato_pagamento)
values (_idsanzione, _idpagatore, _datascadenza, _importo, _idutente, _indice, _numerorate,_tipopagamento, _tiporiduzione, _tipoversamento, _iud, _identificativotipodovuto, _causale, _datispecifici, 'PAGAMENTO NON INIZIATO') returning id into idInserito;

return '{"idInserito" : '||idInserito||', "IUD" : "'||_iud||'"}';

END $$;


ALTER FUNCTION pagopa.pagopa_genera_pagamento(_idsanzione integer, _idpagatore integer, _importo text, _datascadenza text, _tipopagamento text, _tiporiduzione text, _indice integer, _numerorate integer, _idutente integer) OWNER TO postgres;

--
-- Name: pagopa_get_avvisi_in_scadenza(); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_avvisi_in_scadenza() RETURNS TABLE(id_pagamento integer, id_sanzione integer, data_scadenza text, importo_singolo_versamento text, identificativo_univoco_versamento text, stato_pagamento text, tipo_riduzione text, tipo_notifica text, data_notifica text, notifica_aggiornata text)
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
r RECORD;	
BEGIN
SET SEARCH_PATH = 'pagopa';
FOR 

id_pagamento, id_sanzione, data_scadenza, importo_singolo_versamento, identificativo_univoco_versamento, stato_pagamento, tipo_riduzione, tipo_notifica, data_notifica, notifica_aggiornata

in

select 
p.id, p.id_sanzione, p.data_scadenza, p.importo_singolo_versamento, p.identificativo_univoco_versamento, p.stato_pagamento, p.tipo_riduzione, n.tipo_notifica, n.data_notifica, n.notifica_aggiornata
from pagopa_pagamenti p join pagopa_sanzioni_pagatori_notifiche n on p.id_sanzione = n.id_sanzione and p.id_pagatore = n.id_pagatore where p.trashed_date is null and n.trashed_date is null and p.tipo_pagamento = 'PV' and p.stato_pagamento = 'PAGAMENTO NON INIZIATO' and p.data_scadenza::timestamp without time zone <= now() and n.notifica_aggiornata is not true order by p.id_sanzione asc, p.identificativo_univoco_versamento asc

    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$$;


ALTER FUNCTION pagopa.pagopa_get_avvisi_in_scadenza() OWNER TO postgres;

--
-- Name: pagopa_get_avvisi_non_pagati(); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_avvisi_non_pagati() RETURNS TABLE(id_pagamento integer, id_sanzione integer, data_scadenza text, importo_singolo_versamento text, identificativo_univoco_versamento text, stato_pagamento text, tipo_riduzione text, tipo_notifica text, data_notifica text, notifica_aggiornata text)
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
r RECORD;	
BEGIN
SET SEARCH_PATH = 'pagopa';
FOR 

id_pagamento, id_sanzione, data_scadenza, importo_singolo_versamento, identificativo_univoco_versamento, stato_pagamento, tipo_riduzione, tipo_notifica, data_notifica, notifica_aggiornata

in

select 
p.id, p.id_sanzione, p.data_scadenza, p.importo_singolo_versamento, p.identificativo_univoco_versamento, p.stato_pagamento, p.tipo_riduzione, n.tipo_notifica, n.data_notifica, n.notifica_aggiornata
from pagopa_pagamenti p 
join pagopa_sanzioni_pagatori_notifiche n on p.id_sanzione = n.id_sanzione and p.id_pagatore = n.id_pagatore 
where p.trashed_date is null and n.trashed_date is null and p.stato_pagamento = 'PAGAMENTO NON INIZIATO' 

order by p.id_sanzione asc, p.identificativo_univoco_versamento asc

    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$$;


ALTER FUNCTION pagopa.pagopa_get_avvisi_non_pagati() OWNER TO postgres;

--
-- Name: pagopa_get_avvisi_scaduti(); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_avvisi_scaduti() RETURNS TABLE(id_pagamento integer, id_sanzione integer, data_scadenza text, importo_singolo_versamento text, identificativo_univoco_versamento text, stato_pagamento text, tipo_riduzione text, tipo_notifica text, data_notifica text, notifica_aggiornata text)
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
r RECORD;   
BEGIN
SET SEARCH_PATH = 'pagopa';
FOR

id_pagamento, id_sanzione, data_scadenza, importo_singolo_versamento, identificativo_univoco_versamento, stato_pagamento, tipo_riduzione, tipo_notifica, data_notifica, notifica_aggiornata

in

select
p.id, p.id_sanzione, p.data_scadenza, p.importo_singolo_versamento, p.identificativo_univoco_versamento, p.stato_pagamento, p.tipo_riduzione, n.tipo_notifica, n.data_notifica, n.notifica_aggiornata
from pagopa_pagamenti p join pagopa_sanzioni_pagatori_notifiche n on p.id_sanzione = n.id_sanzione and p.id_pagatore = n.id_pagatore where p.trashed_date is null and n.trashed_date is null and p.tipo_pagamento = 'PV' and p.stato_pagamento = 'PAGAMENTO NON INIZIATO' and p.data_scadenza::timestamp without time zone < now()
and ((n.tipo_notifica='R' and n.notifica_aggiornata is NOT true))

order by p.id_sanzione asc, p.identificativo_univoco_versamento asc

    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$$;


ALTER FUNCTION pagopa.pagopa_get_avvisi_scaduti() OWNER TO postgres;

--
-- Name: pagopa_get_dati_pagatore_default(integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_dati_pagatore_default(_id_sanzione integer) RETURNS TABLE(tipo_pagatore text, piva_cf text, ragione_sociale_nominativo text, indirizzo text, civico text, cap text, comune text, cod_provincia text, nazione text, domicilio_digitale text, telefono text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
SET SEARCH_PATH = 'pagopa';
RETURN QUERY
select 'G'::text as tipo_pagatore,
COALESCE(opuo.partita_iva, org.partita_iva, sino.partita_iva)::text as piva_cf, 
coalesce(opuo.ragione_sociale, org.name, sino.ragione_sociale)::text as ragione_sociale_nominativo, 
coalesce(opui.via, orgi.addrline1, sini.via)::text as indirizzo, 
COALESCE(opui.civico, orgi.civico, sini.civico)::text as civico, 
COALESCE(opui.cap, orgi.postalcode, sini.cap)::text as cap, 
COALESCE(opuc.nome, orgi.city, sinc.nome)::text as comune, 
COALESCE(opup.cod_provincia, orgi.state, sinp.cod_provincia)::text as cod_provincia, 
'IT'::text as nazione,
COALESCE(opuo.domicilio_digitale, org.email_rappresentante, sino.domicilio_digitale)::text as domicilio_digitale,
''::text as telefono 

from ticket sanzione
join ticket cu on cu.ticketid = sanzione.id_controllo_ufficiale::integer

left join opu_stabilimento opus on opus.id = cu.id_stabilimento and cu.id_stabilimento>0
left join opu_operatore opuo on opuo.id = opus.id_operatore 
left join opu_indirizzo opui on opui.id = opus.id_indirizzo
left join comuni1 opuc on opuc.id = opui.comune
left join lookup_province opup on opup.code = opuc.cod_provincia::integer

left join organization org on org.org_id = cu.org_id and cu.org_id>0
left join organization_address orgi on orgi.org_id = org.org_id and orgi.address_type = 5

left join sintesis_stabilimento sins on sins.alt_id = cu.alt_id and cu.alt_id>0
left join sintesis_operatore sino on sino.id = sins.id_operatore 
left join sintesis_indirizzo sini on sini.id = sins.id_indirizzo
left join comuni1 sinc on sinc.id = sini.comune
left join lookup_province sinp on sinp.code = sinc.cod_provincia::integer

where sanzione.ticketid = _id_sanzione
limit 1;
 
END;
$$;


ALTER FUNCTION pagopa.pagopa_get_dati_pagatore_default(_id_sanzione integer) OWNER TO postgres;

--
-- Name: pagopa_get_dati_pagatore_default_anagrafica(integer, text); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_dati_pagatore_default_anagrafica(_riferimento_id integer, _riferimento_id_nome_tab text) RETURNS TABLE(tipo_pagatore text, piva_cf text, ragione_sociale_nominativo text, indirizzo text, civico text, cap text, comune text, cod_provincia text, nazione text, domicilio_digitale text, telefono text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
SET SEARCH_PATH = 'pagopa';
RETURN QUERY
select 'G'::text as tipo_pagatore,

replace(
case 
when r.codice_fiscale_rappresentante <> '' and r.riferimento_id_nome_tab = 'opu_stabilimento'  and (opuo.tipo_impresa = 1 or opuo.tipo_societa = 11) then r.codice_fiscale_rappresentante
when r.partita_iva <> '' then r.partita_iva 
when r.codice_fiscale <> '' then r.codice_fiscale 
when r.codice_fiscale_rappresentante <> '' then r.codice_fiscale_rappresentante else '' 
end, '''', '\''')::text as piva_cf, 

r.ragione_sociale::text as ragione_sociale_nominativo, 

replace(
case 
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore <> 2 then orgi.addrline1
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore = 2 then orga.indrizzo_azienda
when r.riferimento_id_nome_tab = 'opu_stabilimento' then concat(oput.description, ' ', opui.via)
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then concat(apit.description, ' ', apii.via)
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then concat(sint.description, ' ', sini.via)
end, '''', '\''')::text as indirizzo, 

replace(
case 
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore <> 2 then orgi.civico
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore = 2 then ''
when r.riferimento_id_nome_tab = 'opu_stabilimento' then opui.civico
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then apii.civico
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then sini.civico
end, '''', '\''')::text as civico, 

replace(
case 
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore <> 2 then orgi.postalcode
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore = 2 then orga.cap_azienda
when r.riferimento_id_nome_tab = 'opu_stabilimento' then opui.cap
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then apii.cap
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then sini.cap
end, '''', '\''')::text as cap, 

replace(
case 
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore <> 2 then orgi.city
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore = 2 then orgac.nome
when r.riferimento_id_nome_tab = 'opu_stabilimento' then opuc.nome
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then apic.nome
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then sinc.nome
end, '''', '\''')::text as comune, 

replace(
case 
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore <> 2 then orgi.state
when r.riferimento_id_nome_tab = 'organization' and r.tipologia_operatore = 2 then orga.prov_sede_azienda
when r.riferimento_id_nome_tab = 'opu_stabilimento' then opup.cod_provincia
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then apip.cod_provincia
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then sinp.cod_provincia
end, '''', '\''')::text as cod_provincia, 

'IT'::text as nazione,

replace(
case 
when r.riferimento_id_nome_tab = 'organization' then org.email_rappresentante
when r.riferimento_id_nome_tab = 'opu_stabilimento' then opuo.domicilio_digitale
when r.riferimento_id_nome_tab = 'apicoltura_imprese' then apio.domicilio_digitale
when r.riferimento_id_nome_tab = 'sintesis_stabilimento' then sino.domicilio_digitale
end, '''', '\''')::text as domicilio_digitale,
''::text as telefono

from ricerche_anagrafiche_old_materializzata r 

left join organization org on org.org_id = r.riferimento_id and r.riferimento_id_nome_tab = 'organization'
left join organization_address orgi on orgi.org_id = org.org_id and orgi.address_type = 5
left join aziende orga on orga.cod_azienda = org.account_number
left join comuni1 orgac on orgac.istat::int = orga.cod_comune_azienda::int

left join opu_stabilimento opus on opus.id = r.riferimento_id and r.riferimento_id_nome_tab = 'opu_stabilimento'
left join opu_operatore opuo on opuo.id = opus.id_operatore 
left join opu_indirizzo opui on opui.id = opus.id_indirizzo
left join lookup_toponimi oput on oput.code = opui.toponimo
left join comuni1 opuc on opuc.id = opui.comune
left join lookup_province opup on opup.code = opuc.cod_provincia::integer

left join apicoltura_apiari apis on apis.id = r.riferimento_id and r.riferimento_id_nome_tab = 'apicoltura_imprese'
left join apicoltura_imprese apio on apio.id = apis.id_operatore 
left join opu_indirizzo apii on apii.id = apis.id_indirizzo
left join lookup_toponimi apit on apit.code = apii.toponimo
left join comuni1 apic on apic.id = apii.comune
left join lookup_province apip on apip.code = apic.cod_provincia::integer

left join sintesis_stabilimento sins on sins.alt_id = r.riferimento_id and r.riferimento_id_nome_tab = 'sintesis_stabilimento'
left join sintesis_operatore sino on sino.id = sins.id_operatore 
left join sintesis_indirizzo sini on sini.id = sins.id_indirizzo
left join lookup_toponimi sint on sint.code = sini.toponimo
left join comuni1 sinc on sinc.id = sini.comune
left join lookup_province sinp on sinp.code = sinc.cod_provincia::integer

where 1=1

and r.riferimento_id = _riferimento_id and r.riferimento_id_nome_tab = _riferimento_id_nome_tab
limit 1;
 
END;
$$;


ALTER FUNCTION pagopa.pagopa_get_dati_pagatore_default_anagrafica(_riferimento_id integer, _riferimento_id_nome_tab text) OWNER TO postgres;

--
-- Name: pagopa_get_dati_pagatore_default_anagrafica(integer, integer, integer); Type: FUNCTION; Schema: pagopa; Owner: postgres
--

CREATE FUNCTION pagopa.pagopa_get_dati_pagatore_default_anagrafica(_orgid integer, _stabid integer, _altid integer) RETURNS TABLE(tipo_pagatore text, piva_cf text, ragione_sociale_nominativo text, indirizzo text, civico text, cap text, comune text, cod_provincia text, nazione text, domicilio_digitale text, telefono text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
SET SEARCH_PATH = 'pagopa';
RETURN QUERY
select 'G'::text as tipo_pagatore,
replace(COALESCE(opuo.partita_iva, org.partita_iva, sino.partita_iva), '''', '\''')::text as piva_cf, 
replace(coalesce(opuo.ragione_sociale, org.name, sino.ragione_sociale), '''', '\''')::text as ragione_sociale_nominativo, 
replace(coalesce(opui.via, orgi.addrline1, sini.via), '''', '\''')::text as indirizzo, 
replace(COALESCE(opui.civico, orgi.civico, sini.civico), '''', '\''')::text as civico, 
replace(COALESCE(opui.cap, orgi.postalcode, sini.cap), '''', '\''')::text as cap, 
replace(COALESCE(opuc.nome, orgi.city, sinc.nome), '''', '\''')::text as comune, 
replace(COALESCE(opup.cod_provincia, orgi.state, sinp.cod_provincia), '''', '\''')::text as cod_provincia, 
'IT'::text as nazione,
replace(COALESCE(opuo.domicilio_digitale, org.email_rappresentante, sino.domicilio_digitale), '''', '\''')::text as domicilio_digitale ,
''::text as telefono

from ricerche_anagrafiche_old_materializzata r 
left join organization org on org.org_id = r.riferimento_id and r.riferimento_id_nome_tab = 'organization'
left join opu_stabilimento opus on opus.id = r.riferimento_id and r.riferimento_id_nome_tab = 'opu_stabilimento'
left join sintesis_stabilimento sins on sins.alt_id = r.riferimento_id and r.riferimento_id_nome_tab = 'sintesis_stabilimento'

left join opu_operatore opuo on opuo.id = opus.id_operatore 
left join opu_indirizzo opui on opui.id = opus.id_indirizzo
left join comuni1 opuc on opuc.id = opui.comune
left join lookup_province opup on opup.code = opuc.cod_provincia::integer

left join organization_address orgi on orgi.org_id = org.org_id and orgi.address_type = 5

left join sintesis_operatore sino on sino.id = sins.id_operatore 
left join sintesis_indirizzo sini on sini.id = sins.id_indirizzo
left join comuni1 sinc on sinc.id = sini.comune
left join lookup_province sinp on sinp.code = sinc.cod_provincia::integer

where 1=1

and ((_orgid > 0 and org.org_id = _orgid) or _orgid <=0)
and ((_stabid > 0 and opus.id = _stabid) or _stabid <=0)
and ((_altid > 0 and sins.alt_id = _altid) or _altid <=0)
limit 1;
 
END;
$$;


ALTER FUNCTION pagopa.pagopa_get_dati_pagatore_default_anagrafica(_orgid integer, _stabid integer, _altid integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: lookup_moduli_pagopa; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.lookup_moduli_pagopa (
    id_modulo bigint NOT NULL
);


ALTER TABLE pagopa.lookup_moduli_pagopa OWNER TO postgres;

--
-- Name: pagopa_pagamenti; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_pagamenti (
    id integer NOT NULL,
    id_sanzione integer,
    id_pagatore integer,
    data_scadenza text,
    tipo_versamento text,
    identificativo_univoco_dovuto text,
    importo_singolo_versamento text,
    identificativo_tipo_dovuto text,
    causale_versamento text,
    dati_specifici_riscossione text,
    entered_by integer,
    entered timestamp without time zone,
    modified_by integer,
    inviato_by integer,
    inviato boolean,
    data_invio timestamp without time zone,
    esito_invio text,
    trashed_date timestamp without time zone,
    identificativo_univoco_versamento text,
    indice integer,
    tipo_pagamento text,
    url_file_avviso text,
    descrizione_errore text,
    stato_pagamento text,
    denominazione_attestante text,
    denominazione_beneficiario text,
    esito_singolo_pagamento text,
    identificativo_univoco_riscossione text,
    singolo_importo_pagato text,
    data_esito_singolo_pagamento text,
    data_generazione_iuv timestamp without time zone,
    tipo_riduzione text,
    note_hd text,
    codice_avviso text,
    aggiornato_con_pagopa boolean,
    numero_rate integer,
    codice_esito_pagamento text,
    data_verbale timestamp without time zone
);


ALTER TABLE pagopa.pagopa_pagamenti OWNER TO postgres;

--
-- Name: pagopa_pagamenti_info_verbale; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_pagamenti_info_verbale (
    id integer NOT NULL,
    id_pagamento bigint,
    id_utente bigint,
    proc_pen character varying,
    rgnr character varying,
    id_modulo text,
    descrizione character varying,
    n_protocollo character varying,
    cantiere_o_impresa character varying,
    data_verbale character varying
);


ALTER TABLE pagopa.pagopa_pagamenti_info_verbale OWNER TO postgres;

--
-- Name: pagamenti_pdf; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagamenti_pdf (
    id_pagamento bigint,
    xml_rt character varying,
    pdf_rt bytea,
    filename_rt character varying,
    pdf_avviso bytea,
    filename_avviso character varying
);


ALTER TABLE pagopa.pagamenti_pdf OWNER TO postgres;

--
-- Name: pagopa_anagrafica_pagatori; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_anagrafica_pagatori (
    id integer NOT NULL,
    tipo_pagatore text,
    piva_cf text,
    ragione_sociale_nominativo text,
    indirizzo text,
    civico text,
    cap text,
    comune text,
    cod_provincia text,
    nazione text,
    domicilio_digitale text,
    entered timestamp without time zone,
    enteredby integer,
    trashed_date timestamp without time zone,
    note_hd text,
    telefono text,
    cognome character varying
);


ALTER TABLE pagopa.pagopa_anagrafica_pagatori OWNER TO postgres;

--
-- Name: pagopa_anagrafica_pagatori_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_anagrafica_pagatori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_anagrafica_pagatori_id_seq OWNER TO postgres;

--
-- Name: pagopa_anagrafica_pagatori_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_anagrafica_pagatori_id_seq OWNED BY pagopa.pagopa_anagrafica_pagatori.id;


--
-- Name: pagopa_identificativo_dovuti_progressivi; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_identificativo_dovuti_progressivi (
    id integer NOT NULL,
    progressivo integer,
    identificativo_univoco_dovuto text,
    entered timestamp without time zone
);


ALTER TABLE pagopa.pagopa_identificativo_dovuti_progressivi OWNER TO postgres;

--
-- Name: pagopa_identificativo_dovuti_progressivi_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_identificativo_dovuti_progressivi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_identificativo_dovuti_progressivi_id_seq OWNER TO postgres;

--
-- Name: pagopa_identificativo_dovuti_progressivi_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_identificativo_dovuti_progressivi_id_seq OWNED BY pagopa.pagopa_identificativo_dovuti_progressivi.id;


--
-- Name: pagopa_mapping_sanzioni_pagatori; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_mapping_sanzioni_pagatori (
    id integer NOT NULL,
    id_sanzione integer,
    id_pagatore integer,
    trasgressore_obbligato text,
    entered timestamp without time zone,
    trashed_date timestamp without time zone,
    enteredby integer,
    note_hd text
);


ALTER TABLE pagopa.pagopa_mapping_sanzioni_pagatori OWNER TO postgres;

--
-- Name: pagopa_mapping_sanzioni_pagatori_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_mapping_sanzioni_pagatori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_mapping_sanzioni_pagatori_id_seq OWNER TO postgres;

--
-- Name: pagopa_mapping_sanzioni_pagatori_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_mapping_sanzioni_pagatori_id_seq OWNED BY pagopa.pagopa_mapping_sanzioni_pagatori.id;


--
-- Name: pagopa_pagamenti_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_pagamenti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_pagamenti_id_seq OWNER TO postgres;

--
-- Name: pagopa_pagamenti_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_pagamenti_id_seq OWNED BY pagopa.pagopa_pagamenti.id;


--
-- Name: pagopa_pagamenti_ispettori_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_pagamenti_ispettori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_pagamenti_ispettori_id_seq OWNER TO postgres;

--
-- Name: pagopa_pagamenti_ispettori_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_pagamenti_ispettori_id_seq OWNED BY pagopa.pagopa_pagamenti_info_verbale.id;


--
-- Name: pagopa_sanzioni_pagatori_notifiche; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_sanzioni_pagatori_notifiche (
    id integer NOT NULL,
    id_pagamento integer,
    id_pagatore integer,
    entered timestamp without time zone,
    enteredby integer,
    modified timestamp without time zone,
    modifiedby integer,
    trashed_date timestamp without time zone,
    tipo_notifica text,
    data_notifica text,
    data_scadenza_prorogata boolean,
    notifica_aggiornata boolean,
    note_hd text
);


ALTER TABLE pagopa.pagopa_sanzioni_pagatori_notifiche OWNER TO postgres;

--
-- Name: pagopa_sanzioni_pagatori_notifiche_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_sanzioni_pagatori_notifiche_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_sanzioni_pagatori_notifiche_id_seq OWNER TO postgres;

--
-- Name: pagopa_sanzioni_pagatori_notifiche_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_sanzioni_pagatori_notifiche_id_seq OWNED BY pagopa.pagopa_sanzioni_pagatori_notifiche.id;


--
-- Name: pagopa_storico; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_storico (
    id integer NOT NULL,
    id_utente integer,
    data_operazione timestamp without time zone,
    id_sanzione integer,
    id_pagamento integer,
    operazione text
);


ALTER TABLE pagopa.pagopa_storico OWNER TO postgres;

--
-- Name: pagopa_storico_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_storico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_storico_id_seq OWNER TO postgres;

--
-- Name: pagopa_storico_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_storico_id_seq OWNED BY pagopa.pagopa_storico.id;


--
-- Name: pagopa_storico_operazioni_automatiche; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.pagopa_storico_operazioni_automatiche (
    id integer NOT NULL,
    entered timestamp without time zone,
    id_sanzione integer,
    id_pagamento integer,
    vecchia_data_scadenza text,
    nuova_data_scadenza text,
    messaggio text
);


ALTER TABLE pagopa.pagopa_storico_operazioni_automatiche OWNER TO postgres;

--
-- Name: pagopa_storico_operazioni_automatiche_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.pagopa_storico_operazioni_automatiche_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.pagopa_storico_operazioni_automatiche_id_seq OWNER TO postgres;

--
-- Name: pagopa_storico_operazioni_automatiche_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.pagopa_storico_operazioni_automatiche_id_seq OWNED BY pagopa.pagopa_storico_operazioni_automatiche.id;


--
-- Name: violazione; Type: TABLE; Schema: pagopa; Owner: postgres
--

CREATE TABLE pagopa.violazione (
    id integer NOT NULL,
    punto_verbale_prescrizione character varying,
    articolo_violato character varying,
    norma character varying,
    id_pagamento bigint NOT NULL
);


ALTER TABLE pagopa.violazione OWNER TO postgres;

--
-- Name: violazione_id_seq; Type: SEQUENCE; Schema: pagopa; Owner: postgres
--

CREATE SEQUENCE pagopa.violazione_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pagopa.violazione_id_seq OWNER TO postgres;

--
-- Name: violazione_id_seq; Type: SEQUENCE OWNED BY; Schema: pagopa; Owner: postgres
--

ALTER SEQUENCE pagopa.violazione_id_seq OWNED BY pagopa.violazione.id;


--
-- Name: vw_anagrafica_pagatori; Type: VIEW; Schema: pagopa; Owner: postgres
--

CREATE VIEW pagopa.vw_anagrafica_pagatori AS
 SELECT pap.id,
    pap.tipo_pagatore,
    pap.piva_cf,
    pap.ragione_sociale_nominativo,
    pap.indirizzo,
    pap.civico,
    pap.cap,
    pap.comune,
    pap.cod_provincia,
    pap.nazione,
    pap.domicilio_digitale,
    pap.entered,
    pap.enteredby,
    pap.trashed_date,
    pap.note_hd,
    pap.telefono
   FROM pagopa.pagopa_anagrafica_pagatori pap;


ALTER TABLE pagopa.vw_anagrafica_pagatori OWNER TO postgres;

--
-- Name: pagopa_anagrafica_pagatori id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_anagrafica_pagatori ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_anagrafica_pagatori_id_seq'::regclass);


--
-- Name: pagopa_identificativo_dovuti_progressivi id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_identificativo_dovuti_progressivi ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_identificativo_dovuti_progressivi_id_seq'::regclass);


--
-- Name: pagopa_mapping_sanzioni_pagatori id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_mapping_sanzioni_pagatori ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_mapping_sanzioni_pagatori_id_seq'::regclass);


--
-- Name: pagopa_pagamenti id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_pagamenti ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_pagamenti_id_seq'::regclass);


--
-- Name: pagopa_pagamenti_info_verbale id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_pagamenti_info_verbale ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_pagamenti_ispettori_id_seq'::regclass);


--
-- Name: pagopa_sanzioni_pagatori_notifiche id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_sanzioni_pagatori_notifiche ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_sanzioni_pagatori_notifiche_id_seq'::regclass);


--
-- Name: pagopa_storico id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_storico ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_storico_id_seq'::regclass);


--
-- Name: pagopa_storico_operazioni_automatiche id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_storico_operazioni_automatiche ALTER COLUMN id SET DEFAULT nextval('pagopa.pagopa_storico_operazioni_automatiche_id_seq'::regclass);


--
-- Name: violazione id; Type: DEFAULT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.violazione ALTER COLUMN id SET DEFAULT nextval('pagopa.violazione_id_seq'::regclass);


--
-- Name: pagopa_pagamenti_info_verbale pagopa_pagamenti_info_verbale_pk; Type: CONSTRAINT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagopa_pagamenti_info_verbale
    ADD CONSTRAINT pagopa_pagamenti_info_verbale_pk PRIMARY KEY (id);


--
-- Name: violazione violazione_pkey; Type: CONSTRAINT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.violazione
    ADD CONSTRAINT violazione_pkey PRIMARY KEY (id);


--
-- Name: pagamenti_pdf xml_pagamenti_pagati_un; Type: CONSTRAINT; Schema: pagopa; Owner: postgres
--

ALTER TABLE ONLY pagopa.pagamenti_pdf
    ADD CONSTRAINT xml_pagamenti_pagati_un UNIQUE (id_pagamento);


--
-- PostgreSQL database dump complete
--

