package it.us.web.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;



public class DbUtil
{
	private static Logger logger = Logger.getLogger("MainLogger");
	 public final static int POSTGRESQL = 1;
	  public final static int MSSQL = 2;
	  public final static int ORACLE = 3;
	  public final static int FIREBIRD = 4;
	  public final static int DAFFODILDB = 5;
	  public final static int DB2 = 6;
	  public final static int MYSQL = 7;
	  public final static int DERBY = 8;
	  public final static int INTERBASE = 9;
	public static void createDataSource()
	{
	/*	Jdbc3PoolingDataSource temp = new Jdbc3PoolingDataSource();
		
		temp.setUser( ApplicationProperties.getProperty( "USERNAME" ) );
		temp.setPassword( ApplicationProperties.getProperty( "PASSWORD" ) );
		temp.setServerName( ApplicationProperties.getProperty( "IP" )  );
		
		temp.setDatabaseName( ApplicationProperties.getProperty( "DATABASE" ) );
		*/
		//System.out.println("[DbUtil.getConnection] - Prelievo connessione dal DB " + ApplicationProperties.getProperty( "DATABASE" ) +  
						   //" della macchina " + ApplicationProperties.getProperty( "dbserver" ) );
		
		//datasource = temp;
	}
	
	 public static String getSequenceName(Connection db, String sequenceName) {
		    int typeId = getType(db);
		    switch (typeId) {
		      case FIREBIRD:
		      case INTERBASE: 
		    	  // interbase actually allows 64 character names, but since we are using the same db scripts...
		        if (sequenceName.length() > 31) {
		          String seqPart1 = sequenceName.substring(0, 13);
		          String seqPart2 = sequenceName.substring(14);
		          sequenceName = seqPart1 + "_" + seqPart2.substring(seqPart2.length() - 17);
		        }
		        break;
		      case DAFFODILDB:
		        break;
		      case ORACLE:
		        if (sequenceName.length() > 30) {
		          String seqPart1 = sequenceName.substring(0, 13);
		          String seqPart2 = sequenceName.substring(14);
		          sequenceName = seqPart1 + "_" + seqPart2.substring(seqPart2.length() - 16);
		        }
		        break;
		      case DB2:
		        if (sequenceName.length() > 30) {
		          String seqPart1 = sequenceName.substring(0, 13);
		          String seqPart2 = sequenceName.substring(14);
		          sequenceName = seqPart1 + "_" + seqPart2.substring(seqPart2.length() - 16);
		        }
		        break;
		      default:
		        break;
		    }
		    return sequenceName;
		  }

	 public static int getNextSeqTipo(Connection db, String origSequenceName) throws SQLException {
		    
		    int id = -1;
		    Statement st = db.createStatement();
		    ResultSet rs = null;
		    String sequenceName = getSequenceName(db, origSequenceName);

		        rs = st.executeQuery(
		            "SELECT nextval ('" + sequenceName + "');");
		        
		    if (rs.next()) {
		      id = rs.getInt(1);
		    }
		    rs.close();
		    st.close();
		    return id;
		  }
	public static int getType(Connection db) {
	    String databaseName = db.getClass().getName();
	    if (databaseName.indexOf("postgresql") > -1 || databaseName.equalsIgnoreCase("org.aspcfs.utils.CustomConnection")) {
	      return POSTGRESQL;
	    } else if ("net.sourceforge.jtds.jdbc.ConnectionJDBC3".equals(
	        databaseName)) {
	      return MSSQL;
	    } else if ("net.sourceforge.jtds.jdbc.TdsConnectionJDBC3".equals(
	        databaseName)) {
	      return MSSQL;
	    } else if (databaseName.indexOf("sqlserver") > -1) {
	      return MSSQL;
	    } else if ("net.sourceforge.jtds.jdbc.TdsConnection".equals(databaseName)) {
	      return MSSQL;
	    } else if ("org.firebirdsql.jdbc.FBConnection".equals(databaseName)) {
	      return FIREBIRD;
	    } else if ("org.firebirdsql.jdbc.FBDriver".equals(databaseName)) {
	      return FIREBIRD;
	    } else if ("oracle.jdbc.driver.OracleConnection".equals(databaseName)) {
	      return ORACLE;
	    } else if (databaseName.indexOf("oracle") > -1) {
	      return ORACLE;
	    } else
	    if ("in.co.daffodil.db.jdbc.DaffodilDBConnection".equals(databaseName)) {
	      return DAFFODILDB;
	    } else if (databaseName.indexOf("db2") > -1) {
	      return DB2;
	    } else if (databaseName.indexOf("mysql") > -1) {
	      return MYSQL;
	    } else if (databaseName.indexOf("derby") > -1) {
	      return DERBY; 
	    } else if ( "interbase.interclient.Connection".equals( databaseName ) ) {
	      return INTERBASE;
	    } else {
	      System.out.println("DatabaseUtils-> Unkown Connection Class: " + databaseName);
	      return -1;
	    }
	  }
	
	public static void destroyDataSource()
	{
		/*if( datasource != null )
		{
			datasource.close();
		}*/
	}

	
	public static Connection getConnection() throws SQLException
	{
		
		
		/*if( datasource == null )
		{
			createDataSource();
		}
		
		return (datasource == null) ? (null) : (datasource.getConnection());
		*/
		Context ctx = null;
		try {
			ctx = new InitialContext();
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		javax.sql.DataSource ds = null;
		try {
			ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/gucM");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ds.getConnection();
		
		
	}
	
	public static void close(Connection db) throws SQLException
	{
		if(db!=null)
		{
			db.close();
		}
	}

	public static void close(ResultSet rs, Statement st)
	{
		if (rs != null) {
			try {
				rs.close();
			}
			catch (Exception e) { }
		}
		
		if (st != null) {
			try {
				st.clearWarnings();
				st.close();
			}
			catch (Exception e) { }
		}
	}

	public static void close(ResultSet rs)
	{
		if (rs != null) {
			try {
				rs.close();
			}
			catch (Exception e) { }
		}
	}

	public static void close(Statement st)
	{
		if (st != null) {
			try {
				st.clearWarnings();
				st.close();
			}
			catch (SQLException e) { }
		}
	}

	public static void close(PreparedStatement stat, Connection conn) throws SQLException {
		if (stat != null) {
			try {
				stat.close();
				stat.clearWarnings();
			}
			catch (Exception e) { }
		}
		
		if (conn != null) {
			conn.close();
		}
	}

	public static void close(ResultSet res, PreparedStatement stat, Connection conn) throws SQLException
	{
		close( res );
		close( stat, conn );
	}
	


	
	
	
}
