
<style>
body {
background-color : #7f7f7f;
} 
div {
background-color : white;
width: 600px;
  padding-top: 50px;
  padding-right: 30px;
  padding-bottom: 50px;
  padding-left: 80px;
}

</style>



<script>
function randomCf(){

	var lettere = "QWERTYUIOPASDFGHJKLZXCVBNM";
	var numeri = "1234567890";
	
	var cf = lettere.charAt(Math. floor(Math. random() * lettere.length)) + lettere.charAt(Math. floor(Math. random() * lettere.length)) + lettere.charAt(Math. floor(Math. random() * lettere.length))+ lettere.charAt(Math. floor(Math. random() * lettere.length))+ lettere.charAt(Math. floor(Math. random() * lettere.length))+ lettere.charAt(Math. floor(Math. random() * lettere.length)) + 	numeri.charAt(Math. floor(Math. random() * numeri.length)) + numeri.charAt(Math. floor(Math. random() * numeri.length)) + 	lettere.charAt(Math. floor(Math. random() * lettere.length)) + 	numeri.charAt(Math. floor(Math. random() * numeri.length)) + numeri.charAt(Math. floor(Math. random() * numeri.length)) + 	lettere.charAt(Math. floor(Math. random() * lettere.length)) + 	numeri.charAt(Math. floor(Math. random() * numeri.length)) + numeri.charAt(Math. floor(Math. random() * numeri.length)) + numeri.charAt(Math. floor(Math. random() * numeri.length)) + 	lettere.charAt(Math. floor(Math. random() * lettere.length));
	document.getElementById("cf").value = cf;
}

function setForm(form, url){
	form.action=url;
}
</script>

<center>


<div>


<label style="font-size: 40px; width: 200px;">MODULO SPID TEST</label>
 
<br/><br/>

<br/><br/>

<form action ="http://172.16.0.41:8080/moduloSpid/index.php">

<input type="hidden" id="admin" name="admin" value="admin"/>
<input type="hidden" id="password" name="password" value="AzuleyaAlessia"/>
<input type="text" id="cf" name="cf" value="" maxlength="16" style="background:lightgray; color: black; font-size: 40px; width: 400px; text-align:center"/>

<br/><br/>

<select onChange="this.form.action=this.value" style="background:lightgray; color: black; font-size: 20px; width: 400px; text-align:center">
<option value="http://172.16.0.41:8080/moduloSpid/index.php">SVILUPPO</option>
<option value="http://wwwcol_new.gisacampania.it/moduloSpid/index.php">COLLAUDO</option>
</select>

<br/><br/>

<input type="submit" style="background:yellow; color: black; font-size: 50px; width: 100px;" value="VAI "/>

<br/><br/>

<input type="button" style="background:blue; color: white; font-size: 10px; width: 100px;" value="RICARICA" onClick="location.reload()"/>
 
</form>

</div>

</center>

<script>
randomCf();
</script>