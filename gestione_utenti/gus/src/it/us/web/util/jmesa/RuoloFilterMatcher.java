package it.us.web.util.jmesa;

import org.jmesa.core.filter.FilterMatcher;

public class RuoloFilterMatcher implements FilterMatcher {
    public boolean evaluate(Object itemValue, String filterValue) {
		
		try {
			System.out.println("itemValue: " + itemValue);
			System.out.println("filterValue: " + filterValue);
		}
		catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
    }
}
