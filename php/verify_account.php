<?php
    error_reporting(0);
    include_once("dbconnect.php");
    $email = $_GET['email'];
    $otp = $_GET['key'];
    
    $sql = "SELECT * FROM tbl_user WHERE email = '$email' AND otp='$otp'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET otp = '0' WHERE email = '$email' AND otp = '$otp'";
        if ($conn->query($sqlupdate) === TRUE){
            echo 'Your account has successfully verified';
        }else{
            echo 'Your account unsuccessful verified';
        }   
    }
    else{
        echo 'failed';
    }
    ?>
    
    