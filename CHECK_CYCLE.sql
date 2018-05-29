create or replace procedure T_DEPT_CHECK_CYCLE 
as
  flag number;
  begin
  select COUNT(*) into flag from
  (select id_dept,id_parent,connect_by_iscycle c from T_DEPT
  start with ID_PARENT is null
  connect by nocycle prior ID_DEPT=ID_PARENT)
  where C=1;
  if FLAG>0
  then DBMS_OUTPUT.PUT_LINE('count cycle = '||FLAG);
  else DBMS_OUTPUT.PUT_LINE('no cycle');
  end if;
  end;
  /
  
