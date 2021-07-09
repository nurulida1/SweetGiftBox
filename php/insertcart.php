<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];

$sqlcheck = "SELECT * FROM tbl_package WHERE id = '$id'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $quantity = $row['quantity'];
        if($quantity == 0){
            echo "failed";
            return;
        }
        else{
            echo $sqlcheckcart = "SELECT * FROM tbl_cart WHERE id = '$id' AND email = '$email'";
            $resultcart = $conn->query($sqlcheckcart);
            if($resultcart->num_rows == 0){
                echo $sqladdtocart = "INSERT INTO tbl_cart (email,id,qty) VALUES ('$email','$id','1')";
                if($conn->query($sqladdtocart) === TRUE){
                    echo "success";
                }
                else{
                    echo "failed";
                }
            } else{
                    echo $sqlupdatecart = "UPDATE tbl_cart SET qty= qty+1 WHERE id = '$id' AND email = '$email'";
                    if ($conn->query($sqlupdatecart) === TRUE) {
                      echo "success";
        }
                      else{
                       echo "failed";
        }
                }
            }
        }
    }
    else{
        echo "failed";
    }
?>
