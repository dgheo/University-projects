

<?php   session_start();  ?>

<?php
if(!isset($_SESSION['use'])) // If session is not set then redirect to Login Page
{
    header("Location:user_login.php");
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
if (isset($_POST['delete'])) {
    $username_client = $_POST['username'];
    $gas_sold = $_POST['gas_sold'];
    $water_sold = $_POST['water_sold'];
    $heat_consumption = $_POST['heat_consumption'];
    $declare_date = $_POST['declare_date'];
    $sql = "CALL Delete_declaration('$username_client', '$declare_date')";
    if ($conn->query($sql) === TRUE) {
        echo '<script type="text/javascript"> window.open("user_statistics.php","_self");</script>';
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    $conn->close();
}


?>




<html>
<head>

    <title> Declared utilities</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;

            background-image: url("/font_images/user-experience.jpg");
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

        .topnav a.active {
            background-color: #4CAF50;
            color: white;
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


        table.redTable {
            font-family: "Lucida Console", Monaco, monospace;
            border: 2px solid #4BA487;
            background-color: #EEAF77;
            width: 100%;
            text-align: center;
            border-collapse: collapse;
        }
        table.redTable {
            width:80%;
            margin-top: 2%;
            margin-left:10%;
            margin-right:10%;
        }
        table.redTable td, table.redTable th {
            border: 4px solid #262507;
            padding: 3px 3px;
        }
        table.redTable tbody td {
            font-size: 16px;
            color: #000000;
        }
        table.redTable tr:nth-child(even) {
            background: #95F57C;
        }
        table.redTable thead {
            background: #2692A4;
        }
        table.redTable thead th {
            font-size: 30px;
            font-weight: bold;
            color: #FFFFFF;
            text-align: center;
            border-left: 2px solid #63A444;
        }
        table.redTable thead th:first-child {
            border-left: none;
        }

        table.redTable tfoot {
            font-size: 13px;
            font-weight: bold;
            color: #FFFFFF;
            background: #2692A4;
        }
        table.redTable tfoot td {
            font-size: 13px;
        }
        table.redTable tfoot .links {
            text-align: right;
        }
        table.redTable tfoot .links a{
            display: inline-block;
            background: #FFFFFF;
            color: #A40000;
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

    </style>

</head>


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
$sql = "CALL user_statistics('$logedInUsername')";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
?>
<table class="redTable">
    <thead>
    <tr>
        <th>username </th>
        <th>gas sold</th>
        <th>water sold</th>
        <th>heat consumption</th>
        <th>declare date</th>
        <th>delete</th>
    </tr>
    </thead>
    <tbody>
    <?php

    while($row = $result->fetch_assoc()) {

        ?>
        <form action="" method="post" >
            <tr>
                <td><?php echo $row["username"];?></td>
                <input type="hidden" name="username" value="<?php echo $row["username"];?>">
                <td><?php echo $row["gas_sold"];?></td>
                <input type="hidden" name="gas/_sold" value="<?php echo $row["gas_sold"];?>">
                <td><?php echo $row["water_sold"]?></td>
                <input type="hidden" name="water_sold" value="<?php echo $row["water_sold"];?>">
                <td><?php echo $row["heat_consumption"];?></td>
                <input type="hidden" name="heat_consumption" value="<?php echo $row["heat_consumption"];?>">

                <td><?php echo $row["declare_date"];?></td>
                <input type="hidden" name="declare_date" value="<?php echo $row["declare_date"];?>">
                <td> <button name="delete" value="delete" class="button4"> delete</button></td>
            </tr>
        </form>


        <?php
    }

    } else {
        echo "<center><p style='font-size:100px;color:blue;'>No declaration</p><center>";
    }

    ?>
    </tbody>
</table>
</body>

</html>
