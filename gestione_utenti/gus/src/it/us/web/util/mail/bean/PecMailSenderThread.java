package it.us.web.util.mail.bean;

import it.us.web.db.ApplicationProperties;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

public class PecMailSenderThread implements Runnable {
	
	private String oggetto;
	private String messaggio;
	private String dataModifica;
	private String mailDestinataria;
	private String  mailCcn;
      
    public PecMailSenderThread (String oggetto, String messaggio, String dataModifica, String mailDestinataria, String mailCcn) {
        this.oggetto= oggetto;
        this.messaggio= messaggio;
        this.dataModifica= dataModifica;
        this.mailDestinataria= mailDestinataria;
        this.mailCcn= mailCcn;
        
    }

    public void run() {
		
		HashMap<String,String> configs = new HashMap<String,String>();
		configs.put("mail.smtp.starttls.enable",ApplicationProperties.getProperty("mail.smtp.starttls.enable"));
		configs.put("mail.smtp.auth", ApplicationProperties.getProperty("mail.smtp.auth"));
		configs.put("mail.smtp.host", ApplicationProperties.getProperty("mail.smtp.host"));
		configs.put("mail.smtp.port", ApplicationProperties.getProperty("mail.smtp.port"));
		configs.put("mail.smtp.ssl.enable",ApplicationProperties.getProperty("mail.smtp.ssl.enable"));
//		configs.put("mail.smtp.ssl.protocols", "tlsv1.2");
//		configs.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
//		configs.put("mail.smtp.socketFactory.fallback", "false");
		
		PecMailSender sender = new PecMailSender(configs,ApplicationProperties.getProperty("username"), ApplicationProperties.getProperty("password"), dataModifica, mailDestinataria);
		sender.config = configs;
			
		//	creo cartella temporanea per salvare file xml il cui contenuto e'' estratto dal db	
		try {
			sender.sendMail(oggetto,messaggio,ApplicationProperties.getProperty("mail.smtp.from"), mailDestinataria, mailCcn, null);
		} catch (AddressException e) {
			e.printStackTrace();
			try {
				sender.sendMail(oggetto,messaggio,ApplicationProperties.getProperty("mail.smtp.from"), mailCcn, mailCcn, null);
			} catch (AddressException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (MessagingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		} catch (MessagingException e) {
			e.printStackTrace();
			}
	}
}