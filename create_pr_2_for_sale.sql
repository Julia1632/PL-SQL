create or replace
PROCEDURE FindCourse_T_sale_delele_1
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
    NEXT_QTY T_REST_HIST.QTY%type,
    PREVIOUS_DT_END T_REST_HIST.DT_END%type,
    previous_qty T_REST_HIST.QTY%type);
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
         LEAD (QTY) over (partition BY ID_WARE order by DT_BEG) NEXT_QTY,
         LAG (DT_END) over (partition BY ID_WARE order by DT_BEG) PREVIOUS_DT_END,
         Lag (QTY) over (partition BY ID_WARE order by DT_BEG) previous_qty
         from
             (
             SELECT ID_WARE,
             --null
             to_date('22.05.2018','dd.mm.yyyy') DT_BEG,--DT_BEG, from :new
             NULL DT_END,
             QTY,
             1 FLAG
             from T_SALE_STR
             WHERE ID_sale=1111
             union all
             select ID_WARE, 
             DT_BEG, 
             DT_END, 
             QTY, 
             0 flag
             from T_REST_HIST 
             order by 1,2
             )
        ) 
        WHERE flag = 1 ;
 
  LOOP
    FETCH C_WEAK_RCTY INTO DEPT_REC;
    EXIT
  WHEN C_WEAK_RCTY%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('1445'||dept_rec.id_ware);
    IF DEPT_REC.NEXT_DT_BEG IS NULL AND DEPT_REC.PREVIOUS_DT_END IS NULL --?????????? ? ?????
      THEN
      DBMS_OUTPUT.PUT_LINE('null null'||dept_rec.id_ware);
      INSERT
      INTO T_REST_HIST
        (
          ID_WARE,
          DT_BEG,
          QTY
        )
        VALUES
        (
          DEPT_REC.ID_WARE,
          DEPT_REC.DT_BEG,
          DEPT_REC.PREVIOUS_QTY-DEPT_REC.QTY
        );--+
      UPDATE T_REST_HIST
      SET DT_END    =DEPT_REC.DT_BEG-1
      WHERE DT_END IS NULL
      AND ID_WARE   = DEPT_REC.ID_WARE
      AND DT_BEG    <DEPT_REC.dt_beg;--+
    ELSE
      if DEPT_REC.NEXT_DT_BEG is not null and DEPT_REC.PREVIOUS_DT_END is null then
        DBMS_OUTPUT.PUT_LINE('nn n empty'||DEPT_REC.ID_WARE);
        RAISE_APPLICATION_ERROR(-20008, 'Error: empty');
    
      ELSE
        IF DEPT_REC.NEXT_DT_BEG IS NOT NULL AND DEPT_REC.PREVIOUS_DT_END IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('nn nn'||DEPT_REC.ID_WARE);
          if DEPT_REC.PREVIOUS_QTY<DEPT_REC.QTY
          then 
          RAISE_APPLICATION_ERROR(-20009, 'Error: QTY not enough');
          else
          UPDATE T_REST_HIST
          SET DT_END  =DEPT_REC.DT_beg-1
          WHERE DT_end=DEPT_REC.PREVIOUS_DT_END
          AND ID_WARE = DEPT_REC.ID_WARE;
          
          update T_REST_HIST
          SET QTY      =QTY-DEPT_REC.QTY
          WHERE DT_BEG>=DEPT_REC.NEXT_DT_BEG
          AND ID_WARE  = DEPT_REC.ID_WARE;
          
          INSERT
          INTO T_REST_HIST
            (
              ID_WARE,
              DT_BEG,
              DT_END,
              QTY
            )
            VALUES
            (
              DEPT_REC.ID_WARE,
              DEPT_REC.DT_BEG,
              DEPT_REC.NEXT_DT_BEG -1,
              DEPT_REC.PREVIOUS_QTY-DEPT_REC.QTY
            );
            end if;
        END IF;
      END IF;
    END IF;
  END LOOP;
  CLOSE C_WEAK_RCTY;
END;
/