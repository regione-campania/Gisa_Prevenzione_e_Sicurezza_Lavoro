package it.us.web.util.jmesa;

import java.text.SimpleDateFormat;
import org.jmesa.util.ItemUtils;
import org.jmesa.view.editor.CellEditor;
import org.jmesa.view.html.HtmlBuilder;

public class DateCellEditor implements CellEditor
{
	public Object getValue(Object item, String property, int rowcount) 
	{
		HtmlBuilder html = new HtmlBuilder();
		
        Object value = ItemUtils.getItemValue(item, property);
        if(value!=null)
        {
        	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        	String data = (String)sdf.format(value);
        	html.append(data);
        }
        return html.toString();
    }
}