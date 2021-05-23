<?php   session_start();  ?>

<?php
if(!isset($_SESSION['use']))
{
    header("Location:user_account_details.php");
}


if(isset($_POST['modify'])){

    echo '<script type="text/javascript"> window.open("user_account_details.php","_self");</script>';
    $conn->close();

}
?>

<html>
<head>

    <title>Account Details</title>
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
            background-color: #9115dd;
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
        echo "<center><p style='font-size:20px;color:#f5102f;text-shadow: 4px 3px 0px #7A7A7A;
'>Welcome $logedInUsername to your manage account page</p><center>";
        ?>
        <div id="wrapper">

            <article>

                <div id="login">

                    <ul id="login">

                        <form method="post" action=""  >
                            <table class="rosyBrownTable">
                                <tr>
                                <td > firstname</td>
                                <td> <input type="submit" name="first_name" value="<?php echo $row["firstname"];?>"></td>
                                </tr>

                                <tr>
                                    <td> lastname  </td>
                                    <td> <input type="submit" name="last_name" value="<?php echo $row["lastname"];?>"></td>
                                </tr>

                                <tr>
                                    <td> email  </td>
                                    <td> <input type="submit" name="email"  value="<?php echo $row["email"];?>"></td>
                                </tr>

                                <tr>
                                    <td> phone  </td>
                                    <td> <input type="submit" name="phone" value="<?php echo $row["phone"];?>"></td>
                                </tr>

                                <tr>
                                    <td> username </td>s
                                    <td><input type="submit" name="username" value="<?php echo $row["username"];?>"></td>
                                </tr>

                                <tr>
                                    <td> password </td>
                                    <td><input type="submit" name="password" value="<?php echo $row["password"];?>"></td>
                                </tr>
                                <input name="modify" type="submit" submit="submit" value="Edit account" class="button4">

                            </table>

                        </form>



                </div>
                <form action="user_home.php" method="post">
                    <div id="login">
                        <ul id="login">
                            <li>
                                <input type="submit" value="back" onclick="user_home.php" class="button">
                            </li>
                        </ul>
                    </div>



            </article>
            <aside>
            </aside>

            <div id="footer">Digori Gheorghe @Copyrights</div>
        </div>
        <?php
    }

}

?>
</body>
</html>
