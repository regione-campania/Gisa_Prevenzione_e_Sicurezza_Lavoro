<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage=""%>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>
<%@ taglib uri="/WEB-INF/jmesa.tld" prefix="jmesa" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<%@page import="it.us.web.bean.validazione.*"%>
<%@ page import="org.json.*"%>
<jsp:useBean id="dettaglioRichiesta" class="it.us.web.bean.validazione.Richiesta" scope="request"/>
<%@ include file="../guc/modalWindow.jsp"%>
<%@ include file="../guc/initPage.jsp"%>

<link rel="stylesheet" type="text/css" href="js/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="js/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>

<script type="text/javascript" src="js/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="js/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="js/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="js/jquerypluginTableSorter/tableJqueryFilterDialogEpc.js"></script>

<style>
table {border-collapse: collapse;}
table th, tr, td {border: 1px solid black; padding: 15px 10px 15px 15px;}
table th {background: 06bbff; font-weight: bold;}
</style>

<script>
function rifiutaRichiesta(){
	
	$("#dialogRifiuta").dialog("close");
	$("#idTipoOperazione").val("999");
	document.getElementById("formRichiesta").action="validazione.Validazione.us";
	document.getElementById("formRichiesta").submit();
} 


function processaRichiesta(){
	
	$("#dialogProcessa").dialog("close");
	document.getElementById("formRichiesta").action="validazione.Validazione.us";
	document.getElementById("formRichiesta").submit();
		
} 

function mostraProcessa(){ 
	loadModalWindow();
	$("#dialogProcessa").dialog();
}
function nascondiProcessa(){
	loadModalWindowUnlock();
	$("#dialogProcessa").dialog("close");
}

function mostraRifiuta(){ 
	loadModalWindow();
	$("#dialogRifiuta").dialog();
}
function nascondiRifiuta(){
	loadModalWindowUnlock();
	$("#dialogRifiuta").dialog("close");
}
</script>


 <%! public static String fixData(String timestring)
  {
	  String toRet = "";
	  if (timestring == null)
		  return toRet;
	  String anno = timestring.substring(0,4);
	  String mese = timestring.substring(5,7);
	  String giorno = timestring.substring(8,10);
	  String ora = timestring.substring(11,13);
	  String minuto = timestring.substring(14,16);
	  String secondi = timestring.substring(17,19);
	  toRet =giorno+"/"+mese+"/"+anno+" "+ora+":"+minuto+":"+secondi;
	  return toRet;
	  
  }%>
  
  
<div align="center">
		<a href="validazione.ToValidazione.us" onClick="loadModalWindow();" style="margin: 0px 0px 0px 50px; font-size: 20px">Indietro</a>
	</div>
<br/><br/>

