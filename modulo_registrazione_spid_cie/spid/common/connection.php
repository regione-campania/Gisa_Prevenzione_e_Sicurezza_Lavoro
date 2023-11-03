<?php

function getConnection($db){

    require("common/config.php");


    error_log($db);
    $strConnection = "host=" . $_CONFIG[$db]["host"] . " " .
        "port=" . $_CONFIG[$db]['port'] . " " .
        "dbname=" .  $_CONFIG[$db]['dbname'] . " ".
        "user=" . $_CONFIG[$db]['username']  . " ".
        "password=" . $_CONFIG[$db]['password'];

    $conn = pg_connect($strConnection) or die ("Errore critico di Connessione al Database $db $strConnection");
    return $conn;

}

function isAdministrator($usr, $psw){
    $conn = getConnection("guc");
    $res = pg_query($conn, "select * from is_administrator('$usr', '$psw')");
    while($row = pg_fetch_assoc($res)){
        $isAdministrator = $row['is_administrator'];
    }
    return $isAdministrator;
}
			  			   
?>