<%@ include file="../guc/modalWindow.jsp"%>

<div align="center">
<script type="text/javascript">
<% if(request.getAttribute("risultato") != null && request.getAttribute("risultato").equals("OK") ){ %>
		alert("MESSAGGIO INSERITO CORRETTAMENTE");
<% }else{ %>
		alert("ERRORE DURANTE L'INSERIMENTO DEL MESSAGGIO");
<% } %>

	loadModalWindow();
	
	//logout con ajax
	$.ajax({
		url: "login.Logout.us"
	}).done(function() {
			window.close();
		});

</script>
</div>