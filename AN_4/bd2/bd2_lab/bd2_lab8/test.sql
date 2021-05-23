--	@C:\Users\alina\Desktop\bd2_lab8\test.sql


set serveroutput on;
declare
	function venit_min_max(f_idSef in emp.empno%type, f_idMin out emp.empno%type, f_idMax out emp.empno%type)
		return boolean
		is
			unSubaltern boolean;
			salMin emp.sal%type;
			salMax emp.sal%type;
			unAngajat exception;
		begin
			unSubaltern := false;
			
			select min(sal), max(sal) into salMin, salMax from emp where mgr = f_idSef;
			
		--	select empno into f_idMin from emp where sal=salMin and mgr=f_idSef;
		--	select empno into f_idMax from emp where sal=salMax and mgr=f_idSef;
		
		
			select count(empno) into auxMin from emp where  sal=salMin and mgr=f_idSef;
			if auxMin > 1 then
				select empno into f_idMin from emp 
						where sal=salMin and mgr=f_idSef fetch first row only;
			else
				select empno into f_idMin from emp where sal=salMin and mgr=f_idSef;
			endif;
		
			select count(empno) into auxMax from emp where  sal=salMax and mgr=f_idSef;
			if auxMax > 1 then
				select empno into f_idMax from emp 
						where sal=salMax and mgr=f_idSef offset 1 rows fetch next 1 rows only;
			else
				select empno into f_idMax from emp where sal=salMax and mgr=f_idSef;
			end if;
			
			
			
			
			
			
		
			
			if f_idMin = f_idMax then
				raise unAngajat;
			end if;
			
			exception	
				when unAngajat then
					unSubaltern := true;
					
			return unSubaltern;
		end;
begin
	declare
		unSub boolean;
		idMin emp.empno%type;
		idMax emp.empno%type;
	begin
		dbms_output.put_line(rpad('LISTA CANDIDATI', 30,' '));
		unSub := venit_min_max(7566, idMin, idMax);
	--7782
	--7566
	--7698
	end;
end;
/		
		
		
		