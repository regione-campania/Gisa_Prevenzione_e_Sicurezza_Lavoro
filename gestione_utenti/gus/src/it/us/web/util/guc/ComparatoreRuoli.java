package it.us.web.util.guc;

import it.us.web.bean.guc.Utente;

import java.util.Comparator;


public class ComparatoreRuoli implements Comparator<Utente> {

	String endpoint;
	
	public String getEndpoint() {
		return endpoint;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	@Override
	public int compare(Utente u1, Utente u2) {
			return u1.getHashRuoli().get(endpoint).getRuoloString().compareTo(u2.getHashRuoli().get(endpoint).getRuoloString());
	}

	
	
}
