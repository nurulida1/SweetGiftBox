<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];


if (isset($_POST['id'])){
    $sqldelete = "DELETE FROM tbl_cart WHERE email = '$email' AND id ='$id'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
}else{
    echo "failed";
}
?>