package it.us.web.util.jmesa;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.jmesa.core.filter.FilterMatcher;

public class MyDateFilterMatcher implements FilterMatcher {
    public boolean evaluate(Object itemValue, String filterValue) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
        
		Date item;
		try 
		{
			item = sdf2.parse(String.valueOf(itemValue));
			
			String inizio = (filterValue.split("-----")[0].equals("nullo"))?(""):(filterValue.split("-----")[0]);
			String fine   = (filterValue.split("-----")[1].equals("nullo"))?(""):(filterValue.split("-----")[1]);
			
			Date dataIni = null;
			if(!String.valueOf(inizio).equals(""))
				dataIni = sdf.parse(String.valueOf(inizio));
        
			Date dataFin = null;
			if(!String.valueOf(fine).equals(""))
				dataFin = sdf.parse(String.valueOf(fine));
        
			if(dataIni!=null && item.before(dataIni))
				return false;
			if(dataFin!=null && item.after(dataFin))
				return false;	
		}
		catch (ParseException e) 
		{
			e.printStackTrace();
			return false;
		}
		return true;
    }
}
