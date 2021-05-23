--	@C:\Users\alina\Desktop\bd2_lab9\ex3.sql

-- Să se creeze un trigger de tip AFTER care afișează un mesaj ori de 
--câte ori se face o modificare în tabela emp, dar doar pentru angajații care 
--nu au funcția ‘MANAGER’

create or replace trigger updateemp2
after update on emp
for each row
when (old.job <> 'MANAGER')
begin
	dbms_output.put_line('S-a facut o modificare in tabela emp');
end;
/


-- set serveroutput on;
-- update emp set comm = 100 where empno = 7566;
-- rollback;
