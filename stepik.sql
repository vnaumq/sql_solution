--SQL

--https://sql-ex.ru/

--https://sqlbolt.com/


--STEPIK

--Создание таблицы где book_id это первичный ключ который автоматически заполняется
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
);

-- Добавление данных в таблицу

INSERT INTO book(title,author,price,amount)
VALUES ('Мастер и Маргарита','Булгаков М.А.',670.99,3);

-- Внесение нескольких записей

INSERT INTO book (title, author, price, amount)
VALUES
    ('Белая гвардия', 'Булгаков М.А.', 540.50 , 5),
    ('Идиот', 'Достоевский Ф.М.', 460, 10),
    ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);

-- Добавление и вычисление нового столбца

SELECT title,amount,
    amount * 1.65 AS pack
FROM book

-- Математические функции

CEILING(x) --возвращает наименьшее целое число, большее или равное x
ROUND(x, k) --возвращает x, округлённое до k знаков после запятой
FLOOR(x) --возвращает наибольшее целое число, меньшее или равное x
POWER(x, y) --возвращает x в степени y
SQRT(x) --возвращает квадратный корень из x
DEGREES(x) -- возвращает градусы из радиан
RADIANS(x) --возвращает радианы из градусов
ABS(x) -- возращает модуль
PI() -- возращает число пи

-- Округление

SELECT title,author,amount,
    ROUND(price - price * 0.3 ,2) AS new_price
FROM book

-- IF

SELECT author,title,
ROUND(IF(author = 'Булгаков М.А.', price* 1.1 , IF(author = 'Есенин С.А.' , price * 1.05 , price * 1)),2) AS new_price
FROM book

-- CASE

SELECT author, title,
CASE
    WHEN author = 'Булгаков М.А.' THEN ROUND(price * 1.1 , 2)
    WHEN author = 'Есенин С.А.' THEN ROUND(price * 1.05, 2)
    ELSE price
END AS new_price
FROM book;

-- WHERE (с двойным условием)

SELECT title,author,price,amount
FROM book
WHERE (price <500 or price >600) AND amount * price >5000 

-- BEETWEEN and IN

SELECT title,author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND amount IN (2,3,5,7)

-- ORDER BY

SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14  
ORDER BY author DESC , title 

-- LIKE

/* Вывести название и автора тех книг, название которых состоит из двух и более слов, 
а инициалы автора содержат букву «С». Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания,
между фамилией автора и инициалами обязателен пробел, инициалы записываются без пробела в формате: буква, точка, буква, точка. 
Информацию отсортировать по названию книги в алфавитном порядке.*/

SELECT title,author
FROM book
WHERE (title LIKE '% %_%') AND (author LIKE '% _.С.' OR author LIKE '% С._.' )
ORDER BY title

-- GROUP BY

/*Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе.
Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.*/

SELECT author AS Автор,COUNT(DISTINCT title) AS Различных_книг, SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;

-- MIN,MAX,AVG

SELECT author, MIN(price) AS Минимальная_цена,MAX(price) AS Максимальная_цена,AVG(price) AS Средняя_цена
FROM book
GROUP BY author

-- Group function

/*Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость), 
а также вычислить налог на добавленную стоимость  для полученных сумм (имя столбца НДС ) , который включен в стоимость и составляет 18% (k=18), 
а также стоимость книг  (Стоимость_без_НДС) без него. 
Значения округлить до двух знаков после запятой. В запросе для расчета НДС(tax)  и Стоимости без НДС(S_without_tax) использовать следующие формулы: 
 */

SELECT author, SUM(price*amount) AS Стоимость, ROUND(SUM(price*amount)*18/118 ,2) AS НДС, ROUND(SUM(price*amount) /1.18,2) AS Стоимость_без_НДС
FROM book
GROUP BY author

-- HAVING используется как where только после group by

