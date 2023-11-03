<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/jmesa.tld" prefix="jmesa" %>
<%@page import="it.us.web.util.guc.GUCEndpoint"%>
<%@page import="java.util.List"%>
<%@page import="it.us.web.bean.guc.Ruolo"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>

<%@page import="java.util.ArrayList"%>
<!-- <script type="text/javascript" src="/js/jquery/jquery-1.3.2.min.js" ></script> -->

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
<script src="https://cdn.jsdelivr.net/sweetalert2/5.3.8/sweetalert2.js"></script>
<link href="https://cdn.jsdelivr.net/sweetalert2/5.3.8/sweetalert2.css" rel="stylesheet"/>

<script type="text/javascript">

$(
		function(){
			abilitaComboRuoli();
		}
);

function abilitaComboRuoli(){

	var combo = $("#endpoint");
	
	$("select[name='ruolo']").hide();
	$("select[name='ruolo']").attr('disabled','disabled');
	
	if(combo.val() != ''){
		$("#" + combo.val() ).attr('disabled','');
		$("#" + combo.val() ).show();
	}
	else{
		$("#tuttiRuoli").attr('disabled','');
		$("#tuttiRuoli").show();
	}
			
}

</script>

<%
boolean utentiAttivi = Boolean.parseBoolean(request.getAttribute("utentiAttivi").toString());
String endpointSelezionato = request.getAttribute("endpoint") != null ? request.getAttribute("endpoint").toString() : "";
int ruoloSelezionato = request.getAttribute("ruolo") != null ? Integer.parseInt(request.getAttribute("ruolo").toString()) : -1;

/*String daAllineareGISA = request.getAttribute("daAllineareGISA") != null ? request.getAttribute("daAllineareGISA").toString() : "0";
String daAllineareGISA_EXT = request.getAttribute("daAllineareGISA_EXT") != null ? request.getAttribute("daAllineareGISA_EXT").toString() : "0";
String daAllineareBDU = request.getAttribute("daAllineareBDU") != null ? request.getAttribute("daAllineareBDU").toString() : "0";
String daAllineareVAM = request.getAttribute("daAllineareVAM") != null ? request.getAttribute("daAllineareVAM").toString() : "0";*/


%>


<div align="center">
			<a href="Index.us" style="margin: 0px 0px 0px 50px">Home</a>
	</div>
	

<div id="content">
<center>
  
<h4 class="titolopagina">Lista Utenti <%= utentiAttivi ? "Attivi":"NON Attivi" %> </h4>

