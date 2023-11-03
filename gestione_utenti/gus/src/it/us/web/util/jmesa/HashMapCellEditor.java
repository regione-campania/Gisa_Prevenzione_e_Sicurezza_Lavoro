package it.us.web.util.jmesa;

import it.us.web.bean.guc.Ruolo;
import it.us.web.bean.guc.Utente;

import java.util.HashMap;
import java.util.TreeMap;

import org.jmesa.view.editor.CellEditor;
import org.jmesa.view.html.HtmlBuilder;

public class HashMapCellEditor implements CellEditor
{
	public Object getValue(Object item, String property, int rowcount) 
	{
		
		HashMap h = (HashMap)item;
		Utente u = (Utente)h.get("u");
		TreeMap<String, Ruolo> ruoli = u.getHashRuoli();
		String ruolo = ruoli.get(property) != null && ruoli.get(property).getRuoloInteger() > 0 ? ruoli.get(property).getRuoloString() : "N.D.";
        
        HtmlBuilder html = new HtmlBuilder();
        html.append(ruolo);
        return html.toString();
    }
}
