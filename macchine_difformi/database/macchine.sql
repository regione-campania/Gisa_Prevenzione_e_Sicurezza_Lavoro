-- DROP SCHEMA gds_macchine;

CREATE SCHEMA gds_macchine AUTHORIZATION postgres;

-- Drop table

-- DROP TABLE gds_macchine."_h_costruttori";

CREATE TABLE gds_macchine."_h_costruttori" (
	id bigserial NOT NULL,
	id_costruttore int8 NULL,
	descr varchar NOT NULL,
	validita tsrange NOT NULL,
	id_transazione int8 NULL,
	ts timestamp NULL,
	ts_transazione timestamp NULL,
	CONSTRAINT "_h_costruttori_pk" PRIMARY KEY (id),
	CONSTRAINT "_h_costruttori_uk" UNIQUE (id_costruttore, validita)
);

-- Drop table

-- DROP TABLE gds_macchine."_h_macchine";

CREATE TABLE gds_macchine."_h_macchine" (
	id bigserial NOT NULL,
	id_macchina int8 NULL,
	id_tipo_macchina int8 NOT NULL,
	id_costruttore int8 NOT NULL,
	modello varchar NOT NULL,
	data_modifica timestamp NOT NULL,
	data_inserimento timestamp NOT NULL,
	validita tsrange NOT NULL,
	id_transazione int8 NULL,
	ts timestamp NULL,
	ts_transazione timestamp NULL,
	CONSTRAINT "_h_macchine_pk" PRIMARY KEY (id),
	CONSTRAINT "_h_macchine_uk" UNIQUE (id_macchina, validita)
);

-- Drop table

-- DROP TABLE gds_macchine.costruttori;

CREATE TABLE gds_macchine.costruttori (
	id bigserial NOT NULL,
	descr varchar NOT NULL,
	CONSTRAINT costruttori_unique UNIQUE (descr),
	CONSTRAINT costruttoricostruttori_pk PRIMARY KEY (id)
);

-- Drop table

-- DROP TABLE gds_macchine.macchine;

CREATE TABLE gds_macchine.macchine (
	id bigserial NOT NULL,
	id_tipo_macchina int8 NOT NULL,
	id_costruttore int8 NOT NULL,
	modello varchar NOT NULL,
	data_modifica timestamp NOT NULL,
	data_inserimento timestamp NOT NULL,
	fileinfo bytea NULL,
	"fName" varchar NULL,
	id_utente int8 NULL,
	data_eliminazione timestamp NULL,
	CONSTRAINT macchine_pk PRIMARY KEY (id),
	CONSTRAINT macchine_un UNIQUE (modello, id_tipo_macchina, id_costruttore),
	CONSTRAINT macchine_costruttore_fk FOREIGN KEY (id_costruttore) REFERENCES gds_macchine.costruttori(id),
	CONSTRAINT macchine_tipo_macchina_fk FOREIGN KEY (id_tipo_macchina) REFERENCES gds_types.tipi_macchina(id)
);

CREATE OR REPLACE VIEW gds_macchine.vw_costruttori
AS SELECT costruttori.id,
    costruttori.id AS id_costruttore,
    costruttori.descr,
    costruttori.descr AS descr_costruttore
   FROM gds_macchine.costruttori;

CREATE OR REPLACE VIEW gds_macchine.vw_h_costruttori
AS SELECT hc.id,
    hc.id AS id_costruttore,
    hc.descr,
    hc.validita,
    hc.id_transazione,
    hc.ts,
    hc.ts_transazione
   FROM gds_macchine._h_costruttori hc;

CREATE OR REPLACE VIEW gds_macchine.vw_h_macchine
AS SELECT hm.id,
    hm.id AS id_macchina,
    hm.id_tipo_macchina,
    hm.id_costruttore,
    hm.modello,
    hm.data_modifica,
    hm.data_inserimento,
    hm.validita,
    hm.id_transazione,
    hm.ts,
    hm.ts_transazione
   FROM gds_macchine._h_macchine hm;

