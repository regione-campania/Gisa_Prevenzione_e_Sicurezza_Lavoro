package it.us.web.bean;

import it.us.web.permessi.Permessi;

public class BRuolo
{
	String ruolo;
	String descrizione;
	int id;
	
	public boolean isGiaAssegnato()
	{
		return Permessi.isRuoloAssegnato( ruolo );
	}
	
	public int getNumeroUtentiAssegnatiRuolo()
	{
		return Permessi.getNumeroUtentiAssegnatiRuolo( ruolo );
	}

	public String getDescrizione()
	{
		return descrizione;
	}
	
	public void setDescrizione(String descrizione)
	{
		this.descrizione = ( descrizione == null )?( "" ):( descrizione );
	}

	public String getRuolo() {
		return ruolo;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public void setRuolo(String ruolo) {
		this.ruolo = ruolo;
	}
}
