  -- процедура проверена ++
  CREATE OR REPLACE procedure FindCourse_del
  
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

  PREVIOUS_DT_END T_REST_HIST.DT_END%type,
 qty_ss T_REST_HIST.QTY%type);
   dept_rec DeptRecTyp;

begin
  open C_WEAK_RCTY for SELECT *
FROM
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
  )
WHERE flag = 1 ;
 
 
 LOOP
      FETCH C_WEAK_RCTY into DEPT_REC;
      EXIT when C_WEAK_RCTY%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE('1445'||dept_rec.id_ware);
     
     if DEPT_REC.NEXT_DT_BEG is null and DEPT_REC.PREVIOUS_DT_END is null --
     then 
          DBMS_OUTPUT.PUT_LINE('null null'||dept_rec.id_ware);
     
     delete from t_rest_hist where id_ware=dept_rec.id_ware and dt_beg=dept_rec.dt_beg;
    
    
    else if  DEPT_REC.NEXT_DT_BEG is not null and DEPT_REC.PREVIOUS_DT_END is null
    then
    delete from T_ResT_HIST where ID_WARE=DEPT_REC.ID_WARE and DT_BEG=DEPT_rec.DT_BEG;
    
    update T_REST_HIST
    set QTY=QTY-DEPT_REC.QTY_SS
    where dt_beg>=DEPT_REC.NEXT_DT_BEG;
         DBMS_OUTPUT.PUT_LINE('nn n'||dept_rec.id_ware);
    
     
     else if  DEPT_REC.NEXT_DT_BEG is not null and DEPT_REC.PREVIOUS_DT_END is not null
     then
     DBMS_OUTPUT.PUT_LINE('nn nn'||dept_rec.id_ware);
     
    update T_REST_HIST
     set DT_END=DEPT_REC.DT_end
     where DT_end=DEPT_REC.PREVIOUS_DT_END and ID_WARE= DEPT_REC.ID_WARE;
     
     
      update T_REST_HIST-- ошибка удаляет два раза из количесва начиная со второй строки
      set QTY=QTY-DEPT_REC.QTY_SS
      where DT_BEG>DEPT_REC.DT_BEG and ID_WARE= DEPT_REC.ID_WARE; 
     
     
      delete from  T_REST_HIST
      where DT_BEG=DEPT_REC.DT_BEG and ID_WARE= DEPT_REC.ID_WARE; 
      
      
     
      else if  DEPT_REC.NEXT_DT_BEG is  null and DEPT_REC.PREVIOUS_DT_END is  not null
      then
      delete from T_REST_HIST where ID_WARE=DEPT_REC.ID_WARE and DT_BEG=DEPT_REC.DT_BEG;
      update T_REST_HISt
      set DT_END = null
      where DT_END=dept_rec.previous_dt_end and ID_WARE=DEPT_REC.ID_WARE;
      
      end if;
     
     end if;
    end if;
     end if;
     
     
     
   END LOOP;
 
 
  close C_WEAK_RCTY;

end;
/
 