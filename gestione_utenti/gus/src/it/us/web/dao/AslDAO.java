package it.us.web.dao;

import it.us.web.bean.BFunzione;
import it.us.web.bean.guc.Asl;
import it.us.web.constants.Sql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AslDAO extends GenericDAO {
	
	private static final Logger logger = LoggerFactory.getLogger( AslDAO.class );
	
	public static List<Asl> getAsl(Connection db)
	{
		
		PreparedStatement	stat	= null;
		ResultSet			rs		= null;
		Asl					bf		= null;
		List<Asl>			ret		= new  ArrayList<Asl>();
		
		try
		{
			
			stat	= db.prepareStatement( Sql.GET_ASL+ " WHERE ID >=201 ORDER BY NOME ASC" );
			rs		= stat.executeQuery();
			
			while( rs.next() )
			{
				bf = loadResultSet(rs);
				ret.add		( bf );
			}
		}
		
		catch (SQLException e)
		{
			logger.error( "", e );
		}
		finally
		{
			close( rs, stat );
		}
		
		return ret;
	}
	
	public static List<String> getComuni(Connection db)
	{
		
		PreparedStatement	stat	= null;
		ResultSet			rs		= null;
	
		List<String>			ret		= new  ArrayList<String>();
		
		try
		{
			System.out.println("Query "+Sql.GET_COMUNI+ " ORDER BY comune ASC");
			stat	= db.prepareStatement( Sql.GET_COMUNI+ " ORDER BY comune ASC" );
			
			rs		= stat.executeQuery();
			
			while( rs.next() )
			{
				
				ret.add		( rs.getString("comune") );
			}
		}
		
		catch (SQLException e)
		{
			logger.error( "", e );
		}
		finally
		{
			close( rs, stat );
		}
		System.out.println("Size comune "+ret.size());
		return ret;
	}
	
	public static Asl getAslbyId(Connection db,int idAsl)
	{
		
		PreparedStatement	stat	= null;
		ResultSet			rs		= null;
		Asl					bf		= null;
		List<Asl>			ret		= new  ArrayList<Asl>();
		
		try
		{
			
			stat	= db.prepareStatement( Sql.GET_ASL+ " WHERE id=? ORDER BY NOME ASC" );
			stat.setInt(1, idAsl);
			rs		= stat.executeQuery();
			
			if( rs.next() )
			{
				bf = loadResultSet(rs);
				
			}
		}
		
		catch (SQLException e)
		{
			logger.error( "", e );
		}
		finally
		{
			close( rs, stat );
		}
		
		return bf;
	}
	
	
	private static Asl loadResultSet(ResultSet rs) throws SQLException
	{
		Asl asl;
		asl = new Asl();
		asl.setId			( rs.getInt("ID") );
		asl.setNome			( rs.getString("NOME") );
		asl.setIdVam(rs.getInt("ID_VAM"));
		return asl;
	}

}
