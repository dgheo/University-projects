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
      if(!isset($_SESSION['use'])) // If session is not set then redirect to Login Page
       {
           header("Location:Login.php");  
       } 


?>



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
$variable = $_SESSION['use'];
echo "<center><p style='font-size:70px;color:#feff14;text-shadow: 4px 3px 0px #7A7A7A;
'>Welcome $variable, you are logged in as administrator</p><center>";
