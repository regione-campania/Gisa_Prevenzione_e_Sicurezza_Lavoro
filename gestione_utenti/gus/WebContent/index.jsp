
<%@page import="it.us.web.action.GenericAction"%>
<%@page import="it.us.web.action.Index"%>

<%
	
	GenericAction.goToAction( new Index(), request, response );

%>
