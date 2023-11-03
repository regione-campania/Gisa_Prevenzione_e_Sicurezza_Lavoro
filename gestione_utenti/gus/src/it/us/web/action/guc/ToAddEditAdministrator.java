package it.us.web.action.guc;

import java.util.Vector;

import it.us.web.action.GenericAction;
import it.us.web.bean.BRuolo;
import it.us.web.bean.BUtente;
import it.us.web.dao.RuoloDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ToAddEditAdministrator extends GenericAction
{
	private static final Logger logger = LoggerFactory.getLogger( EditAnagrafica.class );
	
	@Override
	public void can() throws AuthorizationException
	{
			isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		String op = stringaFromRequest("operation");
		Vector<BRuolo> ruoli = RuoloDAO.getRuoli();
		BUtente u = null;
		int id = -1;
		
		if (op.equals("edit")) {
			id = interoFromRequest("id");
			u = UtenteDAO.getUtenteBId(db, id);
		}
		
		req.setAttribute("idUtente", id);
		req.setAttribute("operation", op);
		req.setAttribute("UserRecord", u);
		req.setAttribute("ruoli", ruoli);
		gotoPage( "/jsp/guc/addEditAdministrator.jsp" );
	}
}
