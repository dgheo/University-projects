
<?php   session_start();  ?>

<?php
if(!isset($_SESSION['use'])) // If session is not set then redirect to Login Page
{
    header("Location:user_login.php");
}


if(isset($_POST['add']) || isset($_POST['reject'])){
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
}

//?>


<html>
<head>

    <title> Statistics   </title>
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;

            background-image: url("/font_images/invoices.jpg");
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

        table.redTable {
            border: 2px solid #A40808;
            background-color: #EEE7DB;
            width: 100%;
            text-align: center;
            border-collapse: collapse;
            position: relative;

        }
        table.redTable {
            width:80%;
            margin-top: 2%;
            margin-left:10%;
            margin-right:10%;
        }
        table.redTable td, table.redTable th {
            border: 5px solid #AAAAAA;
            padding: 3px 2px;
        }
        table.redTable tbody td {
            font-size: 23px;
            position: relative;
        }
        table.redTable tr:nth-child(even) {
            background: #F5C8BF;
        }
        table.redTable thead {
            background: #A40808;
        }
        table.redTable thead th {
            font-size: 25px;
            font-weight: bold;
            color: #FFFFFF;
            text-align: center;
            border-left: 2px solid #A40808;
        }
        table.redTable thead th:first-child {
            border-left: none;
        }

        table.redTable tfoot {
            font-size: 16px;
            font-weight: bold;
            color: #FFFFFF;
            background: #A40808;
            border-top: 2px solid #444444;
        }
        table.redTable tfoot td {
            font-size: 16px;
        }
        table.redTable tfoot .links {
            text-align: right;
        }
        table.redTable tfoot .links a{
            display: inline-block;
            background: #FFFFFF;
            color: #A40808;
            padding: 2px 8px;
            border-radius: 5px;
        }


    </style>

</head>


<div class="topnav">
    <div class="topnav-centered">
        <a href='user_home.php'> Home </a>
    </div>
    <a href='declare_utilities.php'> Declare utilities</a>
    <a href='user_statistics.php'> Declared indexes</a>
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
$sql = "CALL list_invoices('$logedInUsername')";
$result = $conn->query($sql);


if ($result->num_rows > 0) {
?>
<table class="redTable">
    <thead>
    <tr>
        <th>Gas PRICE</th>
        <th>Water PRICE</th>
        <th>Heat consumption PRICE</th>
        <th>TOTAL TO PAY (RON)</th>
        <th>LAST declared</th>
    </tr>
    </thead>
    <tbody>
    <?php

    while($row = $result->fetch_assoc()) {

        ?>
        <form action="" method="post" >
            <tr>
                <td><?php echo $row["gas_price"];?></td>
                <input type="hidden" name="Gas PRICE" value="<?php echo $row["gas_price"];?>">
                <td><?php echo $row["water_price"]?></td>
                <input type="hidden" name="Water PRICE" value="<?php echo $row["water_price"];?>">
                <td><?php echo $row["heat_price"];?></td>
                <input type="hidden" name="Heat consumption PRICE" value="<?php echo $row["heat_price"];?>">
                <td><?php echo $row["total_to_pay"];?></td>
                <input type="hidden" name="TOTAL TO PAY (Ron)" value="<?php echo $row[""];?>">
                <td><?php echo $row["declare_date"];?></td>
                <input type="hidden" name="declare_date" value="<?php echo $row["declare_date"];?>">
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
