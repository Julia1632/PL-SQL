/*ТРИГГЕР ДЛЯ СТРОКИ ПРОДАЖИ И ДЛЯ САМОЙ ПРОДАЖИ, 
автоматически вычисляющий сумму по строкам при
изменении цены или количества, а также скидки в
заголовке, и изменяющие общую сумму продажи в заголовке.
Задача сложная из-за mutating по простой схеме,
когда изменение скидки меняет строки,
а изменение суммы строки — меняет сумму в заголовке.
Как альтернатива: для изменения скидки используется процедура,
но тогда нужно придумать механизм блокировки
ПРЯМОГО ИЗМЕНЕНИЯ ЭТОГО ПОЛЯ В ТАБЛИЦЕ.
*/

create or replace trigger M_T_SALE
before update of DISCOUNT on T_SALE
for each row
declare 
m_sum_sale t_sale.sum%type;
begin
select SUM(SUM) into M_sum_SALE from T_SALE_STR where ID_SALE=:new.ID_SALE;
M_SUM_SALE:=M_SUM_SALE+(M_SUM_SALE*:old.DISCOUNT);
:new.sum:=M_sum_SALE*(1-:new.discount);
end;
/



create or replace trigger M_T_SALE_STR
before update of DISCOUNT on T_SALE_str
for each row
declare 
m_sum_sale t_sale.sum%type;
begin


select SUM(SUM) into M_sum_SALE from T_SALE_STR where ID_SALE=:new.ID_SALE;
M_SUM_SALE:=M_SUM_SALE+(M_SUM_SALE*:old.DISCOUNT);
:new.sum:=M_sum_SALE*(1-:new.discount);
end;
/










