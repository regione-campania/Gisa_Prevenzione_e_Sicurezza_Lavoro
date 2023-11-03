package it.us.web.bean.guc;

public class Importatori {
	private int idImportatore ;
	private String ragioneSociale ;
	private String partitaIva ;
	private int idAsl ;
	
	
	public int getIdAsl() {
		return idAsl;
	}
	public void setIdAsl(int idAsl) {
		this.idAsl = idAsl;
	}
	public int getIdImportatore() {
		return idImportatore;
	}
	public void setIdImportatore(int idImportatore) {
		this.idImportatore = idImportatore;
	}
	public String getRagioneSociale() {
		return ragioneSociale;
	}
	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
	}
	public String getPartitaIva() {
		return partitaIva;
	}
	public void setPartitaIva(String partitaIva) {
		this.partitaIva = partitaIva;
	}
	
	@Override
	public String toString(){
		return getIdImportatore()+"";
	}

}