<% if (dettaglioRichiesta.getEsito()!=null && !dettaglioRichiesta.getEsito().equals("")){
	JSONObject jsonEsito = new JSONObject(dettaglioRichiesta.getEsito()); %>
	
	<center>
	<table>
	<tr><th colspan="2">ESITO OPERAZIONE SU SISTEMA CENTRALIZZATO</th></tr>
	
	<% if (jsonEsito.has("Esito")){ %>
	<tr><th>RICHIESTA ACCETTATA</th> <td><%=jsonEsito.get("Esito")%></td></tr>
	<%} %>
	<% if (jsonEsito.has("DescrizioneErrore") && !jsonEsito.get("DescrizioneErrore").equals("")){ %>
	<tr><th>DESCRIZIONE ERRORE</th> <td><%=jsonEsito.get("DescrizioneErrore")%></td></tr>
	<%} %>
	<% if (jsonEsito.has("CodiceFiscale")){ %>
	<tr><th>CODICE FISCALE</th> <td><%=jsonEsito.get("CodiceFiscale")%></td></tr>
	<%} %>
	
	<% if (jsonEsito.has("ListaEndPoint")) { %>
	
	<%  JSONArray jsonEsitoListaEndPoint = (JSONArray) jsonEsito.get("ListaEndPoint"); 

		for (int i = 0; i<jsonEsitoListaEndPoint.length(); i++){
			
			JSONObject jsonEndPoint = null;
			JSONArray jsonEndPointRisultatoArray = null;
			JSONObject jsonEndPointRisultato = null;
			
			jsonEndPoint = (JSONObject) jsonEsitoListaEndPoint.get(i);
			
			if (jsonEndPoint.has("Risultato"))
				jsonEndPointRisultatoArray = (JSONArray)  jsonEndPoint.get("Risultato");
			
		if (jsonEndPointRisultatoArray!=null && jsonEndPointRisultatoArray.length()>0)
			jsonEndPointRisultato = (JSONObject) jsonEndPointRisultatoArray.get(0);
	%>
		
		<% if (jsonEndPointRisultato!=null && jsonEndPointRisultato.has("Esito")){ %>
		<tr><th colspan="2">ESITO OPERAZIONE SU SISTEMA <%=jsonEndPoint.get("EndPoint") %></th></tr>
				<tr><th>RICHIESTA ACCETTATA</th> <td><%=jsonEndPointRisultato.get("Esito") %></td></tr>
			<% if (jsonEndPointRisultato.has("DescrizioneErrore") && !jsonEndPointRisultato.get("DescrizioneErrore").equals("")){ %>
				<tr><th>DESCRIZIONE ERRORE</th> <td><%=jsonEndPointRisultato.get("DescrizioneErrore") %></td></tr>	
			<%} %>
			<%} %>
		<%} } %>
	</table>
	</center>

<br/><br/>
<% } else if (dettaglioRichiesta.getStato()== Richiesta.STATO_DA_VALIDARE) { %>
	<center>
	<table>
	<tr><td colspan="2">RICHIESTA ANCORA NON ACCETTATA.</td></tr>
	</table>
	</center>
	<br/><br/>
	
<% } else if (dettaglioRichiesta.getStato()== Richiesta.STATO_RIFIUTATA) { %>
	<center>
	<table>
	<tr><td colspan="2">RICHIESTA RIFIUTATA.</td></tr>
	</table>
	</center>
	<br/><br/>
	
<%} %>

<form method="post" action = "validazione.Validazione.us" id="formRichiesta" name="formRichiesta">

<center>
<table cellpadding="10" style="width: 90%;">
<col width="20%">
<tr style="background: yellow"><th>Tipo richiesta</th><td><%=toHtml(dettaglioRichiesta.getTipoRichiesta()) %></td></tr>
<tr><th>Numero richiesta</th><td><%=toHtml(dettaglioRichiesta.getNumeroRichiesta()) %></td></tr>
<tr><th>Tipologia utente</th><td><%=toHtml(dettaglioRichiesta.getTipologiaUtente()) %></td></tr>
<tr><th>Cognome</th><td><%=toHtml(dettaglioRichiesta.getCognome()) %></td></tr>
<tr><th>Nome</th><td><%=toHtml(dettaglioRichiesta.getNome()) %></td></tr>
<tr><th>Codice fiscale</th><td><%=toHtml(dettaglioRichiesta.getCodiceFiscale()) %></td></tr>
<tr><th>Email</th><td><%=toHtml(dettaglioRichiesta.getEmail()) %></td></tr>
<tr><th>Telefono</th><td><%=toHtml(dettaglioRichiesta.getTelefono()) %></td></tr>

<% if (dettaglioRichiesta.getIdGucRuoli() > 0) { %>
	<tr><th colspan="2">Sistema/Ruolo precedenti</th></tr>
	<tr><th>Sistema</th><td><%=toHtml(dettaglioRichiesta.getEndpointGucRuoli())%></td></tr>
	<tr><th>Ruolo</th><td><%=dettaglioRichiesta.getRuoloGucRuoli() %></td></tr>

<% } %>

