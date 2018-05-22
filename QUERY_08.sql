/*query-08
ВЫЧИСЛИТЬ ЧИСЛО СТРОК ПРОДАЖ, КОЛИЧЕСТВО, СУММУ СРЕДНЕВЗВЕШЕННУЮ, 
максимальную и минимальную скидку по торговой марке (t_model.label). */

  
select m.label,
  COUNT(ID_SALE_str) COUNT_S,
  SUM(SUM) SUM_S,
  SUM(SUM)/COUNT(ID_SALE) v_sum_s,
  MAX(DISCOUNT) max_d,
  MIN(DISCOUNT) min_d
from T_SALE_STR S
left JOIN T_WARE W
on S.ID_WARE=W.ID_WARE
 left join T_MODEL M
on W.ID_MODEL=M.ID_MODEL
group by m.label
;