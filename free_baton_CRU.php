<?php    

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function GetParam($name, $default = "") { return array_key_exists($name, $_GET) ? $_GET[$name]: $default;}
function echo_error($s) {resp("ERROR: " + $s);}
function resp($s) {echo($s. "\n");}

//DATABASE CONNECTION:
require_once("config.php");
    
$conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

$action = GetParam("action");

$baton_key  = GetParam("baton_key");

if ($action == "Read")
{
    $sql = "SELECT * FROM free_baton WHERE baton_key='".$baton_key."'";
    
    if ($result=mysqli_query($conn,$sql))
    {
    // Return the number of rows in result set
    $rowcount=mysqli_num_rows($result);
    
    //counting existing records
    if($rowcount==0){
        // insert return 50
        $sql = "INSERT INTO free_baton (baton_id) VALUES ('".$baton_key."')";
        if ($conn->query($sql) === TRUE) {
            echo "Baton has been updated";
          } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
          }
    }else{
                    // update ebc = ebc - 1
    }
    // Free result set
    mysqli_free_result($result);
    }else echo_error("During Baton Read");
    
    $stmt->close();
    
}

?>