CREATE OR REPLACE VIEW gds_macchine.vw_macchine
AS SELECT m.id,
    m.id AS id_macchina,
    m.modello,
    m.id_tipo_macchina,
    m.id_costruttore,
    tm.descr_tipo_macchina,
    c.descr_costruttore,
    m.data_modifica,
    m.data_inserimento,
    m.fileinfo,
    m."fName",
    m.id_utente
   FROM gds_macchine.macchine m
     JOIN gds_types.vw_tipi_macchina tm ON m.id_tipo_macchina = tm.id_tipo_macchina
     JOIN gds_macchine.vw_costruttori c ON c.id = m.id_costruttore
  WHERE m.data_eliminazione IS NULL
  ORDER BY m.data_inserimento DESC;

CREATE UNIQUE INDEX _h_costruttori_pk ON gds_macchine._h_costruttori USING btree (id);

CREATE UNIQUE INDEX _h_costruttori_uk ON gds_macchine._h_costruttori USING btree (id_costruttore, validita);

CREATE UNIQUE INDEX costruttori_unique ON gds_macchine.costruttori USING btree (descr);

CREATE UNIQUE INDEX costruttoricostruttori_pk ON gds_macchine.costruttori USING btree (id);

CREATE UNIQUE INDEX macchine_pk ON gds_macchine.macchine USING btree (id);

CREATE UNIQUE INDEX macchine_un ON gds_macchine.macchine USING btree (modello, id_tipo_macchina, id_costruttore);

CREATE UNIQUE INDEX _h_macchine_pk ON gds_macchine._h_macchine USING btree (id);

CREATE UNIQUE INDEX _h_macchine_uk ON gds_macchine._h_macchine USING btree (id_macchina, validita);

CREATE OR REPLACE FUNCTION gds_macchine.upd_costruttori(v character varying, idtransazione bigint)
 RETURNS gds_types.result_type
 LANGUAGE plpgsql
AS $function$
begin
	declare 
		ret gds_types.result_type; -- START
		id_op bigint;
		proc_name varchar; -- END
		R_costruttore     gds_macchine.costruttori%ROWTYPE;
		R_costruttore_old gds_macchine.costruttori%ROWTYPE;
		R_costruttore_new gds_macchine.costruttori%ROWTYPE;
		n bigint;
    begin
		proc_name:='gds_macchine.upd_costruttori';
	    id_op:=gds_log.start_op(proc_name,idtransazione ,v);
        R_costruttore.descr:=trim(json_extract_path_text(v::json,'descr_costruttore'));
       	raise notice 'valore R_costruttore.descr: %', R_costruttore.descr;
		
       	-- Esci se costruttore nullo
		if R_costruttore.descr is null or R_costruttore.descr = '' then
        	ret.valore:=null;
        	ret.esito=false;
        	ret.msg:='';
        	return ret;
        end if;

       	-- Inserisci il costruttore se non esiste già
       	ret.esito:=true;
       	select * into R_costruttore_old from gds_macchine.costruttori c where c.descr = R_costruttore.descr;
	    ret:=gds_ui.build_ret(ret, proc_name, R_costruttore_old.id);

        if R_costruttore_old.id is null then
            insert into gds_macchine.costruttori (id, descr) values (nextval('gds_macchine.costruttori_id_seq'), R_costruttore.descr);
       		select * into R_costruttore_new from gds_macchine.costruttori c where c.id = currval('gds_macchine.costruttori_id_seq');
       		n:=gds_log.upd_record(proc_name, idtransazione, R_costruttore_new,'I');
	       	ret:=gds_ui.build_ret(ret, proc_name, R_costruttore_new.id);
        end if;
	    -- ret.esito:=true;
		-- ret:=gds_ui.build_ret(ret, proc_name, R_costruttore_new.id);
		id_op:=gds_log.end_op(proc_name, idtransazione, row_to_json(ret)::varchar);
		return ret;
	end;
END
$function$
;

CREATE OR REPLACE FUNCTION gds_macchine.upd_macchine(v character varying, idtransazione bigint)
 RETURNS gds_types.result_type
 LANGUAGE plpgsql