<% if (dettaglioRichiesta.getIdRuoloGisa() > 0) { %>
	<tr><th colspan="2">GISA</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloGisa())%></td></tr>
	
	<% if (dettaglioRichiesta.getIdTipoRichiesta()!=Richiesta.TIPO_ELIMINAZIONE){ %>
		<tr><th>Flag aggiuntivi</th> <td>
				
		<% if (dettaglioRichiesta.getIdTipologiaUtente() == 1 || dettaglioRichiesta.getIdTipologiaUtente() == 2 || dettaglioRichiesta.getIdTipologiaUtente() == 15 || dettaglioRichiesta.getIdTipologiaUtente() == 19) {%>
		<input type="checkbox" id="inNucleo" name="inNucleo" value="true" <%=dettaglioRichiesta.getStato() != Richiesta.STATO_DA_VALIDARE ? "disabled" : "" %> <%=Boolean.TRUE.equals(dettaglioRichiesta.getInNucleo()) ? "checked" : "" %> <%=(dettaglioRichiesta.getIdTipologiaUtente() == 15) ? "checked onClick='return false';" : "" /* CENTRI DI RIFERIMENTO: HANNO SEMPRE NUCLEO ISPETTIVO = TRUE*/ %>/> Il nominativo può essere selezionato nel Nucleo Ispettivo?	<br/>
		<% } %>
		
		<% if (dettaglioRichiesta.getIdTipologiaUtente() == 1) {%>
		<input type="checkbox" id="inDpat" name="inDpat" value="true" <%=dettaglioRichiesta.getStato() != Richiesta.STATO_DA_VALIDARE ? "disabled" : "" %> <%=Boolean.TRUE.equals(dettaglioRichiesta.getInDpat()) ? "checked" : "" %>/> Il nominativo può appartenere ad un organigramma?
		<% } %>
				
		</td></tr>
	<% } %>
	
	<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoGisa() ? "OK" : "PENDENTE" %></td></tr>
	
<% } %>

<% if (dettaglioRichiesta.getIdRuoloGisaExt() > 0) { %>
	<tr><th colspan="2">GISA</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloGisaExt()) %></td></tr>
	
	<% if (dettaglioRichiesta.getIdTipoRichiesta()!=Richiesta.TIPO_ELIMINAZIONE){ %>
		<tr><th>Flag aggiuntivi</th> <td>
		
		<% if (dettaglioRichiesta.getIdTipologiaUtente() == 1 || dettaglioRichiesta.getIdTipologiaUtente() == 2 || dettaglioRichiesta.getIdTipologiaUtente() == 15 || dettaglioRichiesta.getIdTipologiaUtente() == 19) {%>
		<input type="checkbox" id="inNucleo" name="inNucleo" value="true" <%=dettaglioRichiesta.getStato() != Richiesta.STATO_DA_VALIDARE ? "disabled" : "" %> <%=Boolean.FALSE.equals(dettaglioRichiesta.getInNucleo()) ? "" : "checked" %>/> Il nominativo può essere selezionato nel Nucleo Ispettivo?	
		<% } %>
		
		</td></tr>
	<% } %>
	
		<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoGisaExt() ? "OK" : "PENDENTE" %></td></tr>
<% } %>

<% if (dettaglioRichiesta.getIdRuoloBdu() > 0) { %>
	<tr><th colspan="2">BDR</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloBdu()) %></td></tr>
	<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoBdu() ? "OK" : "PENDENTE" %></td></tr>
	<% } %>

<% if (dettaglioRichiesta.getIdRuoloVam() > 0) { %>
	<tr><th colspan="2">VAM</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloVam()) %></td></tr>
	<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoVam() ? "OK" : "PENDENTE" %></td></tr>
<% } %>

