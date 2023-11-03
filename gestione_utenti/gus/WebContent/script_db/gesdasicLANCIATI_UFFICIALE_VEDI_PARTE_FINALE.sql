alter table spid.spid_registrazioni_esiti add column esito_sicurezza_lavoro boolean;
alter table spid.spid_registrazioni add column id_ruolo_sicurezza_lavoro integer;

CREATE OR REPLACE FUNCTION spid.processa_richiesta_insert(
    _numero_richiesta text,
    _id_utente integer)
  RETURNS text AS
$BODY$
DECLARE
	--r RECORD;
	giava integer;
	ep_guc text;
	ep_gisa integer;
	ep_gisa_ext integer;
	ep_bdu integer;
	ep_vam integer;
	ep_digemon integer;
	ep_sicurezza_lavoro integer;
	_id_tipo_richiesta integer;
	username_out text;
	password_out text;
	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	esito_processa text;
	check_gisa text;
	check_vam text;
	check_bdu text;
	check_digemon text;
	check_gisa_ext text;
	check_sicurezza_lavoro text;
	query text;
	query_endpoint text;
	esito_api text;
	esito_dist text;
	esito_acque text;
	esito_guc text;

	indice integer;
BEGIN
	giava := -1;
	username_out := '';
	output_gisa = '';
	output_gisa_ext = '';
	output_bdu = '' ;
	output_vam = '';
	output_digemon = '';
	output_sicurezza_lavoro = '';
	ep_gisa = -1;
	ep_gisa_ext = -1;
	ep_bdu = -1;
	ep_vam = -1;
	ep_digemon = -1;
	ep_sicurezza_lavoro = -1;
	
	check_gisa := '';
	check_gisa_ext := '';
	check_bdu := '';
	check_vam := '';
	check_digemon := '';
	check_sicurezza_lavoro := '';

	ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_sicurezza_lavoro := (select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta));

	_id_tipo_richiesta := (select id_tipo_richiesta from spid.spid_registrazioni  where numero_richiesta = _numero_richiesta);
	--codicefiscale := (select codice_fiscale from spid.spid_registrazioni where numero_richiesta = _numero_richiesta);
	

	-- chiamo dbi dei check
	if(ep_gisa > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_gisa||', ''gisa'');';
		check_gisa := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_gisa_ext > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_gisa_ext||', ''gisa_ext'');';
		check_gisa_ext := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_bdu > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_bdu||', ''bdu'');';
		check_bdu := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;
	
	if(ep_vam > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_vam||', ''vam'');';
		check_vam := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_digemon> 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_digemon||', ''digemon'');';
		check_digemon := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_sicurezza_lavoro> 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_digemon||', ''sicurezzalavoro'');';
		check_sicurezza_lavoro := (select * from spid.esegui_query(query, 'sicurezzalavoro', _id_utente,''));
	end if;
	
	
	IF length(check_gisa)>0 THEN
	ep_guc := 'KO;;KO';
	output_gisa := '{"Esito":"KO", "DescrizioneErrore":"'||check_gisa||'"}';
	END IF;
	IF length(check_gisa_ext)>0 THEN
	ep_guc := 'KO;;KO';
	output_gisa_ext := '{"Esito":"KO", "DescrizioneErrore":"'||check_gisa_ext||'"}';
	END IF;
	IF length(check_bdu)>0 THEN
	ep_guc := 'KO;;KO';
	output_bdu := '{"Esito":"KO", "DescrizioneErrore":"'||check_bdu||'"}';
	END IF;
	IF length(check_vam)>0 THEN
	ep_guc := 'KO;;KO';
	output_vam := '{"Esito":"KO", "DescrizioneErrore":"'||check_vam||'"}';
	END IF;
	IF length(check_digemon)>0 THEN
	--ep_guc := 'KO;;KO';
	output_digemon := '{"Esito":"KO", "DescrizioneErrore":"'||check_digemon||'"}';
	END IF;
	IF length(check_sicurezza_lavoro)>0 THEN
	ep_guc := 'KO;;KO';
	output_sicurezza_lavoro := '{"Esito":"KO", "DescrizioneErrore":"'||check_sicurezza_lavoro||'"}';
	END IF;
	
	if (length(check_gisa)=0 and length(check_gisa_ext) = 0 and length(check_bdu) = 0 and length(check_vam) = 0 --and length(check_digemon) = 0 IGNORO I KO SU DIGEMON E VADO AVANTI COMUNQUE
	and length(check_sicurezza_lavoro) = 0) then 
	
		if (_id_tipo_richiesta = 1) then -- inserimento utente
			query := (select * from spid.get_dbi_per_endpoint(_numero_richiesta,'guc','insert',_id_utente,null,null,null::timestamp without time zone,-1, -1)); 
			ep_guc:= (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;

		username_out := (select split_part(ep_guc,';;','3'));
		raise info ' username %', username_out;
		password_out := (select split_part(ep_guc,';;','4'));
		raise info ' password %', password_out;
		esito_guc := (select split_part(ep_guc,';;','1'));
		raise info ' esito insert guc %', esito_guc;

		if (ep_gisa > 0 and esito_guc = 'OK' and length(check_gisa)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			output_gisa := '{"Esito" : "'||output_gisa ||'"}';
			query := (select concat(
			concat('select * from dbi_insert_utente_extended_opt(',
			'''', (select id from guc_utenti where username = username_out), '''', ', ',
			'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
			'''', 'true', '''', ', ',
			'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
			'''', 'false', '''', ', ',
			'''', 'false', 
			'''', '); ')) );
			query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;

		if (ep_gisa_ext > 0 and esito_guc = 'OK' and length(check_gisa_ext)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			output_gisa_ext := '{"Esito" : "'||output_gisa_ext ||'"}';
			giava := (select id_ruolo_gisa_ext from spid.spid_registrazioni s where s.numero_richiesta = _numero_richiesta);
			query :=(select concat(
			concat('select * from dbi_insert_utente_extended_opt(',
				'''', (select id from guc_utenti where username = username_out), '''', ', ',
				'''', 'false', '''', ', ',
				'''', 'false', '''', ', ',
				'''', 'false', '''', ', ',
				'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
				'''', (case when giava =10000008 then 'false' else 'true' end), 
				'''', '); ')) );
			query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;
	    
		if (ep_bdu > 0 and esito_guc = 'OK' and length(check_bdu)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _id_utente,'host=dbBDUL dbname=bdu'));
			output_bdu := '{"Esito" : "'||output_bdu ||'"}';
		end if;

		if (ep_vam > 0 and esito_guc = 'OK' and length(check_vam)=0) then

		indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP

			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, (indice+1)));
			output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _id_utente,'host=dbVAML dbname=vam'));

				output_vam := '{"Esito" : "'||output_vam ||'"}';
			indice = indice+1;
		END LOOP;	
		end if;

		if (ep_digemon > 0 and esito_guc = 'OK' and length(check_digemon)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _id_utente,'host=dbDIGEMONL dbname=digemon_u'));
			output_digemon := '{"Esito" : "'||output_digemon ||'"}';
		end if;

if (ep_sicurezza_lavoro > 0 and esito_guc = 'OK' and length(check_sicurezza_lavoro)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _id_utente,'host=dbGESDASICL dbname=gesdasic'));
			output_sicurezza_lavoro := '{"Esito" : "'||output_sicurezza_lavoro ||'"}';
		end if;		

		END IF;

		esito_processa = '{"EndPoint" : "GUC", "Esito": "'||(select split_part(ep_guc,';;','1'))||'", 
				   "Username" : "'||username_out||'", "ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}
				   ]
				}';		

		RAISE INFO 'esito_processa= %', esito_processa;

		if(get_json_valore(output_gisa_ext, 'Esito')='OK') then
			-- gestione ruolo gestore acque
			if ep_gisa_ext = 10000006 then 
				query = (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', 
				(select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', 
				(select coalesce(id_gestore_acque,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				(select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), 
				''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', 'ACQUE', ''')'));
				raise info 'stampa query insert gisa_ext acque%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert acque: %', query;
			end if;
			-- gestione ruolo apicoltore autoconsumo/commercio
			if ep_gisa_ext = 10000002 then 
				raise info 'inserisco una richiesta per apicoltura';
				query = (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', (select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', -1, ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				(select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', 'API', ''')'));
				raise info 'stampa query insert gisa_ext api%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert apicoltura: %', query;	
										
				raise info 'inserisco un soggetto fisico per apicoltura';
				query = (select concat('SELECT * from insert_soggetto_fisico_per_apicoltore(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, '''::text, (select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', '', '''::text, -1, ''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''::text,  ''', '', '''::text, ''', (select cap from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select indirizzo from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select istat_comune from spid.get_lista_richieste(_numero_richiesta)), '''::text)'));
				raise info 'stampa query insert gisa_ext api%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert apicoltura: %', query;	
			end if;
			
			-- gestione ruolo dist e trasportatore
			if ep_gisa_ext = 10000004 then 
				query := (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', 
				(select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''',
				 (select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''',
				  (select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				  (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', -1, ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				  (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', (select case when id_tipologia_trasp_dist = 1 then 'TRASPORTATORE' when id_tipologia_trasp_dist = 2 then 'DISTRIBUTORE' else '' end from spid.get_lista_richieste(_numero_richiesta)), ''')'));
				raise info 'stampa query insert gisa_ext trasp/dist%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert distributori: %', query;	
			end if;
		end if;

		if(get_json_valore(output_vam, 'Esito')='OK') then
		indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP
		
				query = (select concat('insert into guc_cliniche_vam(id_clinica, descrizione_clinica, id_utente) values(', (select id_clinica_vam[indice+1] from spid.get_lista_richieste(_numero_richiesta)), ',''', (select replace(clinica_vam[indice+1], '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ', (select split_part(ep_guc,';;','2')), ') returning ''OK'';'));
				raise info 'stampa query insert vam cliniche%', query;
				query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
				raise info 'output query insert vam cliniche: %', query;

				indice = indice+1;
		END LOOP;
			end if;
		
		-- update e insert richieste
UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon, esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
 (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),			       
					       _id_utente, (case when (select split_part(ep_guc,';;','1')) = 'OK' then 1 end)
						,esito_processa);
						

     RETURN esito_processa;

 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION spid.processa_richiesta_insert(text, integer)
  OWNER TO postgres;


  -- Function: spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer)

-- DROP FUNCTION spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer);

CREATE OR REPLACE FUNCTION spid.get_dbi_per_endpoint(
    _numero_richiesta text,
    _endpoint text,
    _tipologia text,
    _id_utente integer,
    _username text,
    _password text,
    _data_scadenza timestamp without time zone,
    _id_ruolo_old integer,
    _indice integer)
  RETURNS text AS
$BODY$
declare
 _query text;
 
BEGIN

_query := '';

RAISE INFO '[get_dbi_per_endpoint] _numero_richiesta: %', _numero_richiesta;
RAISE INFO '[get_dbi_per_endpoint] _endpoint: %', _endpoint;
RAISE INFO '[get_dbi_per_endpoint] _tipologia: %', _tipologia;
RAISE INFO '[get_dbi_per_endpoint] _id_utente: %', _id_utente;
RAISE INFO '[get_dbi_per_endpoint] _username: %', _username;
RAISE INFO '[get_dbi_per_endpoint] _password: %', _password;
RAISE INFO '[get_dbi_per_endpoint] _data_scadenza: %', _data_scadenza;
RAISE INFO '[get_dbi_per_endpoint] _id_ruolo_old: %', _id_ruolo_old;
RAISE INFO '[get_dbi_per_endpoint] _indice: %', _indice;

IF _tipologia ilike 'INSERT' THEN

IF _endpoint ilike 'GUC' then

select concat(
concat('select * from dbi_insert_utente_guc(',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '1', '''', ', ',
_id_utente, ', ',
'NULL::timestamp without time zone', ', ', 
_id_utente, ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', null::character varying, '''', ', ', 
'''', null::character varying, '''', ', ', 
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
'''', '', '''', ', '), 
concat('''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select coalesce(numero_autorizzazione_regionale_vet,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', 
-1, ', ',
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
(select case  when provincia_ordine_vet ilike '%avellino%' then 64 when provincia_ordine_vet ilike '%benevento%' then 62 when provincia_ordine_vet ilike '%caserta%' then 61 when provincia_ordine_vet ilike '%napoli%' then 63 when provincia_ordine_vet ilike '%salerno%' then 65 else -1 end from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select numero_ordine_vet from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
0, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', --31simo parametro numero stab
0, ', '), 
concat('''', null::character varying, '''', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', 
(select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_gisa,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_gisa_ext,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_bdu,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_vam,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_vam,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
-1, ', ',
'''', '', '''', ', ',
(select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_digemon,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '-1', '''', ', ',
-1, ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
-1, ', ',
'''', (select coalesce(piva_numregistrazione,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
(select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_sicurezza_lavoro,'') from spid.get_lista_richieste(_numero_richiesta)), '''','); ')) into _query;
END IF;

IF _endpoint ilike 'GISA' then

select concat(
'select * from dbi_insert_utente(',
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
-1, ', ',
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
END IF;

IF _endpoint ilike 'GISA_EXT' then

select concat(
'select * from dbi_insert_utente_ext(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_gestore_acque,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '', '''', ', ',
-1, ', ', 
'''', (select coalesce(indirizzo,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
-1, ', ', 
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'BDU' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
-1, ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select case  when provincia_ordine_vet ilike '%avellino%' then 64 when provincia_ordine_vet ilike '%benevento%' then 62 when provincia_ordine_vet ilike '%caserta%' then 61 when provincia_ordine_vet ilike '%napoli%' then 63 when provincia_ordine_vet ilike '%salerno%' then 65 else -1 end from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select numero_ordine_vet from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'VAM' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_vam,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', '1', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
(select coalesce(id_clinica_vam[_indice],-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', '-1', '''', ', ',
-1, ', ',
'''', null::character varying, '''', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'DIGEMON' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', '1', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
			
END IF;

IF _endpoint ilike 'sicurezzalavoro' then

select concat(
'select * from dbi_insert_utente(',
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select nome from spid.get_lista_richieste(_numero_richiesta)), '''',  ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
-1, ', ',
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
END IF;

END IF;

IF _tipologia ilike 'ELIMINA' THEN

IF _endpoint ilike 'GISA' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'GISA_EXT' then

select concat(
'select * from dbi_elimina_utente_ext(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'BDU' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'VAM' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'DIGEMON' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'sicurezzalavoro' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;


END IF;

RAISE INFO '[get_dbi_per_endpoint] %', _query;

return _query;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer)
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION spid.processa_richiesta_modifica(
    _numero_richiesta text,
    _idutente integer)
  RETURNS text AS
$BODY$
declare

	esito integer;
	output_guc_gisa text;
	output_guc_gisa_ext text;
	output_guc_bdu text;
	output_guc_vam text;
	output_guc_digemon text;
	output_guc_sicurezza_lavoro text;
	username_out text;
	password_out text;
	
	ep_gisa integer;
	ep_gisa_ext integer;
	ep_bdu integer;
	ep_vam integer;
	ep_digemon integer;
	ep_sicurezza_lavoro integer;

	check_endpoint text;

	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	query text;
	
	_codice_fiscale text;
	esito_processa text;
	query_endpoint text;
	output_guc text;

	indice integer;

	_id_guc_ruoli integer;
	_endpoint_guc_ruoli text;
	_id_utente_guc_ruoli integer;
	_id_ruolo_guc_ruoli integer;

BEGIN
	-- recupero CF e id_ruoli per ogni EP
	_id_guc_ruoli := (select id_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_endpoint_guc_ruoli := (select endpoint_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_id_utente_guc_ruoli := (select id_utente from guc_ruoli where id = _id_guc_ruoli);
	_id_ruolo_guc_ruoli := (select ruolo_integer from guc_ruoli where id = _id_guc_ruoli);
	username_out := (select username from guc_utenti where id = _id_utente_guc_ruoli);
	password_out := (select password from guc_utenti where id = _id_utente_guc_ruoli);

	_codice_fiscale := (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));
	
	-- new
	ep_sicurezza_lavoro := (select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta));

	
	output_gisa='{}';
	output_gisa_ext='{}';
	output_bdu='{}';
	output_vam='{}';
	output_digemon='{}';
	output_guc ='{}';
	output_sicurezza_lavoro ='{}';
	
	if (ep_gisa > 0 and _endpoint_guc_ruoli ilike 'gisa') then
		
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa'')';
			output_guc_gisa := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_gisa := COALESCE(output_guc_gisa, '');

			if (get_json_valore(output_guc_gisa, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_gisa||',''Gisa'')';			
				output_guc_gisa := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_gisa, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _idutente,'host=dbGISAL dbname=gisa'));
					if (get_json_valore(output_gisa, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _idutente,'host=dbGISAL dbname=gisa'));
						output_gisa := '{"Esito" : "'||output_gisa ||'"}';
					end if;
					--else
			--output_gisa := output_guc_gisa;
				end if;
			end if;	
	
	end if; -- fine ep_gisa

	if (ep_gisa_ext > 0 and _endpoint_guc_ruoli ilike 'gisa_ext') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa_ext'')';
			output_guc_gisa_ext := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_gisa_ext := COALESCE(output_guc_gisa_ext, '');

			if (get_json_valore(output_guc_gisa_ext, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_gisa_ext||',''Gisa_ext'')';			
				output_guc_gisa_ext := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_gisa_ext, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _idutente,'host=dbGISAL dbname=gisa'));
					if (get_json_valore(output_gisa_ext, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _idutente,'host=dbGISAL dbname=gisa'));
						output_gisa_ext := '{"Esito" : "'||output_gisa_ext||'"}';
					end if;
					--else
			--output_gisa_ext := output_guc_gisa_ext;
				end if;
			end if;			        
			
	end if; -- fine ep_gisa_ext

	if (ep_bdu > 0 and _endpoint_guc_ruoli ilike 'bdu') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''bdu'')';
			output_guc_bdu := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_bdu := COALESCE(output_guc_bdu, '');
			if (get_json_valore(output_guc_bdu, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_bdu||',''bdu'')';			
				output_guc_bdu := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_bdu, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _idutente,'host=dbBDUL dbname=bdu'));
					if (get_json_valore(output_bdu, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _idutente,'host=dbBDUL dbname=bdu'));
						output_bdu := '{"Esito" : "'||output_bdu||'"}';
					end if;
					--else
			--output_bdu := output_guc_bdu;
				end if;
			end if;		
		
	end if; -- fine ep_bdu
				  
	if (ep_vam > 0 and _endpoint_guc_ruoli ilike 'vam') then
		
			-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''vam'')';
			output_guc_vam := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_vam := COALESCE(output_guc_vam, '');
			if (get_json_valore(output_guc_vam, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_vam||',''vam'')';			
				output_guc_vam := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_vam, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _idutente,'host=dbVAML dbname=vam'));
					if (get_json_valore(output_vam, 'Esito') = 'OK') then -- insert utente
					-- svuoto tutte le cliniche in GUC
					delete from guc_cliniche_vam where id_utente = _id_utente_guc_ruoli;
					indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP
		
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, (indice+1)));
						output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _idutente,'host=dbVAML dbname=vam'));
						output_vam := '{"Esito" : "'||output_vam||'"}';

						-- aggiornamento cliniche vam
						query := (select concat('insert into guc_cliniche_vam(id_clinica, descrizione_clinica, id_utente) values(', 
						(select id_clinica_vam[indice+1] from spid.get_lista_richieste(_numero_richiesta)), ',''', 
						(select replace(clinica_vam[indice+1], '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ', 
						(_id_utente_guc_ruoli), ') returning ''OK'';'));
						raise info 'stampa query insert vam cliniche%', query;
						query := (select * from spid.esegui_query(query, 'guc', _idutente,''));
						raise info 'output query insert vam cliniche: %', query;

						
						indice = indice+1;
		END LOOP;
					end if;
					--else
			--output_vam := output_guc_vam;
				end if;
			end if;		
		
	end if; -- fine ep_vam	  

	if (ep_digemon > 0 and _endpoint_guc_ruoli ilike 'digemon') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''digemon'')';
			output_guc_digemon := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_digemon := COALESCE(output_guc_digemon, '');

			if (get_json_valore(output_guc_digemon, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_digemon||',''digemon'')';			
				output_guc_digemon := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_digemon, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _idutente,'host=dbDIGEMONL dbname=digemon_u'));
					if (get_json_valore(output_digemon, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _idutente,'host=dbDIGEMONL dbname=digemon_u'));
						output_digemon := '{"Esito" : "'||output_digemon||'"}';
					end if;
					--else
			--output_digemon := output_guc_digemon;
				end if;
			end if;	
		
	end if; -- fine ep_digemon
	

	if (ep_sicurezza_lavoro > 0 and _endpoint_guc_ruoli ilike 'sicurezzalavoro') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''sicurezzalavoro'')';
			output_guc_sicurezza_lavoro := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_sicurezza_lavoro := COALESCE(output_guc_sicurezza_lavoro, '');

			if (get_json_valore(output_guc_sicurezza_lavoro, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_sicurezza_lavoro||',''sicurezzalavoro'')';			
				output_guc_sicurezza_lavoro := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_sicurezza_lavoro, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _idutente,'host=dbGESDASICL dbname=gesdasic'));
					if (get_json_valore(output_sicurezza_lavoro, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _idutente,'host=dbGESDASICL dbname=gesdasic'));
						output_sicurezza_lavoro := '{"Esito" : "'||output_sicurezza_lavoro||'"}';
					end if;
				end if;
			end if;	
		
	end if; -- fine ep_sicurezza_lavoro

	esito_processa = '{"EndPoint" : "GUC", "Username" : "' || username_out || '", "CodiceFiscale": "'||_codice_fiscale||'","ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}

			]}';
	raise info '[STAMPA ESITO PROCESSA] %', esito_processa;

	IF get_json_valore(output_gisa, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_gisa_ext, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_bdu, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_vam, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_digemon, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' THEN
		esito = 1;
	END IF;
		
	-- update e insert richieste
	UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
	insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon, esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
	values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),
					       _idutente, (case when esito = 1 then 1 end),esito_processa);
		

	return esito_processa;
	
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.processa_richiesta_modifica(text, integer)
  OWNER TO postgres;

  -- DROP FUNCTION spid.processa_richiesta_elimina(text, integer);

CREATE OR REPLACE FUNCTION spid.processa_richiesta_elimina(
    _numero_richiesta text,
    _id_utente integer)
  RETURNS text AS
$BODY$
declare
	esito integer;

	esito_processa text;

	query_endpoint text;
	query text;

	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	output_guc text;
	_codice_fiscale text;
	output_guc_gisa_ext text;
	output_guc_bdu text;
	output_guc_vam text;
	output_guc_digemon text;
	output_guc_sicurezza_lavoro text;
	output_guc_gisa text;

	output_disattiva text;
	_id_guc_ruoli integer;
	_endpoint_guc_ruoli text;
	_id_utente_guc_ruoli integer;
	_id_ruolo_guc_ruoli integer;

	username_out text;
BEGIN
	output_gisa = '{}';
	output_gisa_ext = '{}';
	output_bdu = '{}' ;
	output_vam = '{}';
	output_digemon = '{}';
	output_sicurezza_lavoro = '{}';
	output_guc = '{}';
	-- elimino utente prima in guc e poi nell'EP.
	_id_guc_ruoli := (select id_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_endpoint_guc_ruoli := (select endpoint_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_id_utente_guc_ruoli := (select id_utente from guc_ruoli where id = _id_guc_ruoli);
	_id_ruolo_guc_ruoli := (select ruolo_integer from guc_ruoli where id = _id_guc_ruoli);
	username_out := (select username from guc_utenti where id = _id_utente_guc_ruoli);
	
	_codice_fiscale := (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta));
	/*ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));

	_ruolo_gisa := (select coalesce(ruolo_gisa,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_gisa_ext := (select coalesce(ruolo_gisa_ext,'')from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_bdu := (select coalesce(ruolo_bdu,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_vam := (select coalesce(ruolo_vam,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_digemon :=(select coalesce(ruolo_digemon,'') from spid.get_lista_richieste(_numero_richiesta));
*/

	if (_endpoint_guc_ruoli ilike 'gisa') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_gisa := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'elimina', _id_utente, username_out, '', now()::timestamp without time zone - interval '1 DAY',_id_ruolo_guc_ruoli, -1));
				output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			end if;	
		  end if; -- fine ep_gisa

	if (_endpoint_guc_ruoli ilike 'gisa_ext') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa_ext'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_gisa_ext := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _id_utente,'host=dbGISAL dbname=gisa'));
			end if;	
		end if; -- fine ep_gisa_ext
        
	if (_endpoint_guc_ruoli ilike 'bdu') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''bdu'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_bdu := COALESCE(output_guc, '');
			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _id_utente,'host=dbBDUL dbname=bdu'));
				
			end if;	
		end if; -- fine ep_bdu
        
	if (_endpoint_guc_ruoli ilike 'vam') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''vam'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_vam := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _id_utente,'host=dbVAML dbname=vam'));
			end if;	
		  end if; -- fine ep_vam

	if (_endpoint_guc_ruoli ilike 'digemon') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''digemon'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_digemon := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _id_utente,'host=dbdigemonL dbname=digemon_u'));
			end if;	
		 end if; -- fine ep_digemon

		 if (_endpoint_guc_ruoli ilike 'sicurezzalavoro') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''sicurezzalavoro'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_sicurezza_lavoro := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _id_utente,'host=dbGESDASICL dbname=gesdasic'));
			end if;	
		 end if; -- fine ep_sicurezza_lavoro
       
	esito_processa = '{"EndPoint" : "GUC", "Risultato": '||output_guc||', "CodiceFiscale": "'||_codice_fiscale||'","ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}]}';	
				   
	raise info '[STAMPA ESITO PROCESSA] %', esito_processa;

	IF get_json_valore(output_gisa, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_gisa_ext, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_bdu, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_vam, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_digemon, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' THEN
		esito = 1;
	END IF;

	output_disattiva := (select * from public.disattiva_utente(_id_utente_guc_ruoli));

	UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
	insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon,esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
	values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),
					       _id_utente, (case when esito = 1 then 1 end)
						,esito_processa);					
		   
	return esito_processa;
	
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.processa_richiesta_elimina(text, integer)
  OWNER TO postgres;
  
