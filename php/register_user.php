<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/Exception.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/PHPMailer.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/SMTP.php';

include_once ("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$status = "active";

$sqlregister = "INSERT INTO tbl_user(name,email,password,otp,status) VALUES ('$name','$email','$passha1','$otp','$status')";

if ($conn->query($sqlregister) === true){
    sendEmail($otp,$email);
    echo "success";
}
else{
    echo "failed";
}

function sendEmail($otp,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.nurulida1.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'sweetgiftbox@nurulida1.com';                  //SMTP username
    $mail->Password   = '(kD1]unRslGR';   //SMTP password
    
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "sweetgiftbox@nurulida1.com";
    $to = $email;
    $subject = "Verify your contact information for Sweet GiftBox Account";
    $message = "<p>Dear ".$email.",<br><br>Please click on the following link to verify your email address.<br><br><a href='https://nurulida1.com/272932/sweetgiftbox/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here</a>";
    
    $mail->setFrom($from,"Sweet GiftBox");
    $mail->addAddress($to, "Ida");                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

?>