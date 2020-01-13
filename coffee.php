<?php
 
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "coffee_crew";
 
    // we will get actions from the app to do operations in the database...
    $action = $_POST['action'];

    // Create Connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check Connection
    if($conn->connect_error){
        die("Connection Failed: " . $conn->connect_error);
        return;
    }

    /////////////////Coffee Crew//////////////////////
    // Login
    if("LOGIN" == $action){
        $table = "user";
        $email = $_POST['email'];
        $password = $_POST['password'];
        $db_data = array();
        $sql = "SELECT userId, teamId from $table WHERE email = '$email' AND password = '$password'";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data[0]);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

     // register
     if("REGISTER" == $action){
        // App will be posting these values to this server
        $table = "user";
        $name = $_POST["name"];
        $email = $_POST["email"];
        $password = $_POST["password"];
        $teamId = $_POST["teamId"];

        $sql = "SELECT userId from $table WHERE email = '$email'";
        $result = $conn->query($sql);

        if($result->num_rows > 0){
            echo "ERR_EMAIL_EXISTS";
        }else{
            $sql = "INSERT INTO $table (name, email, password, teamId) VALUES ('$name', '$email', '$password', '$teamId')";
            $result = $conn->query($sql);

            if($result){
                echo "success";
            }else{
                echo "error";
            }
        }
        
        $conn->close();
        return;
    }

    // Get all TEAMS
    if("GET_ALL_TEAMS" == $action){
        $table = "team";
        $db_data = array();
        $sql = "SELECT teamId, team_name from $table ORDER BY team_name ASC";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 


    ///////////////////////////////////////
   // Get all employee records from the database
    if("GET_ALL" == $action){
        $db_data = array();
        $sql = "SELECT id, first_name, last_name from $table ORDER BY id DESC";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
    // Add an Employee
    if("ADD_EMP" == $action){
        // App will be posting these values to this server
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];
        $sql = "INSERT INTO $table (first_name, last_name) VALUES ('$first_name', '$last_name')";
        $result = $conn->query($sql);
        echo "success";
        $conn->close();
        return;
    }
 
    // Remember - this is the server file.
    // I am updating the server file.
    // Update an Employee
    if("UPDATE_EMP" == $action){
        // App will be posting these values to this server
        $emp_id = $_POST['emp_id'];
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];
        $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' WHERE id = $emp_id";
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
    // Delete an Employee
    if('DELETE_EMP' == $action){
        $emp_id = $_POST['emp_id'];
        $sql = "DELETE FROM $table WHERE id = $emp_id"; // don't need quotes since id is an integer.
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
?>