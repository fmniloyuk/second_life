<?php

// Create Read Update file for register

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

require_once("config.php");

$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");
$avatar_key = GetParam("avatar_key");
if ("Create" == $action)
{
$sql = "INSERT INTO register (avatar_key, registration_date, amount, experience) VALUES ('".$avatar_key."', '".date("Y-m-d")."',0,0)";
if ($conn->query($sql) === TRUE) {
  echo "You have been added to the database!";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
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
    // if ($stmt->execute())
    // {
    //     $stmt->store_result();
    //     if ($stmt->num_rows == 0) resp("NOT FOUND");
    //     else
    //     {
    //         resp("FOUND");
    //         $row = $stmt->fetch_assoc();
    //         foreach ($row as $key => $value) resp($key.":".$value);
    //     }
    // }
    
    $stmt->close();
}

else if ("Update" == $action)
{
}

else
{
    resp("NOT MANAGED");
}