AS $function$
begin
	declare 
	
            ret gds_types.result_type; -- START
		    id_op bigint;   
		    proc_name varchar; -- END
	        R_macchina     gds_macchine.vw_macchine%ROWTYPE;
            R_macchina_old gds_macchine.macchine%ROWTYPE;
            R_macchina_new gds_macchine.macchine%ROWTYPE;
            n bigint;
           
	begin
		
		proc_name:='gds_macchine.upd_macchine';
	    id_op:=gds_log.start_op(proc_name,idtransazione ,v);
        R_macchina:=  json_populate_record(null::gds_notifiche.vw_macchine,v::json);
        R_macchina.id:=R_cantieri.id_macchina;
        R_macchina.descr_tipo_macchina:= trim(R_macchina.descr_tipo_macchina);
        R_macchina.descr_costruttore:= trim(R_macchina.descr_costruttore);
       
        --select * into R_macchina_old from gds_macchine.macchine m where id =R_macchina.id;
        -- aggiungere controlli prt tipo_macchina e costruttore (nel caso fare insert)

        ret := gds_macchine.upd_tipi_macchina(v,id_transazione);
        R_macchina.id_tipo_macchina:=ret.valore;
        ret := gds_macchine.upd_costruttori(v,id_transazione);
        R_macchina.id_costruttore:=ret.valore;
        /*select * into R_tipo_macchina where descr=R_macchina.descr_tipo_macchina;
        if R_tipo_macchina is null then
        	insert into gds_types.tipi_macchina values(nextval('gds_types.tipi_macchina_id_seq',R_macchina.descr_tipo_macchina);
            n:=gds_log.upd_record(proc_name,idtransazione,R_macchine_new,'I'); 
        end if;
		*/
       if R_macchina.id is null then
        	insert into gds_macchine.macchine   (                                     id,           id_tipo_macchina,           id_costruttore,           modello,    data_modifica, data_inserimento)
       									 values (nextval('gds_macchine.macchine_id_seq'),R_macchina.id_tipo_macchina,R_macchina.id_costruttore,R_macchina.modello,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP());
       		select * into R_macchina_new from gds_macchine.macchine  where id = R_macchina.id;
       		n:=gds_log.upd_record(proc_name,idtransazione,R_macchine_new,'I');    	
        end if;
        select * into R_macchina_old from gds_macchine.vw_macchine where id = R_macchina.id;
   
    	IF R_macchina.id_tipo_macchina != R_macchina_old.id_tipo_macchina or (R_macchina.id_tipo_macchina is not null and R_macchina_old.id_tipo_macchina is  null)
    	    or R_macchina.id_costruttore != R_macchina_old.id_costruttore or (R_macchina.id_costruttore is not null and R_macchina_old.id_costruttore is  null)
    	    or R_macchina.modello != R_macchina_old.modello or (R_macchina.modello is not null and R_macchina_old.modello is  null)
       		then
       		raise notice 'sono nell update %',proc_name;

        	update gds_macchine.macchine  set (           id_tipo_macchina,           id_costruttore,           modello,data_modifica) =
       									      (R_macchina.id_tipo_macchina,R_macchina.id_costruttore,R_macchina.modello,CLOCK_TIMESTAMP())
       		where id = R_macchine.id;
       		select * into R_macchina_new from gds_macchine.macchine  where id = R_macchina.id;
       		n:=gds_log.upd_record(proc_name,idtransazione,R_macchine_new,'U');    								
    	end if;
  
	    ret.esito:=true;	
		ret:=gds_ui.build_ret(ret,proc_name,0);
		id_op:=gds_log.end_op(proc_name,idtransazione ,row_to_json(ret)::varchar);
		return ret;
	end;
END
$function$
;

