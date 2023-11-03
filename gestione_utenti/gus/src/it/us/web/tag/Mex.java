package it.us.web.tag;

import java.io.IOException;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspWriter;

public class Mex extends GenericTag
{
	private static final long serialVersionUID = 1L;
	private static final String templatePre1 = "<div class=\"";
	private static final String templatePre2 = "\"><strong>";
	private static final String templatePost = "</strong></div>";
	private static final String defaultClass = "etichetta-nera";
	private String alt;
	private String size;
	private String classe;
	
	public String getClasse() {
		return classe;
	}


	public void setClasse(String classe) {
		this.classe = classe;
	}
	
	public int doStartTag()
	{
		try
		{
			ServletRequest req = pageContext.getRequest();
			String messaggio = (String)req.getAttribute( "messaggio" );
			String templatePre = templatePre1 + ( (classe == null) ? (defaultClass) : (classe) ) + templatePre2;
			
			if ( (messaggio != null) && !(messaggio.equalsIgnoreCase( "" )) ) 
			{
				if(size!=null){
					messaggio=messaggio.substring(0, Integer.parseInt(size))+"...";
				}
				JspWriter o = pageContext.getOut();
				o.print(  templatePre + toHtml( messaggio ) + templatePost  );
				return SKIP_BODY;
				
			}
			else
			{
				if(size!=null && alt!=null && alt.length()<= Integer.parseInt(size))
				{
					alt=alt.substring(0, Integer.parseInt(size))+"...";
					
				}
				if(alt==null)
				{
					JspWriter o = pageContext.getOut();
					o.print(  templatePre + toHtml( ""  ) + templatePost  );
					return SKIP_BODY;
				}
				else{
					JspWriter o = pageContext.getOut();
					o.print(  templatePre + toHtml( alt  ) + templatePost  );
					return SKIP_BODY;
				}
			}
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		return SKIP_BODY;
	}
	
		
	public int doEndTag()
	{
		return EVAL_BODY_INCLUDE;
	}


	public String getAlt() {
		return alt;
	}


	public void setAlt(String alt) {
		this.alt = alt;
	}


	public String getSize() {
		return size;
	}


	public void setSize(String size) {
		this.size = size;
	}
}