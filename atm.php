<?php    

//DATABASE CONNECTION:
    require_once("config.php");
    $table    = "atm";
    
    //Connect to the database.
    $conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

//CHECKING FOR EXISTING KEY

    //Check to see if a POST request has been submitted.
   if(array_key_exists("balance", $_GET)) {
        $avatarkey = $_GET['balance'];
        $avatarname = $_GET['membername'];
        $sql = "SELECT * FROM register WHERE avatar_key = '".$avatarkey."'";
        $result = mysqli_query($conn, $sql);

        if(mysqli_num_rows($result) > 0) {
            $data = mysqli_fetch_assoc($result);
            echo  "successfull".",".$data['amount'];
        } 
        else {
          echo "You have not been added to the music stand....!";
        }
        
    } 
    else if(array_key_exists("withdraw", $_GET)) {
        $avatarkey = $_GET['withdraw'];
        $avatarname = $_GET['membername'];
        $sql = "SELECT * FROM register WHERE avatar_key = '".$avatarkey."'";
        $result = mysqli_query($conn, $sql);

        if(mysqli_num_rows($result) > 0) {
            $data = mysqli_fetch_assoc($result);
            $updateamount = $data['amount'] - floor($data['amount']);
            $sql1 = "update register set amount = '".$updateamount."'   WHERE avatar_key = '".$avatarkey."'";
            $result1 = mysqli_query($conn, $sql1);
            //echo "update register set amount = 0   WHERE avatar_key = '".$avatarkey."'";
            echo  "successfull".",".floor($data['amount']).",".$avatarkey;
            
        } 
        else {
          echo "You have not been added to the music stand....!";
        }
        
    } 
?>