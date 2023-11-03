package it.us.web.bean;

import java.io.Serializable;

public class BSubfunzione implements Serializable
{
	private static final long serialVersionUID = -5498057834528409420L;
	
	private String nome;
	private String descrizione;
	private int id;
	private int id_function;
	
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public int getId_function() {
		return id_function;
	}
	public void setId_function(int id_function) {
		this.id_function = id_function;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
}
