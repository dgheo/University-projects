<?php   session_start();  ?>

<html>
<head>
    <title> Home </title>
    <style>
        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;

            background-image: url("/font_images/home_screen_gh.jpg");
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
            background-color: #dd3a23;
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

    </style>
</head>
<body>
<?php
if(!isset($_SESSION['use'])) // If session is not set then redirect to user_login Page
{
    header("Location:user_login.php");
}


?>


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
$variable = $_SESSION['use'];
echo "<center><p style='font-size:70px;color:#ff1518;text-shadow: 4px 3px 0px #7A7A7A;
'>Welcome $variable to your building administration page!</p><center>";

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
$sql = "CALL list_invoices('$variable')";
$result = $conn->query($sql);


if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $water = $row["water_price"];
        $gas = $row["gas_price"];
        $heat = $row["heat_price"];
        $total = $row["total_to_pay"];
    }
}

$dataPoints = array(
	array("label"=> "Water price", "y"=> $water),
	array("label"=> "Heat price", "y"=> $gas),
	array("label"=> "Gas price", "y"=> $heat),

);

?>
<!DOCTYPE HTML>
<html>
<head>
    <script>
        window.onload = function () {

            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: true,
                exportEnabled: true,
                title:{
                    text: "Current invoice"
                },
                subtitles: [{
                    text: "Currency Used: RON"
                }],
                data: [{
                    type: "pie",
                    showInLegend: "true",
                    legendText: "{label}",
                    indexLabelFontSize: 16,
                    indexLabel: "{label} - #percent%",
                    yValueFormatString: "฿#,##0",
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render();

        }
    </script>
</head>
<body>
<div id="chartContainer" style="height: 400px; width: 50%;"></div>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</body>
</html>