-- Function: public.dbi_insert_utente_guc(text, text, text, boolean, integer, timestamp without time zone, integer, text, text, text, text, integer, text, integer, text, text, text, integer, integer, text, text, integer, text, integer, text, text, text, text, text, text, text, integer, text, text, integer, text, integer, text, integer, text, integer, text, integer, text, integer, text, text, integer, text, integer, integer, text, text, integer, text, text, integer, text, text, integer, text)

-- DROP FUNCTION public.dbi_insert_utente_guc(text, text, text, boolean, integer, timestamp without time zone, integer, text, text, text, text, integer, text, integer, text, text, text, integer, integer, text, text, integer, text, integer, text, text, text, text, text, text, text, integer, text, text, integer, text, integer, text, integer, text, integer, text, integer, text, integer, text, text, integer, text, integer, integer, text, text, integer, text, text, integer, text, text, integer, text);

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
conta_guc int;

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

-------------------------------------- verifica guc ----------------------------------------------------------------
conta_guc := (select count(*) from spid.get_lista_ruoli_utente_guc(input_cf, 'Digemon', '') where id_ruolo = input_ruolo_id_digemon);
    
if conta_guc <= 0 then 
	
	INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_importatori.end_point,ruolo_importatori.id_ruolo,ruolo_importatori.descrizione_ruolo,us_id,input_note);

	ruolo_digemon.id_ruolo:= input_ruolo_id_digemon;
	ruolo_digemon.descrizione_ruolo:= input_ruolo_descrizione_digemon;
	ruolo_digemon.end_point:= 'Digemon';
end if;

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_digemon.end_point,ruolo_digemon.id_ruolo,ruolo_digemon.descrizione_ruolo,us_id,input_note);

ruolo_sicurezza_lavoro.id_ruolo:= input_ruolo_id_sicurezza_lavoro;
ruolo_sicurezza_lavoro.descrizione_ruolo:= input_ruolo_descrizione_sicurezza_lavoro;
ruolo_sicurezza_lavoro.end_point:= 'SicurezzaLavoro';

INSERT INTO guc_ruoli (endpoint,ruolo_integer,ruolo_string,id_utente,note) VALUES (ruolo_sicurezza_lavoro.end_point,ruolo_sicurezza_lavoro.id_ruolo,ruolo_sicurezza_lavoro.descrizione_ruolo,us_id,input_note);

RETURN concat(msg,';;',us_id,';;','spid_usr_',us_id,';;',input_password_decrypted);
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_insert_utente_guc(text, text, text, boolean, integer, timestamp without time zone, integer, text, text, text, text, integer, text, integer, text, text, text, integer, integer, text, text, integer, text, integer, text, text, text, text, text, text, text, integer, text, text, integer, text, integer, text, integer, text, integer, text, integer, text, integer, text, text, integer, text, integer, integer, text, text, integer, text, text, integer, text, text, integer, text)
  OWNER TO postgres;
