set serveroutput on;
declare
	type tableNested is table of emp%rowtype;
	contor integer;
	tblNested tableNested;
begin
	dbms_output.put_line('folosire bulk collect into nested table');
	select * bulk collect into tblNested from emp where deptno=10;
	for contor in tblNested.first .. tblNested.last
	loop
		dbms_output.put_line('contor=' || contor
			|| ' tblNested.empno=' || tblNested(contor).empno
			|| ' tblNested.ename=' || tblNested(contor).ename
			|| ' tblNested.sal=' || tblNested(contor).sal
			|| ' tblNested.comm=' || tblNested(contor).comm
			|| ' tblNested.hiredate=' || tblNested(contor).hiredate
			|| ' tblNested.mgr=' || tblNested(contor).mgr
			|| ' tblNested.deptno=' || tblNested(contor).deptno);
	end loop;
end;
/