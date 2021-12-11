<?php    

//DATABASE CONNECTION:

    //Define the database information.
    $hostname = "localhost";
    $username = "bhicxumy_jbclare";
    $password = "oK7C*fywikC7";
    $database = "bhicxumy_tester";
    $table    = "register";
    
    //Connect to the database.
    $conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");

       if(array_key_exists("member", $_GET)) {
    
        //A POST request was submitted, so define the variables.
        $avatar = $_GET['member'];
        $avatarname = $_GET['membername'];
        
        //Create the query and send it to the database.
        $sql = "SELECT * FROM ".$table." WHERE avatar_key = '".$avatar."'";
        //echo "SELECT * FROM ".$table." WHERE avatar_key = '".$avatar."'";
        $result = mysqli_query($conn, $sql);
        
        //If the database finds at least one row...
        if(mysqli_num_rows($result) > 0) {
        
            //Set the associative array.
            $data = mysqli_fetch_assoc($result);
            
            //Tell the avatar that they are already registered.
            echo "successfull".","."firsttime";
            
//ADDING THE NEW KEY

        //If the avatar is not found.
        } else {
        
            //Create the query and send it to the database.
            $sql = "INSERT INTO ".$table." (avatar_key, registration_date) VALUES ('".$avatar."', '".date("Y-m-d")."')";
            //echo "INSERT INTO ".$table." (avatar_key, registration_date) VALUES ('".$avatar."', '".date("Y-m-d")."')";
            $result = mysqli_query($conn, $sql);
            
            //Tell the avatar they have been added.
              echo "successfull";
        }
        
    } 
    else {
        //A POST request was not submitted, so display an error.
        echo "Sorry! You're not allowed to view this page.";
    }
?>