package it.us.web.tag;

import java.io.Serializable;
import java.util.Collection;

public class Contain extends GenericTag
{
	private static final long serialVersionUID = 1L;
	
	private Collection<Serializable> collection;
	private Serializable item;
	
	
	public int doStartTag()
	{
		int ret = SKIP_BODY;
		
		if( collection != null && collection.contains( item ) )
		{
			ret = EVAL_BODY_INCLUDE;
		}
		
		return ret;
	}
	
		
	public int doEndTag()
	{
		return EVAL_BODY_INCLUDE;
	}


	public Collection<Serializable> getCollection() {
		return collection;
	}


	public void setCollection(Collection<Serializable> collection) {
		this.collection = collection;
	}


	public Serializable getItem() {
		return item;
	}


	public void setItem(Serializable item) {
		this.item = item;
	}

}