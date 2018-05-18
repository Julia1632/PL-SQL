/*Поставки и Продажи имеют два состояния: 
Черновик (new) и Исполнена (done). 
При исполнении документа изменяются остатки на складе. 
Пока документ — черновик, его можно свободно изменять.
А исполненные документы править нельзя.*/

CREATE OR REPLACE TRIGGER lock_table_t_supply FOR UPDATE OR
  INSERT OR
  DELETE ON t_supply_str compound TRIGGER n_state t_supply.e_state%type;
  o_state t_supply.e_state%type;
  new_id t_supply_str.id_supply%type;
  old_id t_supply_str.id_supply%type;
  n1 NUMBER(1);
  n2 NUMBER(1);
  before EACH row
IS
BEGIN
  new_id:=:new.id_supply;
  old_id:=:old.id_supply;
  SELECT COUNT(*)
  INTO n1
  FROM t_supply s
  WHERE s.id_supply=new_id
  AND s.e_state    ='done';

  SELECT COUNT(*)
  INTO n2
  FROM t_supply s
  WHERE s.id_supply=old_id
  AND s.e_state    ='done';

  end before EACH row;
  after each row is
  BEGIN
    IF (n1>0 or n2>0) THEN
      raise_application_error(-20001,'invalid action');
    END if;
  END after each row;
END lock_table_t_supply;
/