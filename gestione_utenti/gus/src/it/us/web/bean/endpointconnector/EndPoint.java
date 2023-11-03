package it.us.web.bean.endpointconnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;



public class EndPoint {

	private int id = -1;
	private String nome ="";
	private String dataSourceMaster="";
	private String dataSourceSlave="";
	
	public static final int BDU= 1;
	public static final int GISA= 2;
	public static final int GISA_EXT= 3;
	public static final int VAM= 4;
	public static final int IMPORTATORI= 5;
	public static final int GUC= 6;
	public static final int DIGEMON= 7;
	public static final int SICUREZZALAVORO= 9; 
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getDataSourceMaster() {
		return dataSourceMaster;
	}

	public void setDataSourceMaster(String dataSourceMaster) {
		this.dataSourceMaster = dataSourceMaster;
	}

	public String getDataSourceSlave() {
		return dataSourceSlave;
	}

	public void setDataSourceSlave(String dataSourceSlave) {
		this.dataSourceSlave = dataSourceSlave;
	}

	public EndPoint() {

	}
	public EndPoint(Connection db, int id) {
		 String sql = "select * from guc_endpoint where id = ?";
		 PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			pst.setInt(1, id);
			ResultSet rs = pst.executeQuery();
			if (rs.next())
				buildRecord(rs);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	 
	}

	public EndPoint(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	
	private void buildRecord(ResultSet rs) throws SQLException {
		this.id =  rs.getInt("id");
		this.nome = rs.getString("nome");
		this.dataSourceMaster = rs.getString("ds_master");
		this.dataSourceSlave = rs.getString("ds_slave");
	}
	
	
	
	public static ArrayList<EndPoint> getListaEndPoint(Connection db, boolean includeGUC){
		ArrayList<EndPoint> lista = new ArrayList<EndPoint>();
		 String sql = "select * from guc_endpoint where enabled";
		 if (!includeGUC)
			 sql+= " and id <> "+EndPoint.GUC;
		 PreparedStatement pst;
		 try {
				pst = db.prepareStatement(sql);
				ResultSet rs = pst.executeQuery();
				while (rs.next()){
					EndPoint ep = new EndPoint();
					ep.buildRecord(rs);
					lista.add(ep);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	 
		return lista;
	}
}
	







	

