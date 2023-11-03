<%@page import="java.util.ArrayList"%>
<%@page import="it.us.web.bean.deltautenti.Utenze"%>
<%@page import="it.us.web.bean.guc.Asl"%>
<%@page import="it.us.web.bean.guc.Ruolo"%>

<%@ include file="../guc/modalWindow.jsp"%>

<style>
 .details{
    border-collapse: collapse;
    width: 50%;
 }
 .details td{
 	border: 1px solid #ddd;
 	padding: 10px;
 }
</style>
<div align="center">
<a href="deltautenti.toDeltaUtenti.us" style="font-size: 20px">Indietro</a><br><br>
<br><br><br>
<% ArrayList<Utenze> utenze = (ArrayList<Utenze>)request.getAttribute("utenze");
ArrayList<Asl> listaAsl = (ArrayList<Asl>)request.getAttribute("listaAsl");
ArrayList<Ruolo> ruoliBDU = (ArrayList<Ruolo>)request.getAttribute("ruoliBDU");
ArrayList<Ruolo> ruoliGISA = (ArrayList<Ruolo>)request.getAttribute("ruoliGISA");
ArrayList<Ruolo> ruoliDIGEMON = (ArrayList<Ruolo>)request.getAttribute("ruoliDIGEMON");
ArrayList<Ruolo> ruoliVAM = (ArrayList<Ruolo>)request.getAttribute("ruoliVAM");


if(utenze.size() > 0){
%>
UTENZE NON ALLINEATE PER: <b><%= utenze.get(0).getNome() %> <%= utenze.get(0).getCognome() %> - <%= utenze.get(0).getCodiceFiscale() %></b> 
<table class="details">
	<tr>
		<th>Endpoint</th>
		<th>Ruolo</th>
		<th>Asl</th>
	</tr>
<%
	for(Utenze ut : utenze){ 		
%>
<tr>
	<td><%= ut.getEndpoint() %></td>
	<td>
	<%
	if(ut.getEndpoint().equals("bdu")){
		for(int i=0; i<ruoliBDU.size();i++){
			if(ruoliBDU.get(i).getRuoloInteger() == ut.getRuoloInteger()){
				%><%= ruoliBDU.get(i).getRuoloString() %><%
			}
		}
	}else if(ut.getEndpoint().equals("Gisa")){
		for(int i=0; i<ruoliGISA.size();i++){
			if(ruoliGISA.get(i).getRuoloInteger() == ut.getRuoloInteger()){
				%><%= ruoliGISA.get(i).getRuoloString() %><%
			}
		}
	}else if(ut.getEndpoint().equals("Digemon")){
		for(int i=0; i<ruoliDIGEMON.size();i++){
			if(ruoliDIGEMON.get(i).getRuoloInteger() == ut.getRuoloInteger()){
				%><%= ruoliDIGEMON.get(i).getRuoloString() %><%
			}
		}
	}else if(ut.getEndpoint().equals("Vam")){
		for(int i=0; i<ruoliVAM.size();i++){
			if(ruoliVAM.get(i).getRuoloInteger() == ut.getRuoloInteger()){
				%><%= ruoliVAM.get(i).getRuoloString() %><%
			}
		}
	}else{
		%><%= ut.getRuoloInteger() %><%
	}
	
	%>

	</td>
	<td>
	<% 
	for(int i=0; i<listaAsl.size();i++){
		if(listaAsl.get(i).getId() == ut.getAslId()){
			%><%= listaAsl.get(i).getNome() %><%
		}
	}
	%>
	</td>
</tr> <%
	} %>
</table>
	<br>Proseguire con l'allineamento?
<form id="invioDelta" action="deltautenti.DeltaUtenti.us">
	<div style="display:none">
		<input type="text" id="codice_fiscale" name="codice_fiscale" value="<%= request.getParameter("codice_fiscale")%>" />
		<input type="text" id="ambiente" name="ambiente" value="<%= request.getParameter("ambiente")%>" />
		<input type="text" id="endpoint" name="endpoint" value="<%= request.getAttribute("endpointCAT")%>" />
	</div>
	<br>
	<input type="submit" value="SI" onclick="loadModalWindow();"/> <input type="button" value="NO" onclick="loadModalWindow();window.location.href= 'deltautenti.toDeltaUtenti.us' " />
</form>
<%	
}else{
%>
Nessun Utenza da Allineare.

<% } %>

</div>
