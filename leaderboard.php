<?php
require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$sql = "SELECT * FROM leaderboard";
$result = $conn->query($sql);
//var_dump($result);
$rows = array();
while($r = mysqli_fetch_assoc($result)) {
    $rows[] = $r;
}
echo json_encode($rows);
//
?>