<?php
include_once("dbconnect.php");
$id_feed = $_POST['id_feed'];

    $sqlloadfeed= "SELECT * FROM tbl_feed ORDER BY date_created DESC";
    $result = $conn->query($sqlloadfeed);

if ($result->num_rows > 0){
    $response["feed"] = array();
    while ($row = $result -> fetch_assoc()){
        $_feedList = array();
        $_feedList[id_feed] = $row['id_feed'];
        $_feedList[feed_descript] = $row['feed_descript'];
        $_feedList[date_created] = $row['date_created'];
        $_feedList['feed_image'] = 'https://nurulida1.com/272932/sweetgiftbox/images/products/' . $row['feed_image'];
        array_push($response["feed"],$_feedList);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>