

-- CHI: Bartolo Sansone
--  COSA: Nuova configurazione end point connector
--  QUANDO: 11/04/2016

-- db: guc


CREATE TABLE guc_endpoint
(
  id serial NOT NULL,
  nome text NOT NULL,
  ds_master text,
  ds_slave text,
  enabled boolean default true,
 CONSTRAINT guc_endpoint_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE guc_endpoint
  OWNER TO postgres;
  
  
  CREATE TABLE guc_operazioni
(
  id serial NOT NULL,
  nome text NOT NULL,
  enabled boolean default true,
 CONSTRAINT guc_operazioni_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE guc_operazioni
  OWNER TO postgres;
  
  CREATE TABLE guc_endpoint_connector_config
(
  id serial NOT NULL,
  id_operazione integer NOT NULL,
  id_endpoint integer NOT NULL,
  sql text,
  firma_sql text,
  url_reload_utenti text,
  firma_url_reload_utenti text,
  enabled boolean default true,
  CONSTRAINT guc_endpoint_connector_config_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE guc_endpoint_connector_config
  OWNER TO postgres;
  
  
insert into guc_endpoint(nome, ds_master, ds_slave) values ('bdu', 'jdbc/bduM', 'jdbc/bduS');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Gisa', 'jdbc/gisaM', 'jdbc/gisaS');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Gisa_ext', 'jdbc/gisa_extM', 'jdbc/gisa_extS');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Vam', 'jdbc/vamM', 'jdbc/vamS');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Importatori', 'jdbc/importatori', 'jdbc/importatori');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Guc', 'jdbc/guc', 'jdbc/guc');
insert into guc_endpoint(nome, ds_master, ds_slave) values ('Digemon', 'jdbc/digemon', 'jdbc/digemon');
update guc_endpoint set enabled = false where id = 7;

 -- Popolo tabella guc_operazioni
 insert into guc_operazioni(nome) values ('GetRuoliUtente');
insert into guc_operazioni(nome) values ('InsertUtente');
insert into guc_operazioni(nome) values ('ModifyProfiloUtente');
insert into guc_operazioni(nome) values ('RollBackProfiloUtente');
insert into guc_operazioni(nome) values ('ModifyAnagraficaUtente');
insert into guc_operazioni(nome) values ('DisableUtente');
insert into guc_operazioni(nome) values ('EnableUtente');
insert into guc_operazioni(nome) values ('CheckEnableUtente');
insert into guc_operazioni(nome) values ('CheckEsistenzaUtente');
insert into guc_operazioni(nome) values ('CheckEsistenzaUtenteByStruttura');
insert into guc_operazioni(nome) values ('GetCaniliUtenteBdu');
insert into guc_operazioni(nome) values ('GetListaProvince');
insert into guc_operazioni(nome) values ('VerificaUtenteModificabile'); 
insert into guc_operazioni(nome) values ('AccreditaSuap'); 
insert into guc_operazioni(nome) values ('ModifyUtente'); 
insert into guc_operazioni(nome) values ('GetImportatoriUtente'); 
insert into guc_operazioni(nome) values ('GetClinicheUtente'); 
insert into guc_operazioni(id, nome) values (18, 'VerificaPasswordPrecedente'); 
insert into guc_operazioni(id, nome) values (19, 'CambioPassword'); 

 insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_get_ruoli_utente();','',1,1);

insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvBDUW/bdu/ReloadUtenti?username=',2,1);

insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values (' select * from  dbi_cambia_profilo_utente ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);','http://srvBDUW/bdu/ReloadUtenti?username=',3,1);

insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);
','http://srvBDUW/bdu/ReloadUtenti?username=',4,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);
','http://srvBDUW/bdu/ReloadUtenti?username=',5,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);
','',6,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);
','http://srvBDUW/bdu/ReloadUtenti?username=',7,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);
','',8,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);
','',9,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);
','',10,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from get_lista_canili();

select * from get_lista_canili();

select * from get_lista_canili();

select * from get_lista_canili();
','',11,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_lista_province();

select * from dbi_get_lista_province();

select * from dbi_get_lista_province();

select * from dbi_get_lista_province();
','',12,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_verifica_utente_modificabile(?);

select * from dbi_verifica_utente_modificabile(?);

select * from dbi_verifica_utente_modificabile(?);

select * from dbi_verifica_utente_modificabile(?);
','',13,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_ruoli_utente();

select * from dbi_get_ruoli_utente();

select * from dbi_get_ruoli_utente();

select * from dbi_get_ruoli_utente();
','',1,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_nt/ReloadUtenti?username=',2,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_cambia_profilo_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_cambia_profilo_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_cambia_profilo_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_nt/ReloadUtenti?username=',3,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);
','http://srvGISAW/gisa_nt/ReloadUtenti?username=',4,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_nt/ReloadUtenti?username=',5,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);
','',6,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);
','http://srvGISAW/gisa_nt/ReloadUtenti?username=',7,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);
','',8,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);
','',9,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);
','',10,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_ruoli_utente_ext();

select * from dbi_get_ruoli_utente_ext();

select * from dbi_get_ruoli_utente_ext();
','',1,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_insert_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',2,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_accreditamento_utente_suap(?,?,?,?,?,?,?,?);


select * from dbi_accreditamento_utente_suap(?,?,?,?,?,?,?,?);


select * from dbi_accreditamento_utente_suap(?,?,?,?,?,?,?,?);

