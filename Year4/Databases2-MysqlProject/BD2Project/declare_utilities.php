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
if(isset($_POST['Submit']))
{

    $logedInUsername = $_SESSION['use'];

    $gas_sold = $_POST['gas_sold'];
    if($gas_sold == "" ){
        echo "gas_sold incorect";
        return false;
    }
    $water_sold = $_POST['water_sold'];
    if($water_sold == "" ){
        echo "water_sold incorect";
        return false;
    }
    $heat_consumption= $_POST['heat_consumption'];
    if($heat_consumption == "" ){
        echo "heat_consumption incorect";
        return false;
    }

    $sql = "CALL insert_utilities('$logedInUsername','$gas_sold','$water_sold','$heat_consumption')";
    if ($conn->query($sql) === TRUE) {
        echo '<script type="text/javascript"> window.open("declare_utilities.php","_self");</script>';
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    $conn->close();
}

?>

<html>
<head>

    <title> add Page   </title>
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;

            background-image: url("/font_images/declare_utilities.png");
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

        table.steelBlueCols {
            border: 4px solid #555555;
            background-color: #555555;
            width: 400px;
            text-align: center;
            border-collapse: collapse;
        }
        table.steelBlueCols td, table.steelBlueCols th {
            border: 1px solid #555555;
            padding: 5px 10px;
        }
        table.steelBlueCols tbody td {
            font-size: 12px;
            font-weight: bold;
            color: #FFFFFF;
        }
        table.steelBlueCols td:nth-child(even) {
            background: #398AA4;
        }
        table.steelBlueCols thead {
            background: #398AA4;
            border-bottom: 10px solid #398AA4;
        }
        table.steelBlueCols thead th {
            font-size: 15px;
            font-weight: bold;
            color: #FFFFFF;
            text-align: left;
            border-left: 2px solid #398AA4;
        }
        table.steelBlueCols thead th:first-child {
            border-left: none;
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

<body>
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


<form id='utilities' action='declare_utilities.php' method='post'
      accept-charset='UTF-8'>
    <table class="steelBlueCols">
        <tr>
                <input type='hidden' name='submitted' id='submitted' value='1'/>
            <td>   <label for='gas_sold' >Gas Sold*: </label> </td>
            <td>   <input type='number' name='gas_sold' id='gas_sold' maxlength="50" />
            </td>
        </tr>>
        <tr>
            <td>
                <label for='water_sold' >Water Sold*:</label></td>
            <td><input type='number' name='water_sold' id='water_sold' maxlength="50" />
            </td>
        </tr>
        <tr>
            <td>
                <label for='heat_consumption' >Heat consumption*:</label></td>
            <td><input type='number' name='heat_consumption' id='heat_consumption' maxlength="50" /></td>

        </tr>
        <tr>
            <td>
                <input name="Submit" type="submit" submit="submit" value="Submit" class="button4">
            </td>
        </tr>
    </table>
</form>

<p id="demo"></p>


</body>
</html>