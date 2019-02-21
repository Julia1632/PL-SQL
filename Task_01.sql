-- task 01

--������� ��� ������ ��������, ������������� ����������� ����� � ��� ������. ��������� ��� � ���������� � �������� ����� � ��� ��������� �������� �� ��������� � �������.

create or replace trigger sum_nds_for_supply_str
before insert 
  OR
  update on t_supply_str for each row 
    BEGIN IF :new.price IS NULL
  OR :new.qty                                              IS NULL THEN :new.sum:=0;
  :new.nds                                                 :=0;
ELSE
  :new.sum:=:new.qty*:new.price;
  :new.nds:=:new.sum*20/100;
END IF;
IF inserting THEN
  UPDATE t_supply
  SET SUM        =SUM+:new.sum ,
    nds          =nds+:new.nds
  WHERE id_supply=:new.id_supply;
END IF;
IF updating THEN
  if :old.sum>:new.sum
  then 
    UPDATE t_supply
    SET SUM        =SUM-(:old.sum-:new.sum) ,
      nds          =nds-(:old.nds-:new.nds)
    WHERE id_supply=:new.id_supply;
  end if;
   END IF;


end sum_nds_for_supply_str;
/

create or replace procedure test_tr_sum_nds
as
answer_s t_supply_str.sum%type;
answer_n t_supply_str.nds%type;
begin
commit;

insert into t_supply_str (id_supply_str,id_supply,id_ware,qty,price)
values (1112,2001,5001,10,to_number(10.2));
select sum into answer_s from t_supply_str where id_supply_str=1112;
dbms_output.put_line('correct value=102 Get'||to_char(answer_s));
select nds into answer_n from t_supply_str where id_supply_str=1112;
dbms_output.put_line('correct value=20.4 Get'||to_char(answer_n));
rollback;
end test_tr_sum_nds;
/

begin
test_tr_sum_nds();
end;
/