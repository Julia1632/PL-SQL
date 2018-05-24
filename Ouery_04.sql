insert into T_DEPT(ID_DEPT,ID_PARENT,name) values (1,null,'');
insert into T_DEPT(ID_DEPT,ID_PARENT,name) values (2,1,'');
insert into T_dept(ID_dept,id_parent,name) values (3,1,'');

select LPAD(' ',(level-1)*3,' ') 
    || T.ID_dept id ,
    T.ID_PARENT,
 
    T.name
    FROM T_dept T
    start with T.ID_PARENT      is null
    CONNECT BY prior ID_dept = ID_PARENT; 