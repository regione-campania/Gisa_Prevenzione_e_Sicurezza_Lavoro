package it.us.web.util;

import org.apache.commons.beanutils.Converter;

public class FloatConverter implements Converter
{
	@SuppressWarnings("unchecked")
	@Override
	public Object convert(Class clazz, Object value)
	{
		float ret = 0;

		if( value != null && !value.equals("") )
		{
			value = ((String)value).replaceAll( ",", "." );
			try
			{
				ret = Float.parseFloat( (String) value );
			}
			catch ( Exception e )
			{
				try
				{
					ret = Float.parseFloat( (String) value );
				}
				catch ( Exception e1 )
				{
					e1.printStackTrace();
				}
			}
		}
		else if( value.equals(""))
		{
			return null;
		}
		
		return ret;
	}	
}