<div class="area-contenuti-2">
	<form action="Home.us" method="post">
		<table width="90%"   align="center">
	   		<tr>
	   			<!--td >
	   				< table>
		   			<tr><td colspan='2'>
		   				<b><font color="red">[#] utenti presenti in GUC e non sull'ENDPOINT</font></b><br>
	   				</td></tr>
	   				<tr><td><b><font color="red">[<!--%=daAllineareGISA %>]</font></b></td><td><a href="guc.Allinea.us?allinea=allineaGISA" onclick="attendere('GISA')"><img src="images/allinea.png" height="18px" width="18px" title="Allinea utenti GISA" alt="Allinea utenti GISA" />Allinea Utenti GISA</a></td></tr>
	   				<tr><td><b><font color="red">[<!--%=daAllineareGISA_EXT %>]</font></b></td><td><a href="guc.Allinea.us?allinea=allineaGISA_EXT"  onclick="attendere('GISA_EXT')"><img src="images/allinea.png" height="18px" width="18px" title="Allinea utenti GISA_EXT" alt="Allinea utenti GISA_EXT" />Allinea Utenti GISA_EXT</a></td></tr>
	   				<tr><td><b><font color="red">[<!--%=daAllineareBDU %>]</font></b></td><td><a href="guc.Allinea.us?allinea=allineaBDU"  onclick="attendere('BDU')"><img src="images/allinea.png" height="18px" width="18px" title="Allinea utenti BDU" alt="Allinea utenti BDU" />Allinea Utenti BDU</a></td></tr>
	   				<tr><td><b><font color="red">[<!--%=daAllineareVAM %>]</font></b></td><td><a href="guc.Allinea.us?allinea=allineaVAM"  onclick="attendere('VAM')"><img src="images/allinea.png" height="18px" width="18px" title="Allinea utenti VAM" alt="Allinea utenti VAM" />Allinea Utenti VAM</a></td></tr>
	   				</table >
	   			</td-->
				<td width="70%">
					<!-- <table width="90%" style="text-align: center;" align="center"> -->
					<table width="80%" >
						<tr>
							<th width="25%">Utenti</th>
							<th width="25%">Endpoint</th>
							<th width="50%">Ruoli</th>
						</tr>
						<tr>
							<td>
								<select name="utentiAttivi" id="utentiAttivi" style="width: 100%;" >
									<option value="true" <%if(utentiAttivi){ %>selected="selected"<%} %> >Attivi</option>
								</select>
							</td>
							<td>
								<select name="endpoint" id="endpoint" onchange="javascript:abilitaComboRuoli();" style="width: 100%;" disabled>
<!-- 									<option value="">-- Tutti --</option> -->
										<c:forEach items="${endpoints}" var="e">
											<option value="${e}" <c:if test="${e == endpoint}">selected="selected"</c:if> >${e}</option>
										</c:forEach>
								</select>
							</td>
							<td>
								<%for(GUCEndpoint e : GUCEndpoint.values()){ 
									System.out.println(e);
									ArrayList<Ruolo> listaRuoli = (ArrayList<Ruolo>)request.getAttribute("listaRuoli" + e); 
									if (listaRuoli!=null) {
										System.out.println(e+" "+listaRuoli.size());%>
										<select name="ruolo" id="<%= e %>" style="width: 100%;">
											<optgroup label="<%= e %>">
											<option value="">-- Tutti --</option><%
											if(listaRuoli.size() > 0){
												for(Ruolo r : listaRuoli){ %>
													<option value="<%= r.getRuoloInteger() %>" <%if(r.getRuoloInteger() == ruoloSelezionato){ %>selected="selected"<%} %> ><%= r.getRuoloString() %></option><%	
												}
											} %>
											</optgroup>
										</select><%
									} 
								} %>		
							</td>
							<td align="center"colspan="3">
								<input type="button" onclick="document.forms[0].submit();" value="CERCA"/>
							</td>
						</tr>
					</table>
				</td>
				<td align="center">
<!-- 					<image src="images/adobe-icon.png"/><br> -->
<!-- 					<a href="jsp/guida/manualeutente.pdf" target="_blank" style="color:black">Manuale utente</a> -->
				</td>	
				</tr>
         	</table>

<a href="guc.ToAdd.us" style="display: none"><img src="images/add.png" height="24px" width="24px" title="Aggiungi Utente" alt="Aggiungi Utente"/></a>
<a href="guc.ToImport.us" style="display: none"><img src="images/uploader.png" height="24px" width="24px" title="Importa Utenti da File" alt="Importa Utenti da File"/></a>

		<jmesa:tableModel items="${utentiList}" id="utentiList" var="u" filterMatcherMap="it.us.web.util.jmesa.MyFilterMatcherMap" columnSort="it.us.web.util.jmesa.CustomColumnSort">
			<jmesa:htmlTable styleClass="tabella">
				<jmesa:htmlRow>

					<jmesa:htmlColumn property="username" title="Username" />
					<jmesa:htmlColumn property="codiceFiscale" title="Codice Fiscale" />
					<jmesa:htmlColumn property="nominativo" title="Cognome , Nome" />
					<jmesa:htmlColumn property="asl.nome" title="Asl" filterEditor="it.us.web.util.jmesa.AslDroplistFilterEditor" />
					<c:forEach items="${endpoints}" var="e">
					<jmesa:htmlColumn  property="${e}" title="Ruolo ${e}" cellEditor="it.us.web.util.jmesa.HashMapCellEditor" filterable="false">
					</jmesa:htmlColumn>
					</c:forEach> 
					
					<jmesa:htmlColumn sortable="false" filterable="false" title="Operazioni" width="68px">
						
							
						<a href="guc.Detail.us?id=${u.id}" style="margin: 0px 2px 0px 2px"><img src="images/detail.gif" height="16px" width="16px" title="Dettaglio Utente" alt="Dettaglio Utente" /></a>
						
						<c:if test="${u.dataScadenza==null}">
 						<!-- <a href="guc.ToEditAnagrafica.us?id=${u.id}" style="margin: 0px 2px 0px 2px"><img src="images/edit-user.png" height="16px" width="16px" title="Modifica Credenziali" alt="Modifica Credenziali" /></a>  -->
						<a href="guc.ToEditProfilo.us?id=${u.id}" style="margin: 0px 2px 0px 2px"><img src="images/edit_role.png" height="16px" width="16px" title="Disattiva Ruolo" alt="Disattiva Ruolo" /></a>
						</c:if>
						<c:if test="${u.dataScadenza!=null}">
						<a href="#" onclick="if (confirm('Su Questo Utente esistono variazioni di Profiloche saranno visibili dopo il ${u.dataScadenza} Desideri annullare le modifiche ?')==true){location.href='guc.Rollback.us?id=${u.id}';}" style="margin: 0px 2px 0px 2px"><img src="images/undo.png" height="16px" width="16px" title="Annulla Modifiche" alt="Annulla Modifiche" /></a>
						</c:if>
					</jmesa:htmlColumn>
					
				</jmesa:htmlRow>
			</jmesa:htmlTable>
		</jmesa:tableModel>	
		<br/>
		<us:can>
		<h4 class="titolopagina">Lista Utenti Amministratori</h4>
		<a href="guc.ToAddEditAdministrator.us?operation=add"><img src="images/add.png" height="24px" width="24px" title="Aggiungi Utente" alt="Aggiungi Utente Amministratore" /></a>
		
		
		<jmesa:tableModel items="${utentiListGuc}" id="utentiListGuc" var="u" filterMatcherMap="it.us.web.util.jmesa.MyFilterMatcherMap" columnSort="it.us.web.util.jmesa.CustomColumnSort">
			<jmesa:htmlTable styleClass="tabella">
				<jmesa:htmlRow>
					<jmesa:htmlColumn property="username" title="Username" />
					<jmesa:htmlColumn property="nominativo" title="Cognome , Nome" />
					<jmesa:htmlColumn sortable="false" filterable="false" title="Operazioni" width="68px">
						
					
					

						<a href="guc.DetailAdministrator.us?id=${u.id}" style="margin: 0px 2px 0px 2px"><img src="images/detail.gif" height="16px" width="16px" title="Dettaglio Utente" alt="Dettaglio Utente" /></a>
						<a href="guc.ToAddEditAdministrator.us?id=${u.id}&operation=edit" style="margin: 0px 2px 0px 2px"><img src="images/edit.gif" height="16px" width="16px" title="Modifica Utente" alt="Modifica Utente" /></a>
					
				
					</jmesa:htmlColumn>
				</jmesa:htmlRow>
			</jmesa:htmlTable>
		</jmesa:tableModel>
		</us:can>
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
			location.href = 'Home.us?' + parameterString;
		}
	</script>
</div>
</center>
  
</div>
<<script type="text/javascript">
function attendere(sistema){
	swal('Allineamento utenti '+sistema);
	swal.showLoading();
}
</script>

