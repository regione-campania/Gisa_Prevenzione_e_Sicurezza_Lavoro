<%@page import="it.us.web.action.GenericAction"%>
<%@page import="it.us.web.action.IndexGUC"%>

<%
	
	GenericAction.goToAction( new IndexGUC(), request, response );

%>