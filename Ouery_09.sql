/*query-09
Выдать отчет о продажах по подразделениям, 
для каждого подразделения в дереве в отчет 
включать подчиненные.В отчете — 
число продаж, число строк, количество, 
общая сумма. Указание. Д
ля начала сделать запрос, который бы для каждого подразделения 
выводил все подчиненные.*/
SELECT D1.ID_PARENT,D1.ID_DEPT FROM T_DEPT D1
UNION
SELECT ID_DEPT,
  NULL
FROM t_dept
WHERE id_dept IN
  (SELECT id_dept FROM T_DEPT
  MINUS
  SELECT id_parent FROM t_dept
  );

select * from T_DEPT;



select z2.id_parent id_dept,Z2.id_dept id_parent ,  z1.sum
  fROM
  (SELECT * FROM T_CLIENT C JOIN T_SALE S ON C.ID_CLIENT=S.ID_CLIENT
  )z1 ,
  (SELECT D1.ID_PARENT,D1.ID_DEPT FROM T_DEPT D1
  UNION
  SELECT ID_DEPT,
    NULL
  FROM t_dept
  WHERE id_dept IN
    (SELECT id_dept FROM T_DEPT
    MINUS
    SELECT ID_PARENT FROM T_DEPT
    )
  )Z2
WHERE z1.id_dept(+)=z2.id_dept ;


select distinct  LPAD(' ',(level-1)*3,' ') 

    || T.ID_dept id , T.ID_DEPT,

    T.ID_PARENT,

 

    T.name,z1.sum, z1.sum

    from T_DEPT T,(select * from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT)Z1
    where T.ID_DEPT=z1.id_dept(+)

    start with T.ID_dept in (SELECT id_dept FROM T_DEPT
    minus
    SELECT ID_PARENT FROM T_DEPT)

    CONNECT BY t.ID_dept =  prior t.ID_PARENT; 
    
    
WITH R(ID_DEPT,ID_PARENT,C) AS
  (SELECT ID_DEPT,
    ID_PARENT,
    SUM
  FROM
    (SELECT D.ID_DEPT,
      D.ID_PARENT,
      Z1.SUM
    FROM T_DEPT D
    JOIN
      (SELECT * FROM T_CLIENT C JOIN T_SALE S ON C.ID_CLIENT=S.ID_CLIENT
      )Z1 ON D.ID_DEPT=Z1.ID_DEPT
    )
  WHERE id_dept IN
    (SELECT id_dept FROM T_DEPT
    MINUS
    SELECT ID_PARENT FROM T_DEPT
    ) UNIAON ALL
  SELECT id_dept,
    id_parent,
    SUM
  FROM r
  JOIN
    (SELECT D.ID_DEPT,
      D.ID_PARENT,
      Z1.SUM
    FROM T_DEPT D
    JOIN
      (SELECT * FROM T_CLIENT C JOIN T_SALE S ON C
      ) ;
    SELECT d.id_dept,
      d.id_parent,
      z1.sum
    FROM t_dept d
    JOIN
      (SELECT * FROM T_CLIENT C JOIN T_SALE S ON C.ID_CLIENT=S.ID_CLIENT
      )Z1 ON d.id_dept=z1.id_dept; 
    
       with R(ID_DEPT,ID_PARENT,C)
    as (select ID_DEPT,ID_PARENT, ID_DEPT||id_parent  from t_dept
    
    union all
    select D.ID_DEPT,D.ID_PARENT, c||d.id_parent c from R,T_DEPT D 
    where d.id_dept=R.id_parent
    )
    select * from r;
    
    
    
     WITH R(ID_DEPT,ID_childer ,C, s) AS
  (
  select D.ID_DEPT ,
    null,
    TO_CHAR(D.ID_DEPT) C, z1.sum
  from T_DEPT D,(select * from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT)Z1
  WHERE d.id_dept in (select id_dept from t_dept minus (select id_parent from t_dept)) and z1.id_dept=d.id_dept
 
  UNION ALL
 
  SELECT D.id_parent, r.id_dept,
    C||D.ID_PARENT C
    , z1.sum
  from T_DEPT D,
    R,(select * from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT)Z1
  WHERE d.id_dept=R.id_dept and z1.id_dept=d.id_parent
  )
select * from R; 


select ID_DEPT, SUM(SUM)  from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT;



(select D.ID_DEPT
from t_dept d)


(;
select D2.ID_DEPT
from t_dept d2
start with D2.IDselect D2.ID_DEPT
from t_dept d2
start with D2.ID_PARENT is null
connect by prior D2.ID_DEPT=D2.ID_PARENT;
_PARENT
connect by prior d2.ID_DEPT=d2.ID_PARENT;


) from t_dept d




select ID_DEPT,ID_PARENT from  T_DEPT D2
connect by prior D2.ID_DEPT=D2.ID_PARENT;



with R(ID_DEPT, ID_PARENT)
as (select ID_DEPT,ID_PARENT from T_DEPT
union all
select ID_DEPT,ID_PARENT from T_DEPT,R
start with R._ID_DEPT
connect by r.id_dept=id_parent)
select * from r;



with pairs as
(
    select ID_DEPT as a, ID_DEPT as b from T_DEPT

    UNION ALL

    select pairs.a as a, T_DEPT.id as b
    from T_DEPT, PAIRS
    where T_DEPT.id_parent = pairs.b
)
select *
from T_DEPT, PAIRS
where pairs.a = 1 and pairs.b = T_DEPT.id_dept
