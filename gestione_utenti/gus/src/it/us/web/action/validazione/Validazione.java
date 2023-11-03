package it.us.web.action.validazione;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.mail.MessagingException;
import javax.mail.SendFailedException;

import org.json.JSONArray;
import org.json.JSONObject;

import it.us.web.action.GenericAction;
import it.us.web.bean.endpointconnector.EndPoint;
import it.us.web.bean.endpointconnector.EndPointConnector;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.bean.endpointconnector.Operazione;
import it.us.web.bean.guc.Utente;
import it.us.web.bean.validazione.Richiesta;
import it.us.web.db.ApplicationProperties;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.guc.GUCEndpoint;
import it.us.web.util.guc.UrlUtil;
import it.us.web.util.mail.bean.PecMailSenderThread;



public class Validazione extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception
	{
		String numeroRichiesta = stringaFromRequest("numeroRichiesta");
		int idTipoOperazione = interoFromRequest("idTipoOperazione");
		String messaggioRuoli = "";

		if (idTipoOperazione == 1 || idTipoOperazione == 2 || idTipoOperazione == 3){
			Richiesta ric = new Richiesta(db, numeroRichiesta);

			Boolean inNucleo = null;
			Boolean inDpat = null;

			try {inNucleo = Boolean.parseBoolean(stringaFromRequest("inNucleo")); } catch (Exception e) {}
			try {inDpat = Boolean.parseBoolean(stringaFromRequest("inDpat")); } catch (Exception e) {}

			ric.aggiornaFlag(db, inNucleo, inDpat);

			String esito =  ric.processa(db, utente.getId());

			try {
				JSONObject jsonEsito = new JSONObject(esito);

				EndPointConnectorList listaEndPointConnector = (EndPointConnectorList) req.getSession().getAttribute("listaEndPointConnector");

				JSONArray jsonEsitoListaEndPoint = (JSONArray) jsonEsito.get("ListaEndPoint"); 

				if (ric.getIdTipoRichiesta()==1 || ric.getIdTipoRichiesta()==2) {

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
								String urlReloadUtenti = epcInserimentoENDPOINT.getUrlReloadUtenti() +jsonEsito.get("Username");
								System.out.println("[GUC] [VALIDAZIONE] RELOAD UTENTI: " + urlReloadUtenti);
								try {String resp = UrlUtil.getUrlResponse(urlReloadUtenti); } catch (Exception e) {}
								
								
								
								
								if(ric.getIdRuoloBdu()==24 && jsonEndPoint.get("EndPoint").equals("GISA"))
								{
									EndPointConnectorList listaEndPointConnectorOperazioneSecondaria = listaEndPointConnector.getByIdOperazione(Operazione.INSERTUTENTE); 
									for(int j = 0; i <listaEndPointConnectorOperazioneSecondaria.size(); j++)
									{
										EndPointConnector epcSecondaria = (EndPointConnector) listaEndPointConnectorOperazioneSecondaria.get(j);
										if(epcSecondaria.getEndPoint().getId()==EndPoint.VAM)
										{
											String urlReloadUtentiSecondaria = epcSecondaria.getUrlReloadUtenti();
											try {String resp = UrlUtil.getUrlResponse(urlReloadUtentiSecondaria); } catch (Exception e) {}
										}
										j++;
									}
								}
								
								
								
							}
							messaggioRuoli +="\n\n"+ (jsonEndPoint.get("EndPoint").equals("GISA") ? "GISA\n " + ric.getRuoloGisa() : jsonEndPoint.get("EndPoint").equals("GISA_EXT") ? "GISA\n " + ric.getRuoloGisaExt() : jsonEndPoint.get("EndPoint").equals("BDR") ? "BDR\n " + ric.getRuoloBdu() : jsonEndPoint.get("EndPoint").equals("VAM") ? "VAM\n " + ric.getRuoloVam() : jsonEndPoint.get("EndPoint").equals("DIGEMON") ? "DIGEMON\n " + ric.getRuoloDigemon() : jsonEndPoint.get("EndPoint").equals("SICUREZZALAVORO") ? "SICUREZZA LAVORO\n " + ric.getRuoloSicurezzaLavoro() : "");
							
							if (jsonEndPointRisultato.get("Esito").equals("OK"))
								messaggioRuoli+= "\n\tVALIDAZIONE CON SUCCESSO.";
							else if (jsonEndPointRisultato.get("Esito").equals("KO"))
								messaggioRuoli+= "\n\tERRORE NELLA VALIDAZIONE. ("+jsonEndPointRisultato.get("DescrizioneErrore")+")\n Contattare l'Help Desk.";
						}

					}
				}
				else if (ric.getIdTipoRichiesta()==3) {
					for (int i = 0; i<jsonEsitoListaEndPoint.length(); i++){
						JSONObject jsonEndPoint = null;
						JSONArray jsonEndPointRisultatoArray = null;
						JSONObject jsonEndPointRisultato = null;

						jsonEndPoint = (JSONObject) jsonEsitoListaEndPoint.get(i);

						if (jsonEndPoint.has("Risultato"))
							jsonEndPointRisultatoArray = (JSONArray)  jsonEndPoint.get("Risultato");

						if (jsonEndPointRisultatoArray!=null && jsonEndPointRisultatoArray.length()>0)
							jsonEndPointRisultato = (JSONObject) jsonEndPointRisultatoArray.get(0);

						if (jsonEndPointRisultato!=null && jsonEndPointRisultato.has("Esito") && jsonEndPointRisultato.get("Esito").equals("OK")) {
							messaggioRuoli +="\n\n"+ (jsonEndPoint.get("EndPoint").equals("GISA") ? "GISA\n " + ric.getRuoloGucRuoli() : jsonEndPoint.get("EndPoint").equals("GISA_EXT") ? "GISA\n " + ric.getRuoloGucRuoli() : jsonEndPoint.get("EndPoint").equals("BDR") ? "BDR\n " + ric.getRuoloGucRuoli() : jsonEndPoint.get("EndPoint").equals("VAM") ? "VAM\n " + ric.getRuoloGucRuoli() : jsonEndPoint.get("EndPoint").equals("DIGEMON") ? "DIGEMON\n " + ric.getRuoloGucRuoli() : jsonEndPoint.get("EndPoint").equals("SICUREZZALAVORO") ? "SICUREZZA LAVORO\n " + ric.getRuoloGucRuoli() : "");
						}

					}

				}
			} catch (Exception e) {}

			if (ApplicationProperties.getProperty("mail.invio.utente")!=null && ApplicationProperties.getProperty("mail.invio.utente").equalsIgnoreCase("si"))		
				invioMail(ric, messaggioRuoli);	

			//req.setAttribute("esito", esito); 
		}
		else if (idTipoOperazione == 999){
			Richiesta ric = new Richiesta(db, numeroRichiesta);

			String esito =  ric.rifiuta(db, utente.getId());
			//req.setAttribute("esito", esito);
			
			if (ApplicationProperties.getProperty("mail.invio.utente")!=null && ApplicationProperties.getProperty("mail.invio.utente").equalsIgnoreCase("si"))		
				invioMail(ric, "LA RICHIESTA E' STATA RIFIUTATA."); 	
		}

		Richiesta ricNew = new Richiesta(db, numeroRichiesta);
		req.setAttribute("dettaglioRichiesta", ricNew);
		gotoPage( "/jsp/validazione/richiesta.jsp" );

	}

	private void invioMail(Richiesta ric, String messaggioRuoli) throws SendFailedException, MessagingException{
		if (messaggioRuoli!=null && !messaggioRuoli.equals("")){

			System.out.println("Invio la mail a "+ric.getEmail());
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			Date date = new Date();
			String time = sdf.format(date);
			String currentTime    = String.valueOf(time);

			String oggetto = ApplicationProperties.getProperty("mail.header") + "PROFILAZIONE - Comunicazione Esito Richiesta Registrazione";

			String messaggio ="In data " + currentTime +" e' stata gestita la richiesta fatta a GISA PREVENZIONE E SICUREZZA LAVORO.\n";
			messaggio+= "\nEsito della validazione: \n";
			messaggio+= messaggioRuoli + "\n";
			messaggio+= "\nTipo richiesta: "+ric.getTipoRichiesta()+"\n";
			messaggio+= "\nNumero richiesta: "+ric.getNumeroRichiesta()+"\n";
			messaggio+= "\nCodice fiscale: "+ric.getCodiceFiscale()+"\n";

			if (!messaggioRuoli.equalsIgnoreCase("LA RICHIESTA E' STATA RIFIUTATA.")) {
				/*if (ric.getIdTipoRichiesta()==1 || ric.getIdTipoRichiesta()==2)
					messaggio+="\n\n\nDa questo momento in caso di esito positivo sara' possibile accedere tramite SPID.";
				else */if (ric.getIdTipoRichiesta()==3)
					messaggio+="OK\n\n\nDa questo momento non sara' possibile accedere per le utenze indicate.";
			}

			String mailCC = ApplicationProperties.getProperty("mail.cc");

			System.out.println("[GUC] Preparazione invio mail a "+ric.getEmail()+" e "+mailCC);

			Runnable run = new PecMailSenderThread(oggetto, messaggio, currentTime, ric.getEmail(), mailCC);
			new Thread(run).start();

			System.out.println("[GUC] Preparazione invio mail a "+ric.getEmailReferente()+" e "+mailCC);

			Runnable run2 = new PecMailSenderThread(oggetto, messaggio, currentTime, ric.getEmailReferente(), mailCC);
			new Thread(run2).start();

		}

	}

}
