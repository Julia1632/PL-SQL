/*������� �������� ����������� �������� ������. 
��� ����� ��������� ������������� �� ��������������� �������,
��� ������ ���������� ���������� �������, ������� � �������,
����������� � ����� ������.*/
-- ��� �������


SELECT discount,
  COUNT(id_sale_str) over (partition BY discount),
  COUNT(ss.id_ware) over (partition BY discount),
  COUNT(id_model) over (partition BY discount)
FROM T_SALE_STR SS
JOIN T_WARE W
ON W.ID_WARE=SS.ID_WARE ;

