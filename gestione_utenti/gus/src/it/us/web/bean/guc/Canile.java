package it.us.web.bean.guc;

public class Canile {
	
	private int idAsl;
	private int idCanile;
	private String descrizioneCanile;
	
	
	public int getIdAsl() {
		return idAsl;
	}
	public void setIdAsl(int idAsl) {
		this.idAsl = idAsl;
	}
	public int getIdCanile() {
		return idCanile;
	}
	public void setIdCanile(int idCanile) {
		this.idCanile = idCanile;
	}
	public String getDescrizioneCanile() {
		return descrizioneCanile;
	}
	public void setDescrizioneCanile(String descrizioneCanile) {
		this.descrizioneCanile = descrizioneCanile;
	}
	
	@Override
	public String toString(){
		return getIdCanile()+"";
	} 

}