CREATE OR REPLACE FUNCTION gds_macchine.upd_macchine(v character varying, idtransazione bigint, file bytea)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
begin
	declare
        ret gds_types.result_type; -- START
	    id_op bigint;   
	    proc_name varchar; -- END
        R_macchina     gds_macchine.vw_macchine%ROWTYPE;
        R_macchina_old gds_macchine.macchine%ROWTYPE;
        R_macchina_new gds_macchine.macchine%ROWTYPE;
        n bigint;
	
	begin
		proc_name:='gds_macchine.upd_macchine';
	    id_op:=gds_log.start_op(proc_name, idTransazione, v);
        R_macchina:=  json_populate_record(null::gds_macchine.vw_macchine, v::json);
        -- R_macchina.id:=R_macchina.id_macchina;
        R_macchina.descr_tipo_macchina:= trim(R_macchina.descr_tipo_macchina);
        R_macchina.descr_costruttore:= trim(R_macchina.descr_costruttore);
       	R_macchina.modello:=trim(R_macchina.modello);
       
        raise notice 'valore R_macchina.descr_tipo_macchina: %', R_macchina.descr_tipo_macchina;
	    raise notice 'valore R_macchina.descr_costruttore: %', R_macchina.descr_costruttore;
		raise notice 'valore R_macchina.modello: %', R_macchina.modello;
	   
        --select * into R_macchina_old from gds_macchine.macchine m where id =R_macchina.id;
        -- aggiungere controlli prt tipo_macchina e costruttore (nel caso fare insert)

		-- Recupera id tipo macchina e id costruttore
        ret := gds_types.upd_tipi_macchina(v, idTransazione);
        R_macchina.id_tipo_macchina := ret.valore;
        ret := gds_macchine.upd_costruttori(v, idTransazione);
        R_macchina.id_costruttore := ret.valore;
       
       	raise notice 'valore R_macchina.id_tipo_macchina: %', R_macchina.id_tipo_macchina;
        raise notice 'valore R_macchina.id_costruttore: %', R_macchina.id_costruttore;
       
       	select * into R_macchina_old from gds_macchine.macchine
       	where modello = R_macchina.modello
       	and id_tipo_macchina = R_macchina.id_tipo_macchina
       	and id_costruttore = R_macchina.id_costruttore;
       	
       	raise notice 'valore R_macchina_old.id: %', R_macchina_old.id;
       
       	-- Inserisci macchina se inesistente (Capire da dove recuperare R_macchina.id)
       	if R_macchina_old.id is null then
        	insert into gds_macchine.macchine(id, id_tipo_macchina, id_costruttore, modello, data_modifica, data_inserimento, fileInfo)
       			values (nextval('gds_macchine.macchine_id_seq'), R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), CLOCK_TIMESTAMP(), file);
       		select * into R_macchina_new from gds_macchine.macchine where id = currval('gds_macchine.macchine_id_seq');
       		n:=gds_log.upd_record(proc_name, idtransazione, R_macchina_new,'I');
        end if;
       
        -- select * into R_macchina_old from gds_macchine.vw_macchine where id = R_macchina.id;
   		
       	-- Se la macchina esiste già, effettua le modifiche se ci sono
    	IF R_macchina_old.id is not null and R_macchina.id_tipo_macchina != R_macchina_old.id_tipo_macchina or (R_macchina.id_tipo_macchina is not null and R_macchina_old.id_tipo_macchina is null)
    	    or R_macchina.id_costruttore != R_macchina_old.id_costruttore or (R_macchina.id_costruttore is not null and R_macchina_old.id_costruttore is null)
    	    or R_macchina.modello != R_macchina_old.modello or (R_macchina.modello is not null and R_macchina_old.modello is null)
       		then
       		raise notice 'sono nell update %',proc_name;

        	update gds_macchine.macchine 
        	set (id_tipo_macchina, id_costruttore, modello, data_modifica, fileInfo) =
       			(R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), file)
       		where id = R_macchina_old.id;
       		
       		select * into R_macchina_new from gds_macchine.macchine where id = R_macchina_old.id;
       		n:=gds_log.upd_record(proc_name, idTransazione, R_macchina_new, 'U');
    	end if;
  
	    ret.esito:=true;
		ret:=gds_ui.build_ret(ret, proc_name, 0);
		-- id_op:=gds_log.end_op(proc_name, idTransazione, row_to_json(ret)::varchar);
		return row_to_json(ret);
	end;
END
$function$
;