','http://srvGISAW/gisa_ext/ReloadUtenti?username=',14,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_cambia_profilo_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_cambia_profilo_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_cambia_profilo_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',3,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_rollback_profilo_utente_ext( ?,?);

select * from dbi_rollback_profilo_utente_ext( ?,?);

select * from dbi_rollback_profilo_utente_ext( ?,?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',4,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_anagrafica_utente_ext(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente_ext(?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_anagrafica_utente_ext(?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',5,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_utente_ext(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',15,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente_ext(?);

select * from dbi_check_esistenza_utente_ext(?);

select * from dbi_check_esistenza_utente_ext(?);
','',9,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_last_login_ext(?,?::timestamp);

select * from dbi_check_last_login_ext(?,?::timestamp);
','',8,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_disable_utente_ext(?);

select * from dbi_disable_utente_ext(?);
','',6,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_enable_utente_ext(?);

select * from dbi_enable_utente_ext(?);
','http://srvGISAW/gisa_ext/ReloadUtenti?username=',7,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_verifica_utente_modificabile_ext(?);

select * from dbi_verifica_utente_modificabile_ext(?);
','',13,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_ruoli_utente();

select * from dbi_get_ruoli_utente();
','',1,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',2,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

select * from dbi_update_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',15,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_disable_utente(?);

select * from dbi_disable_utente(?);
','',6,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_enable_utente(?);

select * from dbi_enable_utente(?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',7,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_last_login(?,?::timestamp);

select * from dbi_check_last_login(?,?::timestamp);
','',8,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente(?);

select * from dbi_check_esistenza_utente(?);
','',9,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente_by_struttura(?,?);

select * from dbi_check_esistenza_utente_by_struttura(?,?);
','',10,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from get_lista_importatori();

select * from get_lista_importatori();
','',16,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_verifica_utente_modificabile(?);

select * from dbi_verifica_utente_modificabile(?);
','',13,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_cambia_profilo_utente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

select * from dbi_cambia_profilo_utente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',3,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_rollback_profilo_utente( ?,?);

select * from dbi_rollback_profilo_utente( ?,?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',4,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);
','http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=',5,5);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_ruoli_utente();
','',1,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_get_cliniche_utente();
','',17,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=',2,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseEditUtente.us?username=',15,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_disable_utente(?);
','',6,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_enable_utente(?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=',7,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_last_login(?,?::timestamp);
','',8,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente(?);
','',9,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_check_esistenza_utente_by_struttura(?,?);
','',10,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_verifica_utente_modificabile(?);
','',13,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_cambia_profilo_utente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=',3,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_rollback_profilo_utente(?, ?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=',4,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('
select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);
','http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=',5,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_insert_utente_guc(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);','',2,6);



  insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_get_ruoli_utente();','',1,7);
     insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_insert_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);','http://srvDIGEMONW/DiGeMon/ReloadUtenti?username=',2,7);
        insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambia_profilo_utente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);','http://srvDIGEMONW/DiGeMon/ReloadUtenti?username=',3,7);
       insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_check_esistenza_utente(?)','',9,7);
          insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_enable_utente(?);','http://srvDIGEMONW/DiGeMon/ReloadUtenti?username=',7,7);
            insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_check_last_login(?,?::timestamp);','',8,7);
            insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_verifica_utente_modificabile(?);','',13,7);
	

insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_verifica_password_precedente(?, ?);','',18,6);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password(?, ?);','',19,1);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password(?, ?);','',19,2);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password_ext(?, ?);','',19,3);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password(?, ?);','',19,4);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password(?, ?);','',19,7);
insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_check_esistenza_utente(?);','',9,6);
	
	  insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_cambio_password(?, ?, ?, ?);','',19,6);


update guc_endpoint_connector_config set sql = sql || ';';

update guc_endpoint_connector_config set sql = trim(
regexp_replace(
substring(sql, 0, position (';' in sql)+1),
 E'[\\n\\r]+', ' ', 'g' )
)



 --Nuove dbi
  -- Database: guc

CREATE OR REPLACE FUNCTION public.dbi_verifica_password_precedente(
    input_username text,
    input_password text)
  RETURNS boolean AS
$BODY$
   DECLARE
esito boolean;
us_id integer;

BEGIN

us_id := (select id from guc_utenti where username ilike input_username and password = md5(input_password));

if (us_id>0) THEN

esito:=true;

ELSE

esito:=false;

	END IF;
	
	RETURN esito;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_verifica_password_precedente(text, text)
  OWNER TO postgres;

    
  CREATE OR REPLACE FUNCTION public.dbi_cambio_password(
    input_username text,
    input_password text,
    input_password_old text,
    input_ip text)
  RETURNS text AS
$BODY$
   DECLARE
us_id integer;
md5_password text;
msg text;

BEGIN

md5_password = md5(input_password);

us_id := (select id from guc_utenti where username = input_username);

if (us_id>0) THEN

update guc_utenti set password = md5_password where id = us_id;
insert into storico_cambio_password (id_utente, ip_modifica, data_modifica, vecchia_password, nuova_password) values (us_id, input_ip, now(), input_password_old, md5_password);
msg = 'OK';

ELSE
msg ='KO';

	END IF;
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_cambio_password(text, text, text, text)
  OWNER TO postgres;
  
  
  
  -- Database: gisa, bdu, digemon
   
  CREATE OR REPLACE FUNCTION public.dbi_cambio_password(
    input_username text,
    input_password text)
  RETURNS text AS
