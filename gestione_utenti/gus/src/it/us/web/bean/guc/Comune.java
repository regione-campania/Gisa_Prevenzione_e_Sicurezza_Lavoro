package it.us.web.bean.guc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;


public class Comune implements Serializable {

	private static final long serialVersionUID = 2L;
	
	private int id;
	private String endpoint;
	private String nome;
	private HashMap<String,String> extOpt;
	
	private boolean selected = false;
	
	public String getNome() {
		return nome;
	}


	public void setNome(String nome) {
		this.nome = nome;
	}


	public boolean isQualifica() {
		return qualifica;
	}


	public void setQualifica(boolean qualifica) {
		this.qualifica = qualifica;
	}


	private boolean qualifica = false;
	
	
	public Comune() {
		setExtOpt(new HashMap<String,String>());
	}
	

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	

	public String getEndpoint() {
		return endpoint;
	}
	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}
	
	@Override
	public String toString(){
		return getEndpoint()+";;;"+getId();
	}


	public HashMap<String,String> getExtOpt() {
		return extOpt;
	}


	public void setExtOpt(HashMap<String,String> extOpt) {
		this.extOpt = extOpt;
	} 
	
	public void buildFromRequest(HttpServletRequest req, int indice){
		selected = (req.getParameter("ruolo_"+indice)!=null && req.getParameter("ruolo_"+indice).equals("on")) ? true : false;
		nome = req.getParameter("nome");
		id = Integer.parseInt( req.getParameter("id") );
		qualifica = (req.getParameter("isQualifica_"+indice)!=null && req.getParameter("isQualifica_"+indice).equals("on")) ? true : false;
		
	}


	public boolean isSelected() {
		return selected;
	}


	public void setSelected(boolean selected) {
		this.selected = selected;
	}

}
