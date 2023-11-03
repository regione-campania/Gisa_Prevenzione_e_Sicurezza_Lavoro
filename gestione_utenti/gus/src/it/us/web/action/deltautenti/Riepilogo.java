package it.us.web.action.deltautenti;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import it.us.web.action.GenericAction;
import it.us.web.bean.deltautenti.Utenze;
import it.us.web.exceptions.ActionNotValidException;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.properties.Message;
import it.us.web.dao.AslDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.db.ApplicationProperties;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.Ruolo;


public class Riepilogo extends GenericAction{
	
	@Override
	public void can() throws AuthorizationException {
		isLogged();
	}

	@Override
	public void execute() throws Exception {
		// TODO Auto-generated method stub
		can();
		if(ApplicationProperties.getAmbiente().toUpperCase().contains("UFFICIALE")){
			throw new ActionNotValidException( Message.getSmart("FUNZIONE_NON_DISPONIBILE") );
		}
		
		String cf;
		String ambiente;
		String[] endpointArr;
		
		ArrayList<Utenze> Utenze = new ArrayList<Utenze>();
		Utenze utenza = null;
		
		ArrayList<Asl> listaAsl = (ArrayList<Asl>)AslDAO.getAsl(db);
		Asl tutte = new Asl();
		tutte.setId(-1);
		tutte.setNome("TUTTE LE ASL");
		listaAsl.add(tutte);
		
		ArrayList<Ruolo> ruoliBDU = (ArrayList<Ruolo>)RuoloDAO.getRuoliByEndPoint("bdu", db);
		ArrayList<Ruolo> ruoliGISA = (ArrayList<Ruolo>)RuoloDAO.getRuoliByEndPoint("Gisa", db);
		ArrayList<Ruolo> ruoliVAM = (ArrayList<Ruolo>)RuoloDAO.getRuoliByEndPoint("Vam", db);
		ArrayList<Ruolo> ruoliDIGEMON = (ArrayList<Ruolo>)RuoloDAO.getRuoliByEndPoint("Digemon", db);
		
		req.setAttribute("listaAsl", listaAsl);
		req.setAttribute("ruoliBDU", ruoliBDU);
		req.setAttribute("ruoliGISA", ruoliGISA);
		req.setAttribute("ruoliVAM", ruoliVAM);
		req.setAttribute("ruoliDIGEMON", ruoliDIGEMON);
		
		cf = req.getParameter("codice_fiscale");
		ambiente = req.getParameter("ambiente");
		endpointArr = req.getParameterValues("endpoint");
		
		String endpoint = "";
		for(int i = 0;i<endpointArr.length;i++){
			endpoint = endpoint + endpointArr[i];
		}
		
		req.setAttribute("endpointCAT", endpoint);
		
		String sql = "select * from delta_utenti(?,?) where codice_fiscale = ?";
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			pst.setString(1, ambiente);
			pst.setString(2, endpoint);
			pst.setString(3, cf);
			ResultSet rs = pst.executeQuery();
			int i = 0;
			while (rs.next()){
				utenza = new Utenze();
				utenza.setId(++i);
				utenza.setNome(rs.getString("nome"));
				utenza.setCognome(rs.getString("cognome"));
				utenza.setCodiceFiscale(rs.getString("codice_fiscale"));
				utenza.setRuoloInteger(rs.getInt("ruolo_integer"));
				utenza.setAslId(rs.getInt("asl_id"));
				utenza.setEndpoint(rs.getString("endpoint"));
				
				Utenze.add(utenza);
				
			}
			
			req.setAttribute("utenze", Utenze);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		gotoPage( "/jsp/deltautenti/riepilogo.jsp" );

	}

}
