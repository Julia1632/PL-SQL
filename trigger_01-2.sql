CREATE OR REPLACE TRIGGER sum_nds_for_supply before
  INSERT OR
  UPDATE ON t_supply FOR EACH row DECLARE add_sum t_supply.sum%type;
  add_nds t_supply.nds%type;
  BEGIN
    SELECT SUM
    INTO add_sum
    FROM t_supply_str t_str
    WHERE t_str.id_supply=:new.id_supply;
    IF :new.sum         IS NOT NULL AND :new.sum<>add_sum THEN
      raise_application_error(-20000,'error in sum');
    END IF;
    SELECT nds
    INTO add_nds
    FROM t_supply_str t_str
    WHERE t_str.id_supply=:new.id_supply;
    IF :new.nds         IS NOT NULL AND :new.nds<>add_nds THEN
      raise_application_error(-20002,'error in nds');
    END IF;
  end sum_nds_for_supply;
  /