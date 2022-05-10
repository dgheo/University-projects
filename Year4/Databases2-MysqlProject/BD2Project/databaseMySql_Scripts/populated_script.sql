-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 07, 2019 at 09:14 PM
-- Server version: 5.6.34-log
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `my_database`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_table_rows` (IN `tablename` VARCHAR(100))  BEGIN  
   SET @s = CONCAT('SELECT * FROM ', tablename);
    PREPARE stmt FROM @s;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_declaration` (IN `usern` VARCHAR(100), IN `datet` VARCHAR(100))  BEGIN
delete from Utilities where username = usern and declare_date = datet;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_building` (IN `nam` VARCHAR(100), IN `cit` VARCHAR(100), IN `stree` VARCHAR(100), IN `street_numbe` INT(6))  BEGIN  
   INSERT INTO Building(name,city,street,street_number)
   values(nam,cit,stree,street_numbe);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user` (IN `build_id` INT(6), IN `firstnam` VARCHAR(100), IN `lastnam` VARCHAR(100), IN `emai` VARCHAR(100), IN `phon` VARCHAR(100), IN `usernam` VARCHAR(100), IN `PASSWOR` VARCHAR(100))  BEGIN  
   INSERT INTO Users(Building_id,firstname,lastname,email,phone,username,PASSWORD)
   values(build_id,firstnam,lastnam,emai,phon,usernam,PASSWOR);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_utilities` (IN `usern` VARCHAR(100), IN `gas` VARCHAR(100), IN `water` VARCHAR(100), IN `heat` INT(6))  BEGIN  
   INSERT INTO Utilities(username, gas_sold,water_sold,heat_consumption)
   values(usern,gas,water,heat);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_invoices` (IN `client` VARCHAR(100))  BEGIN  
   SELECT * FROM to_pay
    WHERE username = client;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_user_details` (IN `client` VARCHAR(100))  BEGIN  
   SELECT * FROM Users
    WHERE username = client;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_profile` (IN `ids` INT(6), IN `usern` VARCHAR(100), IN `building_id` INT(100), IN `pass` VARCHAR(100), IN `first_name` VARCHAR(100), IN `last_name` VARCHAR(100), IN `phon` VARCHAR(100), IN `eml` VARCHAR(100), OUT `RESULT` INT(2))  BEGIN
declare us varchar(30);
declare bi int(30);
declare pa varchar(30);
declare fn varchar(30);
declare lne varchar(30);
declare ph varchar(30);
declare em varchar(30);

set RESULT = 0;
select Building_id, firstname, lastname, email, phone, username, password into bi, fn, lne, em, ph, us, pa
from Users WHERE id = ids;

if (fn <> first_name and first_name <> '') then 
	UPDATE Users SET firstname=first_name WHERE id = ids;
	SET RESULT = 1;
end if;
if (lne <> last_name and last_name <> '') then 
	UPDATE Users SET lastname=last_name WHERE id = ids;
	SET RESULT = 1;
end if;
if (em <> eml and eml <> '')then 
	UPDATE Users SET email=eml WHERE id = ids;
	SET RESULT = 1;
end if;
if (ph <> phon and phon <> '')then 
	UPDATE Users SET phone=phon WHERE id = ids;
	SET RESULT = 1;
end if;
if (pa <> pass and pass <> '') then 
	UPDATE Users SET password=pass WHERE id = ids; 
	SET RESULT = 1;
end if;
if (us <> usern and usern <> '') then 
	UPDATE Users SET username=usern WHERE id = ids; 
	SET RESULT = 1;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_statistics` (IN `client` VARCHAR(100))  BEGIN  
   SELECT * FROM Utilities
    WHERE username = client;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `utility_price` (IN `client` VARCHAR(100), IN `x` INT(2))  begin
declare gas1 int(6);
DECLARE water1 int(6);
DECLARE heat1 int(6);
DECLARE date1 DATE;
declare total_gas int(6);
declare total_water int(6);
declare total_heat int(6);
declare TOTAL int(6);

select gas_sold, water_sold, heat_consumption, declare_date 
	into gas1, water1, heat1, date1 
	from utilities 
	where username = client 
	order by declare_date 
	desc Limit 1;

set total_gas = gas1*10;
set total_water = water1*15;
set total_heat = heat1*5;
set TOTAL = total_gas + total_heat + total_water;
if x = 1 then
	insert into to_pay(username, gas_price, water_price, heat_price,total_to_pay, declare_date) 
	values(client, total_gas, total_water, total_heat, TOTAL, date1);
elseif x = 0 then  
	delete from to_pay where username = client and gas_price = total_gas 
		and water_price = total_water 
		and	heat_price = total_heat and declare_date = date1;
end if;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_userID` (`eml` VARCHAR(100)) RETURNS INT(6) BEGIN
declare ids INT(6);
select id into ids from Users where username = eml;
return ids;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `return_admin_id` (`client` VARCHAR(100), `pass` VARCHAR(100)) RETURNS INT(6) begin
	declare NUM INT(6);
    select count(id) INTO NUM from Admins where username = client and password = pass;
	RETURN NUM;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `return_user_id` (`client` VARCHAR(100), `pass` VARCHAR(100)) RETURNS INT(6) begin
	declare NUM INT(6);
    select count(id) INTO NUM from  Users where username = client and password = pass;
	RETURN NUM;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(6) UNSIGNED NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `firstname`, `lastname`, `email`, `phone`, `username`, `password`) VALUES
