package it.us.web.bean;

import java.io.Serializable;



//@Entity
//@Table(name = "permessi_funzione", schema = "public")
public class BFunzione implements Serializable
{
	private static final long serialVersionUID = -7784325028312603383L;
	
	private String nome;
	private String descrizione;
	private int id;
	
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}
	
	//@Id
	//@GeneratedValue( strategy = GenerationType.IDENTITY )
	//@Column( name = "id_funzione" )
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	//@Column(unique = true)
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
}
