package it.us.web.bean;

import java.io.Serializable;

public class Parameter implements Serializable, Comparable<Parameter>
{
	private static final long serialVersionUID = -3842980586914000622L;
	String nome		= null;
	String prefisso	= null;
	String valore	= null;
	int id 			= -1;
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getPrefisso() {
		return prefisso;
	}
	public void setPrefisso(String prefisso) {
		this.prefisso = prefisso;
	}
	public String getValore() {
		return valore;
	}
	public void setValore(String valore) {
		this.valore = valore;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int compareTo(Parameter o) {
		return (id > o.getId()) ? (1) : (-1);
	}
}
