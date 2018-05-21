SELECT c.id_client,
  C.name,
  COUNT(ID_SALE) COUNT_S,
  SUM(SUM) SUM_S,
  SUM(SUM)/COUNT(ID_SALE) v_sum_s,
  MAX(DISCOUNT) max_d,
  MIN(DISCOUNT) min_d
FROM T_SALE s
JOIN t_client c
ON S.ID_CLIENT=C.ID_CLIENT
WHERE DISCOUNT>25
GROUP BY c.id_client,
  c.name ;