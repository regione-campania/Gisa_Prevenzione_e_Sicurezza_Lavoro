package it.us.web.action.deltautenti;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import it.us.web.action.GenericAction;
import it.us.web.bean.deltautenti.EndpointDelta;
import it.us.web.bean.deltautenti.AmbientiDelta;
import it.us.web.db.ApplicationProperties;
import it.us.web.exceptions.ActionNotValidException;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.properties.Message;

public class toDeltaUtenti extends GenericAction{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@Override
	public void execute() throws Exception {
		can();
		if(ApplicationProperties.getAmbiente().toUpperCase().contains("UFFICIALE")){
			throw new ActionNotValidException( Message.getSmart("FUNZIONE_NON_DISPONIBILE") );
		}
		//costruzione lista endpoint
		ArrayList<EndpointDelta> deltaEndpoint = new ArrayList<EndpointDelta>();
		EndpointDelta ep = null;
		String sql = "select name from delta_endpoint"; 
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			int i = 0;
			while (rs.next()){
				ep = new EndpointDelta();
				ep.setId(++i);
				ep.setNome(rs.getString("name"));
				
				deltaEndpoint.add(ep);
				
				//in ambiente demo DIGEMON non esiste
				if(ApplicationProperties.getAmbiente().toUpperCase().contains("DEMO") && ep.getNome().equalsIgnoreCase("digemon"))
					deltaEndpoint.remove(i-1);
			}
			req.setAttribute("deltaEndpoint", deltaEndpoint);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<AmbientiDelta> deltaAmbienti = new ArrayList<AmbientiDelta>();
		AmbientiDelta am = null;
		sql = "select name from host_config"; 
		try {
			pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			int i = 0;
			while (rs.next()){
				am = new AmbientiDelta();
				am.setId(++i);
				am.setNome(rs.getString("name"));
				
				
				deltaAmbienti.add(am);
			}
			req.setAttribute("deltaAmbienti", deltaAmbienti);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		gotoPage( "/jsp/deltautenti/to_delta_utenti.jsp" );
	}

}
