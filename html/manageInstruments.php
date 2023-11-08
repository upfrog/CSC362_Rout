<?php
/*
INITIAL SETUP
*/
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $config = parse_ini_file('/home/upfrog42/CSC362_Rout/html/mysql.ini');
    $dbname = 'instrument_rentals'; 
    $dbset = "USE instrument_rentals;";
    $key_constr_true = "SET FOREIGN_KEY_CHECKS = TRUE;";
    $key_constr_false = "SET FOREIGN_KEY_CHECKS = FALSE;";
    require 'results_to_table.php';

/*
CONNECT TO DATABSE
*/
    $conn = new mysqli(
                $config['mysqli.default_host'],
                $config['mysqli.default_user'],
                $config['mysqli.default_pw'],
                'instrument_rentals');
    if ($conn->connect_errno) {
        echo "Error: Failed to make a MySQL connection, here is why: ". "<br>";
        echo "Errno: ". $conn->connect_errno . "\n";
        echo "Errno: ". $conn->connect_error . "\n";
        exit; //quit this PHP script if connection fails to go through.
    }
    else {
        echo "Connected Succesffully!" . "<br>";
    }



/*
INSERTION AND DELETION OF NEW RECORDS

When the page is opened, the $_POST array will be checked for one of two flags;
'resetdb' or 'delete'. If one of these flags is present, then the appropriate
if-statement will be run.

*/

    /*
    This uses provided SQL code to insert 9 new instruments.
    */
    if (array_key_exists('resetdb', $_POST)) {
        $add_instruments_php = file_get_contents('add_instruments.sql');

        //This is a bandaid for key constraint issues. 
        $conn->query($key_constr_false);
           
        // Submit the insertion query, checking for errors.
        if(!$conn->query($add_instruments_php)) {
            $conn->query($key_constr_true);
            echo $conn->error;
            echo "Failed to insert records!\n";
        } 
        else {
            $conn->query($key_constr_true);
            header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
            exit(); 
        }
   }

    /*
    This deletes all records selected by the user.
    */
    elseif (array_key_Exists('delete', $_POST)) {
        $current_records = $conn->query("SELECT * FROM instruments;");
        $records_body = $current_records->fetch_all();

        
        $del_stmt = $conn->prepare('DELETE FROM instruments WHERE instrument_id = (?);');
        $del_stmt->bind_param('i', $id);

        /*
        We loop through all records. For each record, we check if it has been chosen for 
        deletion by being included in the $_POST array.
        */
        for ($i = 0; $i<$current_records->num_rows; $i++) {
            $id = $records_body[$i][0];
            $key = "checkbox" . $id;

            $conn->query($key_constr_false);
            //Checks if the current key is in the $_POST statement
            if (isset($_POST[$key]) && !$del_stmt->execute()){
                echo $conn->error;
            }
            $conn->query($key_constr_false);
        }
    }

    //Set the database
    $conn->query($dbset);
    $dblist = "SELECT * FROM instruments;";
    $result = $conn->query($dblist);
    //Note for future improvement: I think you are being redundant with your databse setting
    //and fetching the dblist.
?>


    <form action="manageInstruments.php" method=POST>
    <table>
         <?php
            echo result_to_html_table($result)
         ?>
    </table>
        <input type="submit" name = "delete" value="Delete Selected Records" method=POST/>
    </form>

    <form action="manageInstruments.php" method=POST>
        <input type="submit" name="resetdb" value = "Add nine more records" method=POST/>
    </form>

<?php
    $conn->close();
?>