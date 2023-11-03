package it.us.web.action.messaggi;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import it.us.web.action.GenericAction;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.bean.deltautenti.EndpointDelta;
import it.us.web.bean.messaggi.Messaggio;


public class Messaggi extends GenericAction{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@Override
	public void execute() throws Exception {
		can(); 
		
		if(req.getParameter("salva") != null && req.getParameter("salva").equals("salva")){
			//inserisci messaggio
			//select insert_messaggio_home(6567,'messaggio','di','test2','gisa');

			String sql = "select insert_messaggio_home(?,?,?,?,?)";
			PreparedStatement pst;
			
			pst = db.prepareStatement(sql);
			pst.setInt(1, utente.getId());
			pst.setString(2, req.getParameter("header"));
			pst.setString(3, req.getParameter("body"));
			pst.setString(4, req.getParameter("footer"));
			pst.setString(5, req.getParameter("endpoint"));
			
			ResultSet rs = pst.executeQuery();
			String risultato = null;
			
			while (rs.next()){
				risultato = rs.getString(1);
			}
			
			if(risultato.equals("OK"))
				req.setAttribute("risultato",risultato);
			else
				req.setAttribute("risultato","KO");
			
			if(req.getParameter("iframe") == null || req.getParameter("iframe").equals("null"))
				goToAction(new toMessaggi());
			else
				gotoPage("/jsp/messaggi/messaggi_esito_iframe.jsp");
		}
		
		ArrayList<EndpointDelta> listaEndpoint = new ArrayList<EndpointDelta>();
		EndpointDelta ep = null;
		String sql = "select name from delta_endpoint where enabled = 'true'"; 
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			int i = 0;
			while (rs.next()){
				ep = new EndpointDelta();
 				ep.setId(++i);
				ep.setNome(rs.getString("name"));
				
				listaEndpoint.add(ep);
				
				//gestione messaggi disponibile solo per gisa bdu e vam
				if(ep.getNome().equalsIgnoreCase("digemon"))
					listaEndpoint.remove(i-1);
			}
			req.setAttribute("listaEndpoint", listaEndpoint);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//se endpoint e' valorizzato allora si modifica il messaggio relativo
		if(req.getParameter("endpoint") != null && !req.getParameter("endpoint").equals("")){
			
			Messaggio messaggioGenerico = new Messaggio();
			
			sql = "select * from get_messaggio_home(?)";
			pst = db.prepareStatement(sql);
			pst.setString(1, req.getParameter("endpoint"));
			
			ResultSet rs = pst.executeQuery();
			
			while (rs.next()){
				messaggioGenerico.setId(rs.getInt("id"));
				messaggioGenerico.setEntered(rs.getTimestamp("entered"));
				messaggioGenerico.setEntered_by(rs.getInt("entered_by"));
				messaggioGenerico.setHeader(rs.getString("header"));
				messaggioGenerico.setBody(rs.getString("body"));
				messaggioGenerico.setFooter(rs.getString("footer"));
				messaggioGenerico.setEndpoint(rs.getString("endpoint"));
				messaggioGenerico.setTrashed_date(rs.getTimestamp("trashed_date"));
			}
			
			req.setAttribute("messaggioGenerico", messaggioGenerico);
		}
		
		if(req.getParameter("iframe") != null)
			req.setAttribute("iframe", "true");
		
		gotoPage( "/jsp/messaggi/messaggi_add.jsp" );
	}

}
