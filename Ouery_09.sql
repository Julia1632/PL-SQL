/*query-09
������ ����� � �������� �� ��������������, 
��� ������� ������������� � ������ � ����� 
�������� �����������.� ������ � 
����� ������, ����� �����, ����������, 
����� �����. ��������. �
�� ������ ������� ������, ������� �� ��� ������� ������������� 
������� ��� �����������.*/
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


select  distinct d1_id, d2_id,sum(sum) over (partition by d1_id), count(id_sale) over (partition by d1_id)  from
(SELECT *
FROM
  (SELECT D1.ID_DEPT D1_ID,
    D2.ID_DEPT D2_ID
  FROM T_DEPT D1
  cross join T_DEPT D2
  ) WHeRE D2_ID IN
  (SELECT Z.ID_DEPT
  from T_DEPT Z
    START WITH Z.ID_PARENT    =D1_ID
    CONNECT BY prior z.id_dept=z.id_parent
  ) 
  union all

select ID_DEPT, ID_DEPT from T_DEPT) Z1,
(select * from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT) Z2
where D2_ID=Z2.ID_DEPT
order by 1,2
;
    
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    SELECT *
FROM
  (SELECT D1.ID_DEPT D1_ID,
    D2.ID_DEPT D2_ID
  FROM T_DEPT D1
  cross join T_DEPT D2
  ) WHeRE D2_ID IN
  (SELECT Z.ID_DEPT
  from T_DEPT Z
    START WITH Z.ID_PARENT    =D1_ID
    CONNECT BY prior z.id_dept=z.id_parent
  ) 
  union all

select ID_DEPT, ID_DEPT from T_DEPT
order by 1,2;



select * from T_CLIENT C join T_SALE S on C.ID_CLIENT=S.ID_CLIENT
order by 2;