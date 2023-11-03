package it.us.web.action.guc;

import it.us.web.action.GenericAction;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.guc.GUCEndpoint;

import java.util.ArrayList;
import java.util.List;

import javax.xml.xpath.XPathConstants;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class ToAllineamentoUtenti extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		try{
			NodeList endpointList = (NodeList)xpath.evaluate("//endpoint", doc, XPathConstants.NODESET);
			Element endpointElem = null;
			GUCEndpoint nomeEndpoint = null;
			List<String> endpoints = new ArrayList<String>();
			
			for(int i = 0; i < endpointList.getLength(); i++){
				endpointElem = (Element)endpointList.item(i);
				nomeEndpoint = GUCEndpoint.valueOf( endpointElem.getAttribute("name") );
				endpoints.add(nomeEndpoint.toString());
			}
			
			req.setAttribute("endpoints", endpoints);
			
			gotoPage( "/jsp/guc/allineamentoUtenti.jsp" );
		}
		catch(Exception excEndpoint){
			setErrore(excEndpoint.getMessage());
			excEndpoint.printStackTrace();
			goToAction(new ToAllineamentoUtenti());
		}
		
	}
	

}
