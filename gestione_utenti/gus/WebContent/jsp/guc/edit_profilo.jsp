<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@page import="it.us.web.util.json.JSONObject"%>

<%@page import="it.us.web.bean.guc.*"%>
<%@page import="java.util.*"%>
<%@page import="it.us.web.util.guc.GUCEndpoint"%>


<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script   src="js/jquery-ui.js"></script>




<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.9.2.custom.css" />


<jsp:useBean id="UserRecord" class="it.us.web.bean.guc.Utente" scope="request"/>
<style>
input,label,a,.details,.pagedlist{text-transform:uppercase !important;}
.menutabs-td,.menutabs-th,.trails,.submenuItemUnselected,.sidetab-right,.sidetab-right-sel,.dettaglioTabella,
.odd,.even,.cg-DivItem,.submenuItemSelected{text-transform:uppercase !important;}

</style>
<script type="text/javascript">

  function trim(str){
	    return str.replace(/^\s+|\s+$/g,"");
  } 
    
  function abilitaCampiBDU(form,endpoint) 
  {
	  if(endpoint=='bdu')
	  {
	  		if (form.roleIdbdu.value == '24' || form.roleIdbdu.value == '37')
	  		{
		  		if ( form.id_provincia_iscrizione_albo_vet_privato!=null)
			  	{
		  			form.id_provincia_iscrizione_albo_vet_privato.disabled = "";
			  	}
		  		if(form.nr_iscrione_albo_vet_privato!=null)
			  	{
			  		form.nr_iscrione_albo_vet_privato.disabled = "";
			  	}
		   		if(form.id_provincia_iscrizione_albo_vet_privato!=null)
			   	{
		 	 		form.id_provincia_iscrizione_albo_vet_privato.value = "-1";
			   	}
		  		if(form.nr_iscrione_albo_vet_privato!=null)
			  	{
		  			form.nr_iscrione_albo_vet_privato.value = ""; 
			  	}
	  		} 
	  		else 
	  		{
		  		form.id_provincia_iscrizione_albo_vet_privato.value = "-1";
		  		form.nr_iscrione_albo_vet_privato.value = "";
		  		form.id_provincia_iscrizione_albo_vet_privato.disabled = "disabled";
		  		form.nr_iscrione_albo_vet_privato.disabled = "disabled";
	  		}  
	  		if (form.roleIdbdu.value == '24')
	  		{
		  		form.numAutorizzazione.disabled="";
		  		form.numAutorizzazione.value="";
	  		} 
	  		else 
	  		{
		  		form.numAutorizzazione.value="";
		  		form.numAutorizzazione.disabled="disabled";
	  		} 
		}
  }
  
  
  function abilitaCampiVAM(form,endpoint) 
  {
	  if(endpoint=='Vam')
	  {
	  		if (form.roleIdVam.value == '18' )
	  		{
		  		if ( form.id_provincia_iscrizione_albo_vet_privato_vam!=null)
			  	{
		  			form.id_provincia_iscrizione_albo_vet_privato_vam.disabled = "";
			  	}
		  		if(form.nr_iscrione_albo_vet_privato_vam!=null)
			  	{
			  		form.nr_iscrione_albo_vet_privato_vam.disabled = "";
			  	}
		   		if(form.id_provincia_iscrizione_albo_vet_privato_vam!=null)
			   	{
		 	 		form.id_provincia_iscrizione_albo_vet_privato_vam.value = "-1";
			   	}
		  		if(form.nr_iscrione_albo_vet_privato_vam!=null)
			  	{
		  			form.nr_iscrione_albo_vet_privato.value_vam = ""; 
			  	}
	  		} 
	  		else 
	  		{
		  		form.id_provincia_iscrizione_albo_vet_privato_vam.value = "-1";
		  		form.nr_iscrione_albo_vet_privato_vam.value = "";
		  		form.id_provincia_iscrizione_albo_vet_privato_vam.disabled = "disabled";
		  		form.nr_iscrione_albo_vet_privato_vam.disabled = "disabled";
	  		}  
	  }
  }
  
  
  
  function abilitaCampoAccess(form,endpoint) 
  {
	  if(endpoint=='Gisa_ext')
	  {
	  		if (form.roleIdGisa_ext.value == '10000008' )
	  		{
	  			if ( form.Gisa_ext_access!=null)
	  			{
		  			form.Gisa_ext_access.disabled = "true";
	  			}
	  			if ( form.hidden_Gisa_ext_access!=null)
  				{
		  			form.hidden_Gisa_ext_access.value = "false";
  				}
	  		} 
	  		else 
	  		{
	  			if ( form.Gisa_ext_access!=null)
  				{
	  				form.Gisa_ext_access.disabled = false;
  				}
	  		}
      }
  }

  function getDataOdierna(){
	  var today = new Date();
	  var dd = today.getDate();
	  var mm = today.getMonth()+1; //January is 0!
	  var yyyy = today.getFullYear();
	  if(dd<10){
	      dd='0'+dd
	  } 
	  if(mm<10){
	      mm='0'+mm
	  } 
	  var dataOdierna = dd+'/'+mm+'/'+yyyy;
	  return dataOdierna;
	  }
  
  function giorni_differenza(data1,data2){
		
		anno1 = parseInt(data1.substr(6),10);
		mese1 = parseInt(data1.substr(3, 2),10);
		giorno1 = parseInt(data1.substr(0, 2),10);
		anno2 = parseInt(data2.substr(6),10);
		mese2 = parseInt(data2.substr(3, 2),10);
		giorno2 = parseInt(data2.substr(0, 2),10);

		var dataok1=new Date(anno1, mese1-1, giorno1);
		var dataok2=new Date(anno2, mese2-1, giorno2);

		differenza = dataok2-dataok1;    
		giorni_diff = new String(Math.ceil(differenza/86400000));
		//alert('diff');
		//alert(giorni_diff);
		return giorni_diff;
	}
  
  function checkForm(form) {
	  	var ids=[]; var j=0;
	    var f = document.getElementsByTagName('input');
	  
	  
	    formTest = true;
	    message = "";
	    
	    
	    var element =  document.getElementById('dataScadenza');
	    if (typeof(element) != 'undefined' && element != null)
	    {
	    	var dataOdierna = getDataOdierna();
	    	if (element.value == '' || element.value == null){
	    	  message += "- Data inizio validità obbligatoria per variazione profilo.\r\n";
		      formTest = false;
	      }
	     else if ((giorni_differenza(dataOdierna, element.value)<=0)){
	   	  message += "- La Data inizio validità deve essere successiva alla data odierna.\r\n";
		      formTest = false;
	     }
	    }
	    /*
	    if (form.roleIdGisa_ext.value == '10000006')
	    {
			if (form.gestore.value=='-1' || form.comuneGestore.value=='-1')
			{
			 	message += "- Campo 'Gestore Acque' e 'Comune Gestore Acque' obbligatorio.\r\n";
		        formTest = false;
			}
	    }
	    

	    if (form.roleIdGisa_ext.value == '10000001' || (form.roleIdGisa_ext.value == '10000002' && form.tipoAttivitaApicoltore.value=="C"))
	    {
	    	if (form.piva.value=='' ){
			 	message += "- Campo 'Partita iva associazione/attivita apicoltura' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    }
	    
	    if (form.roleIdGisa_ext.value == '10000002')
	    {
	    	if (form.tipoAttivitaApicoltore.value=='' ){
			 	message += "- Campo 'Tipo attivita apicoltore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    	if (form.comuneApicoltore.value=='-1' ){
			 	message += "- Campo 'Comune apicoltore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    	if (form.indirizzoApicoltore.value=='' ){
			 	message += "- Campo 'Indirizzo apicoltore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    	if (form.capIndirizzoApicoltore.value=='' ){
			 	message += "- Campo 'CAP Indirizzo apicoltore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    }
	    
	    if (form.roleIdGisa_ext.value == '10000004')
	    {
	    	if (form.comuneTrasportatore.value=='-1' ){
			 	message += "- Campo 'Comune trasportatore/distributore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    	if (form.indirizzoTrasportatore.value=='' ){
			 	message += "- Campo 'Indirizzo trasportatore/distributore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    	if (form.capIndirizzoTrasportatore.value=='' ){
			 	message += "- Campo 'CAP Indirizzo trasportatore/distributore' obbligatorio per il ruolo specificato.\r\n";
		        formTest = false;
			}	
	    }
			
	    if (form.roleIdbdu.value == '24'){
		 	if (form.numAutorizzazione.value==''){
			  message += "- Campo nr. autorizzazione obbligatorio per LP.\r\n";
		      formTest = false;
			} 
			if (form.luogo.value=='-1'){
			 	message += "- Campo luogo obbligatorio per LP.\r\n";
		        formTest = false;
			}
			
			if (form.id_provincia_iscrizione_albo_vet_privato!= null && form.id_provincia_iscrizione_albo_vet_privato.value=='-1'){
				message += "- Campo provincia iscrizione albo obbligatorio per LP.\r\n";
			     formTest = false;
			}
			
			if (form.nr_iscrione_albo_vet_privato!= null &&  form.nr_iscrione_albo_vet_privato.value==''){
				message += "- Campo nr. iscrizione albo veterinari obbligatorio per LP.\r\n";
			     formTest = false;
			}
		}
	    
	    if (form.roleIdbdu.value == '37'){
	    	if (form.id_provincia_iscrizione_albo_vet_privato.value=='-1'){
				message += "- Campo provincia iscrizione albo obbligatorio per Utente Unina.\r\n";
			     formTest = false;
			}
			
			if (form.nr_iscrione_albo_vet_privato != null &&  form.nr_iscrione_albo_vet_privato.value==''){
				message += "- Campo nr. iscrizione albo veterinari obbligatorio per Utente Unina.\r\n";
			     formTest = false;
			}
	    }
	    
	    
	    if (form.roleIdVam!=null && form.roleIdVam.value!='-1' && 1==2){
	    	valido=true;
	    	var cont=0;
	    	var lista_cliniche = document.getElementById('clinicaId');
	    	for (var c=0;c<lista_cliniche.length;c++){
	    		var el = lista_cliniche[c];
	    		if (el.selected){
	    			if (el.value=='-1')
	    				valido=false;
	    			cont=cont+1;
	    		}
	    	}    	
	    	if (valido==false){
	    		if (cont==1){
	    			message += "- Selezionare almeno una clinica.\r\n"; 
	    		} else {
	    			message += "- Controllare le cliniche selezionate.\r\n"; 
	    		}
		    	formTest = false;
	    	}	
	    	else if (cont==0)
	    	{
	    		message += "- Selezionare almeno una clinica.\r\n"; 
	    		formTest = false;
	    	}
	    }     
	    
	    
	    if (document.getElementById("numRegStab")!=null && document.getElementById("gestoreDispId").style.display=="" && document.getElementById("numRegStab").value=="" )
	    	{
	    	message += "- Campo Numero Registrazione Stabilimento obbligatorio.\r\n";
	        formTest = false;
	    	}
	    
	    
	   
	    if (form.idAsl.value == "0") {
	        message += "- Campo asl obbligatorio.\r\n";
	        formTest = false;
	    }
	    if (form.roleIdImportatori!= null && form.roleIdImportatori.value=='3'){
		    if (form.id_importatore!= null && form.id_importatore.value=='-1'){
		    	 message += "- Campo Importatore Obbligatorio.\r\n";
		         formTest = false;
		    }
	    }    
	    if (form.roleIdbdu!= null && form.roleIdbdu.value=='31'){
		    if (form.canilebduId!= null && form.canilebduId.value=='-1'){
		    	 message += "- Campo Canile Obbligatorio.\r\n";
		         formTest = false;
		    }
	    }
	    */
	    if (formTest == false) {
	      alert("La form non può essere salvata, si prega di verificare quanto segue:\r\n\r\n" + message);
	      for (var k=0;k<ids.length;k++){
	    	  document.getElementById(ids[k]).disabled='disabled';
	      }
	      return false;
	    }
	    else {    	
	    	
	    	if(confirm(/*'Impostati i seguenti valori dei ruoli : \r\n\r\n'+messRuoli+' '+messExtOpt+*/'\r\n\r\nSicuro di voler procedere alle modifiche?')){
	      		return form.submit();
	    	}
	    	else {
	    		for (var k=0;k<ids.length;k++){
	  	    	  document.getElementById(ids[k]).disabled='disabled';
	  	      	}
	    		return false;
	    	}
	    }
  }
 
