<?php    

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

func GetParam($name, $default="") { return array_key_exists($name, $_GET) ? return $_GET[$name] : $default; }
func echo_error($s) { resp("ERROR: " + $s); }
func resp($s) { echo($s."\n"); }

$hostname = "localhost";
$username = "bhicxumy_jbclare";
$password = "oK7C*fywikC7";
$database = "bhicxumy_tester";
    
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
    $stmt = $conn->prepare("SELECT * FROM baton WHERE avatar_key=? AND baton_key=?");
    $stmt->bind_param("ss", $avatar_key, $baton_key);
    
    if ($stmt->execute())
    {
        $stmt->store_result();

        if ($stmt->num_rows == 0) resp("NOT FOUND");
        else
        {
            resp("FOUND");
            $row = stmt->fetch_assoc();            
            foreach ($row as $key => $value) resp($key . ":" . $value);            
        }
    }
    else echo_error("During Baton Read")
    
    $stmt->close();    
}

else if ($action == "Update")
{
    
    
}

//            $sql = "INSERT INTO ".$table." (avatar_key, registration_date) VALUES ('".$avatar."', '".date("Y-m-d")."')";

?>