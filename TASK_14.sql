create or replace 
trigger T_HISTORY_REST_ADD after
  insert on T_SUPPLY_STR for each row declare M_DT T_SUPPLY.DT%type;
  flag number(1);
  BEGIN
  
  select dt into m_dt from t_supply where id_supply=:new.id_supply;
  
  
    merge INTO T_REST P1 USING
    ( SELECT :new.ID_WARE id , :new.QTY Q FROM DUAL
    )
    P2 ON (P2.id=P1.ID_WARE)
  WHEN matched THEN
    UPDATE SET P1.QTY=P1.QTY+Q WHEN NOT matched THEN
    INSERT
      (
        ID_WARE,
        QTY
      )
      VALUES
      (
        :new.ID_WARE,
        :new.QTY
      );
    
    select COUNT(distinct ID_WARE) into FLAG  from T_REST_HIST
    where id_ware=:new.id_ware;
    if FLAG>0
    then
    
    update T_REST_HIST
    set DT_END=m_Dt-1
    where ID_WARE=:new.ID_WARE and DT_END is null;
    end if;
    
    INSERT into t_rest_hist (ID_WARE,DT_BEG,QTY
      ) values
      (:new.ID_WARE,M_DT,:new.QTY);
    
  END T_HISTORY_REST_ADD;


/

/*

select * from t_rest;