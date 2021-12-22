<?php

// Create Read Update file for register

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");
$table = "usage";

$user_key = GetParam('user_key',"");
$location_key = GetParam('location_key',"");
$baton_type = GetParam('baton_type',"");
$start = GetParam('start',"");
$nb_times = GetParam('nb_times',"");
if ("Create" == $action)
{
  try{
    
  $sql = "INSERT INTO ".$table." (user_key, location_key, baton_type, stastartrt, nb_times) VALUES 
  ('".$user_key."', '".$location_key."','".$baton_type."','".$start."','".$nb_times.""."')";
  
  if ($conn->query($sql) === TRUE) {
    echo "Music stand is updated successfully...";
  } else {
    echo "Error: " . $sql . "<br>" . $conn->error;
  }
}catch(Exception $e){
  echo 'Message: ' .$e->getMessage();
}
}

else if ("Read" == $action)
{
    $stmt = $conn->prepare("SELECT * FROM register avatar_key=?"); 
    $stmt->bind_param("s", $avatar_key);
    if ($stmt->execute())
    {
        $stmt->store_result();
        if ($stmt->num_rows == 0) resp("NOT FOUND");
        else
        {
            resp("FOUND");
            $row = $stmt->fetch_assoc();
            foreach ($row as $key => $value) resp($key.":".$value);
        }
    }
    else echo_error("During Read");
    $stmt->close();
}

else if ("Update" == $action)
{
  // $sql = "UPDATE stand SET clicks = clicks + 1 WHERE owner_key='".$owner_key."' and stand_key='".$stand_key."'";
  // if ($conn->query($sql) === TRUE) {
  //   echo "Music stand is updated successfully...";
  // } else {
  //   echo "Error: " . $sql . "<br>" . $conn->error;
  // }
}
// else if ('UpdateMoneyAndSurl' == $action)
// {
//   $sql = "UPDATE stand SET money='".$money."', surl='".$surl."' where owner_key='".$owner_key."' and stand_key='".$stand_key."'";
//   if ($conn->query($sql) === TRUE) {
//     echo "Music stand is updated successfully...";
//   } else {
//     echo "Error: " . $sql . "<br>" . $conn->error;
//   }

// }

else
{
    resp("NOT MANAGED");
}