CREATE OR REPLACE FUNCTION gds_macchine.upd_macchine(v character varying, idtransazione bigint, file bytea, namefile character varying)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
begin
	declare
        ret gds_types.result_type; -- START
	    id_op bigint;   
	    proc_name varchar; -- END
        R_macchina     gds_macchine.vw_macchine%ROWTYPE;
        R_macchina_old gds_macchine.macchine%ROWTYPE;
        R_macchina_new gds_macchine.macchine%ROWTYPE;
        n bigint;
	
	begin
		proc_name:='gds_macchine.upd_macchine';
	    id_op:=gds_log.start_op(proc_name, idTransazione, v);
        R_macchina:=  json_populate_record(null::gds_macchine.vw_macchine, v::json);
        -- R_macchina.id:=R_macchina.id_macchina;
        R_macchina.descr_tipo_macchina:= trim(R_macchina.descr_tipo_macchina);
        R_macchina.descr_costruttore:= trim(R_macchina.descr_costruttore);
       	R_macchina.modello:=trim(R_macchina.modello);
       
        raise notice 'valore R_macchina.descr_tipo_macchina: %', R_macchina.descr_tipo_macchina;
	    raise notice 'valore R_macchina.descr_costruttore: %', R_macchina.descr_costruttore;
		raise notice 'valore R_macchina.modello: %', R_macchina.modello;
	   
        --select * into R_macchina_old from gds_macchine.macchine m where id =R_macchina.id;
        -- aggiungere controlli prt tipo_macchina e costruttore (nel caso fare insert)

		-- Recupera id tipo macchina e id costruttore
        ret := gds_types.upd_tipi_macchina(v, idTransazione);
        R_macchina.id_tipo_macchina := ret.valore;
        ret := gds_macchine.upd_costruttori(v, idTransazione);
        R_macchina.id_costruttore := ret.valore;
       
       	raise notice 'valore R_macchina.id_tipo_macchina: %', R_macchina.id_tipo_macchina;
        raise notice 'valore R_macchina.id_costruttore: %', R_macchina.id_costruttore;
       
       	select * into R_macchina_old from gds_macchine.macchine
       	where modello = R_macchina.modello
       	and id_tipo_macchina = R_macchina.id_tipo_macchina
       	and id_costruttore = R_macchina.id_costruttore;
       	
       	raise notice 'valore R_macchina_old.id: %', R_macchina_old.id;
       
       	-- Inserisci macchina se inesistente (Capire da dove recuperare R_macchina.id)
       	if R_macchina_old.id is null then
        	insert into gds_macchine.macchine(id, id_tipo_macchina, id_costruttore, modello, data_modifica, data_inserimento, fileInfo, "fName")
       			values (nextval('gds_macchine.macchine_id_seq'), R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), CLOCK_TIMESTAMP(), file, nameFile);
       		select * into R_macchina_new from gds_macchine.macchine where id = currval('gds_macchine.macchine_id_seq');
       		n:=gds_log.upd_record(proc_name, idtransazione, R_macchina_new,'I');
        end if;
       
        -- select * into R_macchina_old from gds_macchine.vw_macchine where id = R_macchina.id;
   		
       	-- Se la macchina esiste già, effettua le modifiche se ci sono
    	IF R_macchina_old.id is not null and R_macchina.id_tipo_macchina != R_macchina_old.id_tipo_macchina or (R_macchina.id_tipo_macchina is not null and R_macchina_old.id_tipo_macchina is null)
    	    or R_macchina.id_costruttore != R_macchina_old.id_costruttore or (R_macchina.id_costruttore is not null and R_macchina_old.id_costruttore is null)
    	    or R_macchina.modello != R_macchina_old.modello or (R_macchina.modello is not null and R_macchina_old.modello is null)
       		then
       		raise notice 'sono nell update %',proc_name;

        	update gds_macchine.macchine 
        	set (id_tipo_macchina, id_costruttore, modello, data_modifica, fileInfo, "fName") =
       			(R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), file, nameFile)
       		where id = R_macchina_old.id;
       		
       		select * into R_macchina_new from gds_macchine.macchine where id = R_macchina_old.id;
       		n:=gds_log.upd_record(proc_name, idTransazione, R_macchina_new, 'U');
    	end if;
  
	    ret.esito:=true;
		ret:=gds_ui.build_ret(ret, proc_name, 0);
		-- id_op:=gds_log.end_op(proc_name, idTransazione, row_to_json(ret)::varchar);
		return row_to_json(ret);
	end;
END
$function$
;

