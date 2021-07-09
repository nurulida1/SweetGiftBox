<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$id = $_POST['id'];
$qty = $_POST['qty'];

$sqlupdate = "UPDATE tbl_cart SET qty = '$qty' WHERE email = '$email' AND id = '$id'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
?>