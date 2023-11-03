<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>

<%@page import="java.util.*"%>
<%@page import="it.us.web.util.guc.*"%>
<%@page import="it.us.web.bean.guc.*"%>
<jsp:useBean id="UserRecord" class="it.us.web.bean.BUtente" scope="request"/>

<div id="content" align="center">

	<div align="center">
	<a href="Home.us" style="margin: 0px 0px 0px 50px"><img src="images/lista.png" height="18px" width="18px" />Lista Utenti</a>
	<a href="guc.ToAddEditAdministrator.us?id=${UserRecord.id}&operation=edit" style="margin: 0px 0px 0px 50px"><img src="images/edit.gif" height="18px" width="18px" />Modifica Utente Amministratore</a>
	<a href="guc.ToAddEditAdministrator.us?operation=add" style="margin: 0px 0px 0px 50px"><img src="images/add.png" height="18px" width="18px" />Aggiungi Utente Amministratore</a>
	</div>
 
	<h4 class="titolopagina">Dettaglio Utente Amministratore</h4>

		<table cellpadding="4" cellspacing="0" border="0" width="100%"
			class="details">
			<tr>
				<td class="formLabel">Nome</td>
				<td>${UserRecord.nome}</td>
			</tr>
			<tr>
				<td class="formLabel">Cognome</td>
				<td>${UserRecord.cognome}</td>
			</tr>
			<tr>
				<td class="formLabel">Codice fiscale</td>
				<td>${UserRecord.codiceFiscale}</td>
			</tr>
			<tr>
				<td class="formLabel">Data Nascita</td>
				<td>${UserRecord.dataNascita}</td>
			</tr>
			<tr>
				<td class="formLabel">Comune Nascita</td>
				<td>${UserRecord.comuneNascita}</td>
			</tr>
			<tr><td></td></tr><tr><td></td></tr>
			<tr>
				<td class="formLabel">Indirizzo</td>
				<td>${UserRecord.indirizzo}</td>
			</tr>
			<tr>
				<td class="formLabel">CAP</td>
				<td>${UserRecord.cap}</td>
			</tr>
			<tr>
				<td class="formLabel">Comune</td>
				<td>${UserRecord.comune}</td>
			</tr>
			<tr>
				<td class="formLabel">Provincia</td>
				<td>${UserRecord.provincia}</td>
			</tr>
			<tr>
				<td class="formLabel">Stato</td>
				<td>${UserRecord.stato}</td>
			</tr>
			<tr><td></td></tr><tr><td></td></tr>			
			<tr>
				<td class="formLabel">E-mail</td>
				<td>${UserRecord.email}</td>
			</tr>
			<tr>
				<td class="formLabel">Fax</td>
				<td>${UserRecord.fax}</td>
			</tr>
			<tr>
				<td class="formLabel">Telefono 1</td>
				<td>${UserRecord.telefono1}</td>
			</tr>
			<tr>
				<td class="formLabel">Telefono 2</td>
				<td>${UserRecord.telefono2}</td>
			</tr>
			<tr>
				<td class="formLabel">Note</td>
				<td>${UserRecord.note}</td>
			</tr>
			<tr><td></td></tr><tr><td></td></tr>
			<tr>
				<td class="formLabel">Username</td>
				<td>${UserRecord.username}</td>
			</tr>			
			<tr>
				<td class="formLabel">Ruolo</td>
				<td>${UserRecord.ruolo}</td>
			</tr>			
			<tr>
				<td class="formLabel">Scadenza login</td>
				<td>${UserRecord.dataScadenza}</td>
			</tr>
			<tr>
				<td class="formLabel">Abilitato</td>
				<td><c:if test="${UserRecord.enabled==true}">SI</c:if>
					<c:if test="${UserRecord.enabled==false}">NO</c:if></td>
			</tr>	
			
		</table>
</div>
