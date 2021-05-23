set serveroutput on;
declare
	alege integer;
	functie emp.job%type;
	nume emp.ename%type;
begin
	alege := &numar;
	
	functie := case alege
			when '1' then 'SALESMAN'
			when '2' then 'CLERK'
			else 'ANALYST'
		end;
		
	select ename into nume from emp
		where empno = (case functie
						when 'SALESMAN' then 7844
						when 'CLERK' then 7900
						when 'ANALYST' then 7902
						else 7839
					end );
	
	dbms_output.put_line(nume || ' are functia ' || functie);
end;
/