--—ледующий шаг Ч вычисление в триггере суммы и Ќƒ— заголовка поставки по изменению в строках.
CREATE OR REPLACE TRIGGER sum_nds_for_supply before
  insert or
  update on t_supply for each row declare 
  add_sum t_supply.sum%type;
  add_nds t_supply.nds%type;
  begin
    select nvl(sum,0) into add_sum from t_supply_str t_str
    where  t_str.id_supply=:new.id_supply; 
    
    if :new.sum is not null and :new.sum<>add_sum then
      raise_application_error(-20003,'error in sum');
    END IF;
 
     select nvl(sum(nds),0) into add_nds from t_supply_str t_str
    where  t_str.id_supply=:new.id_supply;
        if :new.nds<>add_nds
     
    then 
   
    raise_application_error(-20002,'error in nds');
    end if;
  END sum_nds_for_supply;
  /

