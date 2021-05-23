--	@C:\Users\alina\Desktop\bd2_lab9\ex2.sql

-- Să se creeze un trigger de tip AFTER care afișează un mesaj ori de 
--câte ori se face o modificare în tabela EMP

create or replace trigger updateemp
after update on emp
begin
	dbms_output.put_line('S-a facut o modificare in tabela emp');
end;
/


-- set serveroutput on;
-- update emp set comm = 100 where empno = 7902;


-- update emp set comm = 100 where empno = 9999;


-- update emp set empno=null where empno=7902;
-- rollback;
