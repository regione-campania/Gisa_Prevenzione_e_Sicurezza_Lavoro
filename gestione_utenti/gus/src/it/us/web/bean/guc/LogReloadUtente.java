package it.us.web.bean.guc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

public class LogReloadUtente {
	
	private int id ;
	private String endpoint ;
	private String url_invocata;
	private int id_utente ;
	private String username ;
	private  Timestamp data_chiamata ;
	private String response;
	private String tipo_op;
	
	
	public String getTipo_op() {
		return tipo_op;
	}
	public void setTipo_op(String tipo_op) {
		this.tipo_op = tipo_op;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getEndpoint() {
		return endpoint;
	}
	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}
	public String getUrl_invocata() {
		return url_invocata;
	}
	public void setUrl_invocata(String url_invocata) {
		this.url_invocata = url_invocata;
	}
	public int getId_utente() {
		return id_utente;
	}
	public void setId_utente(int id_utente) {
		this.id_utente = id_utente;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Timestamp getData_chiamata() {
		return data_chiamata;
	}
	public void setData_chiamata(Timestamp data_chiamata) {
		this.data_chiamata = data_chiamata;
	}
	public String getResponse() {
		return response;
	}
	public void setResponse(String response) {
		this.response = response;
	}
	
	
	
	
	
	public void insert(Connection db)
	{
		String insert = "INSERT INTO log_reload_utenti(endpoint, url_invocata, id_utente, username, data_chiamata,response,tipo_op)VALUES (?, ?, ?, ?, current_timestamp, ?,?);";
		try
		{
			int i = 0 ;
			PreparedStatement pst = db.prepareStatement(insert);
			pst.setString(++i, endpoint);
			pst.setString(++i, url_invocata);
			pst.setInt(++i, id_utente);
			pst.setString(++i, username);
			pst.setString(++i, response);
			pst.setString(++i, tipo_op);
			pst.execute();

			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
}
