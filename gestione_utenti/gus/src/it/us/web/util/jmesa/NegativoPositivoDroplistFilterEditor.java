package it.us.web.util.jmesa;

import java.util.ArrayList;

import org.jmesa.view.html.editor.DroplistFilterEditor;

public class NegativoPositivoDroplistFilterEditor extends DroplistFilterEditor {
   @Override
   protected ArrayList<Option> getOptions()  {
	   ArrayList<Option> options = new ArrayList<Option>();
      options.add(new Option("Negativo","Negativo"));
      options.add(new Option("Positivo", "Positivo"));
      return options;
   }
}