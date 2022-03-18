<?php    

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

//DATABASE CONNECTION:
require_once("config.php");
    
$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");
$type = GetParam("type");
$baton_key  = GetParam("baton_key");

if ($action == "Read")
{
    try{


    $sql = "SELECT * FROM free_baton WHERE baton_key='".$baton_key."'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        // output data of each row
        $row = $result->fetch_assoc();
        $ebc = $row['ebc'];
        if ($type == 'update'){
            $ebc = $row['ebc'] - 1;
        }
        if ($ebc<0)
            $ebc = 0;
        echo $ebc;
        $sql = "UPDATE free_baton SET ebc=".$ebc." WHERE baton_key='".$baton_key."'";
        $conn->query($sql);
    } else {
        $sql = "INSERT INTO free_baton (baton_key) VALUES ('".$baton_key."')";
        if ($conn->query($sql) === TRUE) {
            echo 50;
        }
    }
}catch(Exception $e){
    echo $e->getMessage();
}
    mysqli_free_result($result);    
    $stmt->close();
    
}

?>