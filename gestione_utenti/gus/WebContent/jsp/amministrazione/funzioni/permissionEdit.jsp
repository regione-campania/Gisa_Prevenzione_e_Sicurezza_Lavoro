<%@ page contentType="text/html; charset=windows-1252" language="java" errorPage=""%>
<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>

<%@page import="java.util.*" %>
    			
<%@page import="it.us.web.bean.BUtente"%>
<%@page import="it.us.web.bean.BRuolo"%>
<%@page import="it.us.web.util.properties.Message"%>
<%@page import="it.us.web.bean.BFunzione"%>
<%@page import="it.us.web.util.properties.Label"%>
<%@page import="it.us.web.bean.BGuiView"%>

	<%
	    BUtente			utente		= (BUtente)session.getAttribute( "utente" );
		Vector			funzioni	= (Vector)request.getAttribute( "funzioni" );
		Vector<BRuolo>	ruoli		= (Vector<BRuolo>)request.getAttribute( "ruoli" );
		Vector			permessi	= (Vector)request.getAttribute( "permessi" );
		String			funzione	= (String)request.getParameter( "funzione" );
		funzione = (funzione == null) ? ("") : (funzione);
	%>
    
    <p>
    	<%-- in questo contesto non serve questa funzionalità 
		<us:can f="AMMINISTRAZIONE" sf="FUNZIONI" og="ANAGRAFA" r="w" >
			<a href="permessi.AnagrafaFunzioni.us" onclick="return confirm('Sei sicuro di voler anagrafare le nuove funzioni?')" accesskey="6"><span>Anagrafa Funzioni</span></a>
		</us:can>
		--%>
	</p>
	
	 <div class="area-contenuti-2">
		 <br/>
			<%
			if( funzioni != null && !ruoli.isEmpty() )
			{
				Enumeration e = funzioni.elements();
			%>
			
			<form id="a1" action="XXX" method="post">
			<p><select name="FUNZIONI" size="1" onchange="selezionaFunzioneInGestioneFunzioni( this )" >
			<option value="" selected="selected">Seleziona una funzione</option>
			<%
			while(e.hasMoreElements())
			{
				BFunzione bf = (BFunzione)e.nextElement();
			%>
			<option value="<%=bf.getId()+""%>" <%=(bf.getId() + "").equalsIgnoreCase(funzione) ? ("selected=\"selected\"") : ("") %>><%=Label.getSmart( bf.getNome()+"" ) %></option>
			<% 
			}
			}
			%>
			</select></p>
			</form>
			<br/>
			<br/>
			 
			<%if( (funzione != null) && (funzione.length() > 0) )
			{
				Enumeration enp=permessi.elements();
			%>
			<form action="funzioni.PermissionEdit.us" method="post">
			<table width="95%" class="griglia">
			<tr>
				<th colspan="3" style="text-align:right;width:85%;" >Imposta tutti</th>
				<th>
					<input type="button"  class="button" onclick="setAllRO();" value="RO" />
					<input type="button"  class="button" onclick="setAllRW();" value="RW" />
					<input type="button"  class="button" onclick="setAllNO();" value="NO" /> 
				</th>
			</tr>
			<tr>
				<th width="10%">Funzione</th>
				<th width="10%">SubFunzione</th>
				<th width="10%">GUIObject</th>
				<th width="10%">Permessi</th>
			</tr>
			<%
			int index = 0;
			while(enp.hasMoreElements())
			{ 
			BGuiView bgv = (BGuiView)enp.nextElement();
			int id = bgv.getId_gui();
			%>
				<tr class="<%=(index%2 == 0) ? ("even") : ("odd") %>">
					<td>
						<%=Label.getSmart( bgv.getNome_funzione() )%> 
					</td>
					<td>
						<%=Label.getSmart( bgv.getNome_subfunzione() )%> 
					</td>
					<td>
						<%=Label.getSmart( bgv.getNome_gui() )%> 
					</td>
					<td class="lunghezza" nowrap >
						<input id="ogRadio" type="radio" name="OG_<%=id%>" value="0" /><label for="ogRadioRO_<%=id%>">RO</label>
						<input id="ogRadio" type="radio" name="OG_<%=id%>" value="1" /><label for="ogRadioRW_<%=id%>">RW</label>
						<input id="ogRadio" type="radio" name="OG_<%=id%>" value="2" checked="checked" /><label for="ogRadioNO_<%=id%>">NO</label>
						<a href="funzioni.PermissionList.us?funzione=<%=Label.getSmart( bgv.getNome_funzione() )%>&subfunzione=<%=Label.getSmart( bgv.getNome_subfunzione() )%>&gui=<%=Label.getSmart( bgv.getNome_gui() )%>" 
										  	 onclick="javascript:avviaPopupPiccola(this,this.href,screen.width/3,screen.height/2);return false;">Permessi ruoli</a> 
					</td>
				</tr>
			<%index++; }%>

			<tr style="text-align:left;">
				<th colspan="4" > <br/><br/> Assegna ai ruoli:</th>
			</tr>
						
			<%
				BRuolo ruolo = null;
				for( int i = 0; i < ruoli.size(); i++ )
				{
					ruolo = ruoli.elementAt(i);
			%>
				<tr>
					<td colspan="4">
						<input type="checkbox" id="<%=ruolo.getRuolo()%>"  name="<%=ruolo.getRuolo()%>" value="<%=ruolo.getRuolo()%>" /> <label for="<%=ruolo.getRuolo()%>"><%=ruolo.getRuolo()%>: <%=ruolo.getDescrizione()%></label>
					</td>
				</tr>
			<%
				}
			%>
			<tr>
				<td colspan="4"><input class="button" type="submit" value="Aggiorna Permessi"/></td>
			</tr>
			
			</table>
			</form>
			<%
				}
			%>
			
	</div>
	


