create or replace trigger ADD_TREE_CODE
before insert on T_CTL_NODE
for each row
declare
m_code t_ctl_node.tree_code%type;
begin
select tree_code  into m_code from (
select reverse(C) tree_code, max(L) over (partition by 0) m,l
from(
select SYS_CONNECT_BY_PATH(ID_Ctl_NODE,'.') c, length( SYS_CONNECT_BY_PATH(ID_Ctl_NODE,'|')) l
from T_CTL_NODE
start with ID_CTL_NODE=:new.id_parent
connect by  ID_CTL_NODE= prior ID_PARENT))
where m=l;

:new.tree_code:=m_code||:new.id_ctl_node;

end;
/
