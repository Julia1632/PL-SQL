-- task 01

--“риггер дл€ строки поставки, автоматически вычисл€ющий сумму и Ќƒ— строки. —ледующий шаг Ч вычисление в триггере суммы и Ќƒ— заголовка поставки по изменению в строках.

create or replace trigger sum_nds_for_supply_str
before insert or update on t_supply_str
for each row
begin
if :new.price is null or :new.qty is null
then :new.sum:=0;
 :new.nds:=0;
else :new.sum:=:new.qty*:new.price;
:new.nds:=:new.sum-(:new.price*20/120);
end if;


end sum_nds_for_supply_str;
/

create procedure test_trigger_sum_nds_for_supply_str
as
begin
commit;
insert into t_supplier(id_supplier,moniker) values (1111,'1111');
insert into t_supply(id_supply,code,dt,id_supplier,e_state) values
(1111,'11',sysdate,1111,'new');
insert into t_ware(id_ware,moniker,name) 
values (1111,'Ware_1','Ware_1');
insert into t_supply_str (id_supply_str,id_supply,id_ware)
values (1111,1111,1111);

end test_trigger_sum_nds_for_supply_str;
/