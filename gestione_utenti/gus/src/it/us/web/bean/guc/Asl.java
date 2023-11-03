package it.us.web.bean.guc;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;



public class Asl implements Serializable {

	private static final long serialVersionUID = 3L;
	
	private int id;
	private String nome;
	public int idVam ;
	private Set<Utente> utenti = new HashSet<Utente>(0);

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
	
	
	public Set<Utente> getUtenti() {
		return utenti;
	}
	public void setUtenti(Set<Utente> utenti) {
		this.utenti = utenti;
	}
	public int getIdVam() {
		return idVam;
	}
	public void setIdVam(int idVam) {
		this.idVam = idVam;
	}
	
	@Override
	public String toString(){
		return getId()+"";
	} 
	 
	
	

}
