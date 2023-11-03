package it.us.web.bean;



/**
 * Questo bean serve solo a far creare la tabella permessi_ruoli ad hibernate
 */

//@Entity
//@Table(name = "permessi_ruoli", schema = "public")
public class HRuolo
{
	
	String ruolo;
	String descrizione;
	int id;
	
	public String getDescrizione()
	{
		return descrizione;
	}
	
	public void setDescrizione(String descrizione)
	{
		this.descrizione = ( descrizione == null )?( "" ):( descrizione );
	}

	//@Column(name = "nome", unique = true)
	public String getRuolo() {
		return ruolo;
	}

	//@Id
	//@GeneratedValue( strategy = GenerationType.IDENTITY )
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
