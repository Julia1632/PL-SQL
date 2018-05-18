insert into t_supplier values (1001,'Supplier_1','Supplier_1');

insert into t_supply(id_supply,code,num,dt,id_supplier,e_state)
select 2001,'code1','num1',to_date('07.05.18','dd.mm.yy'),1001,'new'
from dual
union all
select 2002,'code2','num2',to_date('08.05.18','dd.mm.yy'),1001,'done'
from dual;

insert into t_ctl_node values (3001,null,'Code1','3001','Name1');

insert into t_model(id_model,moniker,name,id_node) 
values (4001,'Model_1','Mode_1',3001);

insert into t_ware(id_ware,moniker,name) 
values (5001,'Ware_1','Ware_1');

insert into t_supply_str (id_supply_str,id_supply ,id_ware) 
select 6001,2001,5001 
from dual
union all
select 6002,2001,5001 
from dual
union all
select 6003,2002,5001 
from dual
union all
select 6004,2002,5001
from dual;