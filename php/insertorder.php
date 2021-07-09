<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$mobile = $POST['mobile'];
$address = $_POST['address'];
$notes = $_POST['notes'];

echo $sqladdtoorder = "INSERT INTO tbl_order (email,name,mobile,address,notes) VALUES ('$email','$name','$mobile','$address','$notes')";
    if($conn->query($sqladdtoorder) === TRUE){
      echo "success";
    }
    else{
       echo "failed";
}
?>