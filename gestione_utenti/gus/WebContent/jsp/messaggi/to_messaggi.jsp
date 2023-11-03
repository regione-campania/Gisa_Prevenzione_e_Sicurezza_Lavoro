<%@page import="it.us.web.bean.messaggi.Messaggio"%>
<%@ include file="../guc/modalWindow.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="it.us.web.bean.deltautenti.EndpointDelta"%>

<% ArrayList<EndpointDelta> listaEndpoint = (ArrayList<EndpointDelta>)request.getAttribute("listaEndpoint"); %>
<% ArrayList<Messaggio> listaMessaggi = (ArrayList<Messaggio>)request.getAttribute("listaMessaggi"); %>

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
<a href="Index.us" style="font-size: 20px">Indietro</a>
<br><br><br>
<% if(listaMessaggi.size() < listaEndpoint.size()){ %>
	<form action="messaggi.Messaggi.us">
		<input type="submit" value="AGGIUNGI" />
	</form>
	<br>
<% }
   if(listaMessaggi.size() > 0){
%>
	<table class="details" align="center">
		<tr>
			<th>ID</th>
			<th>ENTERED</th>
			<th>ENTERED BY</th>
			<th>HEADER</th>
			<th>BODY</th>
			<th>FOOTER</th>
			<th>ENDPOINT</th>
			<th>AZIONI</th>
		</tr>
		<%
				for(Messaggio messaggioGenerico : listaMessaggi){
						if(messaggioGenerico.getId() > 0){
			%>
						<tr>
							<td><%= messaggioGenerico.getId() %></td>
							<td><%= fixData(messaggioGenerico.getEntered().toString()) %></td>
							<td><%= messaggioGenerico.getEntered_by() %></td>
							<td><%= messaggioGenerico.getHeader() %></td>
							<td><%= messaggioGenerico.getBody() %></td>
							<td><%= messaggioGenerico.getFooter() %></td>
							<td><%= messaggioGenerico.getEndpoint() %></td>
							<td>
								<form action="messaggi.Messaggi.us">
									<input type="hidden" id="endpoint" name="endpoint" value="<%= messaggioGenerico.getEndpoint() %>" />
									<input type="submit" value="MODIFICA" />
								</form>
							</td>
						</tr>
			<% 			}
					} 
			%>
	</table>
	<% if(request.getAttribute("risultato") != null && request.getAttribute("risultato").equals("OK") ){ %>
		<br>
		<font color="green">MESSAGGIO INSERITO CORRETTAMENTE</font>
	<% } %>
<% } %>
</div>