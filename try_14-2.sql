
 WHERE SS.ID_SUPPLY=:new.ID_SUPPLY
  AND ID_WARE      IN
    (SELECT ID_WARE FROM T_REST
    MINUS
    select ID_WARE from T_SUPPLY_STR SS where SS.ID_SUPPLY=:new.ID_SUPPLY
    ))
    
    
    
      
select  case when dt_end is null then 1 else 0 end into flag from t_rest_hist where ID_SUPPLY=:new.id_supply and dt_beg=:new_dt;
   merge
  into T_REST_hist P1 using
    ( SELECT id_ware, qty  FROM T_SUPPLY_STR  WHERE ID_SUPPLY=:new.id_supply
    ) P2 on (P2.ID_WARE=P1.ID_WARE) when matched then
  
 
  update set P1.QTY=P1.QTY+P2.QTY when not matched then
  INSERT 
    ( ID_WARE, QTY
    )
    values (P2.ID_WARE,P2.QTY)
  ;
  
 -------- 
CREATE OR REPLACE TRIGGER T_N_ADD_REST AFTER
  UPDATE OF E_STATE ON T_SUPPLY FOR EACH row DECLARE flag NUMBER;
  begin
    if :old.E_STATE='new' and :new.E_STATE='done' then
    merge into T_REST_HIST P1 using
    ( SELECT id_ware, qty, :new.dt as dt_n FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply
    ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    
    when matched then
    update set DT_END=DT_N-1;
  --���-�� ��������� ��������� ����� ���������� ���������
  insert into T_REST_HIST(ID_WARE,DT_BEG)
   SELECT id_ware,:new.dt as dt_n FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply;
    end if;
    
    if :new.E_STATE='new' and :old.E_STATE='done' then
      merge INTO T_REST_hist P1 USING
      (SELECT id_ware,
        QTY,
        :new.dt as DT_N
      FROM T_SUPPLY_STR
      WHERE ID_SUPPLY    =:new.id_supply
      ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    WHEN matched THEN
      UPDATE
      SET DT_END=
        (SELECT DT_END FROM T_REST_HIST WHERE ID_WARE=P1.ID_WARE AND DT_N=DT_BEG
        )
        where dt_end=dt_n
      delete where DT_BEG=DT_N ;
      END IF;
END T_N_ADD_REST;
/ 

















 WHERE SS.ID_SUPPLY=:new.ID_SUPPLY
  AND ID_WARE      IN
    (SELECT ID_WARE FROM T_REST
    MINUS
    select ID_WARE from T_SUPPLY_STR SS where SS.ID_SUPPLY=:new.ID_SUPPLY
    ))
    
    
    
      
select  case when dt_end is null then 1 else 0 end into flag from t_rest_hist where ID_SUPPLY=:new.id_supply and dt_beg=:new_dt;
   merge
  into T_REST_hist P1 using
    ( SELECT id_ware, qty  FROM T_SUPPLY_STR  WHERE ID_SUPPLY=:new.id_supply
    ) P2 on (P2.ID_WARE=P1.ID_WARE) when matched then
  
 
  update set P1.QTY=P1.QTY+P2.QTY when not matched then
  INSERT 
    ( ID_WARE, QTY
    )
    values (P2.ID_WARE,P2.QTY)
  ;
  
 -------- 
CREATE OR REPLACE TRIGGER T_N_ADD_REST AFTER
  UPDATE OF E_STATE ON T_SUPPLY FOR EACH row DECLARE flag NUMBER;
  begin
    if :old.E_STATE='new' and :new.E_STATE='done' then
    merge into T_REST_HIST P1 using
    ( SELECT id_ware, qty, :new.dt as dt_n FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply
    ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    
    when matched then
    update set DT_END=DT_N-1;
  
  
    insert into T_REST_HIST(ID_WARE,DT_BEG)
   SELECT id_ware,:new.dt as dt_n FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply;
    end if;
    
  /*
  
    if :new.E_STATE='new' and :old.E_STATE='done' then
      merge INTO T_REST_hist P1 USING
      (SELECT id_ware,
        QTY,
        :new.dt as DT_N
      FROM T_SUPPLY_STR
      WHERE ID_SUPPLY    =:new.id_supply
      ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    WHEN matched THEN
      UPDATE
      SET DT_END=
        (SELECT DT_END FROM T_REST_HIST WHERE ID_WARE=P1.ID_WARE AND DT_N=DT_BEG
        )
        where dt_end=dt_n
      delete where DT_BEG=DT_N ;
      END IF;*/
END T_N_ADD_REST;
/ 