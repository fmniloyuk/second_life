<?php

// Create Read Update file for register

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "")
{
  // array_key_exists(string|int $key, array $array): bool
  // array_key_exists() returns true if the given key is set in the array. key can be any value possible for an array index.
  return array_key_exists($name, $_GET) ? $_GET[$name] : $default;
}

function echo_error($s)
{
  resp("ERROR: " + $s);
}

function resp($s)
{
  echo ($s . "\n");
}

require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");
$table = "stand";

$owner_key = GetParam('owner_key',"");
$stand_key = GetParam('stand_key',"");
$owner_name = GetParam('owner_name',"");
$money = GetParam('money',"");
$surl = GetParam('surl',"");
$nb_votes = GetParam('nb_votes',"");
if ("Create" == $action)
{
  try{
  $sql = "SELECT * FROM stand WHERE owner_key='".$owner_key."' and stand_key='".$stand_key."'"  ;
  if ($result=mysqli_query($conn,$sql))
  {
    // Return the number of rows in result set
    $rowcount=mysqli_num_rows($result);
    
    //counting existing records
    if($rowcount==0){
      //inserting if no records found
      $sql = "INSERT INTO ".$table." (owner_key, stand_key, owner_name, money, surl, nb_votes) VALUES 
      ('".$owner_key."', '".$stand_key."','".$owner_name."','".$money."','".$surl."','".$nb_votes."')";
      
      if ($conn->query($sql) === TRUE) {
        echo "Music stand has registered successfully...";
      } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
      }
    }else{
      //updating exsisting record
      $sql = "UPDATE stand SET money='".$money."', surl='".$surl."' where owner_key='".$owner_key."' and stand_key='".$stand_key."'";
      if ($conn->query($sql) === TRUE) {
        echo "Music stand has updated successfully...";
      } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
      }
    }
    // Free result set
    mysqli_free_result($result);
  }
  
}catch(Exception $e){
  echo 'Message: ' .$e->getMessage();
}
}


else if ("Update" == $action)
{
  $maxClick = 10;
  $sql = "SELECT * FROM stand WHERE owner_key='".$owner_key."' and stand_key='".$stand_key."'";
  $result = $conn->query($sql);
  // $row = $result->fetch_assoc();
  //   if($row['clicks']>=$maxClick){
  //   echo "maximum number of clicks reached";
  //   return;
  // }

  $sql = "UPDATE stand SET clicks = clicks + 1 WHERE owner_key='".$owner_key."' and stand_key='".$stand_key."'";

  if ($conn->query($sql) === TRUE) {
    echo "A click on music stand has recorded successfully...";
  } else {
    echo "Error: " . $sql . "<br>" . $conn->error;
  }
} else if ('UpdateMoneyAndSurl' == $action) {
  $sql = "UPDATE stand SET money='" . $money . "', surl='" . $surl . "' where owner_key='" . $owner_key . "' and stand_key='" . $stand_key . "'";
  if ($conn->query($sql) === TRUE) {
    echo "Music stand has updated successfully...";
  } else {
    echo "Error: " . $sql . "<br>" . $conn->error;
  }
} else {
  resp("NOT MANAGED");
}

