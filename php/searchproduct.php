<?php
include_once("dbconnect.php");
$packageSet = $_POST['packageSet'];

    $sqlsearchproducts= "SELECT * FROM tbl_package WHERE packageSet LIKE '%$packageSet%'";
    $result = $conn->query($sqlsearchproducts);

if ($result->num_rows > 0){
    $response["package"] = array();
    while ($row = $result -> fetch_assoc()){
        $_searchList = array();
        $_searchList[id] = $row['id'];
        $_searchList[packageSet] = $row['packageSet'];
        $_searchList[description] = $row['description'];
        $_searchList[quantity] = $row['quantity'];
        $_searchList[price] = $row['price'];
        $_searchList[date_reg] = $row['date_reg'];
        $_searchList['images'] = 'https://nurulida1.com/272932/sweetgiftbox/images/products/' . $row['images'];
        array_push($response["package"],$_searchList);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>