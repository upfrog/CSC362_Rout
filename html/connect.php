<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
?>

<?php
    $config = parse_ini_file('/home/upfrog42/CSC362_Rout/html/mysql.ini');
    $dbname = 'instrument_rentals';            
?>



<?php
    $conn = new mysqli(
                $config['mysqli.default_host'],
                $config['mysqli.default_user'],
                $config['mysqli.default_pw']);
    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection, here is why: ". "<br>";
        echo "Errno: ". $conn->connect_errno . "\n";
        echo "Errno: ". $conn->connect_error . "\n";
        exit; //quit this PHP script if connection fails to go through.
    }
    else {
        echo "Connected Succesffully!" . "<br>";
        echo "YAY!!!" . "<br>";
    }

    $dblist = "SHOW databases";
    $result = $conn->query($dblist);

    while ($dbname = $result->fetch_array()) {
        echo $dbname[0] . "<br>";
    }

    $conn->close();
?>

<h2>Checkback soon!</h2>


<form action="details.php" method="GET">
    <label for="database">Database name:</label>
    <input name="database" id="database" type="text">
    <input type="submit" value="See Details">
</form>

