package it.us.web.bean.guc;

public class Clinica {

	private int idAsl;
	private int idClinica;
	private String descrizioneClinica;
	
	
	public int getIdAsl() {
		return idAsl;
	}
	public void setIdAsl(int idAsl) {
		this.idAsl = idAsl;
	}
	public int getIdClinica() {
		return idClinica;
	}
	public void setIdClinica(int idClinica) {
		this.idClinica = idClinica;
	}
	public String getDescrizioneClinica() {
		return descrizioneClinica;
	}
	public void setDescrizioneClinica(String descrizioneClinica) {
		this.descrizioneClinica = descrizioneClinica;
	}
	
	@Override
	public String toString(){
		return getIdClinica()+"";
	} 
	
}
