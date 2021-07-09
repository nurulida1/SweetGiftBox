<?php
include_once("dbconnect.php");
$id = $_POST['id'];
$packageSet = $_POST['packageSet'];
$description = $_POST['description'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$images = uniqid() . '.png';


    $sqlregister = "INSERT INTO tbl_package(id,packageSet,description,quantity,price,images) VALUES('$id','$packageSet','$description','$quantity','$price','$images')";
    if ($conn->query($sqlregister) === TRUE){
        $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/products/'. $images;
        $is_written = file_put_contents($path, $decoded_string);
        echo "success";
    }else{
        echo "failed";
    }


?>