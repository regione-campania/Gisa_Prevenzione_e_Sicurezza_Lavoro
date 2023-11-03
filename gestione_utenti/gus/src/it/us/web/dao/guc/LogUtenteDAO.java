package it.us.web.dao.guc;

import it.us.web.bean.BUtente;
import it.us.web.bean.guc.Ruolo;
import it.us.web.bean.guc.Utente;
import it.us.web.dao.GenericDAO;
import it.us.web.db.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogUtenteDAO extends GenericDAO
{
	private static final Logger logger = LoggerFactory.getLogger( LogUtenteDAO.class );
	
	public static void loggaUtente(Connection db,Utente u, String operazione, BUtente user, String dbi) throws SQLException{
		
		int id = DbUtil.getNextSeqTipo(db, "log_utenti_id_seq");
		
		System.out.println("LOGG UTENTE "+user.getId()+" 222");

		
		String sql = "INSERT INTO log_utenti(id, id_utente, username, nome, cognome, password, password_encrypted, operazione, data, id_modificante, username_modificante) " +
						"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
		PreparedStatement pst = null;
		
		try{
			pst =  db.prepareStatement(sql);
			pst.setInt(1, id);
			pst.setInt(2, u.getId());
			pst.setString(3, u.getUsername());
			pst.setString(4, u.getNome());
			pst.setString(5, u.getCognome());
			pst.setString(6, u.getPassword());
			pst.setString(7, u.getPasswordEncrypted());
			pst.setString(8, operazione);
			pst.setTimestamp(9, new Timestamp (new Date().getTime()));
			pst.setInt(10, user.getId());
			pst.setString(11, user.getUsername());
				
			pst.executeUpdate();
			
			sql = "INSERT INTO log_ruoli_utenti(id_log_utente, endpoint, ruolo, dbi) VALUES (?, ?, ?, ?);";
			pst =  db.prepareStatement(sql);
			
			for (Ruolo r : u.getRuoli()){
				pst.setInt(1, id);
				pst.setString(2, r.getEndpoint());
				pst.setString(3, r.getRuoloString());
				if (u.getQuery().containsKey(r.getEndpoint().toUpperCase()))
					pst.setString(4, u.getQuery().get(r.getEndpoint().toUpperCase()).replaceAll ("\r\n|\r|\n|	", ""));
				else
					pst.setString(4, "");
				pst.executeUpdate();
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
	}
	public static void loggaUtente(Connection db,Utente u, String operazione, BUtente user) throws SQLException{
		
		int id = DbUtil.getNextSeqTipo(db, "log_utenti_id_seq");
		
		System.out.println("LOGG UTENTE "+user.getId()+" 222");

		
		String sql = "INSERT INTO log_utenti(id, id_utente, username, nome, cognome, password, password_encrypted, operazione, data, id_modificante, username_modificante) " +
						"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
		PreparedStatement pst = null;
		
		try{
			pst =  db.prepareStatement(sql);
			pst.setInt(1, id);
			pst.setInt(2, u.getId());
			pst.setString(3, u.getUsername());
			pst.setString(4, u.getNome());
			pst.setString(5, u.getCognome());
			pst.setString(6, u.getPassword());
			pst.setString(7, u.getPasswordEncrypted());
			pst.setString(8, operazione);
			pst.setTimestamp(9, new Timestamp (new Date().getTime()));
			pst.setInt(10, user.getId());
			pst.setString(11, user.getUsername());
				
			pst.executeUpdate();
			
			sql = "INSERT INTO log_ruoli_utenti(id_log_utente, endpoint, ruolo) VALUES (?, ?, ?);";
			pst =  db.prepareStatement(sql);
			
			for (Ruolo r : u.getRuoli()){
				pst.setInt(1, id);
				pst.setString(2, r.getEndpoint());
				pst.setString(3, r.getRuoloString());
				pst.executeUpdate();
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	public static void loggaUtente(Connection db,BUtente u, String operazione, BUtente modificante) throws SQLException{	
		int id = DbUtil.getNextSeqTipo(db, "log_utenti_id_seq");
		
		System.out.println("LOGG B---UTENTE");
		
		String sql = "INSERT INTO log_utenti(id, id_utente, username, nome, cognome, password, operazione, data, id_modificante, username_modificante) " +
						"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
		PreparedStatement pst = null;
		
		try{
			pst =  db.prepareStatement(sql);
			pst.setInt(1, id);
			pst.setInt(2, u.getId());
			pst.setString(3, u.getUsername());
			pst.setString(4, u.getNome());
			pst.setString(5, u.getCognome());
			pst.setString(6, u.getPassword());
			pst.setString(7, operazione);
			pst.setTimestamp(8, new Timestamp (new Date().getTime()));
			pst.setInt(9, modificante.getId());
			pst.setString(10, modificante.getUsername());
				
			pst.executeUpdate();
		}
		catch(Exception e){
			e.printStackTrace();
		}

		
		
	}
	
	
	
}
