<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage="" %>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>

<%@page import="it.us.web.bean.BUtente"%>
<%@page import="it.us.web.util.properties.Message"%>

<sp:useBean id="ruolo" scope="request" />

		
 <div class="titolo">Modifica descrizione ruolo: ${ruolo.ruolo }</div>
 
 <div class="area-contenuti-2" style="width:50%">

	<form action="ruoli.DescriptionEdit.us" method="post" onsubmit="return checkForm();" >
    	 <input type="hidden" name="ruolo" value="${ruolo.ruolo }" />
    	 <input id="ruoloDesc" maxlength="80" size="50" type="text" name="descrizione" value="${ruolo.descrizione }" /> <font color="red">*</font>
		 <input type="submit" value="Modifica" class="button" />
		 <br/><font color="red">Campo obbligatorio</font>
	</form>	
		
</div>

<script type="text/javascript">
function checkForm()
{
	if( $('#ruoloDesc')[0].value.length > 0 )
	{
		return true;
	}
	else
	{
		alert( "Inserire una descrizione" );
		return false;
	}
		
}
</script>