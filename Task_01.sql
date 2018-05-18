-- task 01

--“риггер дл€ строки поставки, автоматически вычисл€ющий сумму и Ќƒ— строки. —ледующий шаг Ч вычисление в триггере суммы и Ќƒ— заголовка поставки по изменению в строках.

create trigger sum_nds_for_supply_str
before insert or update on t_supply_str
for each row
begin
:new.summa:=:new.qty*:new.price;
:new.nds:=:new.summa-(:new.price*20/120);
end sum_nds_for_supply_str;
/