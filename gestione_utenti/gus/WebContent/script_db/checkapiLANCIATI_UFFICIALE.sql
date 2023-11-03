-- Function: spid.check_vincoli_ruoli_by_endpoint(text, integer, text)

-- DROP FUNCTION spid.check_vincoli_ruoli_by_endpoint(text, integer, text);

CREATE OR REPLACE FUNCTION spid.check_vincoli_ruoli_by_endpoint(
    _numero_richiesta text,
    _id_ruolo integer,
    _endpoint text)
  RETURNS text AS
$BODY$
declare
 _query text;
 _msg text;
 conta_guc integer;
 _id_tipologia_utente integer;
BEGIN

_query := '';
_msg := '';
conta_guc = 0;

RAISE INFO '[CHECK RUOLI BY ENDPOINT] _numero_richiesta: %', _numero_richiesta;
RAISE INFO '[CHECK RUOLI BY ENDPOINT] _id_ruolo: %', _id_ruolo;
RAISE INFO '[CHECK RUOLI BY ENDPOINT] _endpoint: %', _endpoint;

-- CHECK SU GUC PRELIMINARE
conta_guc := (select count(*) from spid.get_lista_ruoli_utente_guc((select codice_fiscale from spid.spid_registrazioni where numero_richiesta = _numero_richiesta), _endpoint, (select codice_gisa from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)) 
where id_ruolo = _id_ruolo);
    
if conta_guc > 0 then 
	_msg := 'Per il codice fiscale selezionato, esiste gia'' un account con questo ruolo.';
end if;

_id_tipologia_utente = (select id_tipologia_utente from spid.spid_registrazioni where numero_richiesta = _numero_richiesta);
RAISE INFO '[CHECK RUOLI BY ENDPOINT] Id tipologia utente recuperato da richiesta: %', _id_tipologia_utente;

-- gestore acque
IF _id_ruolo = 10000006 and _endpoint ilike 'GISA_EXT' THEN 
RAISE INFO '[CHECK RUOLI BY ENDPOINT] Avvio check per il ruolo GESTORE ACQUE';
-- Controlla se non c'è un'altra richiesta con lo stesso gestore e lo stesso comune

SELECT 'SELECT * from check_vincoli_richieste(''''::text,'''||('ACQUE')||'''::text, '||(select id_gestore_acque from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'::integer, 
''' || (select comune from spid.spid_registrazioni where numero_richiesta = _numero_richiesta) || '''::text, ''''::text);' into _query;

_msg := (select * from spid.esegui_query(_query, 'gisa', -1,'host=dbGISAL dbname=gisa'));

RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito del check esistenza RICHIESTE: %', _msg;

-- Controlla se il comune esiste in banca dati
-- Non faccio nulla. Il comune è già mappato come istat.

END IF;

--apicoltore
IF _id_ruolo = 10000002 and _endpoint ilike 'GISA_EXT' THEN
RAISE INFO '[CHECK RUOLI BY ENDPOINT] Avvio check per il ruolo API';
-- Controlla se non c'è un'altra richiesta con lo stesso codice fiscale

SELECT 'SELECT * from check_vincoli_richieste('''||(select codice_fiscale from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text,'''||('API')||'''::text, -1, ''''::text,
'''||(select piva_numregistrazione from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text);' into _query;

_msg := (select * from spid.esegui_query(_query, 'gisa', -1,'host=dbGISAL dbname=gisa'));

RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito del check esistenza RICHIESTE: %', _msg;

IF (_msg = '' and _id_tipologia_utente = 5) THEN 
SELECT 'SELECT * from check_vincoli_utente_api('''||(select piva_numregistrazione from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text);' into _query;

_msg := (select * from spid.esegui_query(_query, 'gisa', -1,'host=dbGISAL dbname=gisa'));

RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito del check per APICOLTORE COMMERCIALE: %', _msg;


END IF;
-- Controlla se il comune esiste in banca dati
-- Non faccio nulla. Il comune è già mappato come istat.

END IF;

--trasportatore/distributore
IF _id_ruolo = 10000004 and _endpoint ilike 'GISA_EXT' THEN
RAISE INFO '[CHECK RUOLI BY ENDPOINT] Avvio check per il ruolo TRASPORTATORE/DISTRIBUTORE';
-- Controlla se il CF è valido
-- Non faccio nulla. Lo fa già il modulo e se non lo fa lo deve fare lui e non una dbi

-- Controlla se il comune esiste in banca dati
-- Non faccio nulla. Il comune è già mappato come istat.

-- Controlla se esiste una richiesta con lo stesso codice fiscale e tipologia (trasporto/distr)
SELECT 'SELECT * from check_vincoli_richieste('''||(select codice_fiscale from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text,
'''||(select CASE WHEN id_tipologia_trasp_dist = 1 then 'TRASPORTATORE' WHEN id_tipologia_trasp_dist = 2 then 'DISTRIBUTORE' end from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text, -1, 
''''::text, '''||(select codice_gisa from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text);' into _query;

_msg := (select * from spid.esegui_query(_query, 'gisa', -1,'host=dbGISAL dbname=gisa'));

RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito del check esistenza RICHIESTE: %', _msg;

IF (_msg = '') THEN 

SELECT 'SELECT * from check_vincoli_utente_trasp_dist('''||(select codice_gisa from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text,
'''||(select id_tipologia_trasp_dist from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::integer,
'''||(select comune from spid.spid_registrazioni where numero_richiesta = _numero_richiesta)||'''::text);' into _query;

_msg := (select * from spid.esegui_query(_query, 'gisa', -1,'host=dbGISAL dbname=gisa'));

RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito del check VINCOLI: %', _msg;

END IF;

END IF;
RAISE INFO '[CHECK RUOLI BY ENDPOINT] Esito finale (Vuoto=OK): %', _msg;

return _msg;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION spid.check_vincoli_ruoli_by_endpoint(text, integer, text)
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION public.check_vincoli_utente_api(_partita_iva text)
  RETURNS text AS
$BODY$
declare
   _msg text;
   _idpratica integer;
BEGIN

_msg := '';
_idpratica := -1;

RAISE INFO '[CHECK VINCOLI UTENTE API] _partita_iva: %', _partita_iva;

-- Controlla se esiste la partita iva associata ad una attività di apicoltura
SELECT id into _idpratica from apicoltura_imprese  where codice_fiscale_impresa  = _partita_iva and trashed_Date is null;
RAISE INFO '[CHECK VINCOLI UTENTE API] Check esistenza _id_stabilimento: %', _idpratica;
IF _idpratica is null THEN
_msg := 'PARTITA IVA non associata ad alcuna attivita'' di apicoltura.';
END IF;


RAISE INFO '[CHECK VINCOLI UTENTE API] Esito finale (Vuoto=OK): %', _msg;

return _msg;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.check_vincoli_utente_api(text)
  OWNER TO postgres;


  select * from check_vincoli_utente_api('03983590658')
