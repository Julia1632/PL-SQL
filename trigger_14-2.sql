create or replace trigger T_N_del_REST after
  UPDATE OF E_STATE ON T_sale FOR EACH row DECLARE flag NUMBER;
  BEGIN
    IF :old.E_STATE='new' AND :new.E_STATE='done' THEN
      merge into T_REST P1 using
      ( SELECT id_ware, qty FROM T_Sale_str WHERE ID_Sale=:new.id_sale
      ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    when matched then
      update set P1.QTY=P1.QTY-P2.QTY ;
      end if;
      
    IF :new.E_STATE='new' AND :old.E_STATE='done' THEN
      merge into T_REST P1 using
     ( SELECT id_ware, qty FROM T_Sale_str WHERE ID_Sale=:new.id_sale
      ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    when matched then
      UPDATE SET P1.QTY=P1.QTY+p2.qty;
    end if;
  END T_N_del_REST;
  / 