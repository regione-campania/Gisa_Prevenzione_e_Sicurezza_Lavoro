package it.us.web.constants;

import java.util.ArrayList;

public class ExtendedOptions {
	//GISA
	public ArrayList<String> Gisa = new ArrayList<String>(){{add("access");add("dpat");add("nucleo_ispettivo");}};
	
	//GISA_EXT
	public ArrayList<String> Gisa_ext = new ArrayList<String>(){{add("access");add("nucleo_ispettivo");}};
	
	//BDU
	public ArrayList<String> bdu = new ArrayList<String>();
	
	//VAM
	public ArrayList<String> Vam = new ArrayList<String>();
	
	//IMPORTATORI
	public ArrayList<String> Importatori = new ArrayList<String>();
	
	//DIGEMON
	public ArrayList<String> Digemon = new ArrayList<String>();

	
	public ArrayList<String> getListOptions(String endpoint){
		ArrayList<String> ret = null;
		switch (endpoint){
			case "Gisa" : ret = Gisa; break;
			case "Gisa_ext" : ret = Gisa_ext; break;
			case "bdu" : ret = bdu; break;
			case "Vam" : ret = Vam; break;
			case "Importatori" : ret = Importatori; break;
			case "Digemon" : ret = Digemon; break;

		}
		return ret;
	}
}