$BODY$
   DECLARE
us_id integer;
md5_password text;
msg text;

BEGIN

md5_password = md5(input_password);

us_id := (select user_id from access where username = input_username);

if (us_id>0) THEN

update access_ set password = md5_password where user_id = us_id;
msg = 'OK';

ELSE
msg ='KO';

	END IF;
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_cambio_password(text, text)
  OWNER TO postgres;
  
  -- Da lanciare su gisa
  
  CREATE OR REPLACE FUNCTION public.dbi_cambio_password_ext(
    input_username text,
    input_password text)
  RETURNS text AS
$BODY$
   DECLARE
us_id integer;
md5_password text;
msg text;

BEGIN

md5_password = md5(input_password);

us_id := (select user_id from access_ext where username = input_username);

if (us_id>0) THEN

update access_ext_ set password = md5_password where user_id = us_id;
msg = 'OK';

ELSE
msg ='KO';

	END IF;
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_cambio_password_ext(text, text)
  OWNER TO postgres;
  
  -- Database: vam
  
  
  CREATE OR REPLACE FUNCTION public.dbi_cambio_password(
    input_username text,
    input_password text)
  RETURNS text AS
$BODY$
   DECLARE
us_id integer;
md5_password text;
msg text;

BEGIN

md5_password = md5(input_password);

us_id := (select id from utenti_super where username = input_username);

if (us_id>0) THEN

update utenti_super set password = md5_password where id = us_id;
msg = 'OK';

ELSE
msg ='KO';

	END IF;
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_cambio_password(text, text)
  OWNER TO postgres;
  
  
  -- tabella storico
    -- Database: guc

  
CREATE TABLE storico_cambio_password
(
  id serial,
 id_utente integer,
  ip_modifica text,
  data_modifica timestamp without time zone default now(),
  vecchia_password text,
  nuova_password text,
  CONSTRAINT storico_cambio_password_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE storico_cambio_password
  OWNER TO postgres;
  
  -- Regola su guc_utenti
  
            CREATE OR REPLACE RULE guc_utenti_update AS
    ON UPDATE TO guc_utenti DO INSTEAD  UPDATE guc_utenti_ SET password = new.password
  WHERE guc_utenti_.id = new.id;
  
  
  -- Dbi esistenza utente GUC
  
  CREATE OR REPLACE FUNCTION public.dbi_check_esistenza_utente(usr character varying)
  RETURNS boolean AS
$BODY$
   DECLARE
esito boolean ;
tot int;   
BEGIN
	tot := (select count(*) from guc_utenti a where a.username = usr and enabled);

	IF (tot=0) THEN
		esito:=false;
	ELSE 	
		esito:=true;
	END IF;
	RETURN esito;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_check_esistenza_utente(character varying)
  OWNER TO postgres;

  
--- INIZIO NUOVA DBI INSERIMENTO

-- Creazione tipo Ruolo

-- Type: guc_ruolo
-- DROP TYPE guc_ruolo;

CREATE TYPE guc_ruolo AS
   (id_ruolo integer,
    descrizione_ruolo text,
    end_point text);
ALTER TYPE guc_ruolo
  OWNER TO postgres;
  
-- Dbi inserimento in guc
  
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
   input_suap_istat_comune text ,
   input_suap_pec text ,
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
  input_ruolo_descrizione_importatori text
   )
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
us_id int ;
ruolo_gisa guc_ruolo;
ruolo_gisa_ext guc_ruolo;
ruolo_bdu guc_ruolo;
ruolo_vam guc_ruolo;
ruolo_importatori guc_ruolo;

BEGIN



--Inserisco utente
us_id:= (select nextval('guc_utenti_id_seq'));
INSERT INTO guc_utenti_ (ID,CODICE_FISCALE,COGNOME,EMAIL,ENABLED,entered,enteredby,expires,modified,modifiedby,note,nome,password,username,asl_id,password_encrypted,canile_id, canile_description,luogo,num_autorizzazione,id_importatore,canilebdu_id, canilebdu_description,importatori_description,id_provincia_iscrizione_albo_vet_privato,nr_iscrione_albo_vet_privato,id_utente_guc_old,suap_ip_address ,suap_istat_comune ,suap_pec ,suap_callback ,suap_shared_key,suap_callback_ko,num_registrazione_stab,suap_livello_accreditamento,suap_descrizione_livello_accreditamento,telefono  ) 
values (us_id,input_cf,input_cognome,input_email,input_enabled,now(),input_enteredby,input_expires,now(),input_modifiedby,input_note, input_nome,input_password,input_username,input_asl_id,input_password_encrypted,input_canile_id, input_canile_description,input_luogo,input_num_autorizzazione,input_id_importatore,input_canilebdu_id, input_canilebdu_description,input_importatori_description,input_id_provincia_iscrizione_albo_vet_privato,input_nr_iscrione_albo_vet_privato,input_id_utente_guc_old,input_suap_ip_address ,input_suap_istat_comune ,input_suap_pec ,input_suap_callback ,input_suap_shared_key,input_suap_callback_ko,input_num_registrazione_stab,input_suap_livello_accreditamento,input_suap_descrizione_livello_accreditamento,input_telefono  );

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

	
	
	RETURN msg||'_'||us_id;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  --- FINE NUOVA DBI INSERIMENTO

  -- modifica codice fiscale


