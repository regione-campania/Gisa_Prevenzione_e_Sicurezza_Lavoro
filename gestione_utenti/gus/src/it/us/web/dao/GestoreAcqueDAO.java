package it.us.web.dao;

import it.us.web.bean.BFunzione;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.GestoreAcque;
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

public class GestoreAcqueDAO extends GenericDAO {
	
	private static final Logger logger = LoggerFactory.getLogger( GestoreAcqueDAO.class );
	
	public static List<GestoreAcque> getGestori(Connection db)
	{
		
		PreparedStatement	stat	= null;
		ResultSet			rs		= null;
		GestoreAcque					g		= null;
		List<GestoreAcque>			ret		= new  ArrayList<GestoreAcque>();
		
		try
		{
			
			stat	= db.prepareStatement( Sql.GET_GESTORE );
			rs		= stat.executeQuery();
			
			while( rs.next() )
			{
				g = loadResultSet(rs);
				ret.add		( g );
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
	
	public static GestoreAcque getGestoreById(Connection db,int id)
	{
		
		PreparedStatement	stat	= null;
		ResultSet			rs		= null;
		GestoreAcque		g		= null;
		List<GestoreAcque>	ret		= new  ArrayList<GestoreAcque>();
		
		try
		{
			
			stat	= db.prepareStatement( Sql.GET_GESTORE  );
			stat.setInt(1, id);
			rs		= stat.executeQuery();
			
			if( rs.next() )
			{
				g = loadResultSet(rs);
				
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
		
		return g;
	}
	
	
	private static GestoreAcque loadResultSet(ResultSet rs) throws SQLException
	{
		GestoreAcque g;
		g = new GestoreAcque();
		g.setId	( rs.getInt("id") );
		g.setNome( rs.getString("nome") );
		return g;
	}

}
