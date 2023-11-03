package it.us.web.bean;

import java.io.Serializable;



//@Entity
//@Table(name = "permessi_subfunzione", schema = "public", uniqueConstraints = {@UniqueConstraint(columnNames = {"id_funzione", "nome"})})
public class HSubfunzione implements Serializable
{
	private static final long serialVersionUID = -5498057834528409420L;
	
	private String nome;
	private String descrizione;
	private int id;
	private BFunzione funzione;
	
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	//@Id
	//@GeneratedValue( strategy = GenerationType.IDENTITY )
	//@Column(name = "id_subfunzione")
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	//@ManyToOne( fetch = FetchType.LAZY )
	//@JoinColumn( name = "id_funzione" )
	public BFunzione getFunzione() {
		return funzione;
	}
	public void setFunzione(BFunzione funzione) {
		this.funzione = funzione;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
}
