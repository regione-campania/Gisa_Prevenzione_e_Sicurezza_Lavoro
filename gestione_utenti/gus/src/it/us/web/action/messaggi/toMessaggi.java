package it.us.web.action.messaggi;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import it.us.web.action.GenericAction;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.bean.deltautenti.EndpointDelta;
import it.us.web.bean.messaggi.Messaggio;


public class toMessaggi extends GenericAction{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@Override
	public void execute() throws Exception {
		can(); 
		
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
			}
			
			ArrayList<Messaggio> listaMessaggi = new ArrayList<Messaggio>();
			for(EndpointDelta e : listaEndpoint){
				String nome = e.getNome();
				
				sql = "select * from get_messaggio_home(?)";
				pst = db.prepareStatement(sql);
				pst.setString(1, nome);
				rs = pst.executeQuery();
				
				Messaggio messaggioGenerico = new Messaggio();
				
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
				
				if(messaggioGenerico.getId() != 0)
					listaMessaggi.add(messaggioGenerico);
				
			}
			
			req.setAttribute("listaEndpoint", listaEndpoint);
			req.setAttribute("listaMessaggi", listaMessaggi);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		gotoPage( "/jsp/messaggi/to_messaggi.jsp" );
	}

}
