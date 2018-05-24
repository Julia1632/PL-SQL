--����� ������� ������������� � ��������� � ������������ � �������� ��������

SELECT Z1.id,z1.id_parent,code,tree_code,name, nvl(z2.c,0) as count_d_n
from
  (select LPAD(' ',(level-1)*3,' ') 
    || T.ID_CTL_NODE id ,T.ID_CTL_NODE,
    T.ID_PARENT,
    code,
    T.TREE_CODE,
    T.name
    FROM T_CTL_NODE T
    START WITH T.ID_PARENT      IS NULL
    CONNECT BY prior ID_CTL_NODE = ID_PARENT
  ) Z1,
  (SELECT distinct count (T.ID_PARENT) over (partition by id_parent) c,
    T.ID_PARENT
  from T_CTL_NODE T
  where id_parent is not null
    START WITH T.ID_PARENT      IS NULL
    connect by prior ID_CTL_NODE = ID_PARENT 
  ) Z2
  where z2.id_parent(+)=z1.id_ctl_node
;