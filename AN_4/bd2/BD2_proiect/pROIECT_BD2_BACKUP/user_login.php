<?php  session_start(); ?> <!--  // session starts with the help of this function  -->

<?php
if(isset($_SESSION['use']))   // Checking whether the session is already there or not if
    // true then header redirect it to the home page directly
{
    header("Location:home.php");
}

if(isset($_POST['login']))   // it checks whether the user clicked login button or not
{
    $user = $_POST['user'];
    $pass = $_POST['pass'];

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

    // bind the second parameter to the session variable @userCount
    $sql = "SELECT return_user_id('$user','$pass')";
    $results = mysqli_query($conn,$sql);
    $row = mysqli_fetch_array($results,MYSQLI_ASSOC);
    $count = array_shift(array_values($row));

    if($count == 1)  // username is  set to "Ank"  and Password
    {
        $_SESSION['use']=$user;

        echo '<script type="text/javascript"> window.open("user_home.php","_self");</script>';            //  On Successful Login redirects to home.php
    }
    else
    {
        echo "invalid UserName or Password";
    }
}
elseif(isset($_POST['admin']))   // it checks whether the user clicked login button or not
{
    $user = $_POST['user'];
    $pass = $_POST['pass'];

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
    $sql = "SELECT return_admin_id('$user','$pass')";
    $results = mysqli_query($conn,$sql);
    $row = mysqli_fetch_array($results,MYSQLI_ASSOC);
    $count = array_shift(array_values($row));

    if($count == 1)  // username is  set to "Ank"  and Password
    {
        $_SESSION['use']=$user;

        echo '<script type="text/javascript"> window.open("admin_home.php","_self");</script>';            //  On Successful Login redirects to home.php
    }
    else
    {
        echo "invalid admin name or password";
    }
}
?>
<html>
<head>

    <title> Login Page   </title>
    <style>
        body {
            background-image: url("/font_images/new_login_gh.jpg");
            background-repeat:no-repeat;
            background-position:50% 50%;
            background-size: 110% 110%;
        }

        input[type=text], input[type=password] {
            width: 100%;
            padding: 8px 5px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        img.avatar {
            width: 30%;
            border-radius: 40%;
        }
        .imgcontainer {
            text-align: center;
            margin: 0 auto
        }
        .contur {
            opacity: 0.90;
            filter: alpha(opacity=80);
            background-color: rgb(204, 229, 255);
            padding: 10px;
        }

        .grandParentContaniner{

            display:table; height:100%; margin: 0 auto;
        }

        .parentContainer{
            display:table-cell; vertical-align:middle;
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

<div class="grandParentContaniner">
    <div class="parentContainer">
        <div class="contur">
            <form action="" method="post">
                <div class="imgcontainer">
                    <img src="admin.jpg" alt="Avatar" class="avatar">
                </div>
                <div class="parentContainer">
                    <label for="uname"><b>Username</b></label>
                    <input type="text" placeholder="Enter Username"
                           name="user" required >

                    <label for="psw"><b>Password</b></label>
                    <input type="password" placeholder="Enter Password"
                           name="pass" required>
                </div>
                    <button name="login" value="LOGIN" class="button"> Login as user</button>

                    <button name="admin" value="admin" class="button4">Login as administrator</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>

