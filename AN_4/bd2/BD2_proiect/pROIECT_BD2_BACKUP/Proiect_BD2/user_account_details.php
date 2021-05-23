
<?php   session_start();  ?>
<?php
if(!isset($_SESSION['use']))
{
    header("Location:user_account_details.php");
}

$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "my_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if(isset($_POST['submit'])){
    $usern = $_POST['username'];
    $pass = $_POST['password'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $eml = $_POST['email'];
    $phon = $_POST['phone'];
    $building_id = 0;
    $logedInUsername = $_SESSION['use'];
    $sql = "SELECT get_userID('$logedInUsername')";
    $results = mysqli_query($conn,$sql);
    $row = mysqli_fetch_array($results,MYSQLI_ASSOC);
    $id = array_shift(array_values($row));
    $conn->close();

    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    $stmt = $conn->prepare('CALL Update_profile(?, ?, ?, ?, ?, ?, ?, ?, @RESULT)');
    $stmt->bind_param('isisssss',$id,$usern, $building_id,
        $pass, $first_name,
        $last_name, $phon, $eml);
    $stmt->execute();
    $result = mysqli_query($conn,'SELECT @RESULT');
    $rows = mysqli_fetch_array($result,MYSQLI_ASSOC);
    $idc = array_shift(array_values($rows));

    if($idc == 1)
    {
        echo '<script type="text/javascript"> window.open("user_details.php","_self");</script>';
    }
    else
    {
        echo "Invalid dates";
    }
    $conn->close();

}

?>

<html>
<head>

    <title>Edit Account</title>
    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;

            background-image: url("/font_images/add_building.jpg");
            background-repeat:no-repeat;
            background-position:50% 50%;
            background-size: 110% 110%;
        }

        .topnav {
            position: relative;
            overflow: hidden;
            background-color: #333;
        }

        .topnav a {
            float: left;
            color: #f2f2f2;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-size: 17px;
        }

        .topnav a:hover {
            background-color: #ddd;
            color: black;
        }
        .topnav-centered a {
            float: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .topnav-right {
            float: right;
        }

        table.rosyBrownTable {
            border: 4px solid #BA8697;
            background-color: #555555;
            width: 400px;
            text-align: center;
            border-collapse: collapse;
        }
        table.rosyBrownTable td, table.rosyBrownTable th {
            border: 1px solid #555555;
            padding: 4px 4px;
        }
        table.rosyBrownTable tbody td {
            font-size: 13px;
            font-weight: bold;
            color: #FFFFFF;
        }
        table.rosyBrownTable tr:nth-child(even) {
            background: #BA8697;
        }
        table.rosyBrownTable td:nth-child(even) {
            background: #BA8697;
        }
        table.rosyBrownTable tfoot {
            font-weight: bold;
            background: #BA8697;
            border-top: 1px solid #444444;
        }
        table.rosyBrownTable tfoot .links {
            text-align: right;
        }
        table.rosyBrownTable tfoot .links a{
            display: inline-block;
            background: #FFFFFF;
            color: #BA8697;
            padding: 2px 8px;
            border-radius: 5px;
        }
        .button4 {
            background-color: #f5102f;
            border: none;
            color: white;
            padding: 16px 50px;
            text-align: center;
            font-size: 16px;
            margin: 8px 4px;
            opacity: 0.6;
            transition: 0.3s;
            display: inline-block;
            text-decoration: none;
            cursor: pointer;
        }
        .button4:hover {opacity: 7}

        .button {

            background-color: #42F531;
            border: none;
            color: white;
            padding: 16px 50px;
            text-align: center;
            font-size: 16px;
            margin: 8px 4px;
            opacity: 0.6;
            transition: 0.3s;
            display: inline-block;
            text-decoration: none;
            cursor: pointer;
        }
        .button:hover {opacity: 7}
    </style>
</head>
<body>
<div class="topnav">
    <div class="topnav-centered">
        <a href='user_home.php'> Home </a>
    </div>
    <a href='declare_utilities.php'> Declare utilities</a>
    <a href='user_statistics.php'>Declared indexes</a>
    <a href='Invoices.php'> Invoices</a>
    <a href='user_details.php'> Account details</a>

    <div class="topnav-right">
        <a href='logout.php' style="float: right;" > Logout</a>
    </div>
</div>
<?php
$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "my_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$logedInUsername = $_SESSION['use'];
$sql = "CALL list_user_details('$logedInUsername')";
$result = $conn->query($sql);


if ($result->num_rows > 0) {
while($row = $result->fetch_assoc()) {

?>
    <div id="wrapper">

    <article>
        <h1>Welcome to edit account page</h1>

        <div id="login">

            <ul id="login">

                <form method="post" name="editAccount" action=""  >
                    <table class="rosyBrownTable">
                        <tr">
                        <td > firstname</td>
                        <td> <input type="text" name="first_name" value="<?php echo $row["firstname"];?>"></td>
                        </tr>

                        <tr>
                            <td> lastname  </td>
                            <td> <input type="text" name="last_name" value="<?php echo $row["lastname"];?>"></td>
                        </tr>

                        <tr>
                            <td> email  </td>
                            <td> <input type="text" name="email"  value="<?php echo $row["email"];?>"></td>
                        </tr>

                        <tr>
                            <td> phone  </td>
                            <td> <input type="text" name="phone" value="<?php echo $row["phone"];?>"></td>
                        </tr>

                        <tr>
                            <td> username </td>
                            <td><input type="submit" name="username" value="<?php echo $row["username"];?>"></td>
                        </tr>

                        <tr>
                            <td> password </td>
                            <td><input type="text" name="password" value="<?php echo $row["password"];?>"></td>
                        </tr>
                        <input name="submit" type="submit" submit="submit" value="Apply changes" class="button4">

                    </table>

                </form>



        </div>
        <form action="user_details.php" method="post">
            <div id="login">
                <ul id="login">
                    <li>
                        <input type="submit" value="back" onclick="user_details.php" class="button">
                    </li>
                </ul>
            </div>



    </article>
    <aside>
    </aside>

    <?php
}

}
?>
</body>
</html>
