<%@page import="it.us.web.db.ApplicationProperties"%>
<script src="<%=ApplicationProperties.getProperty("SITO_GISA")%>/js/GisaSpid.js"></script>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<LINK REL="SHORTCUT ICON" HREF="images/logo.png">
<img id="logoregione" align="right" src="images/logo.png"/>
<c:if test="${utente!=null}" >
<div style="clear: both;" align="right">
<c:out value="${utente.cognome}"/>,<c:out value="${utente.nome}"/> (<c:out value="${utente.username}"/>)
<a href="javascript: GisaSpid.logoutSpid('login.Logout.us')">[Logout]</a>
</div>
</c:if>