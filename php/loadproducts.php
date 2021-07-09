<?php
include_once("dbconnect.php");
$packageSet = $_POST['packageSet'];

    $sqlloadproducts= "SELECT * FROM tbl_package ORDER BY date_reg DESC";
    $result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0){
    $response["package"] = array();
    while ($row = $result -> fetch_assoc()){
        $_packageList = array();
        $_packageList[id] = $row['id'];
        $_packageList[packageSet] = $row['packageSet'];
        $_packageList[description] = $row['description'];
        $_packageList[quantity] = $row['quantity'];
        $_packageList[price] = $row['price'];
        $_packageList[date_reg] = $row['date_reg'];
        $_packageList['images'] = 'https://nurulida1.com/272932/sweetgiftbox/images/products/' . $row['images'];
        array_push($response["package"],$_packageList);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>