package it.us.web.util;

import org.apache.commons.beanutils.Converter;
import org.apache.commons.beanutils.converters.DoubleConverter;

public class MyDoubleConverter implements Converter
{
	@SuppressWarnings("unchecked")
	@Override
	public Object convert(Class arg0, Object arg1) 
	{
		if(  arg1 == null || arg1.equals(""))
		{
			return null;
		}
		else
		{ 
			arg1 = (arg1.toString()).replaceAll( ",", "." );
			DoubleConverter dc = new DoubleConverter();
			return dc.convert(arg0, arg1);
		}
	}
}



