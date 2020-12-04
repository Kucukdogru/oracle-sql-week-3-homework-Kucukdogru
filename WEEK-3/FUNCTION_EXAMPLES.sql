/******************************************************************/
------------------------------CONCAT--------------------------------
/******************************************************************/

SELECT CONCAT(firstname , lastname)
FROM MOVIE.directors;


SELECT firstname || ' ' || lastname
FROM MOVIE.directors;


SELECT CONCAT(CONCAT(firstname, ' '), lastname) 
FROM MOVIE.directors;



/******************************************************************/
-----------------------------LENGTH--------------------------------
/******************************************************************/


SELECT LENGTH(c.title) AS LENGTH
FROM MOVIE.movies m
    INNER JOIN MOVIE.comments c ON m.commentid=c.id
    WHERE 1=1
    AND m.id=1



SELECT *
FROM MOVIE.moviecategories
WHERE 1=1
AND LENGTH(categoryname) > 10;



/******************************************************************/
-----------------------------SUBSTR
/******************************************************************/
SELECT SUBSTR(moviename,0,4) || ' ' || SUBSTR(moviename, 8, 18)
FROM MOVIE.movies;




/*******************************************************************/
-----------------------------INSTR------------------------------------
/*******************************************************************/

SELECT INSTR( firstname, 'a' , 1, 2 )
FROM MOVIE.directors;


SELECT INSTR(moviename, 'e' , 1, 1)
FROM MOVIE.moviecategories c
INNER JOIN movies m ON c.id=m.categoryid
WHERE 1=1
and c.categoryname = 'Dram';





/**********************************************************************/
------------------------------LPAD-------------------------------------
/**********************************************************************/


SELECT m.id, LPAD(m.moviename, 20, 'Dram Filmi') AS Film_Adı
FROM MOVIE.movies m
    INNER JOIN MOVIE.moviecategories c on m.categoryid=c.id
    WHERE categoryid=7;


/***********************************************************************/
-----------------------LPAD AND RPAD------------------------------------
/***********************************************************************/


SELECT firstname, lastname, rpad(job,20,'*' ), lpad(job,20,'/')
FROM MOVIE.customers
WHERE status='ACTIVE';



SELECT LPAD(job, 30, 'İK***')
FROM MOVIE.employees
WHERE JOB LIKE '%İnsan%';





/**************************************************************************/
---------------------------------TRIM---------------------------------------


SELECT TRIM(LEADING 'İ' FROM JOB)
FROM MOVIE.EMPLOYEES
WHERE status='ACTIVE' 
AND job like '%İnsan%';


SELECT TRIM(TRAILING 'ı' FROM JOB)
FROM MOVIE.EMPLOYEES
WHERE status='ACTIVE' 
AND job like '%İnsan%';


SELECT TRIM(BOTH '*' FROM JOB)
FROM MOVIE.EMPLOYEES
WHERE status='ACTIVE' 
AND job like '%İnsan%';



/******************************************************************************/
---------------------------------REPLACE---------------------------------------
/******************************************************************************/


SELECT REPLACE(EMAIL, 'gmail.com')
FROM MOVIE.CUSTOMERS
WHERE status='ACTIVE';


SELECT REPLACE(firstname, substr(firstname, 0,8), 'YÖNETMEN') 
FROM MOVIE.directors
WHERE firstname='Nuri Bilge';


SELECT REPLACE(EMAIL, 'gmail', 'hotmail')
FROM MOVIE.customers;



/************************************************************************************/
---------------------------------UPPER#LOWER#INITCAP---------------------------------
/************************************************************************************/

SELECT UPPER(moviename) UPPER, LOWER(moviename) LOWER, INITCAP(moviename) INITCAP
FROM MOVIE.movies;


/**************************************************************************************/
-----------------------2000-2018 YILLARI ARASINDA CEKİLEN FİLMLER-----------------------
---------------------------------------TO_CHAR------------------------------------------

SELECT * 
FROM MOVIE.movies 
WHERE TO_CHAR(releaseyear, 'YYYY') 
BETWEEN 2000 AND 2018;



/****************************************************************************************/
--------------Film yayın tarihi > Haziran 2014 olan filmleri bulunuz----------------------
/****************************************************************************************/

SELECT *
FROM MOVIE.movies
WHERE releaseyear > TO_DATE(2014, 'YYYY');


-------Film yayın tarihi 2000 ile 2017 arasında olan filme yorum yapan müşteri ile aynı mesleğe sahip çalışanların bilgilerini bulunuz 
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


/********************************************************************************************/
--------------------------------------------ADD_MONTHS----------------------------------------

SELECT releaseyear, ADD_MONTHS(RELEASEYEAR,3) NEW_RELEASEYEAR
FROM MOVIE.movies
	WHERE 1=1
	AND commentid is not null
	AND directorid=10000;



/********************************************************************************************/
----------------------------------------LAST DAY---------------------------------------------


SELECT TO_CHAR(LAST_DAY(SYSDATE), 'DAY') AS SONUC FROM DUAL;



/******************************************************************************************/
--------------------------FIRST VALUE-----------------------------------------------------

select id,moviename,directorid,
       first_value (moviename) over (partition by directorid order by id) as FV
from MOVIE.movies
order by directorid;


select id,moviename,directorid,
       first_value (moviename) over (partition by directorid order by id desc) as LV
from MOVIE.movies
order by directorid;


/******************************************************************************************/
--------------------------------------------NVAL--------------------------------------------
---Şu anda vizyonda olan filmlerden vizyondan kalkma tarihi boş olan kayıtlara başlangıç tarihlerinden----
4 ay sonra bitiş tarihi giriniz------------------------------------------------------------

SELECT c.movieid, m.moviename, startdate, 
NVL(ENDDATE, add_months(startdate,4)) MOVIE_ENDDATE
from MOVIE.CURRENTMOVIES c
    inner join MOVIE.MOVIES m on m.id=c.movieid;




/*******************************************************************************************/
------------------------------------LISTAGG------------------------------------------------

--Tüm meslekleri tek bir satırda # işareti ile listeleyiniz.---
SELECT LISTAGG(JOB, '#') WITHIN GROUP (ORDER BY JOB) "Meslekler" FROM
(
SELECT JOB
FROM MOVIE.customers
UNION
SELECT JOB
FROM MOVIE.employees
);


--Çalışan ve müşteri mesleklerinden ortak olan meslekleri tek bir satırda # işareti ile listeleyiniz.---
SELECT LISTAGG(JOB, '#') WITHIN GROUP (ORDER BY JOB) "Meslekler" FROM
(
SELECT JOB
FROM MOVIE.customers
INTERSECT
SELECT JOB
FROM MOVIE.employees
);


--Müşterilerin meslekleri ile çalışanların meslekleri arasındaki farklı olan meslekleri tek bir satırda # işareti ile listeleyiniz.---
SELECT LISTAGG(JOB, '#') WITHIN GROUP (ORDER BY JOB) "Meslekler" FROM
(
SELECT JOB
FROM MOVIE.customers
MINUS
SELECT JOB
FROM MOVIE.employees
);

