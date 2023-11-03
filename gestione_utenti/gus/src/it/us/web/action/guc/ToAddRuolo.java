package it.us.web.action.guc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.naming.NamingException;

import javassist.bytecode.Descriptor.Iterator;
import it.us.web.action.GenericAction;
import it.us.web.action.Home;
import it.us.web.bean.endpointconnector.EndPoint;
import it.us.web.bean.endpointconnector.EndPointConnector;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.bean.endpointconnector.EndPointList;
import it.us.web.bean.endpointconnector.Operazione;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.Ruolo;
import it.us.web.bean.guc.Utente;
import it.us.web.constants.ExtendedOptions;
import it.us.web.dao.AslDAO;
import it.us.web.dao.guc.UtenteGucDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.guc.DbUtil;

public class ToAddRuolo extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		EndPointList listaEndPoint = new EndPointList();
		listaEndPoint.creaLista(db);
		req.setAttribute("listaEndPoint", listaEndPoint);
		
		
		ArrayList<Ruolo> listaRuoli ;
		List<String> endpoints = new ArrayList<String>();
		EndPointConnectorList listaEndPointConnector = (EndPointConnectorList) req.getSession().getAttribute("listaEndPointConnector");
		EndPointConnectorList listaEndPointConnectorOperazione = listaEndPointConnector.getByIdOperazione(Operazione.GETRUOLIUTENTE); 
		 for(int i = 0; i <listaEndPointConnectorOperazione.size(); i++){
			 EndPointConnector epc = (EndPointConnector) listaEndPointConnectorOperazione.get(i);
		 	listaRuoli = new ArrayList<Ruolo>();
			endpoints.add(epc.getEndPoint().getNome());
			
			Connection conn = null;
			String dataSource = epc.getEndPoint().getDataSourceSlave();
			
				try {
					conn = DbUtil.ottieniConnessioneJDBC(dataSource);
					gestioneRuoliUtente(listaRuoli,epc, conn);
				} catch (SQLException | NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				finally {
					DbUtil.chiudiConnessioneJDBC(null, conn, dataSource);
				}
		
			req.setAttribute("listaRuoli" + epc.getEndPoint().getNome(), listaRuoli);
		}
			
			
		gotoPage( "/jsp/guc/add_ruolo.jsp" );
	}
	
	
	private void gestioneRuoliUtente( ArrayList<Ruolo> ruoloUtenteList,EndPointConnector epc, Connection conn ) throws Exception{
		  
		 
		PreparedStatement pst = null;
		ResultSet rs = null;
		try{

			String queryRuoliUtente = epc.getSql();
			ExtendedOptions e = new ExtendedOptions();
			ArrayList<String> opt = e.getListOptions(epc.getEndPoint().getNome());
			pst = conn.prepareStatement(queryRuoliUtente);
		
			DBI=pst.toString();
			
			rs = pst.executeQuery();
			Ruolo r = null;
			while( rs.next() ){
				r = new Ruolo();
				r.setRuoloInteger(rs.getInt("id_ruolo"));
				r.setRuoloString(rs.getString("descrizione_ruolo"));
				r.setNote(rs.getString("note_ruolo"));
				
				if (opt!=null && opt.size()>0){
					HashMap<String,String> o = new HashMap<String, String>();
					for (int i=0;i<opt.size();i++){
						o.put(epc.getEndPoint().getNome()+"_"+opt.get(i).toString(), rs.getObject(opt.get(i).toString()).toString());
					}
					r.setExtOpt(o);
				}
				ruoloUtenteList.add(r);
			}
		}
		catch (Exception e){
			throw e;
//			e.printStackTrace();
		}
}
}
