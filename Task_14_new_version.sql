-- правильно но толко для t_rest

CREATE OR REPLACE TRIGGER T_N_ADD_REST AFTER
  UPDATE OF E_STATE ON T_SUPPLY FOR EACH row DECLARE flag NUMBER;
  BEGIN
    IF :old.E_STATE='new' AND :new.E_STATE='done' THEN
      merge INTO T_REST P1 USING
      ( SELECT id_ware, qty FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply
      ) P2 ON (P2.ID_WARE=P1.ID_WARE)
    WHEN matched THEN
      UPDATE SET P1.QTY=P1.QTY+p2.QTY WHEN NOT matched THEN
      INSERT
        (
          ID_WARE,
          QTY
        )
        VALUES
        (
          P2.ID_WARE,
          P2.QTY
        ) ;
    END IF;
    IF :new.E_STATE='new' AND :old.E_STATE='done' THEN
      merge INTO T_REST P1 USING
      ( SELECT id_ware, qty FROM T_SUPPLY_STR WHERE ID_SUPPLY=:new.id_supply
      )
      P2 ON (P2.ID_WARE=P1.ID_WARE)
    WHEN matched THEN
      UPDATE SET P1.QTY=P1.QTY-p2.qty;
    END IF;
  END T_N_ADD_REST;
  / 


select * from t_rest;

delete from t_rest;