-- versione da lanciare SENZA il check DIGEMON
  DROP FUNCTION dbi_insert_utente_guc(text,text,text,boolean,integer,timestamp without time zone,integer,text,text,text,text,integer,text,integer,text,text,text,integer,integer,text,text,integer,text,integer,text,text,text,text,text,text,text,integer,text,text,integer,text,integer,text,integer,text,integer,text,integer,text,integer,text,text,integer,text,integer,integer,text,text,integer,text,text,integer,text,text,integer,text);
  CREATE OR REPLACE FUNCTION public.dbi_insert_utente_guc(
    input_cf text,
    input_cognome text,
    input_email text,
    input_enabled boolean,
    input_enteredby integer,
    input_expires timestamp without time zone,
    input_modifiedby integer,
    input_note text,
    input_nome text,
    input_password text,
    input_username text,
    input_asl_id integer,
    input_password_encrypted text,
    input_canile_id integer,
    input_canile_description text,
    input_luogo text,
    input_num_autorizzazione text,
    input_id_importatore integer,
    input_canilebdu_id integer,
    input_canilebdu_description text,
    input_importatori_description text,
    input_id_provincia_iscrizione_albo_vet_privato integer,
    input_nr_iscrione_albo_vet_privato text,
    input_id_utente_guc_old integer,
    input_suap_ip_address text,
    input_suap_istat_comune text,
    input_suap_pec text,
    input_suap_callback text,
    input_suap_shared_key text,
    input_suap_callback_ko text,
    input_num_registrazione_stab text,
    input_suap_livello_accreditamento integer,
    input_suap_descrizione_livello_accreditamento text,
    input_telefono text,
    input_ruolo_id_gisa integer,
    input_ruolo_descrizione_gisa text,
    input_ruolo_id_gisa_ext integer,
    input_ruolo_descrizione_gisa_ext text,
    input_ruolo_id_bdu integer,
    input_ruolo_descrizione_bdu text,
    input_ruolo_id_vam integer,
    input_ruolo_descrizione_vam text,
    input_ruolo_id_importatori integer,
    input_ruolo_descrizione_importatori text,
    input_ruolo_id_digemon integer,
    input_ruolo_descrizione_digemon text,
    input_luogo_vam text,
    input_id_provincia_vam integer,
    input_nr_iscrizione_vam text,
    input_gestore_acque integer,
    input_comune_gestore_acque integer,
    input_piva text,
    input_tipo_attivita_apicoltore text,
    input_comune_apicoltore integer,
    input_indirizzo_apicoltore text,
    input_cap_indirizzo_apicoltore text,
    input_comune_trasportatore integer,
    input_indirizzo_trasportatore text,
    input_cap_indirizzo_trasportatore text,
    input_ruolo_id_sicurezza_lavoro integer,
    input_ruolo_descrizione_sicurezza_lavoro text)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
