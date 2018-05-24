create or replace trigger T_N_ADD_REST after
  UPDATE OF E_STATE ON T_SUPPLY FOR EACH row  ;
  BEGIN
    IF :old.E_STATE='new' AND :new.E_STATE='done' THEN
      insert into T_REST_HIST
        (ID_WARE,DT_BEG,qty
        )
      select ID_WARE,
        :new.DT,qty
      FROM T_SUPPLY_STR
      WHERE ID_SUPPLY=:new.ID_SUPPLY
      AND id_ware   IN
        (SELECT id_ware FROM t_supply_str WHERE id_supply=:new.id_supply
        MINUS
        SELECT id_ware FROM t_rest_hist
        );
      NULL;
    END IF;
    
   /*  C3 cursor
    is select * from dual;
    */
  END T_N_ADD_REST;
  /
 
 select * from(
SELECT ID_WARE,
  DT_BEG,
  DT_END,
  QTY,
  FLAG,
  LEAD (DT_BEG) over (partition by ID_WARE order by DT_BEG) NEXT_DT_BEG,
  LEAD (QTY) over (partition by ID_WARE order by DT_BEG) NEXT_QTY,
  LAG (DT_END) over (partition by ID_WARE order by DT_BEG) PREVIOUS_DT_END,
  Lag (QTY) over (partition by ID_WARE order by DT_BEG) previous_qty
FROM
  (select ID_WARE,
  null DT_BEG,--DT_BEG, from :new
  null DT_END,QTY, 1 FLAG from T_SUPPLY_STR
  union all
  SELECT ID_WARE,
    DT_BEG,
    DT_END,
    QTY,
    0 flag
  FROM T_REST_HIST
  order by 1,2
  ))
  where flag = 1
 ;
 
 
 CREATE OR REPLACE procedure FindCourse
  
is
type WEAK_RCTY is ref cursor;
   c_weak_rcty weak_rcty;
   type DEPTRECTYP is RECORD (
      ID_WARE T_SUPPLY_STR.ID_WARE%type,
  DT_BEG T_REST_HIST.DT_BEG%type,
  DT_END T_REST_HIST.DT_END%type,
  QTY T_REST_HIST.QTY%type,
  FLAG number (1),
  NEXT_DT_BEG T_REST_HIST.DT_END%type,
  NEXT_QTY T_REST_HIST.QTY%type,
  PREVIOUS_DT_END T_REST_HIST.DT_END%type,
   previous_qty T_REST_HIST.QTY%type);
   dept_rec DeptRecTyp;

begin
  open C_WEAK_RCTY for select * from(
SELECT ID_WARE,
  DT_BEG,
  DT_END,
  QTY,
  FLAG,
  LEAD (DT_BEG) over (partition by ID_WARE order by DT_BEG) NEXT_DT_BEG,
  LEAD (QTY) over (partition by ID_WARE order by DT_BEG) NEXT_QTY,
  LAG (DT_END) over (partition by ID_WARE order by DT_BEG) PREVIOUS_DT_END,
  Lag (QTY) over (partition by ID_WARE order by DT_BEG) previous_qty
FROM
  (select ID_WARE,
  null DT_BEG,--DT_BEG, from :new
  null DT_END,QTY, 1 FLAG from T_SUPPLY_STR
  union all
  SELECT ID_WARE,
    DT_BEG,
    DT_END,
    QTY,
    0 flag
  FROM T_REST_HIST
  order by 1,2
  ))
  where flag = 1
 ;
 
 
 LOOP
      FETCH C_WEAK_RCTY into DEPT_REC;
      EXIT when C_WEAK_RCTY%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE('1445'||dept_rec.id_ware);
     
     if DEPT_REC.NEXT_DT_BEG is null and DEPT_REC.PREVIOUS_DT_END is null --добавление в начало
     then 
     insert into T_REST_HIST(ID_WARE,DT_BEG, QTY)
     values (DEPT_REC.ID_WARE, DEPT_REC.DT_BEG, DEPT_REC.PREVIOUS_QTY+DEPT_REC.QTY);
     update T_REST_HIST
     set DT_END=DEPT_REC.DT_BEG-1
     where DT_END is null and ID_WARE= DEPT_REC.ID_WARE;
    else if  DEPT_REC.NEXT_DT_BEG is not null and DEPT_REC.PREVIOUS_DT_END is null
    then
    
    insert into T_REST_HIST(ID_WARE,DT_BEG,DT_END, QTY)
     values (DEPT_REC.ID_WARE, DEPT_REC.DT_BEG,DEPT_REC.NEXT_DT_BEG-1, DEPT_REC.QTY);
     update T_REST_HIST
     set QTY=QTY+DEPT_REC.QTY
     where DT_BEG>=DEPT_REC.NEXT_DT_BEG and ID_WARE= DEPT_REC.ID_WARE;
     
     else if  DEPT_REC.NEXT_DT_BEG is not null and DEPT_REC.PREVIOUS_DT_END is not null
     then
     
     
     insert into T_REST_HIST(ID_WARE,DT_BEG,DT_END, QTY)
     values (DEPT_REC.ID_WARE, DEPT_REC.DT_BEG, DEPT_REC.PREVIOUS_dt_end, DEPT_REC.PREVIOUS_QTY+DEPT_REC.QTY);
     
     update T_REST_HIST
     set DT_END=DEPT_REC.DT_beg
     where DT_end=DEPT_REC.PREVIOUS_DT_END and ID_WARE= DEPT_REC.ID_WARE;
     
      update T_REST_HIST
     set QTY=QTY+DEPT_REC.QTY
     where DT_BEG>=DEPT_REC.NEXT_DT_BEG and ID_WARE= DEPT_REC.ID_WARE; 
     
     null;
     end if;
     
     null;
    end if;
     end if;
     
     
     
   END LOOP;
 
 
  close C_WEAK_RCTY;

end;
/
 
