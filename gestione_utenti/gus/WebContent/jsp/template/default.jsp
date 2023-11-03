<%@page import="it.us.web.db.ApplicationProperties"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage="" %>

<!DOCTYPE html>


<%@page import="it.us.web.bean.BUtente"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=windows-1252" />
		
		<!-- inclusioni per jmesa -->
		<link rel="stylesheet" type="text/css" href="css/jmesa/jmesa.css" />
		<script type="text/javascript" src="js/jmesa/jquery-1.3.min.js"></script>
		<script type="text/javascript" src="js/jmesa/jquery.bgiframe.pack.js"></script>
		<script type="text/javascript" src="js/jmesa/jmesa.js"></script>
		<script type="text/javascript" src="js/jmesa/jmesa.min.js"></script>
		<script type="text/javascript" src="js/jmesa/jquery.jmesa.js"></script>
		
		
<!--		<script type="text/javascript" src="js/jquery/jquery-1.3.2.min.js"></script>-->
		<script type="text/javascript" src="js/jquery/jquery-ui-1.7.3.custom.min.js"></script>
		<script type="text/javascript" src="js/jquery/tooltip.min.js"></script>
		<script type="text/javascript" src="js/jquery/jquery-us.js"></script>

		<!-- link rel="stylesheet" type="text/css" href="css/black-tie/jquery-ui-1.7.3.custom.css" /-->
		<!-- link rel="stylesheet" type="text/css" href="css/custom-theme/jquery-ui-1.7.3.custom.css" /-->
		<!-- link rel="stylesheet" type="text/css" href="css/ui-lightness/jquery-ui-1.7.3.custom.css" /-->
		<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.7.3.custom.css" />
		
		<link rel="stylesheet" type="text/css" href="css/guc/template_css.css" />
		<link rel="stylesheet" type="text/css" href="css/aqua/theme.css" />
		<script type="text/javascript" src="js/amministrazione/permessi.js"></script>
		<script type="text/javascript" src="js/azionijavascript.js"></script>
		<script type="text/javascript" src="js/date.js"></script>
		<script type="text/javascript" src="js/calendario/calendar.js"></script>
		<script type="text/javascript" src="js/calendario/calendar-setup.js"></script>
		<script type="text/javascript" src="js/calendario/calendar-it.js"></script>
		<title>Gestione Utenti Sicurezza Lavoro</title>
		
	</head>
	
  <body class="white" >
    
    <div id="dialog-modal" title="Attendere">
		<p>
			<br />
			<img src="images/loader.gif" />
		</p>
	</div>
	
	<c:if test="${errore != null || messaggio != null}">
		<jsp:include page="default/errore-messaggio-popup.jsp" />
	</c:if>
	
    <div  class="header" >
    	<tiles:insertAttribute name="header" />
    </div>

	<div class="contentBody">
		<us:err classe="errore" />
 		<us:mex classe="messaggio" />

<%
if(!ApplicationProperties.getAmbiente().toUpperCase().contains("UFFICIALE"))
{
%>
<br/><br/>
<h1 style="text-align:center;background-color:<%=ApplicationProperties.getAmbiente().contains("COLLAUDO") ? "#4477AA" : "black" %>;color:white;border:0px;" >
AMBIENTE <%=ApplicationProperties.getAmbiente()%> 
</h1>
<%
}
%>
		<tiles:insertAttribute name="body" />
	</div>
				
	<div id="footer">
		<div class="padding">
             <div class="moduletable">
				<tiles:insertAttribute name="footer" />
			</div>
		</div>
	</div>
					
  </body>

</html>
