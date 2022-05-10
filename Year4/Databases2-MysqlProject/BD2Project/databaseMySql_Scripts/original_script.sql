
CREATE TABLE IF NOT EXISTS Admins (
  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(100) NOT NULL,
  lastname VARCHAR(100) NOT NULL,
  email    VARCHAR(100) UNIQUE NOT NULL,
  phone    VARCHAR(100) NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Users (
  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  Building_id INT(6) NOT NULL,
  firstname VARCHAR(100) NOT NULL,
  lastname VARCHAR(100) NOT NULL,
  email    VARCHAR(100) UNIQUE NOT NULL,
  phone    VARCHAR(100) NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  admin_name varchar(100), FOREIGN KEY (admin_name) REFERENCES Admins(username),
);

INSERT INTO Admins(firstname,lastname,email,phone,username,password) VALUES('admin1234','admin1234','admin1234@me.com', '432423423','admin1234','admin1234');


CREATE TABLE IF NOT EXISTS Building(
	id INT(6) UNSIGNED AUTO_INCREMENT,
	name VARCHAR(100) UNIQUE NOT NULL,
	city VARCHAR(100) NOT NULL,
	Street VARCHAR(100) NOT NULL,
	Street_number INT(6) NOT NULL,
	admin_name varchar(100), FOREIGN KEY (admin_name) REFERENCES Admins(username),
	CONSTRAINT UC_Person UNIQUE (ID,name)

);


CREATE TABLE IF NOT EXISTS Apartment (
	id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	Building_id INT(6), FOREIGN KEY (id) REFERENCES Building(id),
	etaj INT(3) NOT NULL,
	number_rooms INT(2) NOT NULL,
	username varchar(100), FOREIGN KEY (username) REFERENCES Users(username)
);

CREATE TABLE IF NOT EXISTS Utilities(
	username varchar(100), FOREIGN KEY (username) REFERENCES Users(username),
	gas_sold INT(5),
	water_sold INT(5),
	heat_consumption INT(5),
	declare_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS User_changes(
	mesage VARCHAR(100) NOT NULL,
	username varchar(100) NOT NULL,
	declare_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS to_pay(
	username varchar(100), FOREIGN KEY (username) REFERENCES Users(username),
	gas_price INT(6),
	water_price INT(6),
	heat_price INT(6),
	total_to_pay INT(6),
	declare_date DATE
);

CREATE TABLE IF NOT EXISTS Events_log(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	username varchar(100), FOREIGN KEY (username) REFERENCES Users(username),
	message VARCHAR(100) NOT NULL,
	declare_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	total_to_pay INT(6)
);


DELIMITER $$
CREATE TRIGGER admin_activity_log 
BEFORE INSERT ON Users 
FOR EACH ROW 
BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.username, 'New user has been added', now()); 
END$$

DELIMITER $$
CREATE TRIGGER update_profile 
BEFORE UPDATE ON Users 
FOR EACH ROW 
BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.username, 'User updated his profile credentials', now()); 
END $$


DELIMITER $$
CREATE TRIGGER admin_activity_log_buildings 
BEFORE INSERT ON Building
FOR EACH ROW 
BEGIN 
	INSERT INTO User_changes (username, mesage, declare_date ) 
	VALUES(new.name, 'New building has been added', now()); 
END $$



DELIMITER $$
CREATE TRIGGER insert_log 
AFTER INSERT ON Utilities 
FOR EACH ROW 
BEGIN
	declare x int(2);
	set x = 1; 
	INSERT INTO events_log ( username, message, declare_date, total_to_pay ) 
	VALUES(new.username, 'Customer added new utilities', new.declare_date, 
	new.gas_sold+new.water_sold+new.heat_consumption); 
	CALL utility_price(new.username, x);
END $$



DELIMITER $$
CREATE TRIGGER delete_invoces 
BEFORE DELETE ON Utilities 
FOR EACH ROW 
BEGIN 
	declare x int(2);
	set x = 0; 
	CALL utility_price(old.username, x);

END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS `utility_price` $$
CREATE PROCEDURE `utility_price`(IN client varchar(100), IN x int(2))
begin
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




DELIMITER //

DROP PROCEDURE IF EXISTS user_statistics //

CREATE PROCEDURE 
  user_statistics(in client varchar(100))
BEGIN  
   SELECT * FROM Utilities
    WHERE username = client;  
END
//
DELIMITER ;




DELIMITER //

DROP PROCEDURE IF EXISTS all_table_rows //

CREATE PROCEDURE 
  all_table_rows(in tablename varchar(100))
BEGIN  
   SET @s = CONCAT('SELECT * FROM ', tablename);
    PREPARE stmt FROM @s;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END
//
DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS list_invoices //

CREATE PROCEDURE 
  list_invoices(in client varchar(100))
BEGIN  
   SELECT * FROM to_pay
    WHERE username = client;  
END
//
DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS insert_user //

CREATE PROCEDURE 
  insert_user(in build_id int(6), in firstnam varchar(100), in lastnam varchar(100),
  in emai varchar(100), in phon varchar(100), 
  in usernam varchar(100), in PASSWOR varchar(100))
BEGIN  
   INSERT INTO Users(Building_id,firstname,lastname,email,phone,username,PASSWORD)
   values(build_id,firstnam,lastnam,emai,phon,usernam,PASSWOR);
END
//
DELIMITER ;




DELIMITER //

DROP PROCEDURE IF EXISTS insert_building //

CREATE PROCEDURE 
  insert_building(in nam varchar(100), in cit varchar(100), in stree varchar(100), in street_numbe int(6))
BEGIN  
   INSERT INTO Building(name,city,street,street_number)
   values(nam,cit,stree,street_numbe);
END
//
DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS insert_utilities //

CREATE PROCEDURE 
  insert_utilities(in usern varchar(100), in gas varchar(100), in water varchar(100), in heat int(6))
BEGIN  
   INSERT INTO Utilities(username, gas_sold,water_sold,heat_consumption)
   values(usern,gas,water,heat);
END
//
DELIMITER ;




DELIMITER //
DROP PROCEDURE IF EXISTS Delete_declaration //
CREATE PROCEDURE Delete_declaration( in usern varchar(100),
								 in datet varchar(100))
BEGIN
delete from Utilities where username = usern and declare_date = datet;

END
//



DELIMITER //
DROP PROCEDURE IF EXISTS Update_profile //
CREATE PROCEDURE `Update_profile` (IN `ids` INT(6), IN `usern` VARCHAR(100), IN `building_id` INT(100), 
IN `pass` VARCHAR(100), IN `first_name` VARCHAR(100), IN `last_name` VARCHAR(100), 
IN `phon` VARCHAR(100), IN `eml` VARCHAR(100), OUT `RESULT` INT(2))  
BEGIN
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

END
//
DELIMITER ;




DELIMITER //

DROP PROCEDURE IF EXISTS list_user_details //

CREATE PROCEDURE 
  list_user_details(in client varchar(100))
BEGIN  
   SELECT * FROM Users
    WHERE username = client;  
END
//
DELIMITER ;


DELIMITER //
DROP FUNCTION IF EXISTS get_userID //
CREATE FUNCTION get_userID(usern varchar(100)) RETURNS INT(2)
BEGIN
declare ids INT(6);
select id into ids from Users where username = eml;
return ids;
END
//



DELIMITER //
DROP FUNCTION IF EXISTS return_user_id //
create FUNCTION return_user_id(client varchar(100),pass varchar(100)) RETURNS INT(6)
begin
	declare NUM INT(6);
    select count(id) INTO NUM from  Users where username = client and password = pass;
	RETURN NUM;
END
//
DELIMITER ;



DELIMITER //
DROP FUNCTION IF EXISTS return_admin_id //
create FUNCTION return_admin_id(client varchar(100),pass varchar(100)) RETURNS INT(6)
begin
	declare NUM INT(6);
    select count(id) INTO NUM from Admins where username = client and password = pass;
	RETURN NUM;
END
//
DELIMITER ;