us_id int ;
input_password_decrypted text;
ruolo_gisa guc_ruolo;
ruolo_gisa_ext guc_ruolo;
ruolo_bdu guc_ruolo;
ruolo_vam guc_ruolo;
ruolo_importatori guc_ruolo;
ruolo_digemon guc_ruolo;
ruolo_sicurezza_lavoro guc_ruolo;

BEGIN


--Inserisco utente
us_id:= (select nextval('guc_utenti_id_seq'));

IF (input_username is null or input_username = '') THEN
select concat('spid_usr_',us_id) into input_username;
END IF;

IF (input_password  is null or input_password  = '') THEN
select concat('spid_pwd_',us_id) into input_password_decrypted;
select md5(input_password_decrypted) into input_password ;
END IF;

INSERT INTO guc_utenti_ (ID,CODICE_FISCALE,COGNOME,EMAIL,ENABLED,entered,enteredby,expires,modified,modifiedby,note,nome,password,username,asl_id,password_encrypted,canile_id, canile_description,luogo,num_autorizzazione,id_importatore,canilebdu_id, canilebdu_description,
importatori_description,id_provincia_iscrizione_albo_vet_privato,nr_iscrione_albo_vet_privato,id_utente_guc_old,suap_ip_address ,suap_istat_comune ,suap_pec ,
suap_callback ,suap_shared_key,suap_callback_ko,num_registrazione_stab,suap_livello_accreditamento,suap_descrizione_livello_accreditamento,telefono, 
luogo_vam, id_provincia_iscrizione_albo_vet_privato_vam, nr_iscrione_albo_vet_privato_vam, gestore_acque , comune_gestore_acque, piva, 
comune_apicoltore, comune_trasportatore, 
indirizzo_trasportatore, indirizzo_apicoltore, 
cap_trasportatore, cap_apicoltore, 
tipo_attivita_apicoltore) 
values (us_id,input_cf,input_cognome,input_email,input_enabled,now(),input_enteredby,input_expires,now(),input_modifiedby,input_note, input_nome,input_password,input_username,input_asl_id,input_password_encrypted,input_canile_id, 
input_canile_description,input_luogo,input_num_autorizzazione,input_id_importatore,input_canilebdu_id, input_canilebdu_description,input_importatori_description,
input_id_provincia_iscrizione_albo_vet_privato,input_nr_iscrione_albo_vet_privato,input_id_utente_guc_old,
input_suap_ip_address ,input_suap_istat_comune ,input_suap_pec ,input_suap_callback ,
input_suap_shared_key,input_suap_callback_ko,input_num_registrazione_stab,
input_suap_livello_accreditamento,input_suap_descrizione_livello_accreditamento,input_telefono , input_luogo_vam, 
input_id_provincia_vam, input_nr_iscrizione_vam, input_gestore_acque, input_comune_gestore_acque, input_piva, 
input_comune_apicoltore, input_comune_trasportatore, 
input_indirizzo_trasportatore, input_indirizzo_apicoltore, 
input_cap_indirizzo_trasportatore, input_cap_indirizzo_apicoltore, 
input_tipo_attivita_apicoltore);

msg:='OK';


--Popolo ruoli e li inserisco

ruolo_gisa.id_ruolo:= input_ruolo_id_gisa;
ruolo_gisa.descrizione_ruolo:= input_ruolo_descrizione_gisa;
ruolo_gisa.end_point:= 'Gisa';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_gisa.end_point,ruolo_gisa.id_ruolo,ruolo_gisa.descrizione_ruolo,us_id,input_note);

ruolo_gisa_ext.id_ruolo:= input_ruolo_id_gisa_ext;
ruolo_gisa_ext.descrizione_ruolo:= input_ruolo_descrizione_gisa_ext;
ruolo_gisa_ext.end_point:= 'Gisa_ext';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_gisa_ext.end_point,ruolo_gisa_ext.id_ruolo,ruolo_gisa_ext.descrizione_ruolo,us_id,input_note);

ruolo_bdu.id_ruolo:= input_ruolo_id_bdu;
ruolo_bdu.descrizione_ruolo:= input_ruolo_descrizione_bdu;
ruolo_bdu.end_point:= 'bdu';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_bdu.end_point,ruolo_bdu.id_ruolo,ruolo_bdu.descrizione_ruolo,us_id,input_note);

ruolo_vam.id_ruolo:= input_ruolo_id_vam;
ruolo_vam.descrizione_ruolo:= input_ruolo_descrizione_vam;
ruolo_vam.end_point:= 'Vam';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_vam.end_point,ruolo_vam.id_ruolo,ruolo_vam.descrizione_ruolo,us_id,input_note);

ruolo_importatori.id_ruolo:= input_ruolo_id_importatori;
ruolo_importatori.descrizione_ruolo:= input_ruolo_descrizione_importatori;
ruolo_importatori.end_point:= 'Importatori';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_importatori.end_point,ruolo_importatori.id_ruolo,ruolo_importatori.descrizione_ruolo,us_id,input_note);

ruolo_digemon.id_ruolo:= input_ruolo_id_digemon;
ruolo_digemon.descrizione_ruolo:= input_ruolo_descrizione_digemon;
ruolo_digemon.end_point:= 'Digemon';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_digemon.end_point,ruolo_digemon.id_ruolo,ruolo_digemon.descrizione_ruolo,us_id,input_note);

ruolo_sicurezza_lavoro.id_ruolo:= input_ruolo_id_sicurezza_lavoro;
ruolo_sicurezza_lavoro.descrizione_ruolo:= input_ruolo_descrizione_sicurezza_lavoro;
ruolo_sicurezza_lavoro.end_point:= 'SicurezzaLavoro';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_sicurezza_lavoro.end_point,ruolo_sicurezza_lavoro.id_ruolo,ruolo_sicurezza_lavoro.descrizione_ruolo,us_id,input_note);

RETURN concat(msg,';;',us_id,';;','spid_usr_',us_id,';;',input_password_decrypted);
END
$BODY$
  LANGUAGE plpgsql VOLATILE

  
