package it.us.web.bean;

import java.io.Serializable;


/**
 * Questo bean serve solo a far creare la tabella permessi_gui ad hibernate
 */

//@Entity
//@Table(name = "permessi_gui", schema = "public", uniqueConstraints = {@UniqueConstraint(columnNames = {"id_subfunzione", "nome"})})
public class HGui implements Serializable
{
	private static final long serialVersionUID = -5498057834528409420L;
	
	private String nome;
	private String descrizione;
	private HSubfunzione subfunzione;
	private int id_gui;
	
	//@ManyToOne( fetch = FetchType.LAZY )
	//@JoinColumn( name = "id_subfunzione" ) 
	protected HSubfunzione getSubfunzione() {
		return subfunzione;
	}
	protected void setSubfunzione(HSubfunzione subfunzione) {
		this.subfunzione = subfunzione;
	}

	//@Id
	//@GeneratedValue( strategy = GenerationType.IDENTITY )
	protected int getId_gui() {
		return id_gui;
	}
	protected void setId_gui(int id_gui) {
		this.id_gui = id_gui;
	}
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
}
