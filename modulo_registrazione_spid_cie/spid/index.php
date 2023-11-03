<?php
  require_once("common/connection.php");
  mb_internal_encoding("UTF-8");

  $cf = "";
  $flagPost = false;
    if(isset($_GET["admin"]) && isset($_GET["password"])) {
      $isAdmin = isAdministrator($_GET["admin"], $_GET["password"]);
      if($isAdmin == 'f'){ //false
        header("Location:index.html");
      }
      $cf = $_GET["cf"];
    } else {
      if(isset($_POST["cf"])) {
        $flagPost = true;
        $cf = $_POST["cf"];
      } else {
        header("Location:index.html");
      }
    }
  ?>
<!DOCTYPE html>
<html lang="it">

<head>
  <meta charset="utf-8">
  <title>Gisa - Regione Campania - Pre-registrazione</title>

  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="modulo.css?v<?php echo rand() ?>" rel="stylesheet" type="text/css">


  <script src="funzioni.js?v<?php echo rand() ?>"></script>
  <script src="https://d3js.org/d3.v4.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
  <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
  <script src="https://gisagel-coll.regione.campania.it/js/GisaSpid.js?v<?php echo rand() ?>"></script>
  <script src="js/html2pdf.bundle.9.js?v<?php echo rand() ?>"></script>

</head>

<body>

  <div id="dialog" title="Pre-registrazione GISA - Sicurezza Lavoro"  align="center">
    <p id=dialogText></p>
  </div>
  <div id="dialog-confirm" title="Pre-registrazione GISA - Sicurezza Lavoro" style="display: none;"  align="center">
    <p id="confirmText"><span style="float:left; margin:12px 12px 20px 0;"></span></p>
  </div>
  <div id="dialog-blocking" title="Pre-registrazione GISA - Sicurezza Lavoro"  align="center">
    <p id="dialogBlockingText"><span style="float:left; margin:12px 12px 20px 0;"></span></p>
  </div>

  <div>

  </div>
  <div class="container">

    <h1 style="background-image: linear-gradient(to bottom right, #0574d2, #00040a); text-align:center; color:white;">
      Gisa Sicurezza Lavoro - Modulo Pre-Registrazione e variazioni utenti SPID/CIE
    </h1>
    <div>
      <button onclick="GisaSpid.logoutSpid('index.html')">Logout da Spid/CIE</button>
    </div>

    <div style="text-align: right;">
    <image src="https://wwwcol_new.gisacampania.it/image/pdf-icon.png" width="40" height="40">
      <br>
      <a href="ManualeModuloPre-SICUREZZA.pdf?v<?php echo rand() ?>" target="_blank">
        Manuale utente
      </a>
      <br>
      <!--<a href="Faq Modulo SPID.pdf?v<?php echo rand() ?>" target="_blank">
        F.A.Q.
      </a>-->
    </div>

    <div style="float: right; padding-bottom: 5px; margin-right: -60px; font-size: 12px">
