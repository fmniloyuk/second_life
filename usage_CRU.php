<?php

// Create Read Update file for register

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");
$table = "usage_cru";

$user_key = GetParam('user_key',"");
$location_key = GetParam('location_key',"");
$baton_type = GetParam('baton_type',"");
$start = GetParam('start',"");
$nb_times = GetParam('nb_times',"");
if ("Create" == $action)
{
  try{
    $sql = "SELECT * FROM usage_cru WHERE user_key='".$user_key."' and location_key='".$location_key."'";
    if ($result=mysqli_query($conn,$sql))
    {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      
      //counting existing records
      if($rowcount==0){
        $sql = "INSERT INTO ".$table." (user_key, location_key, baton_type, start, nb_times) VALUES 
        ('".$user_key."', '".$location_key."','".$baton_type."','".$start."','".$nb_times.""."')";
        
        if ($conn->query($sql) === TRUE) {
          echo "Baton is updated successfully...";
        } else {
          echo "Error: " . $sql . "<br>" . $conn->error;
        }   
      }
    }
  
}catch(Exception $e){
  echo 'Message: ' .$e->getMessage();
}
}

else if ("Read" == $action)
{
    $sql = "SELECT * FROM register WHERE avatar_key='".$avatar_key."'"; 
    if ($result=mysqli_query($conn,$sql))
    {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      
      //counting existing records
      if($rowcount==0){
        resp("NOT FOUND");
      }else{
        resp("FOUND");
        $row = $result->fetch_assoc();
        foreach ($row as $key => $value) resp($key.":".$value);
      }
      // Free result set
    mysqli_free_result($result);
    }else echo_error("During Read");  
    $stmt->close();
}

elseif("UpdateBatonTypeAndStartAndNbTimes" == $action){
  try{
    $sql = "SELECT * FROM usage_cru WHERE user_key='".$user_key."' and location_key='".$location_key."'";
    if ($result=mysqli_query($conn,$sql))
    {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      
      //counting existing records
      if($rowcount==0){
        //inserting if no records found
        $sql = "INSERT INTO ".$table." (user_key, location_key, baton_type, start, nb_times) VALUES 
        ('".$user_key."', '".$location_key."','".$baton_type."','".$start."','".$nb_times."')";
        
        if ($conn->query($sql) === TRUE) {
          echo "Baton usage is inserted";
        } else {
          echo "Error: " . $sql . "<br>" . $conn->error;
        }
      }else{
        //updating exsisting record
        $sql = "UPDATE usage_cru SET baton_type='".$baton_type."', start='".$start."' nb_times='".$nb_times."' where user_key='".$user_key."'";
        if ($conn->query($sql) === TRUE) {
          echo "Baton is updated successfully...";
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

else
{
    resp("NOT MANAGED");
}