SELECT ROUND(AVG(price),2) AS Средняя_цена, ROUND(SUM(price * amount),2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14

-- WHERE + HAVING

/* Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия».
 В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб.
 Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.*/

SELECT author,
    SUM(amount*price) AS Стоимость
FROM book
WHERE title NOT IN ('Идиот','Белая гвардия')
GROUP BY author
HAVING Стоимость > 5000
ORDER BY Стоимость DESC

-- Вложенный запрос

-- Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе.
-- Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.

SELECT author,title,price 
FROM book
WHERE price <= (
    SELECT AVG(price)
    FROM book
)
ORDER BY price DESC;

-- Вывести информацию (автора, название и цену) о тех книгах, цены которых
-- превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде.

SELECT author,title,price
FROM book
WHERE  ABS(price - (SELECT MIN(price) FROM book)) <= 150  
ORDER BY price

-- Вывести информацию (автора, книгу и количество) 
-- о тех книгах, количество экземпляров которых в таблице book не дублируется.

SELECT author,title,amount
FROM book
WHERE amount IN (
    SELECT amount
    FROM book
    GROUP BY amount
    HAVING COUNT(amount) = 1
)

-- ANY and ALL

-- Вывести информацию о книгах(автор, название, цена),
-- Цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.

SELECT author,title,price
FROM book
WHERE price < ANY (
    SELECT MIN(price)
    FROM book
    GROUP BY author
)

-- Вложенный запрос после SELECT

-- Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, 
-- чтобы на складе стало одинаковое количество экземпляров каждой книги, 
-- равное значению самого большего количества экземпляров одной книги на складе. Вывести название книги, 
-- ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг.
--  Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.

SELECT title,author,amount,
    ((SELECT MAX(amount) FROM book) - amount) AS Заказ
FROM book
WHERE ((SELECT MAX(amount) FROM book) - amount) > 0

-- Добавление в таблицу book всех данных таблицы supply

INSERT INTO book(title,author,price,amount)
SELECT title,author,price,amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.','Достоевский Ф.М.');

-- UPDATE 

UPDATE book
SET price = price * 0.9
WHERE amount BETWEEN 5 AND 10

UPDATE book
SET price = IF(buy = 0, price * 0.9, price),
    buy = IF(buy > amount, amount, buy);

UPDATE book,supply
SET book.amount = book.amount + supply.amount , book.price = (book.price + supply.price)/2
WHERE book.title = supply.title

-- DELETE 

--Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.

DELETE FROM supply
WHERE author IN (SELECT author
       FROM book
       GROUP BY author
       HAVING SUM(amount) > 10 
      )

-- CREATE TABLE + SELECT

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, 
-- количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book.
-- В таблицу включить столбец   amount, 
-- в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.

CREATE TABLE ordering AS
SELECT author,title,
    (
     SELECT ROUND(AVG(amount))
     FROM book
    ) AS amount
FROM book
WHERE amount<(SELECT ROUND(AVG(amount)) FROM book) ;

-- DATEDIFF

-- Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. 
-- В результат включить столбцы name, city, date_first, date_last.

SELECT name,city,date_first,date_last
FROM trip
WHERE DATEDIFF(date_last,date_first) = (SELECT(MIN(DATEDIFF(date_last,date_first))) FROM trip) 

-- MONTH

-- Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). 
-- В результат включить столбцы name, city, date_first, date_last.
--  Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .

SELECT name,city,date_first,date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city,name ASC

-- MONTHNAME

SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY MONTHNAME(date_first)
ORDER BY Количество DESC, Месяц ASC

-- Большая

-- Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок,
-- первый день которых пришелся на февраль или март 2020 года. Значение суточных для каждой командировки занесено 
-- в столбец per_diem. Вывести фамилию и инициалы сотрудника, город, первый день командировки и сумму суточных. 
-- Последний столбец назвать Сумма. 
-- Информацию отсортировать сначала  в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных.

SELECT name,city,date_first,
    ((DATEDIFF(date_last,date_first) + 1) * per_diem) AS Сумма
FROM trip
WHERE YEAR(date_first) = 2020 and (MONTH(date_first) IN (2,3))
ORDER BY name, Сумма DESC

--Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников,
-- которые были в командировках больше чем 3 раза, 
-- в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма.

SELECT name,
    SUM(((DATEDIFF(date_last,date_first) + 1) * per_diem)) AS Сумма
FROM trip
WHERE name IN (SELECT name
               FROM trip
               GROUP BY name
               HAVING COUNT(name)>3)
GROUP BY name
ORDER BY Сумма DESC

-- АЛИАСЫ

-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель,
-- в соответствии с данными из таблицы traffic_violation. При этом суммы заносить 
-- только в пустые поля столбца  sum_fine.

UPDATE fine f, traffic_violation t
SET f.sum_fine = t.sum_fine
WHERE f.violation = t.violation AND f.sum_fine IS NULL

SELECT name,number_plate,violation
FROM fine
GROUP BY name,number_plate,violation
HAVING COUNT(name)>1
ORDER BY name,number_plate,violation

--CREATE TABLE

CREATE TABLE back_payment AS
SELECT name,number_plate,violation,sum_fine,date_violation
FROM fine
WHERE date_payment IS NULL

--

Алексей
Алексей
 4 месяцев назад
Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.

SELECT title, name_author, name_genre, price, amount
FROM 
  author 
  INNER JOIN book ON author.author_id = book.author_id
  INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE genre.genre_id IN
     (
     SELECT query_in_1.genre_id
     FROM 
       ( 
        SELECT genre_id, SUM(amount) AS sum_amount
        FROM book
        GROUP BY genre_id
        )query_in_1
     INNER JOIN 
       ( 
        SELECT genre_id, SUM(amount) AS sum_amount
        FROM book
        GROUP BY genre_id
        ORDER BY sum_amount DESC
        LIMIT 1
        ) query_in_2
     ON query_in_1.sum_amount= query_in_2.sum_amount
     )
     ORDER BY title ASC; 

-- Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора, 
-- а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.

select book.title as Название, supply.author as Автор, (book.amount + supply.amount) as Количество
from supply
left join book on supply.title = book.title
and supply.amount = book.amount
left join author on author.author_id = book.author_id
where book.title = supply.title and book.price = supply.price

_______STUDENTS_________________________

BEGIN TRANSACTION;   
DELETE FROM students  
    WHERE gender != 'aa';
COMMIT TRANSACTION;  

!!! Удаляет все записи и коммитит чтобы все сохранилось 

_______Импорт .csv в postgresql___________

1. Для начала надо в самом БД создать таблицу с типом данных как в csv
2. После этого нужно зайти в консоль psql где нужно ввести название БД и пороль 
3. После этого нужно прописать данную команду которая импортирует данные из csv в таблицу 
\COPY students FROM ‘D:\university\Students Performance in Exams\StudentsPerformance.csv’ DELIMITER ‘,’ CSV HEADER;

___________________________________________











































