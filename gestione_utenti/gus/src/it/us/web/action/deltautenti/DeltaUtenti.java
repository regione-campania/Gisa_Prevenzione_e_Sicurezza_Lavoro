package it.us.web.action.deltautenti;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONObject;

import it.us.web.action.GenericAction;
import it.us.web.bean.endpointconnector.EndPoint;
import it.us.web.bean.endpointconnector.EndPointConnector;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.bean.endpointconnector.Operazione;
import it.us.web.db.ApplicationProperties;
import it.us.web.exceptions.ActionNotValidException;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.guc.UrlUtil;
import it.us.web.util.properties.Message;

public class DeltaUtenti extends GenericAction
{
	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}
	
	@Override
	public void execute() throws Exception {
		// TODO Auto-generated method stub
		can();
		if(ApplicationProperties.getAmbiente().toUpperCase().contains("UFFICIALE")){
			throw new ActionNotValidException( Message.getSmart("FUNZIONE_NON_DISPONIBILE") );
		}
		
		String cf;
		String ambiente;
		String endpoint;
		
		cf = req.getParameter("codice_fiscale");
		ambiente = req.getParameter("ambiente");
		endpoint = req.getParameter("endpoint");
		
		
		String sql = "select execute_delta_utenti(?,?,?)";
		PreparedStatement pst;
		try {
			pst = db.prepareStatement(sql);
			pst.setString(1, ambiente);
			pst.setString(2, cf);
			pst.setString(3, endpoint);
			ResultSet rs = pst.executeQuery();
			int j = 0;
			while (rs.next()){
				String res = rs.getString(++j);
				req.setAttribute("res", res);
				
				JSONObject jsonEsito = new JSONObject(res);
				
				for(int k=0; k<jsonEsito.length(); k++){
					if(jsonEsito.has(Integer.toString(k))){
						JSONObject jsonI = (JSONObject) jsonEsito.get(Integer.toString(k));

						if(jsonI.has("ListaEndPoint")){
							EndPointConnectorList listaEndPointConnector = (EndPointConnectorList) req.getSession().getAttribute("listaEndPointConnector");
							JSONArray jsonEsitoListaEndPoint = (JSONArray) jsonI.get("ListaEndPoint"); 
							
							for (int i = 0; i<jsonEsitoListaEndPoint.length(); i++){
								JSONObject jsonEndPoint = null;
								JSONArray jsonEndPointRisultatoArray = null;
								JSONObject jsonEndPointRisultato = null;
			
								jsonEndPoint = (JSONObject) jsonEsitoListaEndPoint.get(i);
			
								if (jsonEndPoint.has("Risultato"))
									jsonEndPointRisultatoArray = (JSONArray)  jsonEndPoint.get("Risultato");
			
								if (jsonEndPointRisultatoArray!=null && jsonEndPointRisultatoArray.length()>0)
									jsonEndPointRisultato = (JSONObject) jsonEndPointRisultatoArray.get(0);
			
								if (jsonEndPointRisultato!=null && jsonEndPointRisultato.has("Esito")) {
									
									if (jsonEndPointRisultato.get("Esito").equals("OK")){
										EndPointConnector epcInserimentoENDPOINT = listaEndPointConnector.getByIdOperazioneIdEndPoint(Operazione.INSERTUTENTE, (jsonEndPoint.get("EndPoint").equals("GISA") ? EndPoint.GISA : jsonEndPoint.get("EndPoint").equals("GISA_EXT") ? EndPoint.GISA_EXT : jsonEndPoint.get("EndPoint").equals("BDR") ? EndPoint.BDU : jsonEndPoint.get("EndPoint").equals("VAM") ? EndPoint.VAM : jsonEndPoint.get("EndPoint").equals("DIGEMON") ? EndPoint.DIGEMON :  jsonEndPoint.get("EndPoint").equals("SICUREZZALAVORO") ? EndPoint.SICUREZZALAVORO : -1));
										String urlReloadUtenti = epcInserimentoENDPOINT.getUrlReloadUtenti() +jsonI.get("Username");
										System.out.println("[GUC] [VALIDAZIONE] RELOAD UTENTI: " + urlReloadUtenti);
										try {String resp = UrlUtil.getUrlResponse(urlReloadUtenti); } catch (Exception e) {}
			
									}
								}
							}
						}
					}
				}
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		
		
		gotoPage( "/jsp/deltautenti/delta_utenti.jsp" );
	}
}
