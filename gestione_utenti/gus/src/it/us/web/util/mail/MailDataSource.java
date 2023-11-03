package it.us.web.util.mail;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.activation.DataSource;

public class MailDataSource implements DataSource {

	byte[] bytes;

	String contentType = null;
	String name;
	
	public MailDataSource( byte[] bytes, String contentType, String name)
	{
		this.bytes = bytes;
		if (contentType == null)
		{
			this.contentType = "application/octet-stream";
		}
		else
		{
			this.contentType = contentType;
		}
		this.name = name;
	} 
	
	public String getContentType() {
		return contentType;
	}

	public InputStream getInputStream() throws IOException {
		return new ByteArrayInputStream(bytes, 0, bytes.length - 2);
	}

	public String getName() {
		return name;
	}

	public OutputStream getOutputStream() throws IOException {
		throw new FileNotFoundException(); 
	}

}
