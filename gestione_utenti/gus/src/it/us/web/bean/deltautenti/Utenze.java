package it.us.web.bean.deltautenti;

import java.io.Serializable;

public class Utenze implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private int id;
	private String nome;
	private String cognome;
	private String codiceFiscale;
	private int ruoloInteger;
	private int aslId;
	private String endpoint;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	public String getCodiceFiscale() {
		return codiceFiscale;
	}
	public void setCodiceFiscale(String codiceFiscale) {
		this.codiceFiscale = codiceFiscale;
	}
	public int getRuoloInteger() {
		return ruoloInteger;
	}
	public void setRuoloInteger(int ruoloInteger) {
		this.ruoloInteger = ruoloInteger;
	}
	public int getAslId() {
		return aslId;
	}
	public void setAslId(int aslId) {
		this.aslId = aslId;
	}
	public String getEndpoint() {
		return endpoint;
	}
	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

}
