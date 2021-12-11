<?php    

//DATABASE CONNECTION:

    //Define the database information.
    $hostname = "localhost";
    $username = "bhicxumy_jbclare";
    $password = "oK7C*fywikC7";
    $database = "bhicxumy_tester";
    $table    = "stand";
    
    //Connect to the database.
    $conn = mysqli_connect($hostname, $username, $password, $database) or die("Database connection error!");
    if(array_key_exists("stand", $_GET)) {
        $money = $_GET['stand'];
        $avatarkey = $_GET['sender'];
        $avatarname = $_GET['sendername'];
        $region = $_GET['region'];
        
        $present = $_GET['present'];
        $previous = $_GET['previous'];
        $sql = "SELECT * FROM stand WHERE avatar_key = '".$avatarkey."' and previous_id = '".$previous."'";
        $result = mysqli_query($conn, $sql);
        if(mysqli_num_rows($result) > 0) {
            $sql1 = "update stand set previous_id  = '".$present."', region  = '".$region."', money  = '".$money."'  WHERE avatar_key = '".$avatarkey."'and previous_id = '".$previous."'";
            $result1 = mysqli_query($conn, $sql1);
            echo 'update';
        }
        else{
            echo 'insert';
            $sql = "INSERT INTO ".$table." (avatar_key, avatar_name,previous_id,region) VALUES ('".$avatarkey."', '".$avatarname."','".$previous."','".$region."')";
            //echo "INSERT INTO ".$table." (avatar_key, avatar_name,previous_id,region) VALUES ('".$avatarkey."', '".$avatarname."','".$previous."','".$region."')";
            $result = mysqli_query($conn, $sql);
            
            //Tell the avatar they have been added.
            echo "Music stand is updated successfully...";
        }
    }
    else  if(array_key_exists("money", $_GET)) {
        $money = $_GET['money'];
        $avatarkey = $_GET['sender'];
        $avatarname = $_GET['sendername'];
        $region = $_GET['region'];
        
        $present = $_GET['present'];
        $previous = $_GET['previous'];
        $sql = "SELECT * FROM stand WHERE avatar_key = '".$avatarkey."' and previous_id = '".$previous."'";
        $result = mysqli_query($conn, $sql);
        if(mysqli_num_rows($result) > 0) {
            $sql1 = "update stand set previous_id  = '".$present."', region  = '".$region."', money  = '".$money."'  WHERE avatar_key = '".$avatarkey."'and previous_id = '".$previous."'";
            $result1 = mysqli_query($conn, $sql1);
             echo  "Money is updated succesfully....";
        }
        else{
            $sql = "INSERT INTO ".$table." (avatar_key, avatar_name,previous_id,region) VALUES ('".$avatarkey."', '".$avatarname."','".$previous."','".$region."')";
            //echo "INSERT INTO ".$table." (avatar_key, avatar_name,previous_id,region) VALUES ('".$avatarkey."', '".$avatarname."','".$previous."','".$region."')";
            $result = mysqli_query($conn, $sql);
            
            //Tell the avatar they have been added.
            echo "Music stand is updated successfully...";
        }
    }
?>
