/*бшбнд рюакхжш ондпюгдекемхи, 
дкъ йюфднцн сгкю ≈ ясллю опндюф 
гю гюдюммши леяъж. мюохяюрэ гюопня 
он рюакхже я нрвернл х он хяундмшл днйслемрюл. 
оПНБЕПХРЭ ЯННРБЕРЯРБХЕ.*/
-- РЕЙСЫХИ ЛЕЯЪЖ


SELECT D.ID_DEPT,
  SUM(SUM)
FROM T_SALE S
JOIN T_CLIENT C
ON S.ID_CLIENT=C.ID_CLIENT
JOIN T_DEPT D
ON D.ID_DEPT=C.ID_DEPT
WHERE DT BETWEEN TO_DATE(TO_CHAR(sysdate,'MM.YYYY'),'MM.YYYY') AND LAST_DAY(sysdate)
GROUP BY D.ID_DEPT; 