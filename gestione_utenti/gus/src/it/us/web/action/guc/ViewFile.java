package it.us.web.action.guc;

import it.us.web.action.GenericAction;
import it.us.web.bean.guc.Asl;
import it.us.web.dao.AslDAO;
import it.us.web.exceptions.AuthorizationException;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletOutputStream;

public class ViewFile extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		
		
		
		File fileToview = new File (context.getAttribute("FILES_DIR")+File.separator + req.getParameter("fileName").replace("/", File.separator));
		
		res.setContentType("application/excel");
     	res.setHeader("Content-Disposition", "attachment; filename=\"" + fileToview.getName() + "\"");
     	InputStream fis = new FileInputStream(fileToview);
     	 ServletOutputStream os       = res.getOutputStream();
         byte[] bufferData = new byte[1024];
         int read=0;
         while((read = fis.read(bufferData))!= -1){
             os.write(bufferData, 0, read);
         }
         os.flush();
         os.close();
         fis.close();
		
		
	}
	
	

}
