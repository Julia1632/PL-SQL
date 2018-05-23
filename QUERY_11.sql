
SELECT DISCOUNT FROM
(
select max(C)  MAX
FROM
(SELECT  distinct discount,  COUNT(id_sale_str) over (partition BY discount) C
FROM T_SALE_STR SS
join T_WARE W
on W.ID_WARE=SS.ID_WARE)),
(SELECT  distinct discount,  COUNT(id_sale_str) over (partition BY discount) C
FROM T_SALE_STR SS
join T_WARE W
on W.ID_WARE=SS.ID_WARE) 
WHERE MAX=C;