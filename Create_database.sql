create table t_supplier 
(id_supplier number(9) primary key,
moniker varchar2(50) unique not null,
name varchar2(100));

create table t_supply
(id_supply number(9) primary key,
code varchar2(30) not null,
dt date not null,
id_supplier number not null,
constraint f_id_supplier foreign key (id_supplier) references t_supplier(id_supplier),
e_state varchar2(4),
constraint e_e_state check (e_state in ('new','done')),
sum number(14,2),
nds number(14,2));


create table t_dept 
(id_dept number(9) primary key,
name varchar2(50) unique not null,
id_parent number(9),
constraint f_id_parent foreign key (id_parent) references  t_dept(id_dept)) ;


create table t_client 
(id_client number(9) primary key,
id_dept number(9),
constraint f_id_dept foreign key (id_dept) references  t_dept(id_dept),
moniker varchar2(50) unique not null,
name varchar2(100),
is_vip  number(1) not null,
constraint e_is_vip check (is_vip in (0,1)),
town varchar2(100)
) ;


create table t_sale
(id_sale number(9) primary key,
num varchar2(30) not null,
dt date not null,
id_client number not null,
constraint f_id_client foreign key (id_client) references t_client(id_client),
e_state varchar2(4),
constraint e_e_state_tsale check (e_state in ('new','done')),
discount number (8,6) not null,
sum number(14,2),
nds number(14,2));


create table t_ctl_node
(id_ctl_node number(9) primary key,
id_parent number(9),
constraint f_id_parent_node foreign key (id_parent) references  t_ctl_node(id_ctl_node),
code varchar2(30) not null,
tree_code varchar2(240) not null,
name varchar2(50) unique not null) ;

create table t_model
(id_model number(9) primary key,
moniker varchar2(12) unique not null,
name varchar2(50) unique not null,
id_node  number(9),
constraint f_id_node foreign key (id_node) references  t_ctl_node(id_ctl_node),
grp varchar2(50),
sudgrp varchar2(50),
label varchar2(50),
price number(8,2));

create table t_price_model
(id_model number(9),
constraint f_id_model foreign key (id_model) references  t_model(id_model),
dt_beg date,
dt_end date,
price number(8,2));


create table t_ware
(id_ware number(9) primary key,
moniker varchar2(12) unique not null,
name varchar2(50),
id_model number(9) ,
constraint f_id_model_ware foreign key (id_model) references  t_model(id_model),
sz_orig varchar2(30),
sz_ru varchar2(30),
price number(8,2));



create table t_supply_str
(id_supply_str number(9) primary key,
id_supply number(9),
constraint f_id_supply foreign key (id_supply) references t_supply(id_supply),
num number(6),
id_ware number not null,
constraint f_id_ware foreign key (id_ware) references t_ware(id_ware),
qty number(6),
price number(8,2),
sum number(14,2),
nds number(14,2));



create table t_sale_str
(id_sale_str number(9) primary key,
id_sale number(9),
constraint f_id_sale_str foreign key (id_sale)
references 
t_sale
(id_sale),
id_ware number not null,
constraint f_id_ware_sale_str foreign key (id_ware) references t_ware(id_ware),
qty number(6),
price number(8,2),
discount number(8,6),
disc_price number(8,2),
sum number(14,2),
nds number(14,2));


create table t_price_ware
(id_ware number(9),
constraint f_id_ware_orw foreign key (id_ware) references  t_ware(id_ware),
dt_beg date,
dt_end date,
price number(8,2));



create table t_sale_rep
(id_ware number(9),
constraint f_id_ware_sr foreign key (id_ware) references  t_ware(id_ware),
month date,
inp_qty number(16),
inp_sum number (16,2),
supply_qty number(16),
supply_sum number (16,2),
sale_qty number(16),
sale_sum number (16,2),
out_qty number(16),
out_sum number (16,2)
);



create table t_rest
(id_ware number(9),
constraint f_id_ware_r foreign key (id_ware) references  t_ware(id_ware),
qty number(6)
);

create table t_rest_hist
(id_ware number(9),
constraint f_id_ware_rh foreign key (id_ware) references  t_ware(id_ware),
dt_beg date,
dt_end date,
qty number(6));