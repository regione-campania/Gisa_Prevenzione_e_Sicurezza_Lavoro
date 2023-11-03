package it.us.web.util.properties;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class GenericProperties
{
	protected static Properties load( String fileName )
	{
		InputStream	is = GenericProperties.class.getResourceAsStream( fileName );
		Properties applicationProperties = new Properties();
		try
		{
			applicationProperties.load( is );
		} 
		catch (IOException e)
		{
			applicationProperties = null;
		}
		return applicationProperties;
	}
	
	protected static String get( String property, Properties properties )
	{
		return (properties != null) ? properties.getProperty( property ) : null;
	}
	
	/**
	 * @param property, properties
	 * @return il valore della chiave se questa e'' presente nel file message.properties, 
	 * la chiave stessa filtrata dal carattere _ (underscore) altrimenti
	 */
	protected static String getSmart( String property, Properties properties )
	{
		return ( get(property, properties) == null ) ? cleanPropertyName(property) : get(property, properties);
	}
	
	protected static String cleanPropertyName( String propertyName )
	{
		String ret = null;
		
		if( propertyName != null )
		{
			ret = propertyName.replaceAll( "_", " " ).trim();
		}
		
		return ret;
	}
	
}
