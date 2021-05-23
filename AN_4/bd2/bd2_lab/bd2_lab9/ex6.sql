--	@C:\Users\alina\Desktop\bd2_lab9\ex6.sql

-- Să se scrie un trigger de tip AFTER care se declanșează în momentul
--în care se face un insert, delete sau update pe coloanele sal și comm din tabela EMP. 
--Să se insereze mesaje la declanșarea triggerului în tabela MESAJE


create table emp_copy2 as (select * from emp);

create table log_salarii2
(
	empno number,
	sal_old number,
	sal_new number,
	operator varchar2(20),
	data_op varchar2(20)
);
/