-- DROP FUNCTION spid.get_lista_richieste(text);

CREATE OR REPLACE FUNCTION spid.get_lista_richieste(IN _numero_richiesta text DEFAULT NULL::text)
  RETURNS TABLE(id integer, id_tipologia_utente integer, tipologia_utente text, id_tipo_richiesta integer, tipo_richiesta text, cognome text, nome text, codice_fiscale text,
   email text, telefono text, id_ruolo_gisa integer, ruolo_gisa text, id_ruolo_bdu integer, ruolo_bdu text, id_ruolo_vam integer, ruolo_vam text, id_ruolo_gisa_ext integer, ruolo_gisa_ext text, id_ruolo_digemon integer, 
   ruolo_digemon text, id_clinica_vam integer[], clinica_vam text[], id_ruolo_sicurezza_lavoro integer, ruolo_sicurezza_lavoro text, identificativo_ente text, piva_numregistrazione text, comune text, istat_comune text, nominativo_referente text, ruolo_referente text, email_referente text, telefono_referente text, data_richiesta timestamp without time zone, codice_gisa text, indirizzo text, id_gestore_acque integer, gestore_acque text, cap text, pec text, numero_richiesta text, esito_guc boolean, esito_gisa boolean, esito_gisa_ext boolean, esito_bdu boolean, esito_vam boolean, esito_digemon boolean, esito_sicurezza_lavoro boolean, data_esito timestamp without time zone, stato integer, utente_esito text, id_asl integer, asl text, provincia_ordine_vet text, numero_ordine_vet text, numero_decreto_prefettizio text, scadenza_decreto_prefettizio text, numero_autorizzazione_regionale_vet text, id_tipologia_trasp_dist integer, esito text, id_guc_ruoli integer, endpoint_guc_ruoli text, ruolo_guc_ruoli text, in_nucleo boolean, in_dpat boolean) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY

