select * from
(SELECT LPAD(' ',(level-1)*3,' ')
    || T.ID_CTL_NODE id ,
    T.ID_CTL_NODE,
    T.ID_PARENT,
    code,
    T.TREE_CODE,
    T.name
  FROM T_CTL_NODE T
    start with T.ID_PARENT      is null
    connect by prior ID_CTL_NODE = ID_PARENT) Z1,
    (SELECT id_node,
   COUNT( distinct M.ID_MODEL) over (partition by ID_NODE) COUNT_MODEL,
  COUNT( DISTINCT w.id_ware) over (partition BY id_node) count_ware
FROM T_CTL_NODE N
LEFT JOIN t_model m
ON N.ID_CTL_NODE=M.ID_NODE
left join T_WARE W
on M.ID_MODEL=W.ID_MODEL) Z2
where Z1.ID_CTL_NODE=Z2.ID_NODE
    ;