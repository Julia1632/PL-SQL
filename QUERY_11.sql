/*НАЙТИ МОДЕЛИ, НА КОТОРЫЕ 
предоставлены нехарактерно большие скидки,
с учетом предыдущего анализа. Сделать предположение о с составе этих моделей
*/

SELECT id_model,
  z2.discount
FROM
  (SELECT DISCOUNT
  FROM
    (SELECT MAX(C) MAX
    FROM
      (SELECT DISTINCT discount,
        COUNT(id_sale_str) over (partition BY discount) C
      FROM T_SALE_STR SS
      JOIN T_WARE W
      ON W.ID_WARE=SS.ID_WARE
      )
    ),
    (SELECT DISTINCT discount,
      COUNT(id_sale_str) over (partition BY discount) C
    FROM T_SALE_STR SS
    JOIN T_WARE W
    ON W.ID_WARE=SS.ID_WARE
    )
  WHERE MAX=C
  ) Z1,
  (SELECT m.id_model,
    discount
  FROM T_WARE T
  JOIN T_MODEL M
  ON M.ID_MODEL=T.ID_MODEL
  JOIN T_SALE_STR SS
  ON SS.ID_WARE=T.ID_WARE
  ) Z2
WHERE z2.discount>z1.discount ;
