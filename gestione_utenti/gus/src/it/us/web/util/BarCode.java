package it.us.web.util;

import com.itextpdf.text.pdf.Barcode128;

public class BarCode {

	private static final float	larghezzaImmagine 	= 216;
	private static final float	altezzaImmagine 	= 60;
	private static final float	larghezzaBarre 		= 206;
	private static final float	altezzaBarre 		= 1000;
	
		
	public static Barcode128 getBarCode128 (String numero) {
		
		Barcode128 code128 = new Barcode128();	
		code128.setCode(numero);
			
		return code128;
		
	}
	
}
