<%@page import="java.util.ArrayList"%>
<%@page import="it.us.web.bean.deltautenti.EndpointDelta"%>
<%@page import="it.us.web.bean.deltautenti.AmbientiDelta"%>
<%@page import="it.us.web.db.ApplicationProperties"%>


<%@ include file="../guc/modalWindow.jsp"%>

<style>
 .details{
    border-collapse: collapse;
 }
 .details td{
 	border: 1px solid #ddd;
 	width: 50%;
 	padding: 10px;
 }
</style>
<div align="center">
<a href="validazione.ToValidazione.us" style="font-size: 20px">Indietro</a>
<br><br><br>
<form id="invioRiepilogo" action="deltautenti.Riepilogo.us">
<table class="details" align="center">
  <tr><th colspan="2">Allinea DELTA utenti</th></tr>
  <tr>
    <td align="right">AMBIENTE</td>
    <td>
	    <% ArrayList<AmbientiDelta> listaAmbienti = (ArrayList<AmbientiDelta>)request.getAttribute("deltaAmbienti"); %>
		<select id="ambiente" name="ambiente">
		<option value="-1">-- SELEZIONA --</option>
		<% if(listaAmbienti.size() > 0){
				for(AmbientiDelta am : listaAmbienti){
					if(!ApplicationProperties.getAmbiente().toUpperCase().contains(am.getNome().toUpperCase())){
		%>
					<option value="<%= am.getNome() %>"><%= am.getNome() %></option>
		<% 			}
				} 
		   }
		%>
		</select><font color="red">&nbsp*</font>
    </td>
  </tr>
  <tr>
    <td align="right">ENDPOINT</td>
    <td>
	    <% ArrayList<EndpointDelta> listaEndpoint = (ArrayList<EndpointDelta>)request.getAttribute("deltaEndpoint"); %>
		<select id="endpoint" name="endpoint" multiple >
		<% if(listaEndpoint.size() > 0){
				for(EndpointDelta ep : listaEndpoint){
					if(!ApplicationProperties.getAmbiente().toUpperCase().contains(ep.getNome().toUpperCase())){
		%>
					<option value="<%= ep.getNome() %>"><%= ep.getNome() %></option>
		<% 			}
				} 
		   }
		%>
		</select><font color="red">&nbsp*</font>
    </td>
  </tr>
  <tr>
    <td align="right">Codice Fiscale</td>
    <td>	
    	<input type="text" id="codice_fiscale" name="codice_fiscale" maxlength="16"/><font color="red">&nbsp*</font>
	</td>
  </tr>
</table>
<br>
<input type="button" value="VERIFICA" onclick="checkForm(this.form)">


</form>

<script>
 function checkForm(form){
	 
	 document.getElementById('codice_fiscale').value = document.getElementById('codice_fiscale').value.trim();
	 
	 formTest = true;
	 message = "";
	 
	 if (document.getElementById('ambiente').value == -1) {
		 message += "- Selezionare un ambiente di origine.\r\n";
	     formTest = false;
	 }
	 
	 if (document.getElementById('endpoint').value == '') {
		 message += "- Selezionare almeno un endpoint.\r\n";
	     formTest = false;
	 }
	 if (document.getElementById('codice_fiscale').value == '' || document.getElementById('codice_fiscale').value.length != 16){
		 //if(document.getElementById('codice_fiscale').value.length != 16){
			 message += "- Inserire un codice fiscale valido.\r\n";
		     formTest = false;
		 //}
	 }
	 
	 
	 if (formTest == false) {
		 alert("La form non può essere salvata, si prega di verificare quanto segue:\r\n\r\n" + message);
	     return false;
	 }else{
		 loadModalWindow();
		 form.submit();
	 }
 }
 
</script>