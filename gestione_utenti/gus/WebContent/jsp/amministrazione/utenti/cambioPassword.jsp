<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage=""%>
<%@ taglib uri="/WEB-INF/jmesa.tld" prefix="jmesa" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>

<div class="area-contenuti-2">
	
	<form action="utenti.CambioPassword.us" method="post">
		
		<input type="submit" class="button" value="Salva" />
		<input type="button" class="button" value="Annulla" onclick="location.href='utenti.List.us'" />
		<input type="hidden" name="user_id" value="${userDetail.id }" />
		
		<table class="tabella" >
			<thead>
				<tr>
					<th colspan="2">
						Modifica Password
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td> Username</td>
					<td> ${userDetail.username}</td>
				</tr>
				<tr>
					<td>Password</td>
					<td>
						<font color="red">*</font><input type="password" maxlength="64" size="20" name="password_1" value="" />
						conferma:<font color="red">*</font><input type="password" maxlength="64" size="20" name="password_2" value="" />
					</td>
				</tr>
			</tbody>
		</table>
		<font color="red">* Campi obbligatori</font>
	
	</form>

</div>
