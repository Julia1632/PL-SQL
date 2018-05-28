create or replace
PROCEDURE FindCourse_T_sale_ADD_1
IS
type WEAK_RCTY
IS
  ref
  CURSOR;
    c_weak_rcty weak_rcty;
  type DEPTRECTYP
IS
  RECORD
  (
    ID_WARE T_SUPPLY_STR.ID_WARE%type,
    DT_BEG T_REST_HIST.DT_BEG%type,
    DT_END T_REST_HIST.DT_END%type,
    QTY T_REST_HIST.QTY%type,
    FLAG NUMBER (1),
    NEXT_DT_BEG T_REST_HIST.DT_END%type,
    PREVIOUS_DT_END T_REST_HIST.DT_END%type);
  dept_rec DeptRecTyp;
BEGIN
  open C_WEAK_RCTY for 
  
  
 select * from
       (select ID_WARE,
         DT_BEG,
         DT_END,
         QTY,
         FLAG,
         LEAD (DT_BEG) over (partition BY ID_WARE order by DT_BEG) NEXT_DT_BEG,
         LAG (DT_END) over (partition BY ID_WARE order by DT_BEG) PREVIOUS_DT_END
         from
             (
             select T.*, (select COUNT(*) from T_SALE_STR where ID_SALE=1111 and T.DT_BEG=TO_DATE('22.05.18','dd.mm.yy') and T_SALE_STR.ID_WARE = T.ID_WARE) FLAG from T_REST_HIST T
        ORDER BY 1,2
             )
        ) 
        WHERE flag = 1 ;
 
  LOOP
    FETCH C_WEAK_RCTY INTO DEPT_REC;
    EXIT
  WHEN C_WEAK_RCTY%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('1445'||DEPT_REC.ID_WARE);
    IF DEPT_REC.NEXT_DT_BEG IS NULL AND DEPT_REC.PREVIOUS_DT_END IS NOT NULL --?????????? ? ?????
      then
      DBMS_OUTPUT.PUT_LINE('null NOT null'||DEPT_REC.ID_WARE);
    update T_REST_HIST
          SET DT_END  =NULL
          where DT_END=DEPT_REC.PREVIOUS_DT_END
          AND ID_WARE = DEPT_REC.ID_WARE;
    
    delete from T_REST_HIST
      WHERE DT_BEG=DEPT_REC.DT_BEG
      AND ID_WARE   = DEPT_REC.ID_WARE;--+
    ELSE
      
        IF DEPT_REC.NEXT_DT_BEG IS NOT NULL AND DEPT_REC.PREVIOUS_DT_END IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('nn nn'||DEPT_REC.ID_WARE);
          
          UPDATE T_REST_HIST
          SET DT_END  =DEPT_REC.NEXT_DT_BEG-1
          WHERE DT_end=DEPT_REC.PREVIOUS_DT_END
          AND ID_WARE = DEPT_REC.ID_WARE;
          
          update T_REST_HIST
          SET QTY=QTY+DEPT_REC.QTY
          WHERE DT_BEG>=DEPT_REC.NEXT_DT_BEG
          AND ID_WARE  = DEPT_REC.ID_WARE;
          
          delete from T_REST_HIST
           where DT_BEG=DEPT_REC.DT_BEG
           AND ID_WARE   = DEPT_REC.ID_WARE;--+  
            
        END IF;
      END IF;
   
  END LOOP;
  CLOSE C_WEAK_RCTY;
end;
/