CREATE OR REPLACE FUNCTION public.dbi_update_cf_utente(
    input_username character varying,
    input_cf character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
con_id int;
   
BEGIN

	msg := '';
	con_id := (select contact_id from access where username = input_username);

	IF (con_id > 0) THEN
	UPDATE contact_ set codice_fiscale = input_cf where contact_id = con_id;
	msg = 'OK';
	ELSE
	msg = 'KO';
	END IF;

	RETURN msg;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_update_cf_utente(character varying, character varying)
  OWNER TO postgres;

  
  -- GISA
  
  

CREATE OR REPLACE FUNCTION public.dbi_update_cf_utente_ext(
    input_username character varying,
    input_cf character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
con_id int;
   
BEGIN

	msg := '';
	con_id := (select contact_id from access_ext where username = input_username);

	IF (con_id > 0) THEN
	UPDATE contact_ext_ set codice_fiscale = input_cf where contact_id = con_id;
	msg = 'OK';
	ELSE
	msg = 'KO';
	END IF;

	RETURN msg;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_update_cf_utente_ext(character varying, character varying)
  OWNER TO postgres;
  
  
  -- VAM
  
  
CREATE OR REPLACE FUNCTION public.dbi_update_cf_utente(
    input_username character varying,
    input_cf character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
con_id int;
   
BEGIN

	msg := '';
	con_id := (select id from utenti_super where username = input_username);

	IF (con_id > 0) THEN
	UPDATE utenti_ set codice_fiscale = input_cf where superutente = con_id;
	msg = 'OK';
	ELSE
	msg = 'KO';
	END IF;

	RETURN msg;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_update_cf_utente(character varying, character varying)
  OWNER TO postgres;
  
  
  -- GUC
  
  

CREATE OR REPLACE FUNCTION public.dbi_update_cf_utente_guc(
    input_username text,
    input_cf text)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
us_id integer;

BEGIN

--Controllo se l'username esiste gi�
us_id := (select id from guc_utenti_ where username = input_username);

if (us_id>0) THEN
UPDATE guc_utenti_ set codice_fiscale = input_cf where id = us_id;
msg:='OK';
ELSE
msg:= 'Errore. Username non esistente.';
END IF;
	
RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_update_cf_utente_guc(text, text)
  OWNER TO postgres;
  
  
  insert into guc_operazioni(id, nome, enabled) values (20, 'ModificaCodiceFiscale', true);

  insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 1, 'select * from dbi_update_cf_utente(?, ?)', 'http://srvBDUW/bdu/ReloadUtenti?username=', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 2, 'select * from dbi_update_cf_utente(?, ?)', 'http://srvGISAW/gisa_nt/ReloadUtenti?username=', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 3, 'select * from dbi_update_cf_utente_ext(?, ?)', 'http://srvGISAW/gisa_ext/ReloadUtenti?username=', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 5, 'select * from dbi_update_cf_utente(?, ?)', 'http://srvIMPORTATORIW/bdu_ext/ReloadUtenti?username=', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 4, 'select * from dbi_update_cf_utente(?, ?)', 'http://srvVAMW/vam/ws.AggiornamentoFunzioniConcesseAddUtente.us?username=', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 6, 'select * from dbi_update_cf_utente_guc(?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (20, 7, 'select * from dbi_update_cf_utente(?, ?)', 'http://srvDIGEMONW/DiGeMon/ReloadUtenti?username=', true);

  

-- GISA


CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_access boolean,
    input_dpat boolean,
    input_nucleo boolean,
    input_qualifica boolean,
    input_view_lista boolean)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer ;
   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type, note, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 6567, now(), 6567, true, 0, 'Inserito tramite GUC', 1, 'RUOLO GISA', input_access, input_dpat, input_nucleo, input_qualifica, input_view_lista);

--Permessi di guest (49)
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = 49)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  -- EXT
  
  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo_ext(
    input_ruolo character varying,
    input_descrizione character varying,
    input_access boolean,
    input_dpat boolean,
    input_nucleo boolean,
    input_qualifica boolean,
    input_view_lista boolean)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer ;
   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role_ext where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role_ext);

INSERT INTO role_ext (role_id,  role, description, entered, enteredby, modified, modifiedby, enabled, role_type, note, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 10000631, now(), 10000631, true, 0, 'Inserito tramite GUC', 2, 'GRUPPO_ALTRE_AUTORITA', input_access, input_dpat, input_nucleo, input_qualifica, input_view_lista);

--Permessi di NAS (1020)
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission_ext, newrole where role_id = 1020)
insert into role_permission_ext(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  -- bdu
  
  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 13622, now(), 13622, true, 0);

--Permessi di cliente (10)
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = 10)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
  -- importatori
  
  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(),964, now(),  964,  true, 0);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- digemon

  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 3214, now(), 3214, true, 0);

		--Permessi di statistiche (99)
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = 99)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- VAM
  
  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select id from permessi_ruoli where nome ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

INSERT INTO permessi_ruoli ( nome, descrizione)	VALUES ( input_ruolo, input_descrizione);
INSERT INTO category ( name)	VALUES ( input_ruolo);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  -- GUC
  
  
  insert into guc_operazioni(id, nome, enabled) values (21, 'InsertRuolo', true);

  insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 1, 'select * from dbi_insert_ruolo(?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 2, 'select * from dbi_insert_ruolo(?, ?, ?, ?, ?, ?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 3, 'select * from dbi_insert_ruolo_ext(?, ?, ?, ?, ?, ?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 5, 'select * from dbi_insert_ruolo(?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 4, 'select * from dbi_insert_ruolo(?, ?)', '', true);
insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti, enabled) values (21, 7, 'select * from dbi_insert_ruolo(?, ?)', '', true);



