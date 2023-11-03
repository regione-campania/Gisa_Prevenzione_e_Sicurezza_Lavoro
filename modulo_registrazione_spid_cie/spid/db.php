<?php
require_once("common/connection.php");
require("common/config.php");
mb_internal_encoding("UTF-8");

$operation = $_REQUEST['operation'];
$response = new stdClass();
if ($operation == 'get_ruoli') {

    if ($_CONFIG['guc']['enabled']) {
        $conn = getConnection('guc');

        $whereLimitEnti = '';
        if ($_CONFIG['limit_enti'] != null && count($_CONFIG['limit_enti']) > 0)
            $whereLimitEnti = ' where id in (' . implode(',', $_CONFIG['limit_enti']) . ')';

        $whereLimitOperazioni = '';
        if ($_CONFIG['limit_operazioni'] != null && count($_CONFIG['limit_operazioni']) > 0)
            $whereLimitOperazioni = ' where id in (' . implode(',', $_CONFIG['limit_operazioni']) . ')';


        $result = pg_query($conn, "select * from spid.spid_tipologia_utente $whereLimitEnti order by ord");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->tipologia_utente[$i]['id'] = $row['id'];
            $response->tipologia_utente[$i]['descr'] = $row['descr'];
            $i++;
        }

        $result = pg_query($conn, "select * from spid.spid_tipo_richiesta $whereLimitOperazioni");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->tipo_richiesta[$i]['id'] = $row['id'];
            $response->tipo_richiesta[$i]['descr'] = $row['descr'];
            $response->tipo_richiesta[$i]['title'] = $row['title'];
            $i++;
        }

        $result = pg_query($conn, "select * from public.asl where id > 200");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->asl[$i]['id'] = $row['id'];
            $response->asl[$i]['descr'] = $row['nome'];
            $i++;
        }

        /*$result = pg_query($conn, "select * from spid.lookup_tipo_registrazione_trasporti_distributori");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->tipo_gestore[$i]['id'] = $row['id'];
            $response->tipo_gestore[$i]['descr'] = $row['descr'];
            $i++;
        }*/

        pg_close($conn);
    }

    $endpoint = 'bdu';
    if ($_CONFIG[$endpoint]['enabled']) {
        $conn = getConnection($endpoint);

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (31)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_bdu[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_bdu[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (18, 29, 34, 20, 36)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_asl_bdu[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_asl_bdu[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (32)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_regione_bdu[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_regione_bdu[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        /*$result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (26,33)");
    $i = 0;
    while ($row = pg_fetch_assoc($result)) {
        $response->ruoli_bdu_forze[$i]['id'] = $row['id_ruolo'];
        $response->ruoli_bdu_forze[$i]['descr'] = $row['descrizione_ruolo'];
        $i++;
    }*/

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (24)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_bdu_liberi_prof[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_bdu_liberi_prof[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (35)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_zoofile_bdu[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_zoofile_bdu[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        //FLUSSO 315
        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (38)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_bdu_forze[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_bdu_forze[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        pg_close($conn);
    }
    $endpoint = 'gisa';
    if ($_CONFIG[$endpoint]['enabled']) {
        $conn = getConnection($endpoint);

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente()");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_gisa[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_gisa[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (3340)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_gisa_izsm[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_gisa_izsm[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where access and id_ruolo = 10000002");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_apicoltore[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_apicoltore[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_apicoltore[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where access and id_ruolo = 10000001");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_delegato_apicoltore[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_delegato_apicoltore[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_delegato_apicoltore[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where access and id_ruolo = 10000006");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_gestori_acque[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_gestori_acque[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_gestori_acque[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where access and id_ruolo = 10000004");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_trasporti[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_trasporti[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_trasporti[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo in (10000009)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_esercito[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_esercito[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_esercito[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo in (10000005,224,225,226,227,228,223,116,115,105,113,118,1020,1123,114,10000000,110,111,1019)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_forze[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_forze[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_forze[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo in (117)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_arpac[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_arpac[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_arpac[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select id, nome from gestori_acque_gestori where enabled order by nome");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->gestori_acque[$i]['id'] = $row['id'];
            $response->gestori_acque[$i]['nome'] = $row['nome'];
            $i++;
        }

        $result = pg_query($conn, "select istat, nome, codiceistatasl from comuni1 where cod_regione='15' and notused is null order by nome");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->comuni[$i]['istat'] = $row['istat'];
            $response->comuni[$i]['nome'] = $row['nome'];
            $response->comuni[$i]['id_asl_comune'] = $row['codiceistatasl'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo in (329)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_zoofile_gisa[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_zoofile_gisa[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_zoofile_gisa[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo = 10000008");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_giava[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_giava[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_giava[$i]['ext'] = true;
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in(31, 53)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_osservatori[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_osservatori[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in(3373,3368,3367,3369,3370,3366,3365,3375)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_crr[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_crr[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in(40, 324, 27, 326, 327, 37, 47, 328)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_regione[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_regione[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in(96,44,16,221,42,21,45,97,43,19,46,98,33,56,41,59,222)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_asl[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_asl[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        //flusso 303
        $result = pg_query($conn, "select * from dbi_get_ruoli_utente_ext() where id_ruolo in(10000010, 10000011)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_riproduzione_animale[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_riproduzione_animale[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_riproduzione_animale[$i]['ext'] = true;
            $i++;
        }

        pg_close($conn);
    }
    $endpoint = 'vam';
    if ($_CONFIG[$endpoint]['enabled']) {
        $conn = getConnection($endpoint);

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (3, 5, 2, 14)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_vam[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_vam[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_cliniche_utente_attive();");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->cliniche_vam[$i]['id'] = $row['id_clinica'];
            $response->cliniche_vam[$i]['descr'] = $row['nome_clinica'];
            $response->cliniche_vam[$i]['id_asl'] = $row['asl_id'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo = 6");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_izsm_vam[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_izsm_vam[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }

        $result = pg_query($conn, "select * from dbi_get_cliniche_utente_attive() where nome_clinica ilike 'izsm%'");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->cliniche_vam_izsm[$i]['id'] = $row['id_clinica'];
            $response->cliniche_vam_izsm[$i]['descr'] = $row['nome_clinica'];
            $response->cliniche_vam_izsm[$i]['id_asl'] = $row['asl_id'];
            $i++;
        }

        pg_close($conn);
    }
    $endpoint = 'digemon';
    if ($_CONFIG[$endpoint]['enabled']) {
        $conn = getConnection($endpoint);

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (99);");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_digemon[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_digemon[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }
        pg_close($conn);
    }
    $endpoint = 'gesdasic';
    if ($_CONFIG[$endpoint]['enabled']) {
        $conn = getConnection($endpoint);

        $result = pg_query($conn, "select * from dbi_get_ruoli_utente() where id_ruolo in (338);");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_gesdasic_regione[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_gesdasic_regione[$i]['descr'] = $row['descrizione_ruolo'];
            $i++;
        }
        $result = pg_query($conn, "
    select r.*, ra.has_ambito, ra.is_obbligatorio  from dbi_get_ruoli_utente() r
    left join gds.role_ambito ra on ra.id_role = r.id_ruolo
    where id_ruolo in (334,335,336,337,339, 342, 343, 344, 345)");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ruoli_gesdasic_asl[$i]['id'] = $row['id_ruolo'];
            $response->ruoli_gesdasic_asl[$i]['descr'] = $row['descrizione_ruolo'];
            $response->ruoli_gesdasic_asl[$i]['has_ambito'] = $row['has_ambito'];
            $response->ruoli_gesdasic_asl[$i]['is_obbligatorio'] = $row['is_obbligatorio'];
            $i++;
        }

        $result = pg_query($conn, "select * from gds.ambiti where trashed is null");
        $i = 0;
        while ($row = pg_fetch_assoc($result)) {
            $response->ambiti_gesdasic[$i] = $row;
            $i++;
        }

        pg_close($conn);
    }

    //ottengo vecchie registrazioni
    $cf = $_GET['cf'];
    $i = 0;
    $conn = getConnection("guc");
    if ($_CONFIG['gisa']['enabled']) {
        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'GISA', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $response->registrazione[$i]['descrizione'] = (strtoupper($row['endpoint']) . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " . $datiAggiuntiviText);
            $response->registrazione[$i]['is_edit'] = true;
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $i++;
        }
        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'GISA_EXT', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $row['endpoint'] = str_replace("_ext", "", $row['endpoint']);
            $response->registrazione[$i]['descrizione'] = (strtoupper($row['endpoint']) . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " . $datiAggiuntiviText);
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $i++;
        }
    }
    if ($_CONFIG['digemon']['enabled']) {

        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'DIGEMON', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $response->registrazione[$i]['descrizione'] = (strtoupper($row['endpoint']) . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " . $datiAggiuntiviText);
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $i++;
        }
    }
    if ($_CONFIG['vam']['enabled']) {

        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'VAM', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $response->registrazione[$i]['descrizione'] = (strtoupper($row['endpoint']) . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " . $datiAggiuntiviText);
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $response->registrazione[$i]['is_edit'] = true;
            $i++;
        }
    }
    if ($_CONFIG['bdu']['enabled']) {

        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'BDU', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $response->registrazione[$i]['descrizione'] = (strtoupper($row['endpoint']) . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " . $datiAggiuntiviText);
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $i++;
        }
    }
    if ($_CONFIG['gesdasic']['enabled']) {

        $query = "select * from spid.get_lista_ruoli_utente_guc('$cf', 'SICUREZZALAVORO', null)";
        $result = pg_query($conn, $query);
        while ($row = pg_fetch_assoc($result)) {
            $response->registrazione[$i]['tipologia_utente'] = $row['tipologia_utente'];

            $datiAggiuntiviText = "";
            $datiAggiuntiviJson = $row['dettagli'];
            $datiAggiuntiviOggetto = json_decode($datiAggiuntiviJson);
            foreach ($datiAggiuntiviOggetto as $key => $value) {
                if ($key != "IdTipologiaUtente" && $value != "" && $value != null) {
                    $datiAggiuntiviText = $datiAggiuntiviText . " [$key $value]";
                } else if ($key == "IdTipologiaUtente" && $value != "" && $value != null) {
                    $response->registrazione[$i]['tipologia_utente'] = "$value";
                }
            }
            $response->registrazione[$i]['id_guc_ruoli'] = $row['id_guc_ruoli'];
            $response->registrazione[$i]['descrizione'] = (strtoupper("SICUREZZA LAVORO") . ": " . $row['ruolo'] . " [ASL " . $row['asl'] . "] " );
            $response->registrazione[$i]['id_asl'] = $row['id_asl'];
            $i++;
        }
    }

    $response->limit_profilazione = $_CONFIG['limit_profilazione'];

    echo json_encode($response);
} else if ($operation == 'save') {
    $tipologia_utente = $_POST['tipologia_utente'];
    $tipo_richiesta = $_POST['tipo_richiesta'];
    $cognome = str_replace("'", "''", $_POST['cognome']);
    $nome = str_replace("'", "''", $_POST['nome']);
    $codice_fiscale = $_POST['codice_fiscale'];
    $email = $_POST['email'];
    $telefono = $_POST['telefono'];
    $id_ruolo_gisa = $_POST['id_ruolo_gisa'];
    $id_ruolo_bdu = $_POST['id_ruolo_bdu'];
    $id_ruolo_vam = $_POST['id_ruolo_vam'];
    $id_clinica_vam = $_POST['id_clinica_vam'];
    $id_ruolo_ext = $_POST['id_ruolo_ext'];
    $identificativo_ente = $_POST['identificativo_ente'];
    $piva_numregistrazione = $_POST['piva_numregistrazione'];
    $comune = $_POST['comune'];
    $nominativo_referente = $_POST['nominativo_referente'];
    $email_referente = $_POST['email_referente'];
    $telefono_referente = $_POST['telefono_referente'];
    $ruolo_referente = $_POST['ruolo_referente'];
    $codice_gisa = strtoupper($_POST['codice_gisa']);
    $indirizzo = $_POST['indirizzo'];
    $cap = $_POST['cap'];
    $id_gestore_acqua = $_POST['id_gestore_acqua'];
    $pec = $_POST['pec'];
    $giava = $_POST['giava'];
    $digemon = $_POST['digemon'];
    $numero_decreto_prefettizio = $_POST['numero_decreto_prefettizio'];
    $scadenza_decreto_prefettizio = $_POST['scadenza_decreto_prefettizio'];
    $provincia_ordine_vet = $_POST['provincia_ordine_vet'];
    $numero_ordine_vet = $_POST['numero_ordine_vet'];
    $numero_autorizzazione_regionale_vet = $_POST['numero_autorizzazione_regionale_vet'];
    $id_asl = $_POST['asl'];
    $id_tipologia_trasp_dist = $_POST['id_tipologia_trasp_dist'];
    $id_guc_ruoli = $_POST['id_guc_ruoli'];
    $id_ruolo_gesdasic = $_POST['id_ruolo_gesdasic'];
    $id_ambito_gesdasic = $_POST['id_ambito_gesdasic'];

    $userAgent = $_SERVER['HTTP_USER_AGENT'];
    $ip = $_SERVER['REMOTE_ADDR'];

    $conn = getConnection("guc");

    //check se richiesta inserimento già presente
    $query = "
    select count(*), STRING_AGG(r.numero_richiesta ||' DEL '||to_CHAR(data_richiesta, 'DD-MM-YYY'), ', ') as num
        from spid.spid_registrazioni r
        left join spid.spid_registrazioni_esiti e on r.numero_richiesta = e.numero_richiesta
        where
        codice_fiscale = '$codice_fiscale' 
        and id_tipo_richiesta = $tipo_richiesta
        and id_tipologia_utente = $tipologia_utente
        and (id_ruolo_gisa = $id_ruolo_gisa or (id_ruolo_gisa is null and '$id_ruolo_gisa' = 'null'))
        and (id_ruolo_digemon = $digemon or (id_ruolo_digemon is null and '$digemon' = 'null'))
        and id_ruolo_vam = $id_ruolo_vam
        and id_ruolo_bdu = $id_ruolo_bdu
        and id_ruolo_sicurezza_lavoro = $id_ruolo_gesdasic
        and (id_ruolo_gisa_ext = $id_ruolo_ext or (id_ruolo_gisa_ext is null and '$id_ruolo_ext' = 'null'))
        and piva_numregistrazione = '$piva_numregistrazione'
        and (id_asl = $id_asl or (id_asl is null and '$id_asl' = 'null'))
        and data_richiesta + interval '7 days' > current_date and 1 = $tipo_richiesta
        and codice_gisa = '$codice_gisa'
        and e.stato != 2";

    $result = pg_query($conn, $query);
    while ($row = pg_fetch_assoc($result)) {
        if ($row['count'] > 0)
            die("KO: ESISTE GIA' LA RICHIESTA " . $row['num'] . " CONTENENTE I DATI INSERITI. PER CHIARIMENTI CONTATTARE L'HELP DESK.");
    }

    //check se richiesta modifica/cancellazione già inoltrata
    $query = "
        select count(*) 
        from spid.spid_registrazioni r
        left join spid.spid_registrazioni_esiti e on r.numero_richiesta = e.numero_richiesta
        where codice_fiscale = '$codice_fiscale'
        and data_richiesta + interval '1 days' > current_timestamp 
        and id_tipo_richiesta in (2,3)
        and $tipo_richiesta = id_tipo_richiesta 
        and id_guc_ruoli = $id_guc_ruoli
        and  e.stato != 2";

    $avviso = "";
    $result = pg_query($conn, $query);
    while ($row = pg_fetch_assoc($result)) {
        if ($row['count'] > 0)
            $avviso = "La richiesta potrebbe non essere processata, in quanto è già presente una richiesta di modifica/eliminazione account nella stessa giornata a parità di CF, sistema e ruolo da modificare/eliminare";
    }


    $query = "INSERT INTO spid.spid_registrazioni
    (id_tipologia_utente, id_tipo_richiesta, cognome, nome, codice_fiscale, email, telefono, 
    id_ruolo_gisa, id_ruolo_bdu, id_ruolo_vam, id_clinica_vam, id_ruolo_gisa_ext, identificativo_ente, piva_numregistrazione, 
    comune, nominativo_referente, ruolo_referente, email_referente, telefono_referente, data_richiesta, codice_gisa, indirizzo, cap, id_gestore_acque, pec, id_ruolo_digemon,
    numero_ordine_vet, provincia_ordine_vet, numero_autorizzazione_regionale_vet,
    id_asl, id_tipologia_trasp_dist,
    numero_decreto_prefettizio, scadenza_decreto_prefettizio, id_guc_ruoli,
    ip, user_agent, id_ruolo_sicurezza_lavoro,id_ambito_gesdasic)
    VALUES
    ($tipologia_utente, $tipo_richiesta, '$cognome', '$nome', '$codice_fiscale', '$email', '$telefono', 
    $id_ruolo_gisa, $id_ruolo_bdu, $id_ruolo_vam, '{ $id_clinica_vam }', $id_ruolo_ext, '$identificativo_ente', '$piva_numregistrazione', 
    '$comune', '$nominativo_referente', '$ruolo_referente', '$email_referente', '$telefono_referente', CURRENT_TIMESTAMP, '$codice_gisa', '$indirizzo', '$cap', $id_gestore_acqua, '$pec', $digemon , 
    '$numero_ordine_vet', '$provincia_ordine_vet', '$numero_autorizzazione_regionale_vet',
    $id_asl, $id_tipologia_trasp_dist,
    '$numero_decreto_prefettizio', '$scadenza_decreto_prefettizio', $id_guc_ruoli,
    '$ip', '$userAgent', $id_ruolo_gesdasic, $id_ambito_gesdasic)
    returning id";
    $result = pg_query($conn, $query);
    if (!$result)
        die("KO " . $query);
    while ($row = pg_fetch_assoc($result)) {
        $richiesta = date("Y") . '-RIC-' . str_pad($row['id'], 8, "0", STR_PAD_LEFT);
        $result2 = pg_query($conn, "UPDATE spid.spid_registrazioni SET numero_richiesta = '$richiesta' where id =" . $row['id']);
        if (!$result2)
            die("KO numero richiesta");

        $HTML = str_replace("'", "''", $_POST['html']);

        $queryHtml = "INSERT INTO spid.html_registrazioni (id_spid_registrazioni, html) values (" . $row['id'] . ", '" . $HTML . "')";
        $result3 = pg_query($conn, $queryHtml);
        if (!$result3)
            die("KO $queryHtml");

        echo $richiesta . '||' . $avviso;
    }
} else if ($operation == 'printPdf') {

    $num_richiesta = $_GET['numero_richiesta'];
    $query = "select html from spid.html_registrazioni hr where id_spid_registrazioni = (select id from spid.spid_registrazioni sr where numero_richiesta = '$num_richiesta')";
    $conn = getConnection("guc");
    $result = pg_query($conn, $query);
    echo pg_last_error($conn);
    while ($row = pg_fetch_assoc($result)) {
        session_start();
        $HTML = str_replace('"', '\"', $_POST['html']);
        $_SESSION['html'] = $row['html'];
        $_SESSION['numero_richiesta'] = $num_richiesta;
        header("location: esporta.php");
    }
}
