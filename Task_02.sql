create or replace trigger t_control_max_discount
before insert or update on t_sale
for each row
declare
m_is_vip t_client.is_vip%type;
begin
select is_vip into m_is_vip 
from t_client 
where id_client=:new.id_client;

if m_is_vip=0 and :new.discount>20
then
raise_application_error(-20004,'Error: invalid discount');
end if;

end t_control_max_discount;
/

