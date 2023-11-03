<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage=""%>
<%@ taglib uri="/WEB-INF/jmesa.tld" prefix="jmesa" %>



<div class="area-contenuti-2">
	
	<p>	
		<a href="utenti.ToAdd.us">Aggiungi un Nuovo Utente</a>
	</p>
	
	<form action="utenti.List.us" method="post">
		<jmesa:tableModel id="utenti" items="${lista_utenti}" var="ut">
			<jmesa:htmlTable>
				<jmesa:htmlRow>
					<jmesa:htmlColumn property="username" />
					<jmesa:htmlColumn property="cognome" />
					<jmesa:htmlColumn property="nome" />
					<jmesa:htmlColumn property="ruolo" filterEditor="org.jmesa.view.html.editor.DroplistFilterEditor" />
					<jmesa:htmlColumn filterable="false">
						<a href="utenti.Detail.us?user_id=${ut.id}">Dettaglio</a>
						<a href="utenti.ToModify.us?user_id=${ut.id}">Modifica</a>
						<a href="utenti.ToCambioRuolo.us?user_id=${ut.id}">Cambia Ruolo</a>
						<a href="utenti.ToCambioPassword.us?user_id=${ut.id}" >Cambia Password</a>
						<a href="utenti.Delete.us?user_id=${ut.id}" onclick="javascript:return confirm('Eliminare l\'utente ${ut.username}?')" >Elimina</a> 
					</jmesa:htmlColumn>
				</jmesa:htmlRow>
			</jmesa:htmlTable>
		</jmesa:tableModel>
	</form>
	
	<script type="text/javascript">
		function onInvokeAction(id)
		{
			setExportToLimit(id, '');
			createHiddenInputFieldsForLimitAndSubmit(id);
		}
		function onInvokeExportAction(id)
		{
			var parameterString = createParameterStringForLimit(id);
			location.href = 'utenti.List.us?' + parameterString;
		}
	</script>
	
</div>
