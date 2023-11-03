<%@ page import="org.json.*"%>

<%
org.json.JSONObject json = new JSONObject(request.getAttribute("res").toString());
%>

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
<a href="deltautenti.toDeltaUtenti.us" style="font-size: 20px">Indietro</a><br><br>
<%= !json.has("0") ? "Nessun Utenza da Allineare" : "" %>

<table class="details">
<%
for(int i=0;i<json.length();i++){
	if(json.has(Integer.toString(i))){
		JSONObject jsonI = (JSONObject) json.get(Integer.toString(i));

		if(jsonI.has("ListaEndPoint")){
			JSONArray jsonEsitoListaEndPoint = (JSONArray) jsonI.get("ListaEndPoint");
			for (int j = 0; j<jsonEsitoListaEndPoint.length(); j++){
				JSONObject jsonEndPoint = (JSONObject) jsonEsitoListaEndPoint.get(j);
				if(jsonEndPoint.has("Risultato")){
					JSONArray jsonEndPointRisultatoArray = (JSONArray)  jsonEndPoint.get("Risultato");
					JSONObject jsonEndPointRisultato = null;
					
					if (jsonEndPointRisultatoArray!=null && jsonEndPointRisultatoArray.length()>0)
						 jsonEndPointRisultato = (JSONObject) jsonEndPointRisultatoArray.get(0);
					
					 if (jsonEndPointRisultato!=null && jsonEndPointRisultato.has("Esito")){ %>
					<tr><th colspan="2">ESITO OPERAZIONE SU SISTEMA <%=jsonEndPoint.get("EndPoint") %></th></tr>
							<tr><td align="right">RICHIESTA PROCESSATA</td> <td><%=jsonEndPointRisultato.get("Esito") %></td></tr>
						<% if (jsonEndPointRisultato.has("DescrizioneErrore") && !jsonEndPointRisultato.get("DescrizioneErrore").equals("")){ %>
							<tr><td align="right">DESCRIZIONE ERRORE</td> <td><%=jsonEndPointRisultato.get("DescrizioneErrore") %></td></tr>	
						<% }
					}
				}
			}
		}
	}
}
%>
</table>
</div>