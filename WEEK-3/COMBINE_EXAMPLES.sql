/*************************************************************************************************/
----------------------Var olan kategorilerden filmi olmayan kategorileri bulunuz.-----------------
/*************************************************************************************************/

SELECT * 
FROM MOVIE.moviecategories 
    WHERE id IN(
            SELECT c.id
            FROM MOVIE.moviecategories c            
            MINUS            
            SELECT c.id
            FROM MOVIE.movies m
                INNER JOIN MOVIE.moviecategories c on m.categoryid=c.id
                GROUP BY c.id
            );




/*************************************************************************************************/
-------Customer ve employees tablolarındaki meslekleri tekrarsız olarak listeleyiniz -------------
/*************************************************************************************************/

SELECT job FROM MOVIE.employees
UNION
SELECT job FROM MOVIE.customers;





/*************************************************************************************************/
-------------------------------Filmleri olan yönetmenleri bulunuz ----------------------------------
/*************************************************************************************************/

SELECT * 
FROM MOVIE.directors 
WHERE id IN
(
    SELECT id FROM MOVIE.directors
    INTERSECT
    SELECT directorid FROM MOVIE.directors d
    inner join MOVIE.movies m on d.id=m.directorid
);




/*************************************************************************************************/
--------------Employees ve Customer tablolarındaki isimleri listeleyiniz---------------------------
/*************************************************************************************************/

SELECT firstname 
FROM MOVIE.employees
UNION ALL
SELECT firstname
FROM MOVIE.customers;



/*****************************************************************************************************************************************/
-------Film yayın tarihi 2000 ile 2017 arasında olan filme yorum yapan müşteri ile aynı mesleğe sahip çalışanların bilgilerini bulunuz.----
/*****************************************************************************************************************************************/

SELECT *
FROM MOVIE.employees
WHERE JOB   IN(

                SELECT JOB
                FROM MOVIE.customers
                WHERE id IN(
                                SELECT cus.id
                                    FROM MOVIE.movies m
                                        inner join MOVIE.comments c ON m.commentid=c.id
                                        inner join MOVIE.customers cus on cus.id=c.customerid
                                        where m.releaseyear BETWEEN TO_DATE('2000' , 'YYYY')
                                        AND TO_DATE('2017', 'YYYY')
                            )
                
                INTERSECT
                SELECT JOB FROM MOVIE.employees
);


