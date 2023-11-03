package it.us.web.util;

import org.apache.commons.beanutils.Converter;
import org.apache.commons.beanutils.converters.IntegerConverter;

public class MyIntegerConverter implements Converter
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
			IntegerConverter ic = new IntegerConverter();
			return ic.convert(arg0, arg1);
		}
	}
}



