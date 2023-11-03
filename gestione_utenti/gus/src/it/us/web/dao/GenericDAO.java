package it.us.web.dao;

import it.us.web.db.DbUtil;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GenericDAO
{
	private static final Logger logger = LoggerFactory.getLogger( GenericDAO.class );
	
	
	public static Connection retrieveConnection() throws SQLException
	{		
		return DbUtil.getConnection();
	}
	

	public static void close( ResultSet rs, Statement st )
	{
		close( rs );
		close( st );
	}
	
	public static void close( Statement st, Connection conn )
	{
		close( st );
		close( conn );
	}
	
	public static void close( ResultSet rs, Statement st, Connection conn )
	{
		close( rs );
		close( st );
		close( conn );
	}

	public static void close( ResultSet rs )
	{
		if( rs != null )
		{
			try
			{
				rs.clearWarnings();
				rs.close();
			}
			catch (Exception e)
			{
				logger.error( "", e );
			}
		}
	}

	public static void close( Statement st )
	{
		if( st != null )
		{
			try
			{
				st.clearWarnings();
				st.close();
			}
			catch (SQLException e)
			{
				logger.error( "", e );
			}
		}
	}
	
	public static void close( Connection conn )
	{
		if( conn != null )
		{
			try
			{
				conn.clearWarnings();
				conn.close();
			}
			catch (SQLException e)
			{
				logger.error( "", e );
			}
		}
	}

}