(1, 'admin1234', 'admin1234', 'admin1234@me.com', '432423423', 'admin1234', 'admin1234');

-- --------------------------------------------------------

--
-- Table structure for table `apartment`
--

CREATE TABLE `apartment` (
  `id` int(6) UNSIGNED NOT NULL,
  `Building_id` int(6) DEFAULT NULL,
  `etaj` int(3) NOT NULL,
  `number_rooms` int(2) NOT NULL,
  `username` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `building`
--

CREATE TABLE `building` (
  `id` int(6) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `Street` varchar(100) NOT NULL,
  `Street_number` int(6) NOT NULL,
  `admin_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `building`
--

INSERT INTO `building` (`id`, `name`, `city`, `Street`, `Street_number`, `admin_name`) VALUES
(5, 'Partizanilor', 'Bucuresti', 'Cobzarului', 9, NULL),
(4, 'Sirienilor', 'Bucuresti', 'Creanga', 12, NULL),
(3, 'Tower', 'Bucuresti', 'Independentei', 12, NULL);

--
-- Triggers `building`
--
DELIMITER $$
CREATE TRIGGER `admin_activity_log_buildings` BEFORE INSERT ON `building` FOR EACH ROW BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.name, 'New building has been added', now()); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `events_log`
--

CREATE TABLE `events_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `message` varchar(100) NOT NULL,
  `declare_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_to_pay` int(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `events_log`
--

INSERT INTO `events_log` (`id`, `username`, `message`, `declare_date`, `total_to_pay`) VALUES
(1, 'gheorghe', 'Customer added new utilities', '2019-01-07 18:47:19', 120),
(2, 'gheorghe', 'Customer added new utilities', '2019-01-07 18:47:37', 228),
(3, 'gheorghe', 'Customer added new utilities', '2019-01-07 18:47:48', 39),
(4, 'gheorghe', 'Customer added new utilities', '2019-01-07 18:48:05', 48),
(5, 'alina', 'Customer added new utilities', '2019-01-07 19:04:04', 6),
(6, 'alina', 'Customer added new utilities', '2019-01-07 19:04:14', 38),
(7, 'marin', 'Customer added new utilities', '2019-01-07 19:04:41', 12157),
(8, 'mihai', 'Customer added new utilities', '2019-01-07 19:05:16', 12);

-- --------------------------------------------------------

--
-- Table structure for table `to_pay`
--

CREATE TABLE `to_pay` (
  `username` varchar(100) NOT NULL,
  `gas_price` int(6) DEFAULT NULL,
  `water_price` int(6) DEFAULT NULL,
  `heat_price` int(6) DEFAULT NULL,
  `total_to_pay` int(6) DEFAULT NULL,
  `declare_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `to_pay`
--

INSERT INTO `to_pay` (`username`, `gas_price`, `water_price`, `heat_price`, `total_to_pay`, `declare_date`) VALUES
('gheorghe', 100, 150, 500, 750, '2019-01-07'),
('gheorghe', 50, 1500, 615, 2165, '2019-01-07'),
('gheorghe', 30, 495, 15, 540, '2019-01-07'),
('gheorghe', 150, 345, 50, 545, '2019-01-07'),
('alina', 20, 30, 10, 60, '2019-01-07'),
('alina', 120, 210, 60, 390, '2019-01-07'),
('marin', 320, 181830, 15, 182165, '2019-01-07'),
('mihai', 40, 60, 20, 120, '2019-01-07');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(6) UNSIGNED NOT NULL,
  `Building_id` int(6) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `admin_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `Building_id`, `firstname`, `lastname`, `email`, `phone`, `username`, `password`, `admin_name`) VALUES
(2, 1, 'Gheorghe', 'Digori', 'gheorghe@mail.ru', '07234234324', 'gheorghe', 'gheorghe', NULL),
(3, 3, 'Alina', 'Ciobanu', 'alina@mail.com', '7434532323', 'alina', 'alina', NULL),
(4, 2, 'Mihai', 'Mihai', 'mihai@mail.com', '753545343', 'mihai', 'mihai', NULL),
(5, 1, 'Marin', 'Alexandrescu', 'marin@mail.com', '0712312324', 'marin', 'marin', NULL),
(6, 1, 'Alex', 'Militaru', 'alex@mail.com', '0761432344', 'alex', 'alex', NULL);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `admin_activity_log` BEFORE INSERT ON `users` FOR EACH ROW BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.username, 'New user has been added', now()); 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_profile` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.username, 'User updated his profile credentials', now()); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_changes`
--

CREATE TABLE `user_changes` (
  `mesage` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `declare_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_changes`
--

INSERT INTO `user_changes` (`mesage`, `username`, `declare_date`) VALUES
('New user has been added', '1', '2019-01-07'),
('New building has been added', '1', '2019-01-07'),
('New user has been added', 'gheorghe', '2019-01-07'),
('New building has been added', '2', '2019-01-07'),
('New building has been added', 'Tower', '2019-01-07'),
('New user has been added', 'alina', '2019-01-07'),
('New building has been added', 'Sirienilor', '2019-01-07'),
('New user has been added', 'mihai', '2019-01-07'),
('New user has been added', 'marin', '2019-01-07'),
('New user has been added', 'alex', '2019-01-07'),
('New building has been added', 'Partizanilor', '2019-01-07');

-- --------------------------------------------------------

--
-- Table structure for table `utilities`
--

CREATE TABLE `utilities` (
  `username` varchar(100) DEFAULT NULL,
  `gas_sold` int(5) DEFAULT NULL,
  `water_sold` int(5) DEFAULT NULL,
  `heat_consumption` int(5) DEFAULT NULL,
  `declare_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `utilities`
--

INSERT INTO `utilities` (`username`, `gas_sold`, `water_sold`, `heat_consumption`, `declare_date`) VALUES
('gheorghe', 10, 10, 100, '2019-01-07 18:47:19'),
('gheorghe', 5, 100, 123, '2019-01-07 18:47:37'),
('gheorghe', 3, 33, 3, '2019-01-07 18:47:48'),
('gheorghe', 15, 23, 10, '2019-01-07 18:48:05'),
('alina', 2, 2, 2, '2019-01-07 19:04:04'),
('alina', 12, 14, 12, '2019-01-07 19:04:14'),
('marin', 32, 12122, 3, '2019-01-07 19:04:41'),
('mihai', 4, 4, 4, '2019-01-07 19:05:16');

--
-- Triggers `utilities`
--
DELIMITER $$
CREATE TRIGGER `delete_invoces` BEFORE DELETE ON `utilities` FOR EACH ROW BEGIN 
	declare x int(2);
	set x = 0; 
	CALL utility_price(old.username, x);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_log` AFTER INSERT ON `utilities` FOR EACH ROW BEGIN
	declare x int(2);
	set x = 1; 
	INSERT INTO events_log ( username, message, declare_date, total_to_pay ) 
	VALUES(new.username, 'Customer added new utilities', new.declare_date, 
	new.gas_sold+new.water_sold+new.heat_consumption); 
	CALL utility_price(new.username, x);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `apartment`
--
ALTER TABLE `apartment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `building`
--
ALTER TABLE `building`
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `UC_Person` (`id`,`name`),
  ADD KEY `fk_admin` (`admin_name`);

--
-- Indexes for table `events_log`
--
ALTER TABLE `events_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `to_pay`
--
ALTER TABLE `to_pay`
  ADD KEY `fk_grade_id` (`username`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_admin_name` (`admin_name`);

--
-- Indexes for table `user_changes`
--
ALTER TABLE `user_changes`
  ADD KEY `fk_user_changes` (`username`);

--
-- Indexes for table `utilities`
--
ALTER TABLE `utilities`
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `apartment`
--
ALTER TABLE `apartment`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `building`
--
ALTER TABLE `building`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `events_log`
--
ALTER TABLE `events_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `apartment`
--
ALTER TABLE `apartment`
  ADD CONSTRAINT `apartment_ibfk_1` FOREIGN KEY (`id`) REFERENCES `building` (`id`),
  ADD CONSTRAINT `apartment_ibfk_2` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Constraints for table `building`
--
ALTER TABLE `building`
  ADD CONSTRAINT `fk_admin` FOREIGN KEY (`admin_name`) REFERENCES `admins` (`username`);

--
-- Constraints for table `events_log`
--
ALTER TABLE `events_log`
  ADD CONSTRAINT `events_log_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Constraints for table `to_pay`
--
ALTER TABLE `to_pay`
  ADD CONSTRAINT `fk_grade_id` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_admin_name` FOREIGN KEY (`admin_name`) REFERENCES `admins` (`username`);

--
-- Constraints for table `utilities`
--
ALTER TABLE `utilities`
  ADD CONSTRAINT `utilities_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
