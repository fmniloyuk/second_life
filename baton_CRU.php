<?php    

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

//DATABASE CONNECTION:
require_once("config.php");
    
$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");

$avatar_key = GetParam("avatar_key");
$baton_key  = GetParam("baton_key");
$properties = GetParams("properties");

if ($action == "Create")
{
    
}

else if ($action == "Read")
{
    $sql = "SELECT * FROM baton WHERE avatar_key='".$avatar_key."'"." AND baton_key='".$baton_key."'";
    
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
            foreach ($row as $key => $value) resp($key . ":" . $value);            
        }
    // Free result set
    mysqli_free_result($result);
    }else echo_error("During Baton Read");
    
    $stmt->close();
    
}

else if ($action == "UpdateProperties")
{
    
    
}

?>