<?php
require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$filter = $_GET['filter'];
$year = $_GET['year'];
$month = $_GET['month'];
$sql = 'sql';
if ($filter == 'all'){
    $sql = "SELECT leaderboard.avatar_key, profile.avatar_name, profile.avatar_picture, SUM(leaderboard.reward) as reward,SUM(leaderboard.exp) as exp FROM `leaderboard` LEFT JOIN profile ON profile.avatar_key=leaderboard.avatar_key WHERE created_at LIKE '%$year-$month%' GROUP BY avatar_key ORDER BY exp DESC";
}
if ($filter == 'top'){
    $sql = "SELECT leaderboard.avatar_key, profile.avatar_name, profile.avatar_picture, SUM(leaderboard.reward) as reward,SUM(leaderboard.exp) as exp FROM `leaderboard` LEFT JOIN profile ON profile.avatar_key=leaderboard.avatar_key GROUP BY avatar_key ORDER BY exp DESC LIMIT 3";
}

$result = $conn->query($sql);
//var_dump($result);
$rows = array();
while($r = mysqli_fetch_assoc($result)) {
    $rows[] = $r;
}
echo json_encode($rows);
//SELECT avatar_key, avatar_name, avatar_picture, SUM(reward) as reward,SUM(exp) as exp FROM `leaderboard` WHERE created_at LIKE '%2022-03%' GROUP BY avatar_key
?>