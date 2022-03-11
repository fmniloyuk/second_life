<?php
require_once("config.php");
    
$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$sql = "SELECT * FROM leaderboard";
$result = $conn->query($sql);
echo json_encode($result);