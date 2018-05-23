/*query-09
Выдать отчет о продажах по подразделениям, 
для каждого подразделения в дереве в отчет 
включать подчиненные.В отчете — 
число продаж, число строк, количество, 
общая сумма. Указание. Д
ля начала сделать запрос, который бы для каждого подразделения 
выводил все подчиненные.*/
-- без  число строк, количество, 

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
    
 