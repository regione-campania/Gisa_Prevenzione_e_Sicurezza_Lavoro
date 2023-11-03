package it.us.web.util.properties;

import java.util.Properties;

public class Application extends GenericProperties
{
	protected static Properties properties = null;
	
	static
	{
		properties = load( "application.properties" );
	}
	
	public static String get(String property)
	{
		return get( property, properties );
	}

	/**
	 * @param property
	 * @return il valore della chiave se questa e'' presente nel file message.properties, 
	 * la chiave stessa filtrata dal carattere _ (underscore) altrimenti
	 */
	public static String getSmart(String property)
	{
		return getSmart( property, properties );
	}
	
}
