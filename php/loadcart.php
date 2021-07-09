<?php
include_once("dbconnect.php");
$email = $_POST['email'];

    $sqlloadcart= "SELECT * FROM tbl_cart INNER JOIN tbl_package ON tbl_cart.id = tbl_package.id WHERE tbl_cart.email = '$email'";
    $result = $conn->query($sqlloadcart);

if ($result->num_rows > 0){
    $response["cart"] = array();
    while ($row = $result -> fetch_assoc()){
        $_packageList = array();
        $_packageList[id] = $row['id'];
        $_packageList[packageSet] = $row['packageSet'];
        $_packageList[description] = $row['description'];
        $_packageList[quantity] = $row['quantity'];
        $_packageList[qty] = $row['qty'];
        $_packageList[price] = $row['price'];
        $_packageList[date_reg] = $row['date_reg'];
        $_packageList['images'] = 'https://nurulida1.com/272932/sweetgiftbox/images/products/' . $row['images'];
        array_push($response["cart"],$_packageList);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>