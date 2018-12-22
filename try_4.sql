/*, 
������������� ����������� ����� �� ������� ���
��������� ���� ��� ����������, � ����� ������ �
���������, � ���������� ����� ����� ������� � ���������.
������ ������� ��-�� mutating �� ������� �����,
����� ��������� ������ ������ ������,
� ��������� ����� ������ � ������ ����� � ���������.
��� ������������: ��� ��������� ������ ������������ ���������,
�� ����� ����� ��������� �������� ����������
������� ��������� ����� ���� � �������.
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










