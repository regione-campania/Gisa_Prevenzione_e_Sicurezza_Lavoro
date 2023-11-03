<%@page import="java.util.ArrayList"%>
<%@page import="it.us.web.bean.deltautenti.EndpointDelta"%>
<%@page import="it.us.web.db.ApplicationProperties"%>
<%@page import="it.us.web.bean.messaggi.Messaggio"%>

<jsp:useBean id="messaggioGenerico" class="it.us.web.bean.messaggi.Messaggio" scope="request"/>


<%@ include file="../guc/modalWindow.jsp"%>

<style>
 .details{
    border-collapse: collapse;
 }
 .details td{
 	border: 1px solid #ddd;
 	padding: 10px;
 }
 .details th{
 	padding: 10px;
 }
</style>

<div align="center">
<% if(request.getParameter("iframe") == null){ %>
<a href="messaggi.toMessaggi.us" style="font-size: 20px">Indietro</a>
<br><br><br>
<% } %>
<form action="messaggi.Messaggi.us">
<input type="hidden" id="salva" name="salva" value="salva"/>
<input type="hidden" id="iframe" name="iframe" value="<%= request.getParameter("iframe") %>"/>
<table class="details" align="center">
	<tr>
		<th colspan="2">Aggiungi Messaggio</th>
	</tr>
	<tr>
		<td>HEADER</td>
		<td><textarea id="header" name="header" cols="50" rows="5"><%= messaggioGenerico.getHeader() != null ? messaggioGenerico.getHeader() : "" %></textarea></td>
	</tr>
	<tr>
		<td>BODY</td>
		<td><textarea id="body" name="body" cols="50" rows="5"><%= messaggioGenerico.getBody() != null ? messaggioGenerico.getBody() : "" %></textarea></td>
	</tr>
	<tr>
		<td>FOOTER</td>
		<td><textarea id="footer" name="footer" cols="50" rows="5"><%= messaggioGenerico.getFooter() != null ? messaggioGenerico.getFooter() : "" %></textarea></td>
	</tr>
	<tr>
		<td align="right">ENDPOINT</td>
    <td>
    	<% if(messaggioGenerico.getEndpoint() != null){ %>
    		<input type="hidden" id="endpoint" name="endpoint" value="<%= messaggioGenerico.getEndpoint() %>"/>
    		<%= messaggioGenerico.getEndpoint().toUpperCase() %>
    	<% }else{ %>
		    <% ArrayList<EndpointDelta> listaEndpoint = (ArrayList<EndpointDelta>)request.getAttribute("listaEndpoint"); %>
			<select id="endpoint" name="endpoint">
			<option value="-1">-- SELEZIONA --</option>
			<% if(listaEndpoint.size() > 0){
					for(EndpointDelta ep : listaEndpoint){
						if(!ApplicationProperties.getAmbiente().toUpperCase().contains(ep.getNome().toUpperCase())){
			%>
						<option value="<%= ep.getNome() %>"><%= ep.getNome().toUpperCase() %></option>
			<% 			}
					} 
			   }
			%>
			</select><font color="red">&nbsp*</font>
		<% } %>
    </td>
	</tr>
</table>
<br>
<input type="button" value="SALVA" onclick="checkForm(this.form)"/>
<input type="button" value="SVUOTA" onclick="rimuoviMessaggioCorrente()"/>
</form>
<br>

<table class="details">
<tr><th>Gestione messaggio riavvio</th></tr>
<tr><td colspan="4"> <textarea id="messaggioRiavvio" cols="95" rows="5">
#######<br/>
AVVISO RIAVVIO<br/>Si avvisa che #DATA# alle ore #ORA# il sistema subira' un'interruzione per un intervento di manutenzione programmata.<br/>
Il sistema tornera' disponibile dopo pochi minuti.<br/>
Ci scusiamo per il disagio.<br/>
#######<br/>
</textarea>
</td></tr>
<tr>
<td><b>Data</b> <input type="text" id="data" name="data" size="15" value=""/>
<b>Ora</b><input type="text" id="ora" name="ora" size="5" value=""/>
<input type="button" value="AGGIUNGI MESSAGGIO DI RIAVVIO" onClick="aggiungiMessaggioRiavvio()"/>
<input type="button" value="RIMUOVI MESSAGGIO DI RIAVVIO" onClick="rimuoviMessaggioRiavvio()"/></td></tr>
</table>

