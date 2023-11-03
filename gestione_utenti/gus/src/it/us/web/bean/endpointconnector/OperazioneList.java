package it.us.web.bean.endpointconnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;


public class OperazioneList extends Vector  {
	
	public void creaLista(Connection db){
		String sql = "select * from guc_operazioni where enabled order by id asc"; 
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while (rs.next()){
				Operazione op = new Operazione(rs);
				this.add(op);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		
		
		
	}
	
	
}