<% if (dettaglioRichiesta.getIdRuoloDigemon() > 0) { %>
	<tr><th colspan="2">DIGEMON</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloDigemon()) %></td></tr>
	<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoDigemon() ? "OK" : "PENDENTE" %></td></tr>
<% } %>

<% if (dettaglioRichiesta.getIdRuoloSicurezzaLavoro() > 0) { %>
	<tr><th colspan="2">GISA Prevenzione e Sicurezza sui luoghi di lavoro</th></tr>
	<tr><th>Ruolo</th><td><%=toHtml(dettaglioRichiesta.getRuoloSicurezzaLavoro()) %></td></tr>
	<tr><th>Stato</th><td><%=dettaglioRichiesta.getEsitoSicurezzaLavoro() ? "OK" : "PENDENTE" %></td></tr>
<% } %>
	
<tr><th colspan="2">Altre informazioni</th></tr>
<tr><th>ASL</th><td><%=toHtml(dettaglioRichiesta.getAsl()) %></td></tr>
<tr><th>Referente/Responsabile</th><td><%=toHtml(dettaglioRichiesta.getNominativoReferente()) %></td></tr>
<tr><th>Ruolo Referente/Responsabile</th><td><%=toHtml(dettaglioRichiesta.getRuoloReferente()) %></td></tr>
<tr><th>Telefono referente</th><td><%=toHtml(dettaglioRichiesta.getTelefonoReferente()) %></td></tr>
<tr><th>Data richiesta</th><td><%=fixData(dettaglioRichiesta.getDataRichiesta().toString()) %></td></tr>
<tr><th>PEO</th><td><%=toHtml(dettaglioRichiesta.getPec()) %></td></tr>

<tr><th>Stato</th><td><%= dettaglioRichiesta.getStato() == Richiesta.STATO_DA_VALIDARE ? "DA VALIDARE" : dettaglioRichiesta.getStato() == Richiesta.STATO_COMPLETATA ? "COMPLETATA" : dettaglioRichiesta.getStato() == Richiesta.STATO_RIFIUTATA ? "RIFIUTATA" :  ""%></td></tr>

<tr><td colspan="2">
<center>

<% if (dettaglioRichiesta.getStato() == Richiesta.STATO_DA_VALIDARE){ %>
<input type="button" style="background: red; width:500px; height: 50px; font-size: 20px" value="RIFIUTA" onClick="mostraRifiuta()"/>
<input type="button" value="ACCETTA" style="width:500px; height: 50px; font-size: 20px" onClick="mostraProcessa()"/>
<% } %>
</center>
</td>
</table>
</center>

<input type="hidden" id="numeroRichiesta" name="numeroRichiesta" value="<%=dettaglioRichiesta.getNumeroRichiesta()%>"/>
<input type="hidden" id="idTipoOperazione" name="idTipoOperazione" value="<%=dettaglioRichiesta.getIdTipoRichiesta()%>"/>


</form>	


<div id="dialogProcessa" style="display: none;" title="Registrazione Prevenzione e Sicurezza sui luoghi di lavoro">
<div align="center">Accettare questa richiesta?

<input type="button" id="buttonAnnulla" value="ANNULLA" style="width:100px; height: 50px; font-size: 15px" onClick="nascondiProcessa()"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" id="buttonProcessa" value="ACCETTA" style="width:100px; height: 50px; font-size: 15px" onClick="processaRichiesta()"/>
</div>
</div>

<div id="dialogRifiuta" style="display: none;" title="Registrazione Prevenzione e Sicurezza sui luoghi di lavoro">
<div align="center">Rifiutare questa richiesta?

<input type="button" id="buttonAnnulla" value="ANNULLA" style="width:100px; height: 50px; font-size: 15px" onClick="nascondiRifiuta()"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" id="buttonRifiuta" value="RIFIUTA" style="width:100px; height: 50px; font-size: 15px" onClick="rifiutaRichiesta()"/>
</div>
</div>
