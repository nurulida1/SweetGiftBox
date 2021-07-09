<?php
include_once("dbconnect.php");
$id_feed = $_POST['id_feed'];
$feed_descript = $_POST['feed_descript'];
$date_created = $_POST['date_created'];
$encoded_string = $_POST["encoded_string"];
$feed_image = uniqid() . '.png';


    $sqladd = "INSERT INTO tbl_feed(id_feed,feed_image,feed_descript,date_created) VALUES('$id_feed','$feed_image','$feed_descript','$date_created')";
    if ($conn->query($sqladd) === TRUE){
        $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/products/'. $images;
        $is_written = file_put_contents($path, $decoded_string);
        echo "success";
    }else{
        echo "failed";
    }


?>