CREATE OR REPLACE FUNCTION gds_macchine.upd_macchine(v character varying, idtransazione bigint, file bytea, namefile character varying, _id_utente bigint)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
begin
	declare
        ret gds_types.result_type; -- START
	    id_op bigint;   
	    proc_name varchar; -- END
        R_macchina     gds_macchine.vw_macchine%ROWTYPE;
        R_macchina_old gds_macchine.macchine%ROWTYPE;
        R_macchina_new gds_macchine.macchine%ROWTYPE;
        n bigint;
	
	begin
		proc_name:='gds_macchine.upd_macchine';
	    id_op:=gds_log.start_op(proc_name, idTransazione, v);
        R_macchina:=  json_populate_record(null::gds_macchine.vw_macchine, v::json);
        -- R_macchina.id:=R_macchina.id_macchina;
        R_macchina.descr_tipo_macchina:= trim(R_macchina.descr_tipo_macchina);
        R_macchina.descr_costruttore:= trim(R_macchina.descr_costruttore);
       	R_macchina.modello:=trim(R_macchina.modello);
       
        raise notice 'valore R_macchina.descr_tipo_macchina: %', R_macchina.descr_tipo_macchina;
	    raise notice 'valore R_macchina.descr_costruttore: %', R_macchina.descr_costruttore;
		raise notice 'valore R_macchina.modello: %', R_macchina.modello;
	   
        --select * into R_macchina_old from gds_macchine.macchine m where id =R_macchina.id;
        -- aggiungere controlli prt tipo_macchina e costruttore (nel caso fare insert)

		-- Recupera id tipo macchina e id costruttore
        ret := gds_types.upd_tipi_macchina(v, idTransazione);
        R_macchina.id_tipo_macchina := ret.valore;
        ret := gds_macchine.upd_costruttori(v, idTransazione);
        R_macchina.id_costruttore := ret.valore;
       
       	raise notice 'valore R_macchina.id_tipo_macchina: %', R_macchina.id_tipo_macchina;
        raise notice 'valore R_macchina.id_costruttore: %', R_macchina.id_costruttore;
       
       	select * into R_macchina_old from gds_macchine.macchine
       	where modello = R_macchina.modello
       	and id_tipo_macchina = R_macchina.id_tipo_macchina
       	and id_costruttore = R_macchina.id_costruttore;
       	
       	raise notice 'valore R_macchina_old.id: %', R_macchina_old.id;
       
       	-- Inserisci macchina se inesistente (Capire da dove recuperare R_macchina.id)
       	if R_macchina_old.id is null then
        	insert into gds_macchine.macchine(id, id_tipo_macchina, id_costruttore, modello, data_modifica, data_inserimento, fileInfo, "fName", id_utente)
       			values (nextval('gds_macchine.macchine_id_seq'), R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), CLOCK_TIMESTAMP(), file, nameFile, _id_utente);
       		select * into R_macchina_new from gds_macchine.macchine where id = currval('gds_macchine.macchine_id_seq');
       		n:=gds_log.upd_record(proc_name, idtransazione, R_macchina_new,'I');
        end if;
       
        -- select * into R_macchina_old from gds_macchine.vw_macchine where id = R_macchina.id;
   		
       	-- Se la macchina esiste già, effettua le modifiche se ci sono
    	IF R_macchina_old.id is not null and R_macchina.id_tipo_macchina != R_macchina_old.id_tipo_macchina or (R_macchina.id_tipo_macchina is not null and R_macchina_old.id_tipo_macchina is null)
    	    or R_macchina.id_costruttore != R_macchina_old.id_costruttore or (R_macchina.id_costruttore is not null and R_macchina_old.id_costruttore is null)
    	    or R_macchina.modello != R_macchina_old.modello or (R_macchina.modello is not null and R_macchina_old.modello is null)
       		then
       		raise notice 'sono nell update %',proc_name;

        	update gds_macchine.macchine 
        	set (id_tipo_macchina, id_costruttore, modello, data_modifica, fileInfo, "fName", id_utente) =
       			(R_macchina.id_tipo_macchina, R_macchina.id_costruttore, R_macchina.modello, CLOCK_TIMESTAMP(), file, nameFile, _id_utente)
       		where id = R_macchina_old.id;
       		
       		select * into R_macchina_new from gds_macchine.macchine where id = R_macchina_old.id;
       		n:=gds_log.upd_record(proc_name, idTransazione, R_macchina_new, 'U');
    	end if;
  
	    ret.esito:=true;
		ret:=gds_ui.build_ret(ret, proc_name, 0);
		-- id_op:=gds_log.end_op(proc_name, idTransazione, row_to_json(ret)::varchar);
		return row_to_json(ret);
	end;
END
$function$
;

-- DROP SEQUENCE gds_macchine."_h_costruttori_id_seq";

CREATE SEQUENCE gds_macchine."_h_costruttori_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- DROP SEQUENCE gds_macchine."_h_macchine_id_seq";

CREATE SEQUENCE gds_macchine."_h_macchine_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- DROP SEQUENCE gds_macchine.costruttori_id_seq;

CREATE SEQUENCE gds_macchine.costruttori_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- DROP SEQUENCE gds_macchine.macchine_id_seq;

CREATE SEQUENCE gds_macchine.macchine_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