</script>

<body>



<%=(UserRecord.getError()!=null && !"".equals(UserRecord.getError())) ? "<font color='red'>"+UserRecord.getError()+"</font>" :"" %>
<div id="content" align="center">

	<div align="center">
		<a href="Home.us" style="margin: 0px 0px 0px 50px"><img src="images/lista.png" height="18px" width="18px" />Lista Utenti</a>
		<a href="guc.Detail.us?id=${UserRecord.id}" style="margin: 0px 0px 0px 50px"><img src="images/detail.gif" height="18px" width="18px" />Dettaglio Utente</a>
		<a href="guc.ToAdd.us" style="margin: 0px 0px 0px 50px; display: none"><img src="images/add.png" height="18px" width="18px" />Aggiungi Utente</a>
	</div>
	
	<h4 class="titolopagina">ANAGRAFICA Utente</h4>
	
	<form name="editUser" action="guc.EditProfilo.us" onSubmit="return checkForm(this);" method="post">
	<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
	<tr>
		<th colspan="2"><strong>Contatto</strong></th>
	</tr>
	<tr>
		<td class="formLabel">Nome</td>
	  	<td>${UserRecord.nome}</td>
	</tr>
	<tr>
    	<td class="formLabel">Cognome</td>
  		<td>${UserRecord.cognome}</td>
	</tr>
	<tr>
  		<td class="formLabel">Codice fiscale</td>
  		<td>${UserRecord.codiceFiscale}</td>
	</tr>
		
	<tr>
	  <td class="formLabel">E-mail</td>
	  <td>${UserRecord.email}</td>
	</tr>
	
	<tr>
	  <td class="formLabel">Telefono</td>
	  <td>${UserRecord.telefono}</td>
	</tr>
	
	<tr>
  		<td class="formLabel">Note</td>
  	<td>	${UserRecord.note}</td>
	</tr>
	<tr>
  		<th colspan="2"><strong>Credenziali</strong></th>
	</tr>
	<tr>
  		<td class="formLabel">Username</td>
  		<td>
    	${UserRecord.username}
    	<input type="hidden" name="id" value="${UserRecord.id}" ></input>
    	<input type="hidden" name="oldUsername" value="${UserRecord.username}" ></input>
  		</td>
	</tr>
	
	</table>
	
	

<jsp:include page="./edit_profilo_include.jsp"/>


<input type="button" value="Aggiorna" onclick="javascript: checkForm(this.form);"/>



</form>
</div>
</body>
 	
