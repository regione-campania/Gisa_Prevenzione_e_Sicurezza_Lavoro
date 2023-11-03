package it.us.web.action;

import java.sql.Connection;

import it.us.web.exceptions.AuthorizationException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface Action
{	
	public void execute() throws Exception;
	public void can() throws AuthorizationException;
	public void startup( HttpServletRequest req, HttpServletResponse res, ServletContext context );
	public void setConnectionDb( Connection db );
}
