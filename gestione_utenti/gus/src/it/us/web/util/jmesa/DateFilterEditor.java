package it.us.web.util.jmesa;

import org.jmesa.limit.Filter;
import org.jmesa.limit.Limit;
import org.jmesa.view.editor.AbstractFilterEditor;
import org.jmesa.view.html.HtmlBuilder;
import org.jmesa.view.html.component.HtmlColumn;

public class DateFilterEditor extends AbstractFilterEditor
{
    	
	@Override
    public HtmlColumn getColumn()
    {
        return (HtmlColumn)super.getColumn();
    }

    public Object getValue()
    {
        HtmlBuilder html = new HtmlBuilder();
               
        Limit limit = getCoreContext().getLimit();
        HtmlColumn column = getColumn();
        String property = column.getProperty();
        Filter filter = limit.getFilterSet().getFilter(property);

        String filterValue = "";
        if (filter != null)
        {
            filterValue = filter.getValue();
        }
        
        String inizio = (filterValue.equals("") || filterValue.split("-----")[0].equals("nullo"))?(""):(filterValue.split("-----")[0]);
		String fine   = (filterValue.equals("") || filterValue.split("-----")[1].equals("nullo"))?(""):(filterValue.split("-----")[1]);

		html.append("Dal: ");
        html.input().styleClass("dynFilter");
        html.id(property+"Iniziale");
        html.readonly();
        html.value(inizio);
        html.size("10");
        html.onchange("jQuery.jmesa.createDynDateFilter(this, '" + limit.getId() + "','" + column.getProperty() + "')");
        html.close();
        
        html.img().src("images/b_calendar.gif");
        html.id("id_img_" + property + "Iniziale");
        html.alt("calendario");
        html.close();
        html.script().type("text/javascript");
        html.close();
        html.append("Calendar.setup({" +
        		"inputField     :    \""+property+"Iniziale\","+     
				"ifFormat       :    \"%d/%m/%Y\","+
				"button         :    \"id_img_" + property + "Iniziale\",  "+
				"singleClick    :    true,"+
				"timeFormat		:   \"24\","+
				"showsTime		:   false"+
					 "});");
        html.scriptEnd();
        
        html.append(" <br> ");
        html.append(" Al: ");
        html.input().styleClass("dynFilter");
        html.id(property+"Finale");
        html.readonly();
        html.value(fine);
        html.size("10");
        html.onchange("jQuery.jmesa.createDynDateFilter(this, '" + limit.getId() + "','" + column.getProperty() + "')");
        html.close();
        
        html.img().src("images/b_calendar.gif");
        html.id("id_img_" + property + "Finale");
        html.alt("calendario");
        html.close();
        html.script().type("text/javascript");
        html.close();
        html.append("Calendar.setup({" +
        		"inputField     :    \""+property+"Finale\","+     
				"ifFormat       :    \"%d/%m/%Y\","+
				"button         :    \"id_img_" + property + "Finale\",  "+
				"singleClick    :    true,"+
				"timeFormat		:   \"24\","+
				"showsTime		:   false"+
					 "});");
        html.scriptEnd();
        
				 					    

        return html.toString();
    }
}

