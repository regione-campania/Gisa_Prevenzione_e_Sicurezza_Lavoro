package it.us.web.tag;

import javax.servlet.jsp.tagext.TagSupport;

public class GenericTag extends TagSupport {

	private static final long serialVersionUID = 3359813185951628509L;
	
	protected String toHtml( String original )
	{
		String ret = null;
		if( original != null )
		{
			ret = original.replace( "\n", "<BR/>" );
		}
		return ret;
	}
}
