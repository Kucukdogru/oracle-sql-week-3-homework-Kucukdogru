/*****************************************************************************************************/
--------Filmlerin adını, kategorisini ve yönetmenini bularak film id ye göre sıralama yapınız.---------
/*****************************************************************************************************/

SELECT m.moviename, c.categoryname, d.firstname || d.lastname AS Directors
FROM MOVIE.movies m
    INNER JOIN MOVIE.moviecategories c on m.categoryid=c.id
    INNER JOIN MOVIE.directors d on m.directorid=d.id
    ORDER BY m.id;




/**********************************************************************************************************/
------------------------ ID'si 10000 olan yazarın filmlerini bulunuz ---------------------------------------
/**********************************************************************************************************/

SELECT d.firstname || d.lastname AS Yönetmen, m.moviename AS "Film Adı"
FROM MOVIE.movies m
    INNER JOIN MOVIE.directors d on d.id=m.directorid
    WHERE d.id=10000;




/**********************************************************************************************************/
---------------------------Hangi kategoride hangi filmlerin olduğunu bulunuz--------------------------------
/**********************************************************************************************************/

SELECT c.* , m.moviename 
FROM MOVIE.moviecategories c
    LEFT JOIN MOVIE.movies m on c.id=m.categoryid
    ORDER BY c.id


/**********************************************************************************************************/
-----------------Film kategorileri ile yönetmenlerin kombinasyonlarını bulunuz.----------------------------
/**********************************************************************************************************/

SELECT c.categoryname, d.firstname || d.lastname AS "Yönetmen" 
FROM MOVIE.moviecategories c
    CROSS JOIN MOVIE.directors d
    ORDER BY c.id; 


/**********************************************************************************************************/
--------------------Hangi yönetmenin kaç adet filmi olduğunu bulunuz----------------------------------------
/**********************************************************************************************************/


SELECT COUNT(*), d.firstname || ' ' || d.lastname
FROM MOVIE.movies m
    inner join MOVIE.directors d on m.directorid=d.id
    GROUP BY d.id, d.firstname, d.lastname;