--- endpoitn digemon

--digemon

CREATE OR REPLACE RULE access_insert AS
    ON INSERT TO access DO INSTEAD  INSERT INTO access_ (user_id, username, password, contact_id, site_id, role_id, enteredby, modifiedby, timezone, currency, language, enabled, expires)
  VALUES (new.user_id, new.username, new.password, new.contact_id, new.site_id, new.role_id, new.enteredby, new.modifiedby, new.timezone, new.currency, new.language, new.enabled, new.expires);
  
--guc

  
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
    input_ruolo_descrizione_digemon text)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
us_id int ;
ruolo_gisa guc_ruolo;
ruolo_gisa_ext guc_ruolo;
ruolo_bdu guc_ruolo;
ruolo_vam guc_ruolo;
ruolo_importatori guc_ruolo;
ruolo_digemon guc_ruolo;

BEGIN


--Inserisco utente
us_id:= (select nextval('guc_utenti_id_seq'));
INSERT INTO guc_utenti_ (ID,CODICE_FISCALE,COGNOME,EMAIL,ENABLED,entered,enteredby,expires,modified,modifiedby,note,nome,password,username,asl_id,password_encrypted,canile_id, canile_description,luogo,num_autorizzazione,id_importatore,canilebdu_id, canilebdu_description,importatori_description,id_provincia_iscrizione_albo_vet_privato,nr_iscrione_albo_vet_privato,id_utente_guc_old,suap_ip_address ,suap_istat_comune ,suap_pec ,suap_callback ,suap_shared_key,suap_callback_ko,num_registrazione_stab,suap_livello_accreditamento,suap_descrizione_livello_accreditamento,telefono  ) 
values (us_id,input_cf,input_cognome,input_email,input_enabled,now(),input_enteredby,input_expires,now(),input_modifiedby,input_note, input_nome,input_password,input_username,input_asl_id,input_password_encrypted,input_canile_id, input_canile_description,input_luogo,input_num_autorizzazione,input_id_importatore,input_canilebdu_id, input_canilebdu_description,input_importatori_description,input_id_provincia_iscrizione_albo_vet_privato,input_nr_iscrione_albo_vet_privato,input_id_utente_guc_old,input_suap_ip_address ,input_suap_istat_comune ,input_suap_pec ,input_suap_callback ,input_suap_shared_key,input_suap_callback_ko,input_num_registrazione_stab,input_suap_livello_accreditamento,input_suap_descrizione_livello_accreditamento,input_telefono  );

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

	
	
	RETURN msg||'_'||us_id;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_insert_utente_guc(text, text, text, boolean, integer, timestamp without time zone, integer, text, text, text, text, integer, text, integer, text, text, text, integer, integer, text, text, integer, text, integer, text, text, text, text, text, text, text, integer, text, text, integer, text, integer, text, integer, text, integer, text, integer, text, integer, text)
  OWNER TO postgres;

  
  DROP FUNCTION public.dbi_insert_utente_guc(text, text, text, boolean, integer, timestamp without time zone, integer, text, text, text, text, integer, text, integer, text, text, text, integer, integer, text, text, integer, text, integer, text, text, text, text, text, text, text, integer, text, text, integer, text, integer, text, integer, text, integer, text, integer, text);
  
  update guc_endpoint_connector_config set sql = 'select * from dbi_insert_utente_guc(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);' where id = 62

  
  insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti) values (5,7, 'select * from dbi_update_anagrafica_utente(?,?,?,?,?,?,?,?,?,?);', 'http://srvDIGEMONW/DiGeMon/ReloadUtenti?username=');
  
  insert into guc_endpoint_connector_config (id_operazione, id_endpoint, sql, url_reload_utenti) values (4,7, 'select * from dbi_rollback_profilo_utente(?,?);', 'http://srvDIGEMONW/DiGeMon/ReloadUtenti?username='); 
  
  
  
CREATE OR REPLACE FUNCTION public.dbi_verifica_ultima_modifica_password(
    input_username text)
  RETURNS timestamp without time zone AS
$BODY$
   DECLARE
us_id integer;
data_modifica_password timestamp without time zone;


BEGIN

data_modifica_password := (select max(s.data_modifica) from storico_cambio_password s join guc_utenti_ u on u.id = s.id_utente where u.username = input_username);

if (data_modifica_password is null) THEN
data_modifica_password := (select max(entered) from guc_utenti_ where username = input_username);
END IF;
	
	RETURN data_modifica_password;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_verifica_ultima_modifica_password(text)
  OWNER TO postgres;


  -- Function: public.dbi_verifica_cambio_password_recente(text)

-- DROP FUNCTION public.dbi_verifica_cambio_password_recente(text);

CREATE OR REPLACE FUNCTION public.dbi_verifica_cambio_password_recente(
    input_username text)
  RETURNS boolean AS
$BODY$
   DECLARE
esito boolean;
us_id integer;
data timestamp without time zone;
diff_secondi double precision;
BEGIN

esito:=false;

us_id := (select id from guc_utenti where username ilike input_username);

if (us_id>0) THEN

data := (select max(data_modifica) from storico_cambio_password where id_utente = us_id);

IF data is not null THEN
	diff_secondi := (SELECT EXTRACT(EPOCH FROM (now() - data)));
	IF (diff_secondi < 240) THEN
	esito:= true;
	END IF;
	END IF;

END IF;
	
	RETURN esito;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_verifica_cambio_password_recente(text)
  OWNER TO postgres;

  
  insert into guc_operazioni (id, nome, enabled) values (22, 'VerificaCambioPasswordRecente', true);

insert into guc_endpoint_connector_config (  sql, url_reload_utenti, id_operazione, id_endpoint) values ('select * from dbi_verifica_cambio_password_recente(?);','',22,6);


-- Salvataggio nuova password criptata

select * from get_storico_cambio_password()

alter table storico_cambio_password add column nuova_password_decript text;

select * from guc_endpoint_connector_config where id_operazione = 19 and id_endpoint = 6

update guc_endpoint_connector_config set sql = 'select * from dbi_cambio_password(?, ?, ?, ?, ?);' where id = 77

-- Function: dbi_cambio_password(text, text, text, text)

-- DROP FUNCTION dbi_cambio_password(text, text, text, text);

CREATE OR REPLACE FUNCTION dbi_cambio_password(
    input_username text,
    input_password text,
    input_password_old text,
    input_ip text,
    input_password_decript text)
  RETURNS text AS
$BODY$
   DECLARE
us_id integer;
md5_password text;
msg text;

BEGIN

md5_password = md5(input_password);

us_id := (select id from guc_utenti where username = input_username);

if (us_id>0) THEN

update guc_utenti set password = md5_password where id = us_id;
insert into storico_cambio_password (id_utente, ip_modifica, data_modifica, vecchia_password, nuova_password, nuova_password_decript) values (us_id, input_ip, now(), input_password_old, md5_password, input_password_decript);
msg = 'OK';

ELSE
msg ='KO';

	END IF;
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbi_cambio_password(text, text, text, text, text)
  OWNER TO postgres;



-- Function: get_storico_cambio_password()

-- DROP FUNCTION get_storico_cambio_password();

CREATE OR REPLACE FUNCTION get_storico_cambio_password()
  RETURNS TABLE(username text, data_modifica timestamp without time zone, vecchia_password text, nuova_password text, nuova_password_decript text, ip_modifica text) AS
$BODY$
DECLARE
r RECORD;	
BEGIN
FOR username, data_modifica, vecchia_password, nuova_password, nuova_password_decript, ip_modifica
in
select u.username, s.data_modifica, s.vecchia_password, s.nuova_password, s.nuova_password_decript, s.ip_modifica  from storico_cambio_password s
left join guc_utenti_ u on u.id = s.id_utente
order by s.data_modifica desc

    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100
  ROWS 1000;
ALTER FUNCTION get_storico_cambio_password()
  OWNER TO postgres;

-- CHI: Bartolo Sansone
--  COSA: Modifiche inserimento ruolo da copiare
--  QUANDO: 26/10/2016
  
-- GISA

DROP FUNCTION public.dbi_insert_ruolo(character varying, character varying, boolean, boolean, boolean, boolean, boolean);
DROP FUNCTION public.dbi_insert_ruolo_ext(character varying, character varying, boolean, boolean, boolean, boolean, boolean);


CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer,
    input_access boolean,
    input_dpat boolean,
    input_nucleo boolean,
    input_qualifica boolean,
    input_view_lista boolean)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer ;
r_id_da_copiare integer;   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type, note, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 6567, now(), 6567, true, 0, 'Inserito tramite GUC', 1, 'RUOLO GISA', input_access, input_dpat, input_nucleo, input_qualifica, input_view_lista);

--Permessi

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 49;
END IF;
		
 PERFORM setval('role_permission_id_seq', (select MAX(id)+1 from role_permission));     

with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = r_id_da_copiare)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  -- EXT
  
  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo_ext(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer,
    input_access boolean,
    input_dpat boolean,
    input_nucleo boolean,
    input_qualifica boolean,
    input_view_lista boolean)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer ;
r_id_da_copiare integer;   
  
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role_ext where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role_ext);

INSERT INTO role_ext (role_id,  role, description, entered, enteredby, modified, modifiedby, enabled, role_type, note, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 10000631, now(), 10000631, true, 0, 'Inserito tramite GUC', 2, 'GRUPPO_ALTRE_AUTORITA', input_access, input_dpat, input_nucleo, input_qualifica, input_view_lista);

--Permessi 

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 1020;
END IF;
		
 PERFORM setval('role_permission_ext_id_seq', (select MAX(id)+1 from role_permission_ext));     

 
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission_ext, newrole where role_id = r_id_da_copiare)
insert into role_permission_ext(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  -- bdu
  
 DROP FUNCTION public.dbi_insert_ruolo(character varying, character varying);
 
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer
)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;  
r_id_da_copiare integer;   

BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 13622, now(), 13622, true, 0);

--Permessi 

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 10;
END IF;

 PERFORM setval('role_permission_id_seq', (select MAX(id)+1 from role_permission));     

 with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = r_id_da_copiare)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
   -- importatori
  
  DROP FUNCTION public.dbi_insert_ruolo(character varying, character varying);

CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer
)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;
r_id_da_copiare integer;   
   
BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(),964, now(),  964,  true, 0);

--Permessi 

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 7;
END IF;

 PERFORM setval('role_permission_id_seq', (select MAX(id)+1 from role_permission));     
 
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = r_id_da_copiare)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- digemon
DROP FUNCTION public.dbi_insert_ruolo(character varying, character varying);

  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer
)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer; 
r_id_da_copiare integer;   

BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select role_id from role where role ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE

r_id = (select max(role_id)+1 from role);

INSERT INTO role ( role_id, role, description, entered, enteredby, modified, modifiedby, enabled, role_type)
		VALUES ( r_id, input_ruolo, input_descrizione, now(), 3214, now(), 3214, true, 0);

--Permessi 

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 99;
END IF;

 PERFORM setval('role_permission_id_seq', (select MAX(id)+1 from role_permission));     
 
with newrole as(select r_id as t_role_id),t as(select *, newrole.t_role_id as role_id_inserito from role_permission, newrole where role_id = r_id_da_copiare)
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) (
select role_id_inserito, permission_id, role_view, role_add, role_edit, role_delete from t);

msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  -- VAM
  DROP FUNCTION public.dbi_insert_ruolo(character varying, character varying);

  
CREATE OR REPLACE FUNCTION dbi_insert_ruolo(
    input_ruolo character varying,
    input_descrizione character varying,
    input_ruolo_da_copiare integer)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
r_id integer;  
r_id_da_copiare integer; 
r_id_da_copiare_nome text;  
p_abilitati_id integer;

BEGIN
	
input_ruolo:= trim(input_ruolo);
input_descrizione:= trim(input_descrizione);

r_id = (select id from permessi_ruoli where nome ilike input_ruolo);

IF r_id > 0 THEN

msg = 'ERRORE RUOLO ESISTENTE';

ELSE
r_id:= (select max(id)+1 from permessi_ruoli);
p_abilitati_id :=  (select max(id)+1 from permessi_ruoli_abilitati);
INSERT INTO permessi_ruoli (id, nome, descrizione)	VALUES (r_id, input_ruolo, input_descrizione);
INSERT INTO category ( name)	VALUES ( input_ruolo);
INSERT INTO permessi_ruoli_abilitati(id,  id_ruolo, enabled)	VALUES ( p_abilitati_id, r_id, true);

--Permessi

IF (input_ruolo_da_copiare>0) THEN
r_id_da_copiare = input_ruolo_da_copiare;
ELSE
r_id_da_copiare = 10;
END IF;

r_id_da_copiare_nome:= (select nome from permessi_ruoli where id = r_id_da_copiare);


insert into capability (category_name, subject_name) 
select input_ruolo, subject_name from capability where category_name = r_id_da_copiare_nome;


insert into capability_permission (capabilities_id, permissions_name) 
select id, 'w' from capability where category_name = input_ruolo;


msg = 'OK';

END IF;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  -- GUC
  
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo(?, ?, ?)' where id_operazione = 21 and id_endpoint = 1;
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo(?, ?, ?, ?, ?, ?, ?, ?)' where id_operazione = 21 and id_endpoint = 2;
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo_ext(?, ?, ?, ?, ?, ?, ?, ?)' where id_operazione = 21 and id_endpoint = 3;
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo(?, ?, ?)' where id_operazione = 21 and id_endpoint = 4;
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo(?, ?, ?)' where id_operazione = 21 and id_endpoint = 5;
  update guc_endpoint_connector_config set sql =  'select * from dbi_insert_ruolo(?, ?, ?)' where id_operazione = 21 and id_endpoint = 7;
  
  
  
  -- vam
  
  ALTER TABLE ONLY capability ALTER COLUMN id  SET DEFAULT nextval('capability_id_seq'::regclass);
  
  -- 23/08/2022 ---> gestione utente esito operazione RITA MELE
  
CREATE OR REPLACE FUNCTION spid.get_lista_richieste(IN _numero_richiesta text DEFAULT NULL::text)
  RETURNS TABLE(id integer, id_tipologia_utente integer, tipologia_utente text, id_tipo_richiesta integer, tipo_richiesta text, cognome text, nome text, codice_fiscale text, email text, telefono text, id_ruolo_gisa integer, ruolo_gisa text, id_ruolo_bdu integer, ruolo_bdu text, id_ruolo_vam integer, ruolo_vam text, id_ruolo_gisa_ext integer, ruolo_gisa_ext text, id_ruolo_digemon integer, ruolo_digemon text, id_clinica_vam integer[], clinica_vam text[], identificativo_ente text, piva_numregistrazione text, comune text, istat_comune text, nominativo_referente text, ruolo_referente text, email_referente text, telefono_referente text, data_richiesta timestamp without time zone, codice_gisa text, indirizzo text, id_gestore_acque integer, gestore_acque text, cap text, pec text, numero_richiesta text, esito_guc boolean, esito_gisa boolean, esito_gisa_ext boolean, esito_bdu boolean, esito_vam boolean, esito_digemon boolean, data_esito timestamp without time zone, stato integer, utente_esito text, id_asl integer, asl text, provincia_ordine_vet text, numero_ordine_vet text, numero_decreto_prefettizio text, scadenza_decreto_prefettizio text, numero_autorizzazione_regionale_vet text, id_tipologia_trasp_dist integer, esito text, id_guc_ruoli integer, endpoint_guc_ruoli text, ruolo_guc_ruoli text, in_nucleo boolean, in_dpat boolean) AS
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
r.identificativo_ente::text, r.piva_numregistrazione::text, 
(select comuni.comune::text from comuni where codiceistatcomune::integer = (select case when length(r.comune)> 0 then r.comune::integer else -1 end)), coalesce(r.comune,'-1')::text as istat_comune, 
r.nominativo_referente::text,
r.ruolo_referente::text, r.email_referente::text, r.telefono_referente::text, r.data_richiesta, r.codice_gisa::text,
r.indirizzo::text, r.id_gestore_acque::integer, gac.nome, r.cap::text, r.pec::text, r.numero_richiesta::text,
es.esito_guc, es.esito_gisa, es.esito_gisa_ext, es.esito_bdu, es.esito_vam, es.esito_digemon, es.data_esito, es.stato, (select concat_ws(' ', u.nome, u.cognome) from utenti u where u.id = es.id_utente_esito)::text,
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
  -------------------------------- 21/09/2022 CONFIGURAZIONE GESDASIC-------------------------
  
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
	output_guc_gesdasic text;
	username_out text;
	password_out text;
	
	ep_gisa integer;
	ep_gisa_ext integer;
	ep_bdu integer;
	ep_vam integer;
	ep_digemon integer;
	ep_gesdasic integer;

	check_endpoint text;

	output_gisa text;
	output_gisa_ext text;
	output_bdu text;
	output_vam text;
	output_digemon text;
	output_gesdasic text;
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
	ep_gesdasic := (select coalesce(id_ruolo_gesdasic,-1) from spid.get_lista_richieste(_numero_richiesta));

	
	output_gisa='{}';
	output_gisa_ext='{}';
	output_bdu='{}';
	output_vam='{}';
	output_digemon='{}';
	output_guc ='{}';
	output_gesdasic ='{}';
	
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
	

	if (ep_gesdasic > 0 and _endpoint_guc_ruoli ilike 'gesdasic') then
		
			query  := 'select * from spid.elimina_ruolo_utente_guc('||_id_utente_guc_ruoli||','||_id_ruolo_guc_ruoli||',''gesdasic'')';
			output_guc_gesdasic := (select * from spid.esegui_query(query , 'guc', _idutente,''));
			output_gesdasic := COALESCE(output_guc_gesdasic, '');

			if (get_json_valore(output_guc_gesdasic, 'Esito') = 'OK') then
				query := 'select * from spid.insert_ruolo_utente_guc('||_id_utente_guc_ruoli||','||ep_gesdasic||',''gesdasic'')';			
				output_guc_gesdasic := (select * from spid.esegui_query(query , 'guc', _idutente,''));
				if (get_json_valore(output_guc_gesdasic, 'Esito') = 'OK') then
					-- chiamo la dbi elimina utente
					query_endpoint :=( select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gesdasic', 'elimina', _idutente, username_out, '', (now()::timestamp without time zone - interval '1 DAY'), _id_ruolo_guc_ruoli, -1));
					output_gesdasic := (select * from spid.esegui_query(query_endpoint, 'gesdasic', _idutente,'host=dbGESDASICL dbname=gesdasic'));
					if (get_json_valore(output_gesdasic, 'Esito') = 'OK') then -- insert utente
						query_endpoint := (select * from spid.get_dbi_per_endpoint(_numero_richiesta, 'gesdasic', 'insert', _idutente, username_out, password_out, null::timestamp without time zone, -1, -1));
						output_gesdasic := (select * from spid.esegui_query(query_endpoint, 'gesdasic', _idutente,'host=dbGESDASICL dbname=gesdasic'));
						output_gesdasic := '{"Esito" : "'||output_gesdasic||'"}';
					end if;
				end if;
			end if;	
		
	end if; -- fine ep_gesdasic

	esito_processa = '{"EndPoint" : "GUC", "Username" : "' || username_out || '", "CodiceFiscale": "'||_codice_fiscale||'","ListaEndPoint" : [
					{"EndPoint" : "GISA", "Risultato" : ['||output_gisa||']},
					{"EndPoint" : "GISA_EXT", "Risultato" : ['||output_gisa_ext||']},
					{"EndPoint" : "BDR", "Risultato" : ['||output_bdu||']},
					{"EndPoint" : "VAM", "Risultato" : ['||output_vam||']},
					{"EndPoint" : "DIGEMON", "Risultato" : ['||output_digemon||']},
					{"EndPoint" : "GESDASIC", "Risultato" : ['||output_gesdasic||']}

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
	IF get_json_valore(output_gesdasic, 'Esito')='OK' THEN
		esito = 1;
	END IF;
		
	-- update e insert richieste
	UPDATE spid.spid_registrazioni_esiti set trashed_date = now() where numero_richiesta = _numero_richiesta and trashed_date is null;
	insert into spid.spid_registrazioni_esiti(numero_richiesta, esito_guc, esito_gisa, esito_gisa_ext, esito_bdu, esito_vam, esito_digemon, esito_gesdasic, id_utente_esito, stato, json_esito) 
	values (_numero_richiesta,true,(case when get_json_valore(output_gisa, 'Esito')='OK' then true when get_json_valore(output_gisa, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_gisa_ext, 'Esito')='OK' then true when get_json_valore(output_gisa_ext, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_bdu, 'Esito')='OK' then true when get_json_valore(output_bdu, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_vam, 'Esito')='OK' then true when get_json_valore(output_vam, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_digemon, 'Esito')='OK' then true when get_json_valore(output_digemon, 'Esito')='KO' then false else null end),
					       (case when get_json_valore(output_gesdasic, 'Esito')='OK' then true when get_json_valore(output_gesdasic, 'Esito')='KO' then false else null end),
					       _idutente, (case when esito = 1 then 1 end),esito_processa);
		

	return esito_processa;
	
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.processa_richiesta_modifica(text, integer)
  OWNER TO postgres;

  
