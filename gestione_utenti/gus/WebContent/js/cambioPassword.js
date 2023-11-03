var PWD_MIN = 10;
var PWD_MAX = 15;

  function checkFormPassword(form)
  {
	  var pwd1 = null;
	  var pwd2 = null;
	  
	  if (document.getElementById("password1")!=null)
		  pwd1 = document.getElementById("password1");
	  else
		  pwd1 = document.getElementById("password");
	  
	  pwd2 = document.getElementById("password2");
	  
    re = /^\w+$/;
    if(!re.test(pwd1.value)) {
      alert("Errore: Password contenente caratteri non supportati.");
      pwd1.focus();
      return false;
    }
    
      if(pwd1.value.length < PWD_MIN) {
        alert("Errore: la password deve essere almeno di " + PWD_MIN + " caratteri");
        pwd1.focus();
        return false;
      }
      
        if(pwd1.value.length > PWD_MAX) {
            alert("Errore: la password deve essere al massimo di " + PWD_MAX + " caratteri");
            pwd1.focus();
            return false;
          }
          
    
      re = /[0-9]/;
      if(!re.test(pwd1.value)) {
        alert("Errore: La password deve contenere almeno un numero (0-9)!");
        pwd1.focus();
        return false;
      }
      re = /[a-z]/;
      if(!re.test(pwd1.value)) {
        alert("Errore: La password deve contenere almeno una lettera minuscola (a-z)!");
        pwd1.focus();
        return false;
      }
      re = /[A-Z]/;
      if(!re.test(pwd1.value)) {
        alert("Errore: La password deve contenere almeno una lettera maiuscola (A-Z)!");
        pwd1.focus();
        return false;
    } 
  	if(pwd1.value != pwd2.value ) {
      alert("Errore: La password di conferma non corrisponde alla nuova password.");
      pwd1.focus();
      return false;
    }
 
    
  	return true;
  	
  }

   

  
  function showPolicy(){
	  alert('Policy per nuove password: \nLunghezza: 10-15 caratteri\nContenente solo lettere, numeri e underscore (_).\nContenente almeno 1 lettera minuscola (a-z)\nContenente almeno 1 lettera maiuscola (A-Z)\nContenente almeno 1 numero (0-9)');
  }
  
  function reloadOpener(){
	    window.opener.location.reload();
	    window.close();
  }
  
  function mostraNascondi(radio){
	
	  var pwd1 = null;
	  var pwd2 = null;
	  
	  if (document.getElementById("password1")!=null)
		  pwd1 = document.getElementById("password1");
	  else
		  pwd1 = document.getElementById("password");
	  
	  pwd2 = document.getElementById("password2");
	
	if (radio.id == 'female'){
		pwd1.type='text';
		pwd2.type='text';
	}
	else {
		pwd1.type='password';
		pwd2.type='password';
	}
  }
  
  

  
  function show(){
		document.getElementById("policyForm").style.display="block";
	}
	function hide(){
		document.getElementById("policyForm").style.display="none";
	}