package it.us.web.tag;

import it.us.web.bean.BUtente;
import it.us.web.permessi.Permessi;

import java.io.IOException;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

public class Can extends GenericTag
{
	/*
	 * questo TAG puo'' contenere 5 campi
	 * nel caso che su una GUI non si abbia neanche il diritto di lettura
	 * allora sara'' stampato il valore alt
	 * nel caso si abbia il diritto di lettura sara'' stampato il valore value
	 * o in sua assenza alt
	 * nel caso si abbia il diritto di lettura e scrittura sara'' eseguito
	 * cio'' che e'' presente all'interno dei TAG
	 * 
	 */  
	
	private static final long serialVersionUID = 1L;
	private static final String templatePre = "<div class=\"etichetta-nera\"><strong>";
	private static final String templatePost = "</strong></div>";
	private String alt;
	private String f;//funzione
	private String sf;//sub-funzione
	private String og;//oggetto
	private String value;//valore per sola lettura
	private String r;//dice se eseguire il body se in sola lettura (r="r")
	
	
	public String getValue() 
	{
		return value;
	}


	public void setValue(String value) 
	{
		this.value = value;
	}


	public int doStartTag()
	{
		try
		{
			HttpSession ses = pageContext.getSession();
			
			BUtente bu=(BUtente)ses.getAttribute("utente");
			
			//int permessi=Permessi.can(bu,f.toUpperCase(),sf.toUpperCase(),og.toUpperCase());
			//Log.debug( permessi + "" );
			
			//AGGIUNTO PER GESTIRE IL PERMESSO SUL BOTTONE RPM 
			int permessi=1;
			if (bu.isSuperAdmin()){
				permessi=2;
			}
			
			if(permessi==0 && alt!=null)
			{
				JspWriter o = pageContext.getOut();
				o.print(  templatePre + toHtml( alt  ) + templatePost  );
				return SKIP_BODY;
			}
			if(permessi==0 && alt==null)
			{
				//JspWriter o = pageContext.getOut();
				//o.print(  templatePre + toHtml( ""  ) + templatePost  );
				return SKIP_BODY;
			}
			if(permessi==1)
			{
				if( r != null && r.equalsIgnoreCase( "r" ) )
				{
					return EVAL_BODY_INCLUDE;
				}
				else if(value!=null)
				{
					JspWriter o = pageContext.getOut();
					o.print(  templatePre + toHtml( value  ) + templatePost  );
					return SKIP_BODY;
				}
				else{
					if(alt!=null)
					{
						JspWriter o = pageContext.getOut();
						o.print(  templatePre + toHtml( alt  ) + templatePost  );
						return SKIP_BODY;
					}
					else
					{
						JspWriter o = pageContext.getOut();
						o.print(  templatePre + toHtml( ""  ) + templatePost  );
						return SKIP_BODY;
					}
				}
			}
			if(permessi==2)
			{
				return EVAL_BODY_INCLUDE;
			}
			
				
		}
		catch(IOException e)
		{
			e.printStackTrace();
			return SKIP_BODY;
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


	public String getF() {
		return f;
	}


	public void setF(String f) {
		this.f = f;
	}


	public String getOg() {
		return og;
	}


	public void setOg(String og) {
		this.og = og;
	}


	public String getSf() {
		return sf;
	}


	public void setSf(String sf) {
		this.sf = sf;
	}


	public String getR() {
		return r;
	}


	public void setR(String r) {
		this.r = r;
	}
}