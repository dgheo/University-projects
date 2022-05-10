<?php   session_start();  ?>

<?php
      if(!isset($_SESSION['use']))
       {
           header("Location:Login.php");  
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
        if(isset($_POST['add_building']))
		{
     		$name = $_POST['name'];
     		if($name == "" ){
     			echo "nume incorect";
     			return false;
     		}
     		$city = $_POST['city'];
     		if($city == "" ){
     			echo "city incorect";
     			return false;
     		}
     		$street= $_POST['Street'];
     		if($street == "" ){
     			echo "Street incorect";
     			return false;
     		}
     		$street_number = $_POST['Street_number'];
     		if($street_number == "" ){
     			echo "Street_number incorect";
     			return false;
     		}

            $sql = "CALL insert_building('$name','$city','$street','$street_number')";

     		if ($conn->query($sql) === TRUE) {
                echo '<script type="text/javascript"> window.open("add.php","_self");</script>';
			} else {
			    echo "Error: " . $sql . "<br>" . $conn->error;
			}
			$conn->close();

		}



		if(isset($_POST['add_user']))   // it checks whether the user clicked login button or not
		{
			$firstname = $_POST['firstname'];
     		if($firstname == "" ){
     			echo "incorect name";
     			return false;
     		}
     		$lastname = $_POST['lastname'];
     		if($lastname == "" ){
     			echo "incorect lastname";
     			return false;
     		}
     		$email = $_POST['email'];
     		if($email == "" ){
     			echo "incorect email";
     			return false;
     		}
     		$phone = $_POST['phone'];
     		if($phone == "" ){
     			echo "incorect phone";
     			return false;
     		}
     		$username = $_POST['username'];
     		if($username == "" ){
     			echo "incorect username";
     			return false;
     		}

     		$PASSWORD = $_POST['PASSWORD'];
     		if($PASSWORD == "") {
                echo "incorect password";
                return false;
            }
            $Building_id = $_POST['BuildingID'];
            if($Building_id == "") {
                echo "incorect building_id";
                return false;
            }
            $sql = "CALL insert_user('$Building_id','$firstname','$lastname','$email','$phone','$username','$PASSWORD')";
     		if ($conn->query($sql) === TRUE) {
                echo '<script type="text/javascript"> window.open("add.php","_self");</script>';
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


    .styleSelect{
       -webkit-appearance: button;
        position: center;
        -moz-border-radius: 20px
        display: inline-block;
        background-repeat: no-repeat;
        color: rgba(0, 0, 0, 0.96);
        margin: 20px;
        padding: 10px 15px;
        width: 300px;
        line-height:35px;
        background-image: url(http://i62.tinypic.com/15xvbd5.png), -webkit-linear-gradient(#009baa, #aa001f 40%, #162591);
        background-color: #5592bb;
        border-bottom: 70px;
    }
    td{
        color: #330729;
        background-color: #27fffd;
        font-size: 40px;
        font-family: "Times New Roman", Times, serif;
    }


    input[type=checkbox]
    {
      /* Double-sized Checkboxes */
      -ms-transform: scale(3); /* IE */
      -moz-transform: scale(3); /* FF */
      -webkit-transform: scale(3); /* Safari and Chrome */
      -o-transform: scale(3); /* Opera */
      padding: 10px;
    }

    {
      /* Checkbox text */
      font-size: 110%;
      display: inline;
    }
    .button {
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
    .button:hover {opacity: 7}

    </style>

</head>

<body>
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


<select  name="add" id="add" onchange="updateT()" class="styleSelect" >
    <option>Select option</option>
    <option value="Add_building">Add building</option>
    <option value="Add_user">Add user</option>
</select>


<script type="text/javascript">
function updateT() {
	var sel= document.getElementById('add');
	var selValue = sel.options[sel.selectedIndex].value;
	if(selValue == "Add_user"){
	    document.getElementById("demo").innerHTML= `
        <form action="" method="post" >
        <table width="200" border="0">
        <select name="name_user" class="styleSelect">
        <?php

         $servername = "localhost";
         $username = "root";
         $password = "root";
         $dbname = "my_database";

         $conn = new mysqli($servername, $username, $password, $dbname);
         $tablename = "Users";
         $sql = "CALL all_table_rows('$tablename')";
         $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            ?> <option> <?php echo "NEW USER"?> </option>
                <?php
            // output data of each row
            while($row = $result->fetch_assoc()) {
               ?> <option> <?php echo $row["username"] ?> </option>
                <?php
            }
        } else {
            echo "<option> nu exista </option>";
        }

        ?>
        </select>

          <tr>
            <td > BuildingID</td>
            <td> <input type="number" name="BuildingID" > </td>
          </tr>

          <tr">
            <td > Firstname</td>
            <td> <input type="text" name="firstname" > </td>
          </tr>

          <tr>
            <td> Lastname  </td>
            <td> <input type="text" name="lastname"></td>
          </tr>

          <tr>
            <td> Email  </td>
             <td> <input type="text" name="email" ></td>
          </tr>

          <tr>
            <td> Phone  </td>
            <td> <input type="text" name="phone"></td>
          </tr>

          <tr>
            <td> Username </td>
            <td><input type="text" name="username"></td>
          </tr>

          <tr>
            <td> Password </td>
            <td><input type="text" name="PASSWORD"></td>
          </tr>


         <tr>
            <td><button name="add_user" value="add_user" class="button">Add new user</button></td>
          </tr>

        </table>
        </form>`;
	}
	else if(selValue == "Add_building"){
		document.getElementById("demo").innerHTML = `
        <form action="" method="post">

          <table width="200" border="0">
            <select name="name_user" class="styleSelect">
        <?php

            $servername = "localhost";
            $username = "root";
            $password = "root";
            $dbname = "my_database";

            $conn = new mysqli($servername, $username, $password, $dbname);
            $tablename = "Building";
            $sql = "CALL all_table_rows('$tablename')";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
            // output data of each row
            ?> <option> <?php echo "NEW BUILDING"?> </option>
                <?php
            while($row = $result->fetch_assoc()) {
            ?> <option> <?php echo $row["name"] ?> </option>
                <?php
            }
            } else {
            echo "<option> nu exista </option>";
        }

            ?>
        </select>
          <tr>
            <td> Name</td>
            <td> <input type="text" name="name" > </td>
          </tr>

            <tr>
            <td> City  </td>
             <td> <input type="text" name="city"></td>
          </tr>

            </tr>
            <tr>
            <td> Street  </td>
             <td> <input type="text" name="Street"></td>
          </tr>

            <tr>
            <td> Street number  </td>
            <td> <input type="number" name="Street_number"></td>
          </tr>


           <tr>
            <td><button name="add_building" value="add_building" class="button">Add new building</button></td>
            <td></td>
          </tr>

        </table>
        </form>`;
    }
}
</script>

<p id="demo"></p>


</body>
</html>