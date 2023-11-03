package it.us.web.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Md5
{
	public static String encrypt(String password)
	{
		MessageDigest messageDigest;
		try
		{
			messageDigest = MessageDigest.getInstance("MD5");
		}
		catch (NoSuchAlgorithmException e)
		{
			return password;
		}
		byte[] bytes = messageDigest.digest( password.getBytes() );
		StringBuffer sb = new StringBuffer();
		for( int i = 0; i < bytes.length; i++ )
		{
			sb.append(Integer.toHexString((bytes[i] & 0xFF) | 0x100).toLowerCase().substring(1,3));
		}
		return sb.toString();
	}
	
}
