package it.us.web.action.guc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javassist.bytecode.Descriptor.Iterator;
import it.us.web.action.GenericAction;
import it.us.web.action.Home;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.Utente;
import it.us.web.dao.AslDAO;
import it.us.web.dao.guc.UtenteGucDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToEdit extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		int id = interoFromRequest("id");
		HashMap<String,Boolean> listmodificabile = new HashMap<String,Boolean>();
		Utente u = null;
		List<Utente> utentiList = UtenteGucDAO.listaUtentibyId(db, id);//persistence.createCriteria(Utente.class).add(Restrictions.eq("id", id)).list();
		List<String> comuniList = AslDAO.getComuni(db);//persistence.createCriteria(Asl.class).add(Restrictions.ge("id", 201)).addOrder(Order.asc("nome")).list();
		req.setAttribute("comuniList", comuniList);
		if( utentiList.size() > 0 ){
			u = utentiList.get(0);
			req.setAttribute("UserRecord", u);
			
			List<Asl> aslList = AslDAO.getAsl(db);//persistence.createCriteria(Asl.class).add(Restrictions.ge("id", 201)).addOrder(Order.asc("nome")).list();
			req.setAttribute("aslList", aslList);
			
			Boolean flag = costruisciListaRuoli();
			if (flag==false){
				costruisciListaCliniche();
				costruisciListaCaniliBDU();
				costruisciListaGestori();
				costruisciListaComuni();
				
				//GISA NON e'' ANCORA SUPPORTATO
				//costruisciListaStruttureGisa();
				
				costruisciListaImportatori();
				
				HashMap<String, Integer> HashProvince = costruisciListaProvince();
				req.setAttribute("HashProvince", HashProvince);
				
				
				listmodificabile=verificaUtenteModificabile(u.getUsername());
				req.setAttribute("listmodificabile", listmodificabile);
				
				String list = "";
				java.util.Iterator<Entry<String, Boolean>> it = listmodificabile.entrySet().iterator();
				while(it.hasNext()){
					Map.Entry<String, Boolean> entry = (Map.Entry<String,Boolean>) it.next();
					if (entry.getValue()==false){
						list = list+"\n"+entry.getKey().toUpperCase();
					}
				}
				if (!list.equals("")){
					setMessaggio("Utente non modificabile per i seguenti endpoint : "+list);
				}

				gotoPage( "/jsp/guc/edit.jsp" );
			} else {
				setErrore("Impossibile procedere. Lista Ruoli non disponibile");
				goToAction(new Home());
			}
		}
		else{
			setErrore("Utente con id " + id + " non trovato");
			goToAction(new Home());
		}	
	}
}
