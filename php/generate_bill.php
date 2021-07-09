<?php
error_reporting(0);

$email = $_GET['email']; 
$mobile = $_GET['mobile']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$orderid = $_GET['orderid'];

$api_key = '2fcb9c81-6128-4ee9-9723-42c18645b1c3';
$collection_id = 'us0h8f6j';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $mobile,
          'name' => $name,
          'amount' => $amount * 100,
		  'description' => 'Payment for order id '.$orderid,
          'callback_url' => "http://nurulida1.com/272932/sweetgiftbox/php/return_url",
          'redirect_url' => "http://nurulida1.com/272932/sweetgiftbox/php/payment_update.php?userid=$email&mobile=$mobile&amount=$amount&orderid=$orderid"  
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

header("Location: {$bill['url']}");
?>