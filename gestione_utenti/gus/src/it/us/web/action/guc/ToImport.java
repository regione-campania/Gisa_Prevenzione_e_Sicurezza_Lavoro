package it.us.web.action.guc;

import it.us.web.action.GenericAction;
import it.us.web.bean.guc.Asl;
import it.us.web.dao.AslDAO;
import it.us.web.exceptions.AuthorizationException;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;

public class ToImport extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		File dir = new File (""+context.getAttribute("FILES_DIR"));
		HashMap<String, File[]> listaUpload = new HashMap<String, File[]>();
		File [] listaFile = dir.listFiles();
		if (listaFile != null)
		for (int i = 0 ; i < listaFile.length;i++)
		{
			File ff =listaFile[i];
			
			
			listaUpload.put(ff.getName(), ff.listFiles());
		}
		req.setAttribute("DirList", listaUpload);

		gotoPage( "/jsp/guc/import.jsp" );
		
	}
	
	

}
