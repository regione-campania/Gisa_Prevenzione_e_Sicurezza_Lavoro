package it.us.web.servlet;

import it.us.web.action.GenericAction;

import java.io.File;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Bootstrap extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	final Logger logger = LoggerFactory.getLogger(Bootstrap.class);
       
    public Bootstrap() {
        super();
    }

	@Override
	public void init(ServletConfig config) throws ServletException {
		
		try{
			String fileXML = config.getServletContext().getRealPath("WEB-INF/endpoint-connector.xml");
			
			GenericAction.setFactory( DocumentBuilderFactory.newInstance() );
			GenericAction.getFactory().setValidating(false);
			GenericAction.setBuilder( GenericAction.getFactory().newDocumentBuilder() );
			GenericAction.setDoc( GenericAction.getBuilder().parse(new File(fileXML)) );
			GenericAction.setXpathfactory( XPathFactory.newInstance() );
			GenericAction.setXpath( GenericAction.getXpathfactory().newXPath() );
			
			  
		}
		catch(Exception e){
			logger.error("Eccezione durante la lettura dell'XML: " + e.getMessage());
			e.printStackTrace();
		}
		
	}

	

}
