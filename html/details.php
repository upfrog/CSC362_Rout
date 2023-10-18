<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $dbhost = 'localhost';
    $dbuser = 'srr';
    $dbpass = 'h$lbaip2';
    
    $conn = new mysqli($dbhost, $dbuser, $dbpass);
    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection, here is why: ". "<br>";
        echo "Errno: ". $conn->connect_errno . "\n";
        echo "Errno: ". $conn->connect_error . "\n";
        exit; //quit this PHP script if connection fails to go through.
    }
    else {
        echo "Connected Succesffully!" . "<br>";
        echo "YAY!!!" . "<br>"."<br>";
    }

    $searchdb = "SHOW TABLES FROM " . $_GET['database'];
    $result = $conn->query($searchdb);

    echo "Tables:"."<br>";
    while ($dbname = $result->fetch_array()) {
        echo $dbname[0] . "<br>";
    }
    $conn->close();
    
?>