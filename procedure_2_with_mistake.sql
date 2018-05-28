-- процедура проверена ++
CREATE OR REPLACE
PROCEDURE FindCourse_del
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
    PREVIOUS_DT_END T_REST_HIST.DT_END%type,
    qty_ss T_REST_HIST.QTY%type);
  dept_rec DeptRecTyp;
  N NUMBER;
  f DATE;
  m NUMBER;
BEGIN
  OPEN C_WEAK_RCTY FOR SELECT * FROM
  (SELECT ID_WARE,
    DT_BEG,
    DT_END,
    QTY,
    FLAG,
    LEAD (DT_BEG) over (partition BY ID_WARE order by DT_BEG) NEXT_DT_BEG,
    LAG (DT_END) over (partition BY ID_WARE order by DT_BEG) PREVIOUS_DT_END,
    qty_ss
  FROM
    (SELECT RH.*,
      (SELECT COUNT (*)
      FROM
        (SELECT ID_WARE,
          TO_DATE ('18.05.2018','dd.mm.yyyy') DT_BEG
        FROM T_SUPPLY_STR
        WHERE ID_SUPPLY=1111
        )
    WHERE dt_beg=RH.DT_BEG
    AND id_ware =RH.ID_WARE
      ) flag,
      NVL(
      (SELECT qty
      FROM
        (SELECT ID_WARE,
          TO_DATE ('18.05.2018','dd.mm.yyyy') DT_BEG,
          qty
        FROM T_SUPPLY_STR
        WHERE ID_SUPPLY=1111
        )
      WHERE dt_beg=RH.DT_BEG
      AND id_ware =RH.ID_WARE
      ),0) qty_ss
    FROM T_REST_HIST RH
    ORDER BY 1,2
    )
  ) WHERE flag = 1 ;
  LOOP
    FETCH C_WEAK_RCTY INTO DEPT_REC;
    EXIT
  WHEN C_WEAK_RCTY%NOTFOUND;
    m:=DEPT_REC.QTY_SS;
    DBMS_OUTPUT.PUT_LINE('1445'||dept_rec.id_ware);
    IF DEPT_REC.NEXT_DT_BEG IS NULL AND DEPT_REC.PREVIOUS_DT_END IS NULL --
      THEN
      DBMS_OUTPUT.PUT_LINE('null null'||DEPT_REC.ID_WARE);
      DELETE
      FROM t_rest_hist
      WHERE id_ware=dept_rec.id_ware
      AND DT_BEG   =DEPT_REC.DT_BEG;
    END IF;
    IF DEPT_REC.NEXT_DT_BEG IS NOT NULL AND DEPT_REC.PREVIOUS_DT_END IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('nn n'||DEPT_REC.ID_WARE);
      DELETE
      FROM T_ResT_HIST
      WHERE ID_WARE=DEPT_REC.ID_WARE
      AND DT_BEG   =DEPT_rec.DT_BEG;
      UPDATE T_REST_HIST
      SET QTY      =QTY-DEPT_REC.QTY_SS
      WHERE dt_beg>=DEPT_REC.NEXT_DT_BEG;
    END IF;
    IF DEPT_REC.NEXT_DT_BEG IS NOT NULL AND DEPT_REC.PREVIOUS_DT_END IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('nn nn'||dept_rec.id_ware);
      UPDATE T_REST_HIST
      SET DT_END  =DEPT_REC.DT_end
      WHERE DT_end=DEPT_REC.PREVIOUS_DT_END
      AND ID_WARE = DEPT_REC.ID_WARE;
      DBMS_OUTPUT.PUT_LINE('nn nn'||DEPT_REC.qty_ss);
      merge INTO T_REST_HIST P1 USING
      (SELECT ID_WARE,
        DT_BEG,
        DT_END,
        QTY-m+m qty
      FROM T_REST_HIST
      WHERE DT_BEG       >DEPT_REC.DT_BEG
      AND id_ware        = DEPT_REC.ID_WARE
      ) P2 ON (P2.ID_WARE=P1.ID_WARE AND p1.DT_BEG=p2.DT_BEG)
    WHEN matched THEN
      UPDATE SET P1.QTY=P2.QTY;
      --  select id_ware,dt_beg,dt_end,qty- from T_REST_HIST
      UPDATE T_REST_HIST T-- ошибка удаляет два раза из количесва начиная со второй строки
      SET T.QTY   =QTY-DEPT_REC.QTY_SS
      WHERE DT_BEG=DEPT_REC.NEXT_DT_BEG
      AND ID_WARE = DEPT_REC.ID_WARE;
      DBMS_OUTPUT.PUT_LINE('nn nn'||DEPT_REC.qty_ss);
      DELETE
      FROM T_REST_HIST
      WHERE DT_BEG=DEPT_REC.DT_BEG
      AND ID_WARE = DEPT_REC.ID_WARE;
    END IF;
    IF DEPT_REC.NEXT_DT_BEG IS NULL AND DEPT_REC.PREVIOUS_DT_END IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('n nn'||dept_rec.id_ware);
      DELETE
      FROM T_REST_HIST
      WHERE ID_WARE=DEPT_REC.ID_WARE
      AND DT_BEG   =DEPT_REC.DT_BEG;
      UPDATE T_REST_HISt
      SET DT_END  = NULL
      WHERE DT_END=dept_rec.previous_dt_end
      AND ID_WARE =DEPT_REC.ID_WARE;
    END IF;
  END LOOP;
  CLOSE C_WEAK_RCTY;
END;
/ 