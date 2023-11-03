package it.us.web.util.jmesa;

import java.util.ArrayList;
import java.util.TreeMap;

import org.jmesa.view.html.editor.DroplistFilterEditor;

public class AslDroplistFilterEditor extends DroplistFilterEditor {
	
	private static TreeMap<String, String> mapValueLabel = new TreeMap<String, String>();
	
   public static TreeMap<String, String> getMapValueLabel() {
		return mapValueLabel;
	}

	public static void setMapValueLabel(TreeMap<String, String> mapValueLabel) {
		AslDroplistFilterEditor.mapValueLabel = mapValueLabel;
	}

@Override
   protected ArrayList<Option> getOptions()  {
	  ArrayList<Option> options = new ArrayList<Option>();
	  for(String key : mapValueLabel.keySet()){
		  options.add(new Option(mapValueLabel.get(key),key));
	  }
      return options;
   }
}