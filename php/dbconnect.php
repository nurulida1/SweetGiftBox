<?php
$servername = "localhost";
$username   = "nurulid1_sweetgiftboxadmin";
$password   = "9icK}Lu#(?3a";
$dbname     = "nurulid1_sweetgiftboxdb_272932";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
    echo 'failed';
}
else{
    //echo 'success';
}
?>