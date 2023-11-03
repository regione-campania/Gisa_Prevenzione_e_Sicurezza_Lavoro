package it.us.web.util.properties;

public class PropertiesTest
{

	public static void main(String[] args)
	{
		System.out.println( Message.get( "ERRORE" ) );
		System.out.println( Label.get( "PAGE_TITLE" ) );
		System.out.println( Message.getSmart( "PIPPO" ) );
		System.out.println( Label.getSmart( "page_title" ) );
		System.out.println( Message.get( "pippo" ) );
		System.out.println( Label.get( "page_aafasd" ) );
		System.out.println( Message.getSmart( "ERRORE" ) );
		System.out.println( Label.getSmart( "page_asdf" ) );
	}

}
