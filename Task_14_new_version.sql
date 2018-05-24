CREATE OR REPLACE TRIGGER T_N_ADD_REST AFTER
  update of E_STATE on T_SUPPLY for each row begin 
  
  if :old.E_STATE='new' and :new.E_STATE='done'
  then
  merge
  into T_REST P1 using
    ( SELECT id_ware, qty FROM T_SUPPLY_STR  WHERE ID_SUPPLY=:new.id_supply
    ) P2 on (P2.ID_WARE=P1.ID_WARE) when matched then
  update set P1.QTY=P1.QTY+p2.QTY when not matched then
  INSERT 
    ( ID_WARE, QTY
    )
    values (p2.id_ware,p2.qty)
  ;
  
  end if;
  
  
  
   if :new.E_STATE='new' and :old.E_STATE='done'
  then
  merge
  into T_REST P1 using
    ( SELECT id_ware, qty FROM T_SUPPLY_STR  WHERE ID_SUPPLY=:new.id_supply
    ) P2 on (P2.ID_WARE=P1.ID_WARE) when matched then
  
  update set P1.QTY=P1.QTY-p2.qty;
  
  end if;
 END T_N_ADD_REST;
/ 


select * from t_rest;

delete from t_rest;