package it.us.web.util;

import it.us.web.bean.Parameter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

public class ParameterUtils
{
	@SuppressWarnings("unchecked")
	public static ArrayList<Parameter> list( HttpServletRequest req, String prefisso )
	{
		ArrayList<Parameter> ret = new ArrayList<Parameter>();
		
		Enumeration<String> e = (Enumeration<String>)req.getParameterNames();
		
		while(e.hasMoreElements())
		{
			String nome_parametro = (String)e.nextElement();
			if( nome_parametro.startsWith( prefisso ) )
			{
				Parameter p = new Parameter();
				
				p.setPrefisso( prefisso );
				p.setNome( nome_parametro );
				p.setValore( req.getParameter( nome_parametro ) );
				
				try
				{
					String id = p.getNome().replace( prefisso, "" );
					p.setId( Integer.parseInt( id ) );
				}
				catch (Exception e1)
				{
					
				}
				ret.add( p );
			}
		}
		
		Collections.sort( ret );
		
		return ret;
	}
}
