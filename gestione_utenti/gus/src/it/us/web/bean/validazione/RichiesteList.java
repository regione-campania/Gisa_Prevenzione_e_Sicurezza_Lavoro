package it.us.web.bean.validazione;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;


public class RichiesteList extends Vector  {
	
	public static ArrayList<Richiesta> creaLista(Connection db, int limit){
		
		ArrayList<Richiesta> lista = new ArrayList<Richiesta>();
		
		String sql = "select * from spid.get_lista_richieste(null)";
		
		if (limit > 0)
			sql += " limit "+limit;
				
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			System.out.println("RECUPERO LISTA RIC: " + pst.toString());
			while (rs.next()){
				Richiesta ric = new Richiesta(rs);
				lista.add(ric);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return lista;
		}
		
}
