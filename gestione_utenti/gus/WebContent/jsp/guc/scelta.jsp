<jsp:useBean id="endpoints" class="java.util.ArrayList" scope="request" />

<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>



<c:if test="${utenteGuc!=null}" >
<div style="clear: both;" align="right">
<c:out value="${utenteGuc.cognome}"/>,<c:out value="${utenteGuc.nome}"/> (<c:out value="${utenteGuc.username}"/>)
<a href="login.LogoutGUC.us">[Logout]</a>
</div>
</c:if>


<script type="text/javascript" src="/js/jquery/jquery-1.3.2.min.js" ></script>

<style type="text/css">
#Copia ed adattamento del css contenuto in css > vam > homePage
#content
{
margin:0 auto;
width:899px;
}
#content p
{
font:normal 12px/18px Arial, Helvetica, sans-serif;
padding:10px;
color:#333333;
}
#content_right
{
margin:0 auto;
width:860px;
padding:5px;
}
#content h3
{
font:bold 12px/20px Arial, Helvetica, sans-serif;
color:#607B35;
}
#content_row1
{
margin:0 auto;
width:670px;
height:175px;
background:url('images/homePage/pets_clinic_08.gif') no-repeat 0 0;
padding-left:250px
}
#content_row2
{
margin:0 auto;
width:625px;
}

</style>

 <div  class="header" >
    	<tiles:insertAttribute name="header" />
 </div>

<div id="content">

<center>
  
<h4 class="titolopaginaGUC">Sistemi Di Accesso</h4>

<div class="area-contenuti-2">
	<form action="" method="post">
	
		<p style="font-size: 25px;">Scegliere il sistema cui accedere:</p>
		
		<% int i =1; 
		
			while(i <=endpoints.size() )
			{
				
		%>		
			<a href="login.LoginEndpoint.us?endpoint=<%=endpoints.get(i-1).toString()%>"  style="font-size:15pt" target="_self"><%= endpoints.get(i-1).toString().toUpperCase()%></a><br>
			<%-- <input type="hidden" name="link_<%=i%>" value="login.LoginEndpoint.us?endpoint=<%=endpoints.get(i-1).toString()%>"/>--%>
			
		<% 
			i++;
		}
		%>
		
		<br/>
		
		
		
	</form>
	
</div>
</center>
  
</div>
