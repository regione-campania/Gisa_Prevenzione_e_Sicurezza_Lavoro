package it.us.web.util.guc;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DwrGUC { 

	
	public static boolean verificaEsistenzaStabGiava(String numRegistrazione) throws SQLException
	{
		boolean esistente = false;
		Connection db = null ;
		try
		{
			
			db = it.us.web.db.DbUtil.getConnection();
			PreparedStatement pst = db.prepareStatement("select * from public.dbi_check_esistenza_utente_by_numreg(?)");
			pst.setString(1, numRegistrazione);
			ResultSet rs = pst.executeQuery();
			if (rs.next())
				esistente = rs.getBoolean(1);
			
			it.us.web.db.DbUtil.close(db);
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			it.us.web.db.DbUtil.close(db);
		}
		return esistente;
	}
	
}


