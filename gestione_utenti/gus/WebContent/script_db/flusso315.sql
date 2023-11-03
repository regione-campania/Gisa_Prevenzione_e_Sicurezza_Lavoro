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