SELECT r.id, r.id_tipologia_utente, tip.descr as tipologia_utente, r.id_tipo_richiesta, ric.descr as tipologia_richiesta, 
r.cognome::text, r.nome::text, r.codice_fiscale::text, r.email::text, r.telefono::text, r.id_ruolo_gisa::int, g.ruolo as ruolo_gisa, r.id_ruolo_bdu::int,
b.ruolo as ruolo_bdu, r.id_ruolo_vam::int, v.ruolo as ruolo_vam, r.id_ruolo_gisa_ext::int, ge.ruolo as ruolo_ext, r.id_ruolo_digemon::int, dg.ruolo as ruolo_digemon,
r.id_clinica_vam, 
--cli.nome_clinica, 
(select array_agg(nome_clinica)
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_clinica, nome_clinica from dbi_get_cliniche_utente()')
t1(id_clinica integer, nome_clinica text) where id_clinica = ANY (r.id_clinica_vam)),
r.id_ruolo_sicurezza_lavoro::integer, ges.ruolo as ruolo_sicurezza_lavoro, 
r.identificativo_ente::text, r.piva_numregistrazione::text, 
(select comuni.comune::text from comuni where codiceistatcomune::integer = (select case when length(r.comune)> 0 then r.comune::integer else -1 end)), coalesce(r.comune,'-1')::text as istat_comune, 
r.nominativo_referente::text,
r.ruolo_referente::text, r.email_referente::text, r.telefono_referente::text, r.data_richiesta, r.codice_gisa::text,
r.indirizzo::text, r.id_gestore_acque::integer, gac.nome, r.cap::text, r.pec::text, r.numero_richiesta::text,
es.esito_guc, es.esito_gisa, es.esito_gisa_ext, es.esito_bdu, es.esito_vam, es.esito_digemon, es.esito_sicurezza_lavoro, es.data_esito, es.stato, (select concat_ws(' ', u.nome, u.cognome) from utenti u where u.id = es.id_utente_esito)::text,
r.id_asl, l.nome::text, r.provincia_ordine_vet::text, r.numero_ordine_vet::text, r.numero_decreto_prefettizio::text, r.scadenza_decreto_prefettizio::text,
r.numero_autorizzazione_regionale_vet::text, r.id_tipologia_trasp_dist, es.json_esito, r.id_guc_ruoli, gr.endpoint::text, gr.ruolo_string::text,
f.in_nucleo, f.in_dpat
from spid.spid_registrazioni r 
left join asl l on l.id = r.id_asl
join spid.spid_tipo_richiesta ric on ric.id = r.id_tipo_richiesta
join spid.spid_tipologia_utente tip on tip.id = r.id_tipologia_utente
left join spid.spid_registrazioni_esiti es on es.numero_richiesta = r.numero_richiesta and es.trashed_date is null
left join spid.spid_registrazioni_flag f on f.numero_richiesta = r.numero_richiesta and f.trashed_date is null
left join guc_ruoli gr on gr.id = r.id_guc_ruoli
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id, nome::text from public_functions.dbi_get_gestori_acque(-1)')  -----> perchï¿½ non va bene passare il valore???
t1(id integer, nome text)
) gac on gac.id = r.id_gestore_acque::integer
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) g on r.id_ruolo_gisa = g.id
left join (
select * 
   FROM dblink('host=dbBDUL dbname=bdu'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) b on r.id_ruolo_bdu = b.id
left join (
select * 
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) v on r.id_ruolo_vam = v.id 
--left join (
--select * 
--   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
--			id_clinica, nome_clinica from dbi_get_cliniche_utente()') 
--t1(id_clinica integer, nome_clinica text)
--) cli on cli.id_clinica::text = r.id_clinica_vam
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente_ext()') 
t1(id integer, ruolo text)
) ge on r.id_ruolo_gisa_ext = ge.id 
left join (
select * 
   FROM dblink('host=dbDIGEMONL dbname=digemon_u'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) dg on r.id_ruolo_digemon = dg.id 
left join (
select * 
   FROM dblink('host=dbGESDASICL dbname=gesdasic'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) ges on r.id_ruolo_sicurezza_lavoro = ges.id 
where 1=1 
and (_numero_richiesta is null or r.numero_richiesta = _numero_richiesta)
order by r.data_richiesta desc, r.numero_richiesta;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION spid.get_lista_richieste(text)
  OWNER TO postgres;
  
 insert into guc_endpoint values (9, 'Gesdasic', 'jdbc/gesdasicM', 'jdbc/gesdasicS', true);
 insert into guc_endpoint_connector_config(id_operazione, id_endpoint, url_reload_utenti) 
values
(
(select id from guc_operazioni where nome = 'InsertUtente'), 
(select id from guc_endpoint where nome = 'Gesdasic'), 
'DA_CONFIGURARE_RELOAD_GESDASIC'
); 

update guc_endpoint set nome = 'SicurezzaLavoro' where nome ilike '%gesdasic%';

------------------------------- GUARDARE SOLO QUESTA PARTE PER RILASCIO GESDASIC---------------------------------------
-- per rilasciare anche GESDASIC definire host dbGESDASICL
-- mettere la versione aggiornata di  spid.get_lista_richieste(text) che include il ruolo gesdasic, altrimenti lanciare:
/*DROP FUNCTION spid.get_lista_richieste(text);

CREATE OR REPLACE FUNCTION spid.get_lista_richieste(IN _numero_richiesta text DEFAULT NULL::text)
  RETURNS TABLE(id integer, id_tipologia_utente integer, tipologia_utente text, id_tipo_richiesta integer, tipo_richiesta text, cognome text, nome text, codice_fiscale text,
   email text, telefono text, id_ruolo_gisa integer, ruolo_gisa text, id_ruolo_bdu integer, ruolo_bdu text, id_ruolo_vam integer, ruolo_vam text, id_ruolo_gisa_ext integer, ruolo_gisa_ext text, id_ruolo_digemon integer, 
   ruolo_digemon text, id_clinica_vam integer[], clinica_vam text[], id_ruolo_sicurezza_lavoro integer, ruolo_sicurezza_lavoro text, identificativo_ente text, piva_numregistrazione text, comune text, istat_comune text, nominativo_referente text, ruolo_referente text, email_referente text, telefono_referente text, data_richiesta timestamp without time zone, codice_gisa text, indirizzo text, id_gestore_acque integer, gestore_acque text, cap text, pec text, numero_richiesta text, esito_guc boolean, esito_gisa boolean, esito_gisa_ext boolean, esito_bdu boolean, esito_vam boolean, esito_digemon boolean, esito_sicurezza_lavoro boolean, data_esito timestamp without time zone, stato integer, utente_esito text, id_asl integer, asl text, provincia_ordine_vet text, numero_ordine_vet text, numero_decreto_prefettizio text, scadenza_decreto_prefettizio text, numero_autorizzazione_regionale_vet text, id_tipologia_trasp_dist integer, esito text, id_guc_ruoli integer, endpoint_guc_ruoli text, ruolo_guc_ruoli text, in_nucleo boolean, in_dpat boolean) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY

SELECT r.id, r.id_tipologia_utente, tip.descr as tipologia_utente, r.id_tipo_richiesta, ric.descr as tipologia_richiesta, 
r.cognome::text, r.nome::text, r.codice_fiscale::text, r.email::text, r.telefono::text, r.id_ruolo_gisa::int, g.ruolo as ruolo_gisa, r.id_ruolo_bdu::int,
b.ruolo as ruolo_bdu, r.id_ruolo_vam::int, v.ruolo as ruolo_vam, r.id_ruolo_gisa_ext::int, ge.ruolo as ruolo_ext, r.id_ruolo_digemon::int, dg.ruolo as ruolo_digemon,
r.id_clinica_vam, 
--cli.nome_clinica, 
(select array_agg(nome_clinica)
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_clinica, nome_clinica from dbi_get_cliniche_utente()')
t1(id_clinica integer, nome_clinica text) where id_clinica = ANY (r.id_clinica_vam)),
r.id_ruolo_sicurezza_lavoro::integer, ges.ruolo as ruolo_sicurezza_lavoro, 
r.identificativo_ente::text, r.piva_numregistrazione::text, 
(select comuni.comune::text from comuni where codiceistatcomune::integer = (select case when length(r.comune)> 0 then r.comune::integer else -1 end)), coalesce(r.comune,'-1')::text as istat_comune, 
r.nominativo_referente::text,
r.ruolo_referente::text, r.email_referente::text, r.telefono_referente::text, r.data_richiesta, r.codice_gisa::text,
r.indirizzo::text, r.id_gestore_acque::integer, gac.nome, r.cap::text, r.pec::text, r.numero_richiesta::text,
es.esito_guc, es.esito_gisa, es.esito_gisa_ext, es.esito_bdu, es.esito_vam, es.esito_digemon, es.esito_sicurezza_lavoro, es.data_esito, es.stato, (select concat_ws(' ', u.nome, u.cognome) from utenti u where u.id = es.id_utente_esito)::text,
r.id_asl, l.nome::text, r.provincia_ordine_vet::text, r.numero_ordine_vet::text, r.numero_decreto_prefettizio::text, r.scadenza_decreto_prefettizio::text,
r.numero_autorizzazione_regionale_vet::text, r.id_tipologia_trasp_dist, es.json_esito, r.id_guc_ruoli, gr.endpoint::text, gr.ruolo_string::text,
f.in_nucleo, f.in_dpat
from spid.spid_registrazioni r 
left join asl l on l.id = r.id_asl
join spid.spid_tipo_richiesta ric on ric.id = r.id_tipo_richiesta
join spid.spid_tipologia_utente tip on tip.id = r.id_tipologia_utente
left join spid.spid_registrazioni_esiti es on es.numero_richiesta = r.numero_richiesta and es.trashed_date is null
left join spid.spid_registrazioni_flag f on f.numero_richiesta = r.numero_richiesta and f.trashed_date is null
left join guc_ruoli gr on gr.id = r.id_guc_ruoli
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id, nome::text from public_functions.dbi_get_gestori_acque(-1)')  -----> perchï¿½ non va bene passare il valore???
t1(id integer, nome text)
) gac on gac.id = r.id_gestore_acque::integer
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) g on r.id_ruolo_gisa = g.id
left join (
select * 
   FROM dblink('host=dbBDUL dbname=bdu'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) b on r.id_ruolo_bdu = b.id
left join (
select * 
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) v on r.id_ruolo_vam = v.id 
--left join (
--select * 
--   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
--			id_clinica, nome_clinica from dbi_get_cliniche_utente()') 
--t1(id_clinica integer, nome_clinica text)
--) cli on cli.id_clinica::text = r.id_clinica_vam
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente_ext()') 
t1(id integer, ruolo text)
) ge on r.id_ruolo_gisa_ext = ge.id 
left join (
select * 
   FROM dblink('host=dbDIGEMONL dbname=digemon_u'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) dg on r.id_ruolo_digemon = dg.id 
left join (
select * 
   FROM dblink('host=dbGESDASICL dbname=gesdasic'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) ges on r.id_ruolo_sicurezza_lavoro = ges.id 
where 1=1 
and (_numero_richiesta is null or r.numero_richiesta = _numero_richiesta)
order by r.data_richiesta desc, r.numero_richiesta;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION spid.get_lista_richieste(text)
  OWNER TO postgres;
  **/

------------------------------------------------------------------------------------nuova versione 30/01-----------------------------------------------------------------------------------------------------------------
--#################################MODIFICARE IL NOME DEL DB GESDASIC#######################################################
-- FUNCTION: spid.get_lista_richieste(text)

-- DROP FUNCTION IF EXISTS spid.get_lista_richieste(text);

CREATE OR REPLACE FUNCTION spid.get_lista_richieste(
	_numero_richiesta text DEFAULT NULL::text)
    RETURNS TABLE(id integer, id_tipologia_utente integer, tipologia_utente text, id_tipo_richiesta integer, tipo_richiesta text, 
				  cognome text, nome text, codice_fiscale text, email text, telefono text, id_ruolo_gisa integer, 
				  ruolo_gisa text, id_ruolo_bdu integer, ruolo_bdu text, id_ruolo_vam integer, ruolo_vam text, id_ruolo_gisa_ext integer, 
				  ruolo_gisa_ext text, id_ruolo_digemon integer, ruolo_digemon text, id_clinica_vam integer[], clinica_vam text[], 
				  id_ruolo_sicurezza_lavoro integer, ruolo_sicurezza_lavoro text, identificativo_ente text, piva_numregistrazione text, 
				  comune text, istat_comune text, nominativo_referente text, ruolo_referente text, email_referente text, telefono_referente text, 
				  data_richiesta timestamp without time zone, codice_gisa text, indirizzo text, id_gestore_acque integer, gestore_acque text, 
				  cap text, pec text, numero_richiesta text, esito_guc boolean, esito_gisa boolean, esito_gisa_ext boolean, esito_bdu boolean, 
				  esito_vam boolean, esito_digemon boolean, esito_sicurezza_lavoro boolean, data_esito timestamp without time zone, 
				  stato integer, utente_esito text, id_asl integer, asl text, provincia_ordine_vet text, numero_ordine_vet text, 
				  numero_decreto_prefettizio text, scadenza_decreto_prefettizio text, numero_autorizzazione_regionale_vet text, 
				  id_tipologia_trasp_dist integer, esito text, id_guc_ruoli integer, endpoint_guc_ruoli text, ruolo_guc_ruoli text, 
				  in_nucleo boolean, 
				  in_dpat boolean, id_ambito_gesdasic integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
BEGIN
RETURN QUERY

SELECT r.id, r.id_tipologia_utente, tip.descr as tipologia_utente, r.id_tipo_richiesta, ric.descr as tipologia_richiesta, 
r.cognome::text, r.nome::text, r.codice_fiscale::text, r.email::text, r.telefono::text, r.id_ruolo_gisa::int, g.ruolo as ruolo_gisa, r.id_ruolo_bdu::int,
b.ruolo as ruolo_bdu, r.id_ruolo_vam::int, v.ruolo as ruolo_vam, r.id_ruolo_gisa_ext::int, ge.ruolo as ruolo_ext, r.id_ruolo_digemon::int, dg.ruolo as ruolo_digemon,
r.id_clinica_vam, 
--cli.nome_clinica, 
(select array_agg(nome_clinica)
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_clinica, nome_clinica from dbi_get_cliniche_utente()')
t1(id_clinica integer, nome_clinica text) where id_clinica = ANY (r.id_clinica_vam)),
r.id_ruolo_sicurezza_lavoro::integer, ges.ruolo as ruolo_sicurezza_lavoro, 
r.identificativo_ente::text, r.piva_numregistrazione::text, 
(select comuni.comune::text from comuni where codiceistatcomune::integer = (select case when length(r.comune)> 0 then r.comune::integer else -1 end)), coalesce(r.comune,'-1')::text as istat_comune, 
r.nominativo_referente::text,
r.ruolo_referente::text, r.email_referente::text, r.telefono_referente::text, r.data_richiesta, r.codice_gisa::text,
r.indirizzo::text, r.id_gestore_acque::integer, gac.nome, r.cap::text, r.pec::text, r.numero_richiesta::text,
es.esito_guc, es.esito_gisa, es.esito_gisa_ext, es.esito_bdu, es.esito_vam, es.esito_digemon, es.esito_sicurezza_lavoro, es.data_esito, es.stato, (select concat_ws(' ', u.nome, u.cognome) from utenti u where u.id = es.id_utente_esito)::text,
r.id_asl, l.nome::text, r.provincia_ordine_vet::text, r.numero_ordine_vet::text, r.numero_decreto_prefettizio::text, r.scadenza_decreto_prefettizio::text,
r.numero_autorizzazione_regionale_vet::text, r.id_tipologia_trasp_dist, es.json_esito, r.id_guc_ruoli, gr.endpoint::text, gr.ruolo_string::text,
f.in_nucleo, f.in_dpat, r.id_ambito_gesdasic
from spid.spid_registrazioni r 
left join asl l on l.id = r.id_asl
join spid.spid_tipo_richiesta ric on ric.id = r.id_tipo_richiesta
join spid.spid_tipologia_utente tip on tip.id = r.id_tipologia_utente
left join spid.spid_registrazioni_esiti es on es.numero_richiesta = r.numero_richiesta and es.trashed_date is null
left join spid.spid_registrazioni_flag f on f.numero_richiesta = r.numero_richiesta and f.trashed_date is null
left join guc_ruoli gr on gr.id = r.id_guc_ruoli
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id, nome::text from public_functions.dbi_get_gestori_acque(-1)')  -----> perchï¿½ non va bene passare il valore???
t1(id integer, nome text)
) gac on gac.id = r.id_gestore_acque::integer
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) g on r.id_ruolo_gisa = g.id
left join (
select * 
   FROM dblink('host=dbBDUL dbname=bdu'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) b on r.id_ruolo_bdu = b.id
left join (
select * 
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) v on r.id_ruolo_vam = v.id 
--left join (
--select * 
--   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
--			id_clinica, nome_clinica from dbi_get_cliniche_utente()') 
--t1(id_clinica integer, nome_clinica text)
--) cli on cli.id_clinica::text = r.id_clinica_vam
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente_ext()') 
t1(id integer, ruolo text)
) ge on r.id_ruolo_gisa_ext = ge.id 
left join (
select * 
   FROM dblink('host=dbDIGEMONL dbname=digemon_u'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) dg on r.id_ruolo_digemon = dg.id 
left join (
select * 
   FROM dblink('host=dbGESDASICL dbname=gesdasic'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) ges on r.id_ruolo_sicurezza_lavoro = ges.id 
where 1=1 
and (_numero_richiesta is null or r.numero_richiesta = _numero_richiesta)
order by r.data_richiesta desc, r.numero_richiesta;

END;
$BODY$;

ALTER FUNCTION spid.get_lista_richieste(text)
    OWNER TO postgres;



--NUOVA VERSIONE CON ID_AMBITO_GESDASIC

    -- FUNCTION: spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer)

-- DROP FUNCTION IF EXISTS spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer);

CREATE OR REPLACE FUNCTION spid.get_dbi_per_endpoint(
	_numero_richiesta text,
	_endpoint text,
	_tipologia text,
	_id_utente integer,
	_username text,
	_password text,
	_data_scadenza timestamp without time zone,
	_id_ruolo_old integer,
	_indice integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare
 _query text;
 
BEGIN

_query := '';

RAISE INFO '[get_dbi_per_endpoint] _numero_richiesta: %', _numero_richiesta;
RAISE INFO '[get_dbi_per_endpoint] _endpoint: %', _endpoint;
RAISE INFO '[get_dbi_per_endpoint] _tipologia: %', _tipologia;
RAISE INFO '[get_dbi_per_endpoint] _id_utente: %', _id_utente;
RAISE INFO '[get_dbi_per_endpoint] _username: %', _username;
RAISE INFO '[get_dbi_per_endpoint] _password: %', _password;
RAISE INFO '[get_dbi_per_endpoint] _data_scadenza: %', _data_scadenza;
RAISE INFO '[get_dbi_per_endpoint] _id_ruolo_old: %', _id_ruolo_old;
RAISE INFO '[get_dbi_per_endpoint] _indice: %', _indice;

IF _tipologia ilike 'INSERT' THEN

IF _endpoint ilike 'GUC' then

select concat(
concat('select * from dbi_insert_utente_guc(',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '1', '''', ', ',
_id_utente, ', ',
'NULL::timestamp without time zone', ', ', 
_id_utente, ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', null::character varying, '''', ', ', 
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
'''', '', '''', ', '), 
concat('''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select coalesce(numero_autorizzazione_regionale_vet,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', 
-1, ', ',
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
(select case  when provincia_ordine_vet ilike '%avellino%' then 64 when provincia_ordine_vet ilike '%benevento%' then 62 when provincia_ordine_vet ilike '%caserta%' then 61 when provincia_ordine_vet ilike '%napoli%' then 63 when provincia_ordine_vet ilike '%salerno%' then 65 else -1 end from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select numero_ordine_vet from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
0, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', --31simo parametro numero stab
0, ', '), 
concat('''', null::character varying, '''', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', ', ', 
(select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_gisa,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_gisa_ext,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(coalesce(ruolo_bdu,''), '''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
--'''', (select coalesce(ruolo_bdu,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_ruolo_vam,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_vam,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
-1, ', ',
'''', '', '''', ', ',
(select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_digemon,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '-1', '''', ', ',
-1, ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
-1, ', ',
'''', (select coalesce(piva_numregistrazione,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
-1, ', ',
'''', '', '''', ', ',
'''', '', '''', ', ',
(select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select coalesce(ruolo_sicurezza_lavoro,'') from spid.get_lista_richieste(_numero_richiesta)), '''','); ')) into _query;
END IF;

IF _endpoint ilike 'GISA' then

select concat(
'select * from dbi_insert_utente(',
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
-1, ', ',
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
END IF;

IF _endpoint ilike 'GISA_EXT' then

select concat(
'select * from dbi_insert_utente_ext(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select coalesce(id_gestore_acque,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', '', '''', ', ',
-1, ', ', 
'''', (select replace(COALESCE(indirizzo, ''),'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
-1, ', ', 
'''', '', '''', ', ',
'''', '', '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'BDU' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
-1, ', ',
'''', (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
(select case  when provincia_ordine_vet ilike '%avellino%' then 64 when provincia_ordine_vet ilike '%benevento%' then 62 when provincia_ordine_vet ilike '%caserta%' then 61 when provincia_ordine_vet ilike '%napoli%' then 63 when provincia_ordine_vet ilike '%salerno%' then 65 else -1 end from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select numero_ordine_vet from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'VAM' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_vam,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', '1', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
(select coalesce(id_clinica_vam[_indice],-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', '-1', '''', ', ',
-1, ', ',
'''', null::character varying, '''', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;

END IF;

IF _endpoint ilike 'DIGEMON' then

select concat(
'select * from dbi_insert_utente(', 
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', '1', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
			
END IF;

IF _endpoint ilike 'sicurezzalavoro' then

select concat(
'select * from dbi_insert_utente(',
'''', _username, '''', ', ',
'''', _password, '''', ', ',
(select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
_id_utente, ', ',
_id_utente, ', ',
'''', 'true', '''', ', ',
(select coalesce(id_asl,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', (select replace(nome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select replace(cognome,'''', '''''') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', 'INSERIMENTO UTENTE PER RICHIESTA PROCESSATA NUMERO '||_numero_richiesta, '''', ', ',
'''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'''', null::character varying, '''', ', ', 
'''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''', ', ',
'NULL::timestamp with time zone', ', ', 
(select coalesce(id_ambito_gesdasic,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ',
'''', 'true', '''', ', ',
'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
'''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''', '); ') into _query;
END IF;

END IF;

IF _tipologia ilike 'ELIMINA' THEN

IF _endpoint ilike 'GISA' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'GISA_EXT' then

select concat(
'select * from dbi_elimina_utente_ext(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'BDU' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'VAM' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'DIGEMON' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

IF _endpoint ilike 'sicurezzalavoro' then

select concat(
'select * from dbi_elimina_utente(',
'''', _username, '''',  ', ',
'''', _data_scadenza, '''', '); ') into _query;

END IF;

END IF;

RAISE INFO '[get_dbi_per_endpoint] %', _query;

return _query;
END
$BODY$;

ALTER FUNCTION spid.get_dbi_per_endpoint(text, text, text, integer, text, text, timestamp without time zone, integer, integer)
    OWNER TO postgres;



-- Function: spid.processa_richiesta_insert(text, integer)

-- DROP FUNCTION spid.processa_richiesta_insert(text, integer);

CREATE OR REPLACE FUNCTION spid.processa_richiesta_insert(
    _numero_richiesta text,
    _id_utente integer)
  RETURNS text AS
$BODY$
DECLARE
	--r RECORD;
	giava integer;
	ep_guc text;
	ep_gisa integer;
	ep_gisa_ext integer;
	ep_bdu integer;
	ep_vam integer;
	ep_digemon integer;
	ep_sicurezza_lavoro integer;
	_id_tipo_richiesta integer;
	username_out text;
	password_out text;
	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	esito_processa text;
	check_gisa text;
	check_vam text;
	check_bdu text;
	check_digemon text;
	check_gisa_ext text;
	check_sicurezza_lavoro text;
	query text;
	query_endpoint text;
	esito_api text;
	esito_dist text;
	esito_acque text;
	esito_guc text;

	indice integer;
BEGIN
	giava := -1;
	username_out := '';
	output_gisa = '';
	output_gisa_ext = '';
	output_bdu = '' ;
	output_vam = '';
	output_digemon = '';
	output_sicurezza_lavoro = '';
	ep_gisa = -1;
	ep_gisa_ext = -1;
	ep_bdu = -1;
	ep_vam = -1;
	ep_digemon = -1;
	ep_sicurezza_lavoro = -1;
	
	check_gisa := '';
	check_gisa_ext := '';
	check_bdu := '';
	check_vam := '';
	check_digemon := '';
	check_sicurezza_lavoro := '';

	ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_sicurezza_lavoro := (select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta));

	_id_tipo_richiesta := (select id_tipo_richiesta from spid.spid_registrazioni  where numero_richiesta = _numero_richiesta);
	--codicefiscale := (select codice_fiscale from spid.spid_registrazioni where numero_richiesta = _numero_richiesta);
	

	-- chiamo dbi dei check
	if(ep_gisa > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_gisa||', ''gisa'');';
		check_gisa := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_gisa_ext > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_gisa_ext||', ''gisa_ext'');';
		check_gisa_ext := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_bdu > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_bdu||', ''bdu'');';
		check_bdu := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;
	
	if(ep_vam > 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_vam||', ''vam'');';
		check_vam := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_digemon> 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_digemon||', ''digemon'');';
		check_digemon := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
	end if;

	if(ep_sicurezza_lavoro> 0) then
		query := 'select * from spid.check_vincoli_ruoli_by_endpoint('''||_numero_richiesta||''', '||ep_digemon||', ''sicurezzalavoro'');';
		check_sicurezza_lavoro := (select * from spid.esegui_query(query, 'sicurezzalavoro', _id_utente,''));
	end if;
	
	
	IF length(check_gisa)>0 THEN
	ep_guc := 'KO;;KO';
	output_gisa := '{"Esito":"KO", "DescrizioneErrore":"'||check_gisa||'"}';
	END IF;
	IF length(check_gisa_ext)>0 THEN
	--ep_guc := 'KO;;KO'; -- per ignorare i ko su gisa ext flusso 315
	output_gisa_ext := '{"Esito":"KO", "DescrizioneErrore":"'||check_gisa_ext||'"}';
	END IF;
	IF length(check_bdu)>0 THEN
	ep_guc := 'KO;;KO';
	output_bdu := '{"Esito":"KO", "DescrizioneErrore":"'||check_bdu||'"}';
	END IF;
	IF length(check_vam)>0 THEN
	ep_guc := 'KO;;KO';
	output_vam := '{"Esito":"KO", "DescrizioneErrore":"'||check_vam||'"}';
	END IF;
	IF length(check_digemon)>0 THEN
	--ep_guc := 'KO;;KO'; -- per ignorare i ko digemon
	output_digemon := '{"Esito":"KO", "DescrizioneErrore":"'||check_digemon||'"}';
	END IF;
	IF length(check_sicurezza_lavoro)>0 THEN
	ep_guc := 'KO;;KO';
	output_sicurezza_lavoro := '{"Esito":"KO", "DescrizioneErrore":"'||check_sicurezza_lavoro||'"}';
	END IF;
	
	if (length(check_gisa)=0  and length(check_bdu) = 0 and length(check_vam) = 0 --and length(check_digemon) = 0 IGNORO I KO SU DIGEMON E VADO AVANTI COMUNQUE
									              --and length(check_gisa_ext) = 0 IGNORO I KO SU gisa ext E VADO AVANTI COMUNQUE
	 and length(check_sicurezza_lavoro) = 0) then 
	
		if (_id_tipo_richiesta = 1) then -- inserimento utente
			query := (select * from spid.get_dbi_per_endpoint(_numero_richiesta,'guc','insert',_id_utente,null,null,null::timestamp without time zone,-1, -1)); 
			ep_guc:= (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;

		username_out := (select split_part(ep_guc,';;','3'));
		raise info ' username %', username_out;
		password_out := (select split_part(ep_guc,';;','4'));
		raise info ' password %', password_out;
		esito_guc := (select split_part(ep_guc,';;','1'));
		raise info ' esito insert guc %', esito_guc;

		if (ep_gisa > 0 and esito_guc = 'OK' and length(check_gisa)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			output_gisa := '{"Esito" : "'||output_gisa ||'"}';
			query := (select concat(
			concat('select * from dbi_insert_utente_extended_opt(',
			'''', (select id from guc_utenti where username = username_out), '''', ', ',
			'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
			'''', 'true', '''', ', ',
			'''', (select COALESCE((select coalesce(in_dpat::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
			'''', 'false', '''', ', ',
			'''', 'false', 
			'''', '); ')) );
			query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;

		if (ep_gisa_ext > 0 and esito_guc = 'OK' and length(check_gisa_ext)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			output_gisa_ext := '{"Esito" : "'||output_gisa_ext ||'"}';
			giava := (select id_ruolo_gisa_ext from spid.spid_registrazioni s where s.numero_richiesta = _numero_richiesta);
			query :=(select concat(
			concat('select * from dbi_insert_utente_extended_opt(',
				'''', (select id from guc_utenti where username = username_out), '''', ', ',
				'''', 'false', '''', ', ',
				'''', 'false', '''', ', ',
				'''', 'false', '''', ', ',
				'''', (select COALESCE((select coalesce(in_nucleo::text, 'false') from spid.spid_registrazioni_flag where trashed_date is null and numero_richiesta = _numero_richiesta), 'false')), '''', ', ',
				'''', (case when giava =10000008 then 'false' else 'true' end), 
				'''', '); ')) );
			query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
		end if;
	    
		if (ep_bdu > 0 and esito_guc = 'OK' and length(check_bdu)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _id_utente,'host=dbBDUL dbname=bdu'));
			output_bdu := '{"Esito" : "'||output_bdu ||'"}';
		end if;

		if (ep_vam > 0 and esito_guc = 'OK' and length(check_vam)=0) then

		indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP

			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, (indice+1)));
			output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _id_utente,'host=dbVAML dbname=vam'));

				output_vam := '{"Esito" : "'||output_vam ||'"}';
			indice = indice+1;
		END LOOP;	
		end if;

		if (ep_digemon > 0 and esito_guc = 'OK' and length(check_digemon)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _id_utente,'host=dbDIGEMONL dbname=digemon_u'));
			output_digemon := '{"Esito" : "'||output_digemon ||'"}';
		end if;

if (ep_sicurezza_lavoro > 0 and esito_guc = 'OK' and length(check_sicurezza_lavoro)=0) then
			query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'insert', _id_utente, username_out, password_out, null::timestamp without time zone,-1, -1));
			output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _id_utente,'host=dbGESDASICL dbname=gesdasicCOLL'));
			output_sicurezza_lavoro := '{"Esito" : "'||output_sicurezza_lavoro ||'"}';
		end if;		

		END IF;

		esito_processa = '{"EndPoint" : "GUC", "Esito": "'||(select split_part(ep_guc,';;','1'))||'", 
				   "Username" : "'||username_out||'", "ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}
				   ]
				}';		

		RAISE INFO 'esito_processa= %', esito_processa;

		if(get_json_valore(output_gisa_ext, 'Esito')='OK') then
			-- gestione ruolo gestore acque
			if ep_gisa_ext = 10000006 then 
				query = (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', 
				(select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', 
				(select coalesce(id_gestore_acque,-1) from spid.get_lista_richieste(_numero_richiesta)), ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				(select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), 
				''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', 'ACQUE', ''')'));
				raise info 'stampa query insert gisa_ext acque%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert acque: %', query;
			end if;
			-- gestione ruolo apicoltore autoconsumo/commercio
			if ep_gisa_ext = 10000002 then 
				raise info 'inserisco una richiesta per apicoltura';
				query = (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', (select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', -1, ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				(select piva_numregistrazione from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', 'API', ''')'));
				raise info 'stampa query insert gisa_ext api%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert apicoltura: %', query;	
										
				raise info 'inserisco un soggetto fisico per apicoltura';
				query = (select concat('SELECT * from insert_soggetto_fisico_per_apicoltore(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, '''::text, (select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', '', '''::text, -1, ''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select email from spid.get_lista_richieste(_numero_richiesta)), '''::text,  ''', '', '''::text, ''', (select cap from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select indirizzo from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select replace(coalesce(comune,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), '''::text, ''', (select istat_comune from spid.get_lista_richieste(_numero_richiesta)), '''::text)'));
				raise info 'stampa query insert gisa_ext api%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert apicoltura: %', query;	
			end if;
			
			-- gestione ruolo dist e trasportatore
			if ep_gisa_ext = 10000004 then 
				query := (select concat('SELECT * from dbi_insert_log_user_reg(''', (select replace(coalesce(nome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				(select replace(coalesce(cognome,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta)), ''', ''', '', ''', ''', 
				(select email from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(istat_comune,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''',
				 (select coalesce(lower(provincia_ordine_vet),'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select coalesce(cap,'') from spid.get_lista_richieste(_numero_richiesta)), ''', ''',
				  (select replace(coalesce(indirizzo,''), '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select telefono from spid.get_lista_richieste(_numero_richiesta)), ''', ''', 
				  (select ip from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''',', -1, ', ''', '', ''', ', 'null::timestamp with time zone', ', ''', 
				  (select codice_gisa from spid.get_lista_richieste(_numero_richiesta)), ''', ''', (select user_agent from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), ''', ''', (select case when id_tipologia_trasp_dist = 1 then 'TRASPORTATORE' when id_tipologia_trasp_dist = 2 then 'DISTRIBUTORE' else '' end from spid.get_lista_richieste(_numero_richiesta)), ''')'));
				raise info 'stampa query insert gisa_ext trasp/dist%', query;
				query := (select * from spid.esegui_query(query, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
				raise info 'output query gisa_ext per insert distributori: %', query;	
			end if;
		end if;

		if(get_json_valore(output_vam, 'Esito')='OK') then
		indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP
		
				query = (select concat('insert into guc_cliniche_vam(id_clinica, descrizione_clinica, id_utente) values(', (select id_clinica_vam[indice+1] from spid.get_lista_richieste(_numero_richiesta)), ',''', (select replace(clinica_vam[indice+1], '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ', (select split_part(ep_guc,';;','2')), ') returning ''OK'';'));
				raise info 'stampa query insert vam cliniche%', query;
				query := (select * from spid.esegui_query(query, 'guc', _id_utente,''));
				raise info 'output query insert vam cliniche: %', query;

				indice = indice+1;
		END LOOP;
			end if;
		
		-- update e insert richieste
UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon, esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
 (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),			       
					       _id_utente, (case when (select split_part(ep_guc,';;','1')) = 'OK' then 1 end)
						,esito_processa);
						

     RETURN esito_processa;

 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION spid.processa_richiesta_insert(text, integer)
  OWNER TO postgres;

  -- Function: spid.processa_richiesta_modifica(text, integer)

-- DROP FUNCTION spid.processa_richiesta_modifica(text, integer);

CREATE OR REPLACE FUNCTION spid.processa_richiesta_modifica(
    _numero_richiesta text,
    _idutente integer)
  RETURNS text AS
$BODY$
declare

	esito integer;
	output_guc_gisa text;
	output_guc_gisa_ext text;
	output_guc_bdu text;
	output_guc_vam text;
	output_guc_digemon text;
	output_guc_sicurezza_lavoro text;
	username_out text;
	password_out text;
	
	ep_gisa integer;
	ep_gisa_ext integer;
	ep_bdu integer;
	ep_vam integer;
	ep_digemon integer;
	ep_sicurezza_lavoro integer;

	check_endpoint text;

	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	query text;
	
	_codice_fiscale text;
	esito_processa text;
	query_endpoint text;
	output_guc text;

	indice integer;

	_id_guc_ruoli integer;
	_endpoint_guc_ruoli text;
	_id_utente_guc_ruoli integer;
	_id_ruolo_guc_ruoli integer;

BEGIN
	-- recupero CF e id_ruoli per ogni EP
	_id_guc_ruoli := (select id_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_endpoint_guc_ruoli := (select endpoint_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_id_utente_guc_ruoli := (select id_utente from guc_ruoli where id = _id_guc_ruoli);
	_id_ruolo_guc_ruoli := (select ruolo_integer from guc_ruoli where id = _id_guc_ruoli);
	username_out := (select username from guc_utenti where id = _id_utente_guc_ruoli);
	password_out := (select password from guc_utenti where id = _id_utente_guc_ruoli);

	_codice_fiscale := (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));
	
	-- new
	ep_sicurezza_lavoro := (select coalesce(id_ruolo_sicurezza_lavoro,-1) from spid.get_lista_richieste(_numero_richiesta));

	
	output_gisa='{}';
	output_gisa_ext='{}';
	output_bdu='{}';
	output_vam='{}';
	output_digemon='{}';
	output_guc ='{}';
	output_sicurezza_lavoro ='{}';
	
	if (ep_gisa > 0 and _endpoint_guc_ruoli ilike 'gisa') then
		
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa'')';
			output_guc_gisa := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_gisa := COALESCE(output_guc_gisa, '');

			if (get_json_valore(output_guc_gisa, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_gisa||',''Gisa'')';			
				output_guc_gisa := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_gisa, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _idutente,'host=dbGISAL dbname=gisa'));
					if (get_json_valore(output_gisa, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _idutente,'host=dbGISAL dbname=gisa'));
						output_gisa := '{"Esito" : "'||output_gisa ||'"}';
					end if;
					--else
			--output_gisa := output_guc_gisa;
				end if;
			end if;	
	
	end if; -- fine ep_gisa

	if (ep_gisa_ext > 0 and _endpoint_guc_ruoli ilike 'gisa_ext') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa_ext'')';
			output_guc_gisa_ext := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_gisa_ext := COALESCE(output_guc_gisa_ext, '');

			if (get_json_valore(output_guc_gisa_ext, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_gisa_ext||',''Gisa_ext'')';			
				output_guc_gisa_ext := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_gisa_ext, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _idutente,'host=dbGISAL dbname=gisa'));
					if (get_json_valore(output_gisa_ext, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _idutente,'host=dbGISAL dbname=gisa'));
						output_gisa_ext := '{"Esito" : "'||output_gisa_ext||'"}';
					end if;
					--else
			--output_gisa_ext := output_guc_gisa_ext;
				end if;
			end if;			        
			
	end if; -- fine ep_gisa_ext

	if (ep_bdu > 0 and _endpoint_guc_ruoli ilike 'bdu') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''bdu'')';
			output_guc_bdu := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_bdu := COALESCE(output_guc_bdu, '');
			if (get_json_valore(output_guc_bdu, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_bdu||',''bdu'')';			
				output_guc_bdu := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_bdu, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _idutente,'host=dbBDUL dbname=bdu'));
					if (get_json_valore(output_bdu, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _idutente,'host=dbBDUL dbname=bdu'));
						output_bdu := '{"Esito" : "'||output_bdu||'"}';
					end if;
					--else
			--output_bdu := output_guc_bdu;
				end if;
			end if;		
		
	end if; -- fine ep_bdu
				  
	if (ep_vam > 0 and _endpoint_guc_ruoli ilike 'vam') then
		
			-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''vam'')';
			output_guc_vam := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_vam := COALESCE(output_guc_vam, '');
			if (get_json_valore(output_guc_vam, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_vam||',''vam'')';			
				output_guc_vam := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_vam, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _idutente,'host=dbVAML dbname=vam'));
					if (get_json_valore(output_vam, 'Esito') = 'OK') then -- insert utente
					-- svuoto tutte le cliniche in GUC
					delete from guc_cliniche_vam where id_utente = _id_utente_guc_ruoli;
					indice := 0;
		WHILE indice < (select array_length (id_clinica_vam, 1) from spid.get_lista_richieste(_numero_richiesta)) LOOP
		
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, (indice+1)));
						output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _idutente,'host=dbVAML dbname=vam'));
						output_vam := '{"Esito" : "'||output_vam||'"}';

						-- aggiornamento cliniche vam
						query := (select concat('insert into guc_cliniche_vam(id_clinica, descrizione_clinica, id_utente) values(', 
						(select id_clinica_vam[indice+1] from spid.get_lista_richieste(_numero_richiesta)), ',''', 
						(select replace(clinica_vam[indice+1], '''', '') from spid.get_lista_richieste(_numero_richiesta)), ''', ', 
						(_id_utente_guc_ruoli), ') returning ''OK'';'));
						raise info 'stampa query insert vam cliniche%', query;
						query := (select * from spid.esegui_query(query, 'guc', _idutente,''));
						raise info 'output query insert vam cliniche: %', query;

						
						indice = indice+1;
		END LOOP;
					end if;
					--else
			--output_vam := output_guc_vam;
				end if;
			end if;		
		
	end if; -- fine ep_vam	  

	if (ep_digemon > 0 and _endpoint_guc_ruoli ilike 'digemon') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''digemon'')';
			output_guc_digemon := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_digemon := COALESCE(output_guc_digemon, '');

			if (get_json_valore(output_guc_digemon, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_digemon||',''digemon'')';			
				output_guc_digemon := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_digemon, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _idutente,'host=dbDIGEMONL dbname=digemon_u'));
					if (get_json_valore(output_digemon, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _idutente,'host=dbDIGEMONL dbname=digemon_u'));
						output_digemon := '{"Esito" : "'||output_digemon||'"}';
					end if;
					--else
			--output_digemon := output_guc_digemon;
				end if;
			end if;	
		
	end if; -- fine ep_digemon
	

	if (ep_sicurezza_lavoro > 0 and _endpoint_guc_ruoli ilike 'sicurezzalavoro') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''sicurezzalavoro'')';
			output_guc_sicurezza_lavoro := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_sicurezza_lavoro := COALESCE(output_guc_sicurezza_lavoro, '');

			if (get_json_valore(output_guc_sicurezza_lavoro, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_sicurezza_lavoro||',''sicurezzalavoro'')';			
				output_guc_sicurezza_lavoro := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_sicurezza_lavoro, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _idutente,'host=dbGESDASICL dbname=gesdasicCOLL'));
					if (get_json_valore(output_sicurezza_lavoro, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _idutente,'host=dbGESDASICL dbname=gesdasicCOLL'));
						output_sicurezza_lavoro := '{"Esito" : "'||output_sicurezza_lavoro||'"}';
					end if;
				end if;
			end if;	
		
	end if; -- fine ep_sicurezza_lavoro

	esito_processa = '{"EndPoint" : "GUC", "Username" : "' || username_out || '", "CodiceFiscale": "'||_codice_fiscale||'","ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}

			]}';
	raise info '[STAMPA ESITO PROCESSA] %', esito_processa;

	IF get_json_valore(output_gisa, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_gisa_ext, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_bdu, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_vam, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_digemon, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' THEN
		esito = 1;
	END IF;
		
	-- update e insert richieste
	UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
	insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon, esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
	values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),
					       _idutente, (case when esito = 1 then 1 end),esito_processa);
		

	return esito_processa;
	
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.processa_richiesta_modifica(text, integer)
  OWNER TO postgres;

  -- Function: spid.processa_richiesta_elimina(text, integer)

-- DROP FUNCTION spid.processa_richiesta_elimina(text, integer);

CREATE OR REPLACE FUNCTION spid.processa_richiesta_elimina(
    _numero_richiesta text,
    _id_utente integer)
  RETURNS text AS
$BODY$
declare
	esito integer;

	esito_processa text;

	query_endpoint text;
	query text;

	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_sicurezza_lavoro text;
	output_guc text;
	_codice_fiscale text;
	output_guc_gisa_ext text;
	output_guc_bdu text;
	output_guc_vam text;
	output_guc_digemon text;
	output_guc_sicurezza_lavoro text;
	output_guc_gisa text;

	output_disattiva text;
	_id_guc_ruoli integer;
	_endpoint_guc_ruoli text;
	_id_utente_guc_ruoli integer;
	_id_ruolo_guc_ruoli integer;

	username_out text;
BEGIN
	output_gisa = '{}';
	output_gisa_ext = '{}';
	output_bdu = '{}' ;
	output_vam = '{}';
	output_digemon = '{}';
	output_sicurezza_lavoro = '{}';
	output_guc = '{}';
	-- elimino utente prima in guc e poi nell'EP.
	_id_guc_ruoli := (select id_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_endpoint_guc_ruoli := (select endpoint_guc_ruoli from spid.get_lista_richieste(_numero_richiesta));
	_id_utente_guc_ruoli := (select id_utente from guc_ruoli where id = _id_guc_ruoli);
	_id_ruolo_guc_ruoli := (select ruolo_integer from guc_ruoli where id = _id_guc_ruoli);
	username_out := (select username from guc_utenti where id = _id_utente_guc_ruoli);
	
	_codice_fiscale := (select codice_fiscale from spid.get_lista_richieste(_numero_richiesta));
	/*ep_gisa := (select coalesce(id_ruolo_gisa,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_gisa_ext := (select coalesce(id_ruolo_gisa_ext,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_bdu := (select coalesce(id_ruolo_bdu,-1) from spid.get_lista_richieste(_numero_richiesta));
	ep_vam := (select coalesce(id_ruolo_vam, -1) from spid.get_lista_richieste(_numero_richiesta));
	ep_digemon := (select coalesce(id_ruolo_digemon,-1) from spid.get_lista_richieste(_numero_richiesta));

	_ruolo_gisa := (select coalesce(ruolo_gisa,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_gisa_ext := (select coalesce(ruolo_gisa_ext,'')from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_bdu := (select coalesce(ruolo_bdu,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_vam := (select coalesce(ruolo_vam,'') from spid.get_lista_richieste(_numero_richiesta));
	_ruolo_digemon :=(select coalesce(ruolo_digemon,'') from spid.get_lista_richieste(_numero_richiesta));
*/

	if (_endpoint_guc_ruoli ilike 'gisa') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_gisa := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa', 'elimina', _id_utente, username_out, '', now()::timestamp without time zone - interval '1 DAY',_id_ruolo_guc_ruoli, -1));
				output_gisa := (select * from spid.esegui_query(query_endpoint, 'gisa', _id_utente,'host=dbGISAL dbname=gisa'));
			end if;	
		  end if; -- fine ep_gisa

	if (_endpoint_guc_ruoli ilike 'gisa_ext') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''Gisa_ext'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_gisa_ext := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gisa_ext', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_gisa_ext := (select * from spid.esegui_query(query_endpoint, 'gisa_ext', _id_utente,'host=dbGISAL dbname=gisa'));
			end if;	
		end if; -- fine ep_gisa_ext
        
	if (_endpoint_guc_ruoli ilike 'bdu') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''bdu'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_bdu := COALESCE(output_guc, '');
			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'bdu', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_bdu := (select * from spid.esegui_query(query_endpoint, 'bdu', _id_utente,'host=dbBDUL dbname=bdu'));
				
			end if;	
		end if; -- fine ep_bdu
        
	if (_endpoint_guc_ruoli ilike 'vam') then
		
		-- chiamo guc e gestisco l'output
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''vam'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_vam := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'vam', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_vam := (select * from spid.esegui_query(query_endpoint, 'vam', _id_utente,'host=dbVAML dbname=vam'));
			end if;	
		  end if; -- fine ep_vam

	if (_endpoint_guc_ruoli ilike 'digemon') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''digemon'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_digemon := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'digemon', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_digemon := (select * from spid.esegui_query(query_endpoint, 'digemon', _id_utente,'host=dbdigemonL dbname=digemon_u'));
			end if;	
		 end if; -- fine ep_digemon

		 if (_endpoint_guc_ruoli ilike 'sicurezzalavoro') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''sicurezzalavoro'')';
			output_guc := (select * from spid.esegui_query(query , 'guc', _id_utente,''));
			output_sicurezza_lavoro := COALESCE(output_guc, '');

			if (get_json_valore(output_guc, 'Esito') = 'OK') then
				query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'sicurezzalavoro', 'elimina', _id_utente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'),_id_ruolo_guc_ruoli, -1));
				output_sicurezza_lavoro := (select * from spid.esegui_query(query_endpoint, 'sicurezzalavoro', _id_utente,'host=dbGESDASICL dbname=gesdasicCOLL'));
			end if;	
		 end if; -- fine ep_sicurezza_lavoro
       
	esito_processa = '{"EndPoint" : "GUC", "Risultato": '||output_guc||', "CodiceFiscale": "'||_codice_fiscale||'","ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "SICUREZZA LAVORO", "Risultato" : ['||output_sicurezza_lavoro||']}]}';	
				   
	raise info '[STAMPA ESITO PROCESSA] %', esito_processa;

	IF get_json_valore(output_gisa, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_gisa_ext, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_bdu, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_vam, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_digemon, 'Esito')='OK' THEN
		esito = 1;
	END IF;
	IF get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' THEN
		esito = 1;
	END IF;

	output_disattiva := (select * from public.disattiva_utente(_id_utente_guc_ruoli));

	UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
	insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon,esito_sicurezza_lavoro, id_utente_esito, stato, json_esito) 
	values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
			       (case when get_json_valore(output_sicurezza_lavoro, 'Esito')='OK' then true when get_json_valore(output_sicurezza_lavoro, 'Esito')='KO' then false else null end),
					       _id_utente, (case when esito = 1 then 1 end)
						,esito_processa);					
		   
	return esito_processa;
	
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.processa_richiesta_elimina(text, integer)
  OWNER TO postgres;



  
/*DROP FUNCTION spid.get_lista_richieste(text);

CREATE OR REPLACE FUNCTION spid.get_lista_richieste(IN _numero_richiesta text DEFAULT NULL::text)
  RETURNS TABLE(id integer, id_tipologia_utente integer, tipologia_utente text, id_tipo_richiesta integer, tipo_richiesta text, cognome text, nome text, codice_fiscale text,
   email text, telefono text, id_ruolo_gisa integer, ruolo_gisa text, id_ruolo_bdu integer, ruolo_bdu text, id_ruolo_vam integer, ruolo_vam text, id_ruolo_gisa_ext integer, ruolo_gisa_ext text, id_ruolo_digemon integer, 
   ruolo_digemon text, id_clinica_vam integer[], clinica_vam text[], id_ruolo_sicurezza_lavoro integer, ruolo_sicurezza_lavoro text, identificativo_ente text, 
   piva_numregistrazione text, comune text, istat_comune text, nominativo_referente text, ruolo_referente text, email_referente text, telefono_referente text, 
   data_richiesta timestamp without time zone, codice_gisa text, indirizzo text, id_gestore_acque integer, gestore_acque text, cap text, pec text, numero_richiesta text, 
   esito_guc boolean, esito_gisa boolean, esito_gisa_ext boolean, esito_bdu boolean, esito_vam boolean, esito_digemon boolean, esito_sicurezza_lavoro boolean, data_esito timestamp without time zone, 
   stato integer, utente_esito text, id_asl integer, asl text, provincia_ordine_vet text, numero_ordine_vet text, numero_decreto_prefettizio text, scadenza_decreto_prefettizio text, 
   numero_autorizzazione_regionale_vet text, id_tipologia_trasp_dist integer, esito text, id_guc_ruoli integer, endpoint_guc_ruoli text, ruolo_guc_ruoli text, in_nucleo boolean, in_dpat boolean) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY

SELECT r.id, r.id_tipologia_utente, tip.descr as tipologia_utente, r.id_tipo_richiesta, ric.descr as tipologia_richiesta, 
r.cognome::text, r.nome::text, r.codice_fiscale::text, r.email::text, r.telefono::text, r.id_ruolo_gisa::int, g.ruolo as ruolo_gisa, r.id_ruolo_bdu::int,
b.ruolo as ruolo_bdu, r.id_ruolo_vam::int, v.ruolo as ruolo_vam, r.id_ruolo_gisa_ext::int, ge.ruolo as ruolo_ext, r.id_ruolo_digemon::int, dg.ruolo as ruolo_digemon,
r.id_clinica_vam, 
--cli.nome_clinica, 
(select array_agg(nome_clinica)
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_clinica, nome_clinica from dbi_get_cliniche_utente()')
t1(id_clinica integer, nome_clinica text) where id_clinica = ANY (r.id_clinica_vam)),
--r.id_ruolo_sicurezza_lavoro::integer, ges.ruolo as ruolo_sicurezza_lavoro, 
-1, ''::text,
r.identificativo_ente::text, r.piva_numregistrazione::text, 
(select comuni.comune::text from comuni where codiceistatcomune::integer = (select case when length(r.comune)> 0 then r.comune::integer else -1 end)), coalesce(r.comune,'-1')::text as istat_comune, 
r.nominativo_referente::text,
r.ruolo_referente::text, r.email_referente::text, r.telefono_referente::text, r.data_richiesta, r.codice_gisa::text,
r.indirizzo::text, r.id_gestore_acque::integer, gac.nome, r.cap::text, r.pec::text, r.numero_richiesta::text,
es.esito_guc, es.esito_gisa, es.esito_gisa_ext, es.esito_bdu, es.esito_vam, es.esito_digemon, es.esito_sicurezza_lavoro, es.data_esito, es.stato, (select concat_ws(' ', u.nome, u.cognome) from utenti u where u.id = es.id_utente_esito)::text,
r.id_asl, l.nome::text, r.provincia_ordine_vet::text, r.numero_ordine_vet::text, r.numero_decreto_prefettizio::text, r.scadenza_decreto_prefettizio::text,
r.numero_autorizzazione_regionale_vet::text, r.id_tipologia_trasp_dist, es.json_esito, r.id_guc_ruoli, gr.endpoint::text, gr.ruolo_string::text,
f.in_nucleo, f.in_dpat
from spid.spid_registrazioni r 
left join asl l on l.id = r.id_asl
join spid.spid_tipo_richiesta ric on ric.id = r.id_tipo_richiesta
join spid.spid_tipologia_utente tip on tip.id = r.id_tipologia_utente
left join spid.spid_registrazioni_esiti es on es.numero_richiesta = r.numero_richiesta and es.trashed_date is null
left join spid.spid_registrazioni_flag f on f.numero_richiesta = r.numero_richiesta and f.trashed_date is null
left join guc_ruoli gr on gr.id = r.id_guc_ruoli
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id, nome::text from public_functions.dbi_get_gestori_acque(-1)')  -----> perchï¿½ non va bene passare il valore???
t1(id integer, nome text)
) gac on gac.id = r.id_gestore_acque::integer
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) g on r.id_ruolo_gisa = g.id
left join (
select * 
   FROM dblink('host=dbBDUL dbname=bdu'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) b on r.id_ruolo_bdu = b.id
left join (
select * 
   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) v on r.id_ruolo_vam = v.id 
--left join (
--select * 
--   FROM dblink('host=dbVAML dbname=vam'::text, 'SELECT 
--			id_clinica, nome_clinica from dbi_get_cliniche_utente()') 
--t1(id_clinica integer, nome_clinica text)
--) cli on cli.id_clinica::text = r.id_clinica_vam
left join (
select * 
   FROM dblink('host=dbGISAL dbname=gisa'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente_ext()') 
t1(id integer, ruolo text)
) ge on r.id_ruolo_gisa_ext = ge.id 
left join (
select * 
   FROM dblink('host=dbDIGEMONL dbname=digemon_u'::text, 'SELECT 
			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
t1(id integer, ruolo text)
) dg on r.id_ruolo_digemon = dg.id 
--left join (
--select * 
--   FROM dblink('host=dbGESDASICL dbname=gesdasic'::text, 'SELECT 
--			id_ruolo, descrizione_ruolo from dbi_get_ruoli_utente()') 
--t1(id integer, ruolo text)
--) ges on r.id_ruolo_sicurezza_lavoro = ges.id 
where 1=1 
and (_numero_richiesta is null or r.numero_richiesta = _numero_richiesta)
order by r.data_richiesta desc, r.numero_richiesta;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION spid.get_lista_richieste(text)
  OWNER TO postgres;
 * 
 * 
 * 
 */