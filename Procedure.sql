create or replace procedure 
CHANGE_PARENT_FOR_T_NODE (p_id_node t_ctl_node.id_ctl_node%type, p_new_id_parent t_ctl_node.id_parent%type)
as 
m_tree_code T_CTL_NODE.TREE_CODE%type;
begin

update T_CTL_NODE
set ID_PARENT=P_NEW_ID_PARENT
where ID_CTL_NODE=P_ID_NODE;

select tree_code  into m_tree_code from (
select reverse(C) tree_code, max(L) over (partition by 0) m,l
from(
select SYS_CONNECT_BY_PATH(ID_Ctl_NODE,'.') c, length( SYS_CONNECT_BY_PATH(ID_Ctl_NODE,'|')) l
from T_CTL_NODE
start with ID_CTL_NODE=p_id_node
connect by  ID_CTL_NODE= prior ID_PARENT))
where M=L;

update T_CTL_NODE
set tree_code=m_tree_code
where ID_CTL_NODE=P_ID_NODE;

end;
/


begin
CHANGE_PARENT_FOR_T_NODE(5,7);
end;
/

