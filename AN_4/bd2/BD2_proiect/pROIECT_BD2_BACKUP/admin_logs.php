
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

            background-image: url("/font_images/admin_logs.jpg");
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
            font-family: "Lucida Console", Monaco, monospace;
            border: 2px solid #4BA487;
            background-color: #43EEE4;
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
            font-size: 20px;
            color: #000000;
        }
        table.redTable tr:nth-child(even) {
            background: #71f561;
        }
        table.redTable thead {
            background: #bde146;
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

    </style>

</head>


<div class="topnav">
    <div class="topnav-centered">
        <a href='admin_home.php'> Home </a>
    </div>
    <a href='add.php'> Add</a>
    <a href='LOGS.php'> Users Activity</a>
    <a href='Declared_utilities.php'> Declared utilities</a>
    <a href='admin_logs.php'> Admin Changes</a>


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
$tablename = "user_changes";
$sql = "CALL all_table_rows('$tablename')";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
?>
<table class="redTable">
    <thead>
    <tr>
        <th>Message </th>
        <th>name</th>
        <th>declare date</th>
    </tr>
    </thead>
    <tbody>
    <?php

    while($row = $result->fetch_assoc()) {

        ?>
        <form action="" method="post" >
            <tr>
                <td><?php echo $row["mesage"];?></td>
                <input type="hidden" name="Message" value="<?php echo $row["mesage"];?>">
                <td><?php echo $row["username"];?></td>
                <input type="hidden" name="username" value="<?php echo $row["username"];?>">
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