Dopo aver compilato i campi sottostanti, salvare la richiesta e inviare il relativo pdf tramite peo della propria struttura all'indirizzo mail <strong>gisa.sicurezzalavoro@regione.campania.it</strong>
      <image src="https://www.gisacampania.it/image/regione_new.jpg" width="180" />
    </div>

    <div id="reg" style="top:25px;">

      <form id="form_registrazione" action="" method="post" class="form-horizontal">
        <div id="modulo">
          <table style="table-layout:fixed" id="fixedTable">
            <tr id="sez1Row">
              <th colspan="2">SEZIONE 1 - Ente/Soggetto richiedente</th>
            </tr>

            <tr id="sez1Row">
              <td> <label  width:50%; class="control-label" for="Ente Richiedente / Tipologia Utente">Ente Richiedente / Tipologia Utente</label>

                </div>
              </td>

              <td id="tdUtenti">
              </td>
            </tr>

            <th colspan="2">SEZIONE 2 - Tipo Operazione</th>
          </tr>
          <tr>
            <td> <label class="control-label" for="Tipo Richiesta">Tipo Richiesta</label>
            </td>
            <td id="tdRichieste">
            </td>
          </tr>
          <tr id="sistemaRow" style="display: none">
            <td> <label class="control-label" for="Sistema">Sistema e Ruolo</label>
            </td>
            <td>
              <select name="sistemSelect" id="sistemSelect"  onchange="changeSistemaRuolo(this)">
                <option value="null" selected>Nessun valore selezionato</option>
              </select>
            </td>
          </tr>
          <tr  id="sistemaTextRow" style="display: none">
              <td> <label class="control-label" for="Sistema">Sistema e Ruolo</label></td>
              <td id="sistemText"></td>
          </tr>


          <th colspan="2">SEZIONE 3 - Intestatario delle credenziali</th>

          <tr>
            <td> <label class="control-label" for="cognome">Cognome</label>
            </td>
            <td> <input type="text" name="cognome" id="cognome" value="<?php echo $_POST["cognome"]?>" required placeholder="  ___________________________" <?php if($flagPost) {echo "disabled";} ?>>
            </td>
          </tr>

          <tr>
            <td> <label class="control-label" for="nome">Nome</label>
            </td>
            <td> <input type="text" name="nome" id="nome" value="<?php echo $_POST["nome"]?>" required placeholder="  ___________________________" <?php if($flagPost) {echo "disabled";} ?>>
            </td>
          </tr>
          </br>
          <tr>
            <td> <label class="control-label" for="cf" id="cfLabel" style="display:initial">Codice Fiscale</label>
            </td>
            <td> <input type="text" name="cf[]" maxlength="16" id="cf"
              value="<?php echo $cf ?>"
              required placeholder="  ___________________________" onchange="showSistemaRuolo()" <?php if($flagPost) {echo "disabled";} ?>>
            </td>
          </tr>
          <!-- Aggiunta 3 campi  solo per Apicoltori Autoconsumo-->
          <tr id="comuneRowSezFour" style="display: none">
            <td> <label class="control-label" for="comune">Comune</label>
            </td>
            <td> <input type="text" name="comune" id="comuneSezFour" value="" placeholder="Digitare comune e selezionarlo da lista">
            </td>
          </tr>

          <tr id="addressRowSezFour" style="display: none">
            <td> <label class="control-label">Indirizzo</label>
            </td>
            <td> <input type="text" name="address" id="addressSezFour" value="" placeholder="  ___________________________">
            </td>
          </tr>

          <tr id="capRowSezFour" style="display: none">
            <td> <label class="control-label">CAP</label>
            </td>
            <td> <input type="text" name="cap" id="capSezFour" value="" placeholder="  ___________________________">
            </td>
          </tr>

          <tr>
            <td> <label class="control-label" for="Indirizzo email">Indirizzo email *</label>
            </td>
            <td> <input type="text" name="indirizzo" id="indirizzo" value="" pattern="[^@\s]+@[^@\s]+\.[^@\s]+" required placeholder="  ___________________________">
            </td>
          </tr>

          <tr>
            <td> <label class="control-label" for="telefono">Telefono per ricontatto *</label>
            </td>
            <td> <input type="number" name="telefono" id="telefono" value="" title="Sono consentiti solo numeri." required placeholder="  ___________________________">
            </td>
          </tr>
          <!-- SOLO PER VET LIBERI PROF-->
          <tr id="provinciaOrdineVetRow" style="display: none">
            <td> <label class="control-label">Provincia dell’Ordine di iscrizione</label>
            </td>
            <td> <input type="text" name="provinciaOrdineVet" id="provinciaOrdineVet" value="" false placeholder="  ___________________________">
            </td>
          </tr>

          <tr id="numeroAutorizzazioneRegionaleVetRow" style="display: none">
            <td> <label class="control-label">Numero Autorizzazione Regionale</label>
            </td>
            <td> <input type="text" id="numeroAutorizzazioneRegionaleVet" value="" false placeholder="  ___________________________">
            </td>
          </tr>

          <tr id="numeroOrdineVetRow" style="display: none">
            <td> <label class="control-label">Numero di iscrizione all’Ordine</label>
            </td>
            <td> <input type="text" id="numeroOrdineVet" value="" false placeholder="  ___________________________">
            </td>
          </tr>

          <th colspan="2">SEZIONE 4 - Richiesta autorizzata da</th>

                  <tr id="identificativoEnteRow" style="display: none">
                    <td> <label class="control-label" for="Identificativo Ente">Identificativo Ente *</label>
                    </td>
                    <td> <input type="text" name="identificativoEnte" id="identificativoEnte" value="" placeholder="  ___________________________">
                    </td>
                  </tr>
                  <!-- mod SP -->
                  <tr id="identificativoEnteRowSP" style="display: none">
                    <td> <label class="control-label" for="Identificativo Ente SP">Identificativo Ente</label>
                    </td>
                    <td>
                      <select name="identificativoEnteSP" id="identificativoEnteSP" onchange="modificaEnteSP(this)">
                        <option value="-1" selected>Nessun valore selezionato</option>
                      </select>
                    </td>
                  </tr>

                  <tr id="aslEnteRow">
                    <td> <label class="control-label">ASL *</label>
                    </td>
                    <td> <select id="aslEnte" onchange="changeClinicheVam(this); changeaAmbitoGesdasic(this)">
                        <option value="-1" selected disabled>Seleziona ASL</option>
                      </select>
                    </td>
                  </tr>

                  <tr id="ambitiGesdasicRow" style="display: none">
                    <td> <label class="control-label">Ambito *</label>
                    </td>
                    <td> <select id="ambitiGesdasic">
                        <option value="null" selected>Tutti</option>
                      </select>
                    </td>
                  </tr>

                  <tr id="pIvaRow" style="display: none">
                    <td> <label class="control-label" for="pIva">P.IVA</label>
                    </td>
                    <td> <input type="text" name="pIva" id="pIva" maxlength="11" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="comuneRow" style="display: none">
                    <td> <label class="control-label" for="comune">Comune</label>
                    </td>
                    <td> <input type="text" name="comune" id="comune" value="" placeholder="Digitare comune e selezionarlo da lista">
                    </td>
                  </tr>

                  <tr id="addressRow" style="display: none">
                    <td> <label class="control-label">Indirizzo</label>
                    </td>
                    <td> <input type="text" name="address" id="address" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="capRow" style="display: none">
                    <td> <label class="control-label">CAP</label>
                    </td>
                    <td> <input type="text" name="cap" id="cap" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="referenteRow">
                    <td> <label class="control-label" for="referente"> Referente/Responsabile *</label>
                    </td>
                    <td> <input type="text" name="referente" id="referente" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="ruoloReferenteRow">
                    <td> <label class="control-label" for="Ruolo">Ruolo referente/responsabile *</label>
                    </td>
                    <td> <input type="text" name="ruolo" id="ruolo" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="indirizzoEnteRow">
                    <td> <label class="control-label" for="indirizzo email">Indirizzo email</label>
                    </td>
                    <td> <input type="text" name="indirizzoEnte" id="indirizzoEnte" value="" pattern="[^@\s]+@[^@\s]+\.[^@\s]+" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="pecRow">
                    <td> <label class="control-label" for="pec" id="pecLabel">PEC struttura di appartenenza</label>
                    </td>
                    <td> <input type="text" name="pec" id="pec" value="" required pattern="[^@\s]+@[^@\s]+\.[^@\s]+" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="telefonoEnteRow">
                    <td> <label class="control-label" for="telefonoEnte">Telefono per ricontatto *</label>
                    </td>
                    <td> <input type="number" name="telefonoEnte" id="telefonoEnte" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="codiceGisaRow" style="display: none">
                    <td> <label class="control-label">N. Registrazione Gisa</label>
                    </td>
                    <td> <input type="text" name="codiceGisa" id="codiceGisa" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="decretoPrefettizioRow" style="display: none">
                    <td> <label class="control-label">Numero Decreto prefettizio</label>
                    </td>
                    <td> <input type="text" name="decretoPrefettizio" id="decretoPrefettizio" value="" placeholder="  ___________________________">
                    </td>
                  </tr>

                  <tr id="decretoPrefettizioScadRow" style="display: none">
                    <td> <label class="control-label">Scadenza Decreto prefettizio</label>
                    </td>
                    <td> <input type="text" name="decretoPrefettizioScad" id="decretoPrefettizioScad" value="" placeholder="GG/MM/AAAA" pattern="\d{1,2}/\d{1,2}/\d{4}">
                    </td>
                  </tr>

                  <tr>

            <!-- SOLO PER VET LIBERI PROF-->
            <tr id="provinciaOrdineVetRow" style="display: none">
              <td> <label class="control-label">Provincia dell’Ordine di iscrizione</label>
              </td>
              <td> <input type="text" name="provinciaOrdineVet" id="provinciaOrdineVet" value="" false placeholder="  ___________________________">
              </td>
            </tr>

            <tr id="numeroAutorizzazioneRegionaleVetRow" style="display: none">
              <td> <label class="control-label">Numero Autorizzazione Regionale</label>
              </td>
              <td> <input type="text" id="numeroAutorizzazioneRegionaleVet" value="" false placeholder="  ___________________________">
              </td>
            </tr>

            <tr id="numeroOrdineVetRow" style="display: none">
              <td> <label class="control-label">Numero di iscrizione all’Ordine</label>
              </td>
              <td> <input type="text" id="numeroOrdineVet" value="" false placeholder="  ___________________________">
              </td>
            </tr>
            
            <th colspan="2" id="sez5Row">SEZIONE 5 - Profilazione</th>

            <tr id="ruoloGisaRow" style="display: none">
              <td> <label class="control-label" for="Ruolo GISA">Ruolo GISA</label>
              </td>
              <td> <select name="ruoloGisa" id="ruoloGisa">
                  <option value="-1" selected>Nessun valore selezionato</option>
                </select>
              </td>
            </tr>

            <tr id="ruoloVamRow" style="display: none">
              <td> <label class="control-label" for="Ruolo VAM">Ruolo VAM</label>
              </td>
              <td> <select name="ruoloVam" id="ruoloVam" onchange="changeRuoloVam()">
                  <option value="-1" selected>Nessun valore selezionato</option>
                </select>
              </td>
            </tr>

            <tr id="clinicheVamRow" style="display: none">
              <td> <label class="control-label" for="Cliniche VAM">Cliniche accessibili VAM</label>
              </td>
              <td> <select name="clinicheVam" id="clinicheVam" multiple size="4">
                  <!-- <option value="-1" selected>Nessun valore selezionato</option> -->
                </select>
              </td>
            </tr>

            <tr id="clinicheVamTextRow" style="display: none">
              <td> <label class="control-label">Cliniche accessibili VAM</label>
              </td>
              <td id="clinicheVamText"> 
              </td>
            </tr>

            <tr id="ruoloBduRow" style="display: none">
              <td> <label class="control-label" for="Ruolo BDU">Ruolo Banca Dati Anagrafe canina</label>
              </td>
              <td> <select name="ruoloBdu" id="ruoloBdu">
                  <option value="-1" selected>Nessun valore selezionato</option>
                </select>
              </td>
            </tr>

            <tr id="gestoriAcqueRow" style="display: none">
              <td> <label class="control-label">Gestore: </label>
              </td>
              <td> <select name="gestoreAcqua" id="gestoreAcqua">
                  <option value="-1">Nessun valore selezionato</option>
                </select>
              </td>
            </tr>

            <tr id="digemonRow" style="display: none">
              <td> <label class="control-label">DiGeMon: </label>
              </td>
              <td> <select name="digemon" id="digemon">
                  <option value="null" selected>Nessun valore selezionato</option>
                </select>
              </td>
            </tr>

            <tr id="giavaRow" style="display: none">
              <td> <label class="control-label">Autovalutazione OSA: </label>
              </td>
              <td> <select name="giava" id="giava">
                  <option value="false" selected>Nessun valore selezionato</option>
                <!--  <option value="true" id="optGiava">SI</option> -->
                </select>
              </td>
            </tr>

            <tr id="gesdasicRow" style="display: none">
              <td> <label class="control-label">Sicurezza lavoro: *</label>
              </td>
              <td> <select name="gesdasic" id="gesdasic" onchange="showAmbitiGesdasic(this)">
                  <option value="-1" selected>Nessun valore selezionato</option>
                <!--  <option value="true" id="optGiava">SI</option> -->
                </select>
              </td>
            </tr>

            <tr>
              <td> <label class="control-label">Data Richiesta</label>
              </td>
              <td> <input value="<?php echo date('d/m/Y') ?>" disabled>
              </td>
            </tr>
          </table>
	<div style="float:right"><strong>* campi obbligatori</strong></div>
        </div>

        <div>
          <button name="enter" class="btn btn-primary" onclick="save(event, false)" type="submit">Salva richiesta</button>
        </div>
        </br>
      </form>
    </div>
    <footer>
      <p><a href="https://gisasicurezzalavoro-coll.regione.campania.it/assets/informativaPrivacy.html" target="_blank">Informativa privacy</a></p>
      <p><a href="https://github.com/regione-campania/GISA/tree/main/modulo_spid_cie">Codice sorgente disponibile sul repository Github della Regione Campania</a></p>
    </footer>
  </div>

</body>

</html>
