package it.us.web.util.jmesa;

import it.us.web.util.guc.GUCEndpoint;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.jmesa.core.filter.FilterMatcher;
import org.jmesa.core.filter.FilterMatcherMap;
import org.jmesa.core.filter.MatcherKey;
import org.jmesa.core.filter.StringFilterMatcher;


public class MyFilterMatcherMap implements FilterMatcherMap
{ 
	public Map<MatcherKey, FilterMatcher> getFilterMatchers() 
	{ 
		Map<MatcherKey, FilterMatcher> filterMatcherMap = new HashMap<MatcherKey, FilterMatcher>(); 
		filterMatcherMap.put(new MatcherKey(Date.class),    new MyDateFilterMatcher()); 
		filterMatcherMap.put(new MatcherKey(boolean.class), new StringFilterMatcher());
//		filterMatcherMap.put(new MatcherKey(null), new RuoloFilterMatcher());
		return filterMatcherMap;
	}

} 
