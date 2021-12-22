<?php    

//DATABASE CONNECTION:
    require_once("config.php");
    $table    = "stand";
    
    //Connect to the database.
    $conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");
   
    if(array_key_exists("givemoney", $_GET)) {
        
        $money = $_GET['givemoney'];
        $avatarkey = $_GET['memberkey'];
        $avatarname = $_GET['membername'];
        $region = $_GET['region'];
        $experience = $_GET['experience'];
        
        $present = $_GET['present'];
        $previous = $_GET['previous'];
        $sql = "SELECT * FROM register WHERE avatar_key = '".$avatarkey."'";
        $result = mysqli_query($conn, $sql);
        $data = mysqli_fetch_assoc($result);
        $totalamount =  $data['amount'] + $money;
        $totalexperience = $data['experience'] + $experience;
        //echo $money;
        if(mysqli_num_rows($result) > 0) {
            $sql1 = "update register set amount  = '".$totalamount."', experience  = '".$totalexperience."' WHERE avatar_key = '".$avatarkey."'";
            //echo "update register set amount  = '".$totalamount."', experience  = '".$totalexperience."' WHERE avatar_key = '".$avatarkey."'";
            $result1 = mysqli_query($conn, $sql1);
            echo 'successfull'.",".$totalamount.",".$totalexperience;
        }
        else{
            echo "Un-registered user...";
        }
    }
?>