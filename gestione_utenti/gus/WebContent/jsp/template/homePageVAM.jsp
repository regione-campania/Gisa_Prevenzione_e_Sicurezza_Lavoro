<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>
<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage="" %>

<!DOCTYPE html>

<LINK REL="SHORTCUT ICON" HREF="images/animated_favicon1.gif">


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=windows-1252" />
		<link rel="stylesheet" type="text/css" href="css/vam/template_css.css" />
		<link rel="stylesheet" type="text/css" href="css/vam/homePage/homePage.css" />
		<script type="text/javascript" src="js/jmesa/jquery-1.3.min.js"></script>		
		<script type="text/javascript" src="js/azionijavascript.js"></script>
		<script type="text/javascript" src="js/amministrazione/permessi.js"></script>
		<title>VAM</title>
	</head>
	
	<div class="contentpaneopen">
			<div class="cpocontent">
				<us:err classe="errore" />
				<us:mex classe="messaggio" />
				<tiles:insertAttribute name="body" />
			</div>
		</div>
</html>