</div>

<script>
<%-- 	$('#endpoint').val('<%= endpointSel %>').change(); --%>

let d = new Date();
let date = d.toLocaleDateString("it-IT",{ day: "2-digit", month: "2-digit", year: "numeric" });
let time = d.toLocaleTimeString("it-IT",{ hour: "2-digit", minute: "2-digit" }); 
document.getElementById("data").value = "oggi "+date;
document.getElementById("ora").value = time;

function aggiungiMessaggioRiavvio(){
	var data = document.getElementById("data").value;
	var ora = document.getElementById("ora").value;
	var msg = document.getElementById("messaggioRiavvio").value;
	msg = msg.replace("#DATA#", data);
	msg = msg.replace("#ORA#", ora);
	document.getElementById("body").value = msg;
}

function rimuoviMessaggioRiavvio(){

	var messaggio = document.getElementById("body").value;
	var rx = new RegExp("#######[\\d\\D]*?\#######<br/>", "g");
	messaggio = messaggio.replace(rx, "");
	var messaggioNuovo = messaggio.trim();
	document.getElementById("body").value = messaggioNuovo;
}

function rimuoviMessaggioCorrente(){
	$("#header").val('');
	$("#body").val('');
	$("#footer").val('');
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, 'g'), replace);
}

function fixaHtml( id ){
	var temp = $( '#' + id ).val();
	
	temp=replaceAll(temp,"à", "a'");
    temp=replaceAll(temp,"è", "e'");
    temp=replaceAll(temp,"ì", "i'");
    temp=replaceAll(temp,"ò", "o'");
    temp=replaceAll(temp,"ù", "u'");
    
    temp=replaceAll(temp,"á", "a'");
    temp=replaceAll(temp,"é", "e'");
    temp=replaceAll(temp,"í", "i'");
    temp=replaceAll(temp,"ó", "o'");
    temp=replaceAll(temp,"ú", "u'");
    
    temp=replaceAll(temp,"À", "A'");
    temp=replaceAll(temp,"È", "E'");
    temp=replaceAll(temp,"Ì", "I'");
    temp=replaceAll(temp,"Ò", "O'");
    temp=replaceAll(temp,"Ù", "U'");
    
    temp=replaceAll(temp,"Á", "A'");
    temp=replaceAll(temp,"É", "E'");
    temp=replaceAll(temp,"í", "I'");
    temp=replaceAll(temp,"Ó", "O'");
    temp=replaceAll(temp,"Ú", "U'");
	
	$( '#' + id ).val( temp );
}

function checkForm(form){
	
	//fixa html
	fixaHtml('header');
	fixaHtml('body');
	fixaHtml('footer');
	
	//elimina newline
	$("#header").val($("#header").val().replaceAll("\n", ""));
	$("#body").val($("#body").val().replaceAll("\n", ""));
	$("#footer").val($("#footer").val().replaceAll("\n", ""));
	
	//elimina spazi superflui
	$("#header").val($("#header").val().trim());
	$("#body").val($("#body").val().trim());
	$("#footer").val($("#footer").val().trim());
	
	 formTest = true;
	 message = "";
	 
	 if (document.getElementById('endpoint').value == '-1') {
		 message += "- Selezionare un endpoint.\r\n";
	     formTest = false;
	 }
	 
	 if (formTest == false) {
		 alert("La form non può essere salvata, si prega di verificare quanto segue:\r\n\r\n" + message);
	     return false;
	 }else{
		 if(confirm("Salvare il messaggio?")){
			 loadModalWindow();
			 form.submit();
		 }
	 }
}
</script>