COALESCE(column,'None') - функция для замены NULL на какое либо значение
!!! Когда хотим в дате NULL заменить на текст то нужно эту дату перевести в VARCHAR
_________________________
DATE_PART('time' , column) - функция для вывода указаного части времени(месяц,год,день)
_________________________
CONCAT(column1,column2) - соединение двух строк и более
_________________________
CAST(column AS VARCHAR) или column::VARCHAR - функция для перевода строки к определенному типу
_________________________
SELECT SPLIT_PART('karpov.courses', '.', 2) - функция для разделения строки
Результат:
courses
_________________________
SELECT LEFT('karpov.courses', 6) - функция для вывода количество символов из строки
Результат:
karpov
_________________________
SELECT name,
       CASE 
       WHEN name='свинина' OR name='баранина' OR name='курица' THEN 'мясо'
       WHEN name='треска' OR name='форель' OR name='окунь' THEN 'рыба'
       ELSE 'другое'
       END AS сategory
FROM table
_________________________
SELECT product_id,
		 name,
		 price,
		
	CASE
	WHEN name IN ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') THEN
	round(price/110*10, 2)
	ELSE round(price/120*20, 2)
	END AS tax,
	CASE
	WHEN name IN ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') THEN
	round(price - price/110*10, 2)
	ELSE round(price - price/120*20, 2)
	END AS price_before_tax
FROM products
ORDER BY  price_before_tax desc, product_id
_________________________
SELECT count(order_id) as orders
FROM   orders
WHERE  array_length(product_ids, 1) >= 9

!!! array_length(product_ids, 1) - Считает количество элементов в массиве 

_________________________

SELECT AGE('2022-12-12', '2021-11-10') 
Выводит разницу между двумя датами в типе TIMESTAMP

Результат:
397 days, 0:00:00

_________________________
SELECT AGE(current_date, '2021-11-10')::VARCHAR

Результат:
1 year 1 mon 2 days

_________________________

SELECT agg_function(column) FILTER (WHERE condition)
FROM table

FILTER - подает аггрегирующей функции на вхрд только строки которые проходят по условию

_________________________

SELECT (count(distinct user_id) - count(distinct user_id) filter(WHERE action = 'cancel_order')) as users_count
FROM   user_actions

Запрос который выдает количество пользователей которые никогда не отменяли заказ

_________________________

SELECT COUNT(order_id) as orders,
       COUNT(order_id) FILTER(WHERE 5 <= array_length(product_ids,1)) as large_orders,
       ROUND(COUNT(order_id) FILTER(WHERE 5 <= array_length(product_ids,1)) /COUNT(order_id)::DECIMAL,2)   as large_orders_share
FROM orders

Пример использования filter 

_________________________

SELECT DATE_TRUNC('month', TIMESTAMP '2022-01-12 08:55:30')

Результат:
01/01/22 00:00

SELECT DATE_TRUNC('day', TIMESTAMP '2022-01-12 08:55:30')

Результат:
12/01/22 00:00	

SELECT DATE_TRUNC('hour', TIMESTAMP '2022-01-12 08:55:30')

Результат:
12/01/22 08:00	

!!! Это функция чаще всего используется для группировки даты по месяцу, дн. или времени

_________________________

select sex,MAX(DATE_PART('year',AGE(birth_date))::INT)as max_age
FROM users
GROUP BY sex
ORDER BY max_age

Вычисление максимального возраста у пользователей жен и муж пола

_________________________

select DATE_PART('year',AGE(birth_date))::INT as age, COUNT(user_id) as users_count
FROM users
GROUP BY age
ORDER BY age

!!! Полезный запрос на разбивку пользователей по возрастной группе и количество их в воззрастной группе

_________________________

SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
WHERE  creation_time >= '2022-08-29'
   and creation_time < '2022-09-05'
GROUP BY order_size
ORDER BY order_size

Условие между двумя временами выбрать 

_________________________

SELECT TO_CHAR(TIMESTAMP '2022-08-29', 'Dy')

Результат:
Mon

выдает день недели

_________________________

SELECT CASE
       WHEN array_length(product_ids,1) IN (1,2,3) THEN 'Малый'
       WHEN array_length(product_ids,1) IN (4,5,6) THEN 'Средний'
       ELSE 'Большой'
       END AS order_size,
       COUNT(order_id) as orders_count
FROM orders
GROUP BY order_size
ORDER BY orders_count

Группирует по группировке :3\

_________________________

SELECT date_part('isodow', time)::int as weekday_number,
       to_char(time, 'Dy') as weekday,
       count(action) filter(WHERE action = 'create_order') as created_orders,
       count(action) filter(WHERE action = 'cancel_order') as canceled_orders,
       count(action) filter(WHERE action = 'create_order') - count(action) filter(WHERE action = 'cancel_order') as actual_orders,
       round((count(action) filter(WHERE action = 'create_order') - count(action) filter(WHERE action = 'cancel_order')::decimal) / count(action) filter(WHERE action = 'create_order'),
             3) as success_rate
FROM   user_actions
WHERE  time >= '2022-08-24'
   and time <= '2022-09-07'
GROUP BY 2,1
ORDER BY 1

_________________________

WITH 
subquery_1 AS (
    SELECT column_1, column_2, column_3
    FROM table
),
subquery_2 AS (
    SELECT column_1, column_2
    FROM subquery_1
)

SELECT column_1
FROM subquery_2

_________________________

SELECT NOW() - INTERVAL '1 year 2 months 1 week'

Результат:
10/10/21 19:32

_________________________

SELECT COUNT(DISTINCT user_id) AS users_count
FROM user_actions
WHERE time >= (SELECT MAX(time) - INTERVAL '1 week' FROM user_actions)
  AND action = 'create_order';

!!! Выбор пользователей которые сделали за последнюю неделю хотя бы один заказ

_________________________

SELECT DISTINCT order_id
FROM user_actions
WHERE order_id NOT IN (SELECT DISTINCT order_id FROM user_actions WHERE action = 'cancel_order')
ORDER BY order_id
LIMIT 1000

заказы которые не отменены 


_________________________

with t1 as (SELECT user_id,
                   count(order_id) as orders_count
            FROM   user_actions
            WHERE  action = 'create_order'
            GROUP BY user_id)
SELECT user_id,
       orders_count,
       round((SELECT avg(orders_count)
       FROM   t1), 2) as orders_avg, orders_count - round((SELECT avg(orders_count)
FROM   t1), 2) as orders_diff
FROM   t1
ORDER BY user_id limit 1000 

_________________________

with avg_price as (SELECT round(avg(price), 2) as price
                   FROM   products)
SELECT product_id,
       name,
       price,
       case when price >= (SELECT *
                    FROM   avg_price) + 50 then price*0.85 when price <= (SELECT *
                                                      FROM   avg_price) - 50 then price*0.9 else price end as new_price
FROM   products
ORDER BY price desc, product_id

!!! Пример использования WITH для того чтобы не писать два одинаковых подзапроса 

_________________________

SELECT count(distinct order_id) as orders_canceled,
       count(order_id) filter (WHERE action = 'deliver_order') as orders_canceled_and_delivered
FROM   courier_actions
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order')

Пример работы Filter с сочетаним с WHERE где WHERE задает условие а FILTER его дополняте 

__________________________________                   

Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более заказов.
Результат отсортируйте по возрастанию id курьера.
Поля в результирующей таблице: courier_id, birth_date, sex

WITH t1 as (SELECT courier_id, COUNT(DISTINCT order_id) as counta
            FROM courier_actions
            WHERE action = 'deliver_order' AND 09 = DATE_PART('month' , time)
            GROUP BY courier_id
            HAVING COUNT(DISTINCT order_id) >= 30
            )

SELECT courier_id,birth_date,sex
FROM couriers
WHERE courier_id IN (SELECT courier_id FROM t1)
ORDER BY courier_id

__________________________________   

with t1 as (SELECT order_id
            FROM user_actions
            WHERE action = 'cancel_order' AND user_id IN (SELECT user_id FROM users WHERE sex = 'male')
            GROUP BY order_id)
        

SELECT ROUND(AVG(array_length(product_ids,1)),3) as avg_order_size
FROM orders
WHERE order_id IN (SELECT  order_id FROM t1)

!!! связывает 3 таблица через подзапросы 

__________________________________ 

with users_age as (SELECT user_id,
                          date_part('year', age((SELECT max(time)
                                          FROM   user_actions), birth_date)) as age
                   FROM   users)
SELECT user_id,
       coalesce(age, (SELECT round(avg(age))
               FROM   users_age))::integer as age
FROM   users_age
ORDER BY user_id

__________________________________ 

SELECT order_id,
       min(time) as time_accepted,
       max(time) as time_delivered,
       (extract(epoch
FROM   max(time) - min(time))/60)::integer as delivery_time
FROM   courier_actions
WHERE  order_id in (SELECT order_id
                    FROM   orders
                    WHERE  array_length(product_ids, 1) > 5)
   and order_id not in (SELECT order_id
                     FROM   user_actions
                     WHERE  action = 'cancel_order')
GROUP BY order_id
ORDER BY order_id

__________________________________ 

with gg as (SELECT time,
                   user_id,
                   order_id
            FROM   user_actions
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order'))
SELECT time::date as date ,
       count(time) as first_orders
FROM   gg
WHERE  time in (SELECT min(time)
                FROM   gg
                GROUP BY user_id
                ORDER BY min(time))
GROUP BY time::date
ORDER BY date

__________________________________ 

SELECT order_id, unnest(product_ids) AS product_id
FROM orders

Результат:
 ________________________
| order_id | product_id  |
|__________|_____________|
| 1001     | 5           |
| 1001     | 8           |
| 1001     | 15          |
| 1002     | 2           |
| 1003     | 4           |
| 1003     | 11          |
| 1003     | 21          |
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
!!! unnest - функция разворачивает массив

 __________________________________ 

SELECT product_id,
       times_purchased
FROM   (SELECT unnest(product_ids) as product_id,
               count(*) as times_purchased
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY product_id
        ORDER BY times_purchased desc limit 10) t
ORDER BY product_id

!!! развернуть массив и посчитать количество самых популярных товаров

 __________________________________ 

 SELECT first_order_date as date,
       count(user_id) as first_orders
FROM   (SELECT user_id,
               min(time)::date as first_order_date
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY user_id) t
GROUP BY first_order_date
ORDER BY date

!!! Считает количество первых заказов пользователей в дату 

 __________________________________ 

SELECT user_id,ROUND(AVG(array_length(product_ids,1)),2) as avg_order_size
FROM orders o LEFT JOIN user_actions u
ON o.order_id = u.order_id
WHERE o.order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY user_id
ORDER BY user_id
LIMIT 1000

!!! Считает среднее количество продуктов в заказе пользователя

__________________________________ 

SELECT order_id,
       product_id,
       price
FROM   (SELECT order_id,
               product_ids,
               unnest(product_ids) as product_id
        FROM   orders) as t
    LEFT JOIN products using(product_id)
ORDER BY order_id, product_id limit 1000

!!! Считает цены товаров в заказе пользователя 

__________________________________ 

SELECT o.order_id, SUM(price) as order_price
FROM (SELECT order_id, unnest(product_ids) as product_id
FROM orders) o LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.order_id
ORDER BY o.order_id
LIMIT 1000

!!! Суммарная цена заказа

__________________________________ 

SELECT user_id,
       count(order_price) as orders_count,
       round(avg(order_size), 2) as avg_order_size,
       sum(order_price) as sum_order_value,
       round(avg(order_price), 2) as avg_order_value,
       min(order_price) as min_order_value,
       max(order_price) as max_order_value
FROM   (SELECT user_id,
               order_id,
               array_length(product_ids, 1) as order_size
        FROM   (SELECT user_id,
                       order_id
                FROM   user_actions
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t1
            LEFT JOIN orders using(order_id)) t2
    LEFT JOIN (SELECT order_id,
                      sum(price) as order_price
               FROM   (SELECT order_id,
                              product_ids,
                              unnest(product_ids) as product_id
                       FROM   orders
                       WHERE  order_id not in (SELECT order_id
                                               FROM   user_actions
                                               WHERE  action = 'cancel_order')) t3
                   LEFT JOIN products using(product_id)
               GROUP BY order_id) t4 using (order_id)
GROUP BY user_id
ORDER BY user_id limit 1000

!!! https://lab.karpov.courses/learning/152/module/1762/lesson/17929/53217/257178/

__________________________________

with s1 as (with minmax as (SELECT user_id,
                                   min(sum) as min_order_value,
                                   max(sum) as max_order_value FROM(SELECT user_id,
                                                                    order_id,
                                                                    sum(price)as sum
                                                             FROM   (SELECT order_id,
                                                                            unnest(product_ids) as product_id
                                                                     FROM   orders) i
                                                                 LEFT JOIN products using(product_id)
                                                                 LEFT JOIN user_actions using (order_id)
                                                             WHERE  order_id not in (SELECT order_id
                                                                                     FROM   user_actions
                                                                                     WHERE  action = 'cancel_order')
                                                             GROUP BY user_id, order_id) t1
                            GROUP BY user_id)
SELECT user_id,
       count(order_id) as orders_count,
       round(avg(array_length(product_ids, 1)), 2) as avg_order_size,
       min_order_value,
       max_order_value
FROM   orders
    LEFT JOIN user_actions using(order_id)
    LEFT JOIN minmax using(user_id)
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
GROUP BY user_id, min_order_value, max_order_value
ORDER BY user_id), s2 as (SELECT user_id,
                                 sum(price) as sum_order_value
                          FROM   (SELECT order_id,
                                         unnest(product_ids) as product_id
                                  FROM   orders) o
                              LEFT JOIN products p using(product_id)
                              LEFT JOIN user_actions using(order_id)
                          WHERE  order_id not in (SELECT order_id
                                                  FROM   user_actions
                                                  WHERE  action = 'cancel_order')
                          GROUP BY user_id
                          ORDER BY user_id)
SELECT s1.user_id,
       orders_count,
       round(avg_order_size, 2) as avg_order_size,
       sum_order_value,
       round(sum_order_value/orders_count, 2) as avg_order_value,
       min_order_value,
       max_order_value
FROM   s1
    LEFT JOIN s2 using(user_id)
ORDER BY user_id limit 1000

!!! https://lab.karpov.courses/learning/152/module/1762/lesson/17929/53217/257178/

__________________________________

SELECT date(creation_time) as date,
       sum(price) as revenue
FROM   (SELECT order_id,
               creation_time,
               product_ids,
               unnest(product_ids) as product_id
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t1
    LEFT JOIN products using(product_id)
GROUP BY date

!!! Выручка за день

__________________________________

with s1 as (SELECT DISTINCT cc.courier_id,
                            date_part('year', age((SELECT max(time)FROM user_actions), cou.birth_date))::int as courier_age
            FROM   courier_actions cc
                LEFT JOIN couriers cou using (courier_id)
                LEFT JOIN user_actions us using (order_id)
                LEFT JOIN users using (user_id)), s2 as (SELECT DISTINCT us.user_id,
                                                             date_part('year', age((SELECT max(time)FROM user_actions), users.birth_date))::int as user_age
                                             FROM   courier_actions cc
                                                 LEFT JOIN couriers cou using (courier_id)
                                                 LEFT JOIN user_actions us using (order_id)
                                                 LEFT JOIN users using (user_id))
SELECT DISTINCT order_id,
                user_actions.user_id,
                courier_actions.courier_id,
                s1.courier_age,
                s2.user_age
FROM   orders
    LEFT JOIN courier_actions using (order_id)
    LEFT JOIN user_actions using(order_id)
    LEFT JOIN s1 using (courier_id)
    LEFT JOIN s2 using(user_id)
WHERE  array_length(product_ids, 1) = (SELECT max(array_length(product_ids, 1))
                                       FROM   orders)
ORDER BY order_id

https://lab.karpov.courses/learning/152/module/1762/lesson/17929/53217/257208/

__________________________________

with s1 as (SELECT order_id,
                   product_id,
                   name
            FROM   (SELECT order_id,
                           unnest(product_ids) as product_id
                    FROM   orders) t1
                INNER JOIN products using(product_id)
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')
            GROUP BY order_id, product_id, name)
SELECT case when a.name > b.name then array[b.name,
       a.name] else array[a.name,
       b.name] end as pair,
       count(array[b.name, a.name]) as count_pair
FROM   s1 a join s1 b
        ON a.order_id = b.order_id and
           a.product_id > b.product_id
WHERE  a.name != b.name
GROUP BY 1
ORDER BY count_pair desc, pair

https://lab.karpov.courses/learning/152/module/1762/lesson/17929/53217/260456/

__________________________________

SELECT product_id,
       name,
       price,
       row_number() OVER (ORDER BY price DESC) as product_number,
       rank() OVER (ORDER BY price DESC) as product_rank,
       dense_rank() OVER (ORDER BY price DESC) as product_dense_rank
FROM   products
ORDER BY price DESC

   :( оконные функции 

__________________________________

SELECT date,
		 orders_count,
		 SUM (orders_count) OVER (ORDER BY date) :: INT as orders_cum_count
FROM 
	(SELECT creation_time::date AS date,
		 COUNT(order_id) AS orders_count
	FROM orders
	WHERE order_id NOT IN 
		(SELECT order_id
		FROM user_actions
		WHERE action = 'cancel_order')
	GROUP BY  1 ) t1

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260813/

__________________________________

SELECT user_id,
       order_id,
       time,
       row_number() OVER(PARTITION BY user_id
                         ORDER BY time) as order_number
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_id limit 1000

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260803/

__________________________________

SELECT user_id,
       order_id,
       time,
       row_number() OVER (PARTITION BY user_id
                          ORDER BY time) as order_number,
       lag(time, 1) OVER (PARTITION BY user_id
                          ORDER BY time) as time_lag,
       time - lag(time, 1) OVER (PARTITION BY user_id
                                 ORDER BY time) as time_diff
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_number limit 1000

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260806/

__________________________________

SELECT user_id,
       avg(time_diff) ::int as hours_between_orders
FROM   (SELECT user_id,
               order_id,
               time,
               row_number() OVER(PARTITION BY user_id
                                 ORDER BY time) as order_number,
               extract(epoch
        FROM   age(time, lag(time, 1)
        OVER(
        PARTITION BY user_id)))::decimal / 3600 as time_diff
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        ORDER BY user_id, order_id) t1
WHERE  order_number != 1
GROUP BY user_id limit 1000

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260807/

Среднее время между заказами пользователя

__________________________________

SELECT date,orders_count,
ROUND(AVG(orders_count) OVER(ORDER BY date ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING),2) as moving_avg
FROM (SELECT creation_time::date AS date,
		 count(order_id) AS orders_count
FROM orders
WHERE order_id NOT IN 
	(SELECT order_id
	FROM user_actions
	WHERE action = 'cancel_order') 
GROUP BY 1) t1 

Оконная функция включает в себя 3 предедущих строки но не включает current 

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260804/

__________________________________

SELECT *,
CASE 
WHEN delivered_orders > avg_delivered_orders THEN 1
ELSE 0
END AS is_above_avg
FROM (SELECT courier_id, COUNT(order_id) as delivered_orders, ROUND(AVG(COUNT(order_id)) OVER(),2) as avg_delivered_orders
FROM courier_actions
WHERE action = 'deliver_order' and DATE_PART('month',time) = 09
GROUP BY courier_id) t1
ORDER BY courier_id

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260800/

__________________________________

SELECT time::date as date,
       order_type,
       count(order_id) as orders_count
FROM   (SELECT user_id,
               order_id,
               time,
               case when time = min(time) OVER (PARTITION BY user_id) then 'Первый'
                    else 'Повторный' end as order_type
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t
GROUP BY date, order_type
ORDER BY date, order_type

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/415381/

__________________________________


SELECT time::date as date,
       order_type,
       count(order_id) as orders_count,
       ROUND(orders_count / SUM(orders_count) OVER(PARTITION BY date),2) as orders_share
FROM   (SELECT user_id,
               order_id,
               time,
               case when time = min(time) OVER (PARTITION BY user_id) then 'Первый'
                    else 'Повторный' end as order_type
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t
GROUP BY date, order_type
ORDER BY date, order_type

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/415382/


__________________________________

SELECT name,price,product_id,ROUND(AVG(price) OVER(),2) as avg_price,
ROUND(AVG(price) FILTER(WHERE price != (SELECT MAX(price) FROM products)) OVER(),2) as avg_price_filtered
FROM products
ORDER BY price DESC,product_id ASC

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260810/

__________________________________

SELECT *,
       round(canceled_orders :: decimal / created_orders, 2) as cancel_rate FROM (SELECT *,
                                                                                 count(order_id) filter(WHERE action = 'create_order') OVER(PARTITION BY user_id
                                                                                                                                            ORDER BY time) as created_orders,
                                                                                 count(order_id) filter(WHERE action = 'cancel_order') OVER(PARTITION BY user_id
                                                                                                                                            ORDER BY time) as canceled_orders
                                                                          FROM   user_actions
                                                                          ORDER BY user_id, order_id, time limit 1000) t1

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260811/

__________________________________

SELECT *
FROM
(SELECT courier_id, COUNT(order_id) as orders_count, row_number() OVER(ORDER BY COUNT(order_id) desc,courier_id) as courier_rank
FROM courier_actions
WHERE action = 'deliver_order'
GROUP BY 1
ORDER BY 2 DESC, 1 ASC) t1
WHERE courier_rank <= (SELECT ROUND((COUNT(DISTINCT courier_id) * 0.1 )) FROM courier_actions)   

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260795/

__________________________________

SELECT courier_id,
       count(order_id) filter(WHERE action = 'deliver_order') as delivered_orders,
       date_part('day', age((SELECT max(time)
                      FROM   courier_actions), min(time)))::int as days_employed
FROM   courier_actions
GROUP BY 1 having date_part('day', age((SELECT max(time)
                                        FROM   courier_actions), min(time)))::int >= 10
ORDER BY days_employed desc, courier_id

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260797/

__________________________________

SELECT order_id,
       creation_time,
       order_price,
       sum(order_price) OVER(PARTITION BY date(creation_time)) as daily_revenue,
       round(100 * order_price::decimal / sum(order_price) OVER(PARTITION BY date(creation_time)),
             3) as percentage_of_daily_revenue
FROM   (SELECT order_id,
               creation_time,
               sum(price) as order_price
        FROM   (SELECT order_id,
                       creation_time,
                       product_ids,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t3
            LEFT JOIN products using(product_id)
        GROUP BY order_id, creation_time) t
ORDER BY date(creation_time) desc, percentage_of_daily_revenue desc, order_id

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260797/

__________________________________

WITH sub_query AS (
  SELECT
    order_id,
    SUM(price) as avg_price,
    ROW_NUMBER() OVER(
      ORDER BY
        SUM(price)
    ) as row_number,
    count(order_id) OVER() as order_count
  FROM
    (
      SELECT
        order_id,
        unnest(product_ids) as product_id
      FROM
        orders
    ) t1
    LEFT JOIN products USING(product_id)
  GROUP BY
    order_id
)
SELECT
  CASE
    WHEN mod(order_count, 2) = 0 THEN (
      SELECT
        SUM(avg_price) / 2
      FROM
        sub_query
      WHERE
        row_number in (order_count / 2, order_count / 2 + 1)
    )
    ELSE (
      SELECT
        avg_price
      FROM
        sub_query
      WHERE
        row_number in (order_count / 2 + 1)
    )
  END AS median_price
FROM
  sub_query
LIMIT
  1

https://lab.karpov.courses/learning/152/module/1762/lesson/17930/53221/260797/

__________________________________

SELECT start_date as date,
       new_users,
       new_couriers,
       (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
       (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
FROM   (SELECT start_date,
               count(courier_id) as new_couriers
        FROM   (SELECT courier_id,
                       min(time::date) as start_date
                FROM   courier_actions
                GROUP BY courier_id) t1
        GROUP BY start_date) t2
    LEFT JOIN (SELECT start_date,
                      count(user_id) as new_users
               FROM   (SELECT user_id,
                              min(time::date) as start_date
                       FROM   user_actions
                       GROUP BY user_id) t3
               GROUP BY start_date) t4 using (start_date)

!!! Число новых пользователей 

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269842/

__________________________________

SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       round(100 * (new_users - lag(new_users, 1) OVER (ORDER BY date)) / lag(new_users, 1) OVER (ORDER BY date)::decimal,
             2) as new_users_change,
       round(100 * (new_couriers - lag(new_couriers, 1) OVER (ORDER BY date)) / lag(new_couriers, 1) OVER (ORDER BY date)::decimal,
             2) as new_couriers_change,
       round(100 * new_users::decimal / lag(total_users, 1) OVER (ORDER BY date),
             2) as total_users_growth,
       round(100 * new_couriers::decimal / lag(total_couriers, 1) OVER (ORDER BY date),
             2) as total_couriers_growth
FROM   (SELECT start_date as date,
               new_users,
               new_couriers,
               (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
               (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
        FROM   (SELECT start_date,
                       count(courier_id) as new_couriers
                FROM   (SELECT courier_id,
                               min(time::date) as start_date
                        FROM   courier_actions
                        GROUP BY courier_id) t1
                GROUP BY start_date) t2
            LEFT JOIN (SELECT start_date,
                              count(user_id) as new_users
                       FROM   (SELECT user_id,
                                      min(time::date) as start_date
                               FROM   user_actions
                               GROUP BY user_id) t3
                       GROUP BY start_date) t4 using (start_date)) t5

+ считает еще прецентаж

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269843/

__________________________________

SELECT date,paying_users,active_couriers
FROM (SELECT *
FROM (SELECT time::date as date, COUNT(DISTINCT user_id) FILTER (WHERE order_id NOT IN (SELECT order_id From user_actions Where action = 'cancel_order')) as paying_users,
COUNT(DISTINCT user_id) as couu
FROM user_actions 
group by 1) u LEFT JOIN
(SELECT time::date as date, COUNT(DISTINCT courier_id) FILTER(WHERE order_id IN (SELECT order_id From courier_actions Where action = 'deliver_order') AND order_id IN (SELECT order_id FROM courier_actions WHERE action = 'accept_order')) as active_couriers,
COUNT(DISTINCT courier_id) as couc
FROM courier_actions 
group by 1) c
USING(date)) t

___________________________________

SELECT date,
       paying_users,
       active_couriers,
       round(100 * paying_users::decimal / total_users, 2) as paying_users_share,
       round(100 * active_couriers::decimal / total_couriers, 2) as active_couriers_share
FROM   (SELECT start_date as date,
               new_users,
               new_couriers,
               (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
               (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
        FROM   (SELECT start_date,
                       count(courier_id) as new_couriers
                FROM   (SELECT courier_id,
                               min(time::date) as start_date
                        FROM   courier_actions
                        GROUP BY courier_id) t1
                GROUP BY start_date) t2
            LEFT JOIN (SELECT start_date,
                              count(user_id) as new_users
                       FROM   (SELECT user_id,
                                      min(time::date) as start_date
                               FROM   user_actions
                               GROUP BY user_id) t3
                       GROUP BY start_date) t4 using (start_date)) t5
    LEFT JOIN (SELECT time::date as date,
                      count(distinct courier_id) as active_couriers
               FROM   courier_actions
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order')
               GROUP BY date) t6 using (date)
    LEFT JOIN (SELECT time::date as date,
                      count(distinct user_id) as paying_users
               FROM   user_actions
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order')
               GROUP BY date) t7 using (date)

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269881/

___________________________________

SELECT day::date AS date,
       ROUND(100*COUNT(DISTINCT user_id) FILTER(WHERE count_orders = 1) / COUNT(DISTINCT user_id)::decimal, 2) AS single_order_users_share,
       ROUND(100*COUNT(DISTINCT user_id) FILTER(WHERE count_orders != 1) / COUNT(DISTINCT user_id)::decimal, 2) AS several_orders_users_share
FROM(

SELECT user_id,
       COUNT(DISTINCT order_id) AS count_orders,
       DATE_TRUNC('day', time) AS day
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY user_id, DATE_TRUNC('day', time)
) AS t1
GROUP BY day
ORDER BY day 

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269886/

___________________________________

SELECT date,
       round(revenue::decimal / users, 2) as arpu,
       round(revenue::decimal / paying_users, 2) as arppu,
       round(revenue::decimal / orders, 2) as aov
FROM   (SELECT creation_time::date as date,
               count(distinct order_id) as orders,
               sum(price) as revenue
        FROM   (SELECT order_id,
                       creation_time,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t1
            LEFT JOIN products using(product_id)
        GROUP BY date) t2
    LEFT JOIN (SELECT time::date as date,
                      count(distinct user_id) as users
               FROM   user_actions
               GROUP BY date) t3 using (date)
    LEFT JOIN (SELECT time::date as date,
                      count(distinct user_id) as paying_users
               FROM   user_actions
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order')
               GROUP BY date) t4 using (date)
ORDER BY date

-- or

SELECT date,
       round(revenue/all_users_per_days, 2) as arpu,
       round(revenue/paying_users_per_days, 2) as arppu,
       round(revenue/count_orders_paying_users, 2) as aov
FROM   (--все пользователи по дням
SELECT time::date as date,
       count(distinct user_id) all_users_per_days
FROM   user_actions
GROUP BY 1
ORDER BY 1) t1 full join (--платящие пользователи по дням
SELECT time::date as date,
       count(distinct user_id) paying_users_per_days,
       count(order_id) as count_orders_paying_users
FROM   user_actions
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  order_id not in(SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order'))
GROUP BY 1
ORDER BY 1) t2 using(date) full join (--выручка по дням
SELECT creation_time::date as date,
       sum(price) as revenue
FROM   (SELECT order_id,
               creation_time,
               unnest(product_ids) as product_id
        FROM   orders) as t1 join products using(product_id)
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  order_id not in(SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order'))
GROUP BY 1) t3 using(date)
ORDER BY 1

!!! arpu , arpuu, aov

___________________________________

SELECT date,
       round(paying_users::decimal / couriers, 2) as users_per_courier,
       round(orders::decimal / couriers, 2) as orders_per_courier
FROM   (SELECT time::date as date,
               count(distinct courier_id) as couriers
        FROM   courier_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY date) t1 join (SELECT creation_time::date as date,
                               count(distinct order_id) as orders
                        FROM   orders
                        WHERE  order_id not in (SELECT order_id
                                                FROM   user_actions
                                                WHERE  action = 'cancel_order')
                        GROUP BY date) t2 using (date) join (SELECT time::date as date,
                                            count(distinct user_id) as paying_users
                                     FROM   user_actions
                                     WHERE  order_id not in (SELECT order_id
                                                             FROM   user_actions
                                                             WHERE  action = 'cancel_order')
                                     GROUP BY date) t3 using (date)
ORDER BY date

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269844/

___________________________________

SELECT date,
       round(avg(delivery_time))::int as minutes_to_deliver
FROM   (SELECT order_id,
               max(time::date) as date,
               extract(epoch
        FROM   max(time) - min(time))/60 as delivery_time
        FROM   courier_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY order_id) t
GROUP BY date
ORDER BY date

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269846/

___________________________________

SELECT *,ROUND(first_orders::decimal * 100 / orders,2) as first_orders_share,ROUND(new_users_orders::decimal * 100 / orders,2) as new_users_orders_share
FROM (SELECT time::date as date,COUNT(DISTINCT order_id) as orders
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order') 
GROUP BY date
ORDER BY date) f1
LEFT JOIN
(SELECT date,COUNT(DISTINCT user_id) as	first_orders
FROM
(SELECT user_id,MIN(time) ::date as date
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY 1) t1
GROUP BY date) f4 USING(date)
LEFT JOIN
(SELECT t1.date,COALESCE(SUM(order_counts),0)::int new_users_orders FROM(
    SELECT min(date(time)) date,user_id 
    FROM   user_actions
    
    GROUP BY 2
    )t1
    LEFT JOIN (
        SELECT date(time) date, user_id, COUNT(order_id) order_counts
        FROM user_actions
        WHERE order_id NOT IN(
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
        )
        GROUP BY 1,2
    )t2
    USING (user_id,date)
GROUP BY 1
ORDER BY 1) f USING(date)

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269880/

___________________________________

SELECT *,
       round(canceled_orders::decimal / (successful_orders + canceled_orders) ,
             3) as cancel_rate
FROM   (SELECT date_part('hour', creation_time)::int as hour,
               count(distinct order_id) as successful_orders
        FROM   orders
        WHERE  order_id in (SELECT order_id
                            FROM   courier_actions
                            WHERE  action = 'deliver_order')
        GROUP BY 1) t1
    LEFT JOIN (SELECT date_part('hour', creation_time)::int as hour,
                      count(distinct order_id) as canceled_orders
               FROM   orders
               WHERE  order_id not in (SELECT order_id
                                       FROM   courier_actions
                                       WHERE  action = 'deliver_order')
               GROUP BY 1) t2 using (hour)
ORDER BY hour

https://lab.karpov.courses/learning/152/module/1881/lesson/19868/57329/269847/

___________________________________

SELECT CASE
WHEN share_in_revenue > 0.50 THEN product_name
ELSE 'ДРУГОЕ' 
END AS product_name,
SUM(revenue) as revenue,SUM(share_in_revenue) as share_in_revenue
FROM
(SELECT name as product_name,SUM(price) as revenue, ROUND(SUM(price)::decimal / 21679095 * 100,2) as share_in_revenue
FROM products LEFT JOIN (SELECT order_id,unnest(product_ids) as product_id FROM orders) t1 USING(product_id) 
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order') 
GROUP BY 1
ORDER BY 2 DESC) t4
GROUP BY 1
ORDER BY revenue DESC

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57851/272092/

___________________________________


SELECT date,
       round(revenue/all_users_per_days, 2) as arpu,
       round(revenue/paying_users_per_days, 2) as arppu,
       round(revenue/count_orders_paying_users, 2) as aov
FROM   (--все пользователи по дням
SELECT DATE_PART('isodow', time ) as date,
       count(distinct user_id) all_users_per_days
FROM   user_actions
WHERE time BETWEEN '08-26-2022' AND '09-08-2022'
GROUP BY 1
ORDER BY 1) t1 full join (--платящие пользователи по дням
SELECT DATE_PART('isodow', time ) as date,
       count(distinct user_id) paying_users_per_days,
       count(order_id) as count_orders_paying_users
FROM   user_actions
WHERE time BETWEEN '08-26-2022' AND '09-08-2022' AND order_id not in (SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order')
GROUP BY 1
ORDER BY 1) t2 using(date) full join (--выручка по дням
SELECT DATE_PART('isodow', creation_time ) as date,
       sum(price) as revenue
FROM   (SELECT order_id,
               creation_time,
               unnest(product_ids) as product_id
        FROM   orders) as t1 join products using(product_id)
WHERE  order_id NOT IN (SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order') AND creation_time BETWEEN '08-26-2022' AND '09-08-2022' 
GROUP BY 1) t3 using(date)
ORDER BY 1

___________________________________

SELECT 'Кампания № 1' as ads_campaign ,
       round(250000::decimal / count(distinct user_id), 2) as cac
FROM   user_actions
WHERE  user_id in (8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732, 8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810, 8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883, 8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004, 9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085, 9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180, 9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313, 9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450, 9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524, 9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605, 9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667, 9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786, 9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871, 9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971, 9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057, 10064, 10082, 10103, 10105, 10122, 10134, 10135)
   and order_id not in (SELECT order_id
                     FROM   user_actions
                     WHERE  action = 'cancel_order')
UNION
SELECT 'Кампания № 2' as ads_campaign ,
       round(250000::decimal / count(distinct user_id), 2) as cac
FROM   user_actions
WHERE  user_id in (8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670, 8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713, 8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803, 8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855, 8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923, 8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973, 8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068, 9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137, 9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207, 9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281, 9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337, 9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432, 9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510, 9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567, 9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666, 9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741, 9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790, 9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879, 9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929, 9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038, 10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075, 10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131)
   and order_id not in (SELECT order_id
                     FROM   user_actions
                     WHERE  action = 'cancel_order')

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/277098/

!!! CAC (Customer Acquisition Cost)
___________________________________


SELECT 'Кампания № 1' as ads_campaign, ROUND((SUM(price) - 250000)::decimal/250000 * 100,2) as roi 
FROM products LEFT JOIN (SELECT order_id,unnest(product_ids) as product_id FROM orders) t USING(product_id) LEFT JOIN user_actions USING(order_id)
WHERE user_id IN (8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732, 8739, 8741, 
8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810, 8815, 8828, 8830, 8845, 
8853, 8859, 8867, 8869, 8876, 8879, 8883, 8896, 8909, 8911, 8933, 8940, 8972, 
8976, 8988, 8990, 9002, 9004, 9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 
9075, 9081, 9085, 9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 
9180, 9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313, 9317, 
9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450, 9451, 9454, 9472, 
9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524, 9526, 9528, 9531, 9535, 9550, 
9559, 9561, 9562, 9599, 9603, 9605, 9611, 9612, 9615, 9625, 9633, 9652, 9654, 
9655, 9660, 9662, 9667, 9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 
9778, 9786, 9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871, 
9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971, 9993, 9998, 
9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057, 10064, 10082, 10103, 
10105, 10122, 10134, 10135) AND order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
UNION 
SELECT 'Кампания № 2' as ads_campaign, ROUND((SUM(price) - 250000)::decimal/250000 * 100,2) as roi 
FROM products LEFT JOIN (SELECT order_id,unnest(product_ids) as product_id FROM orders) t USING(product_id) LEFT JOIN user_actions USING(order_id)
WHERE user_id IN (8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670, 8675, 8680, 8681, 
8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713, 8719, 8729, 8733, 8742, 8748, 8754, 
8771, 8794, 8795, 8798, 8803, 8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 
8854, 8855, 8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923, 8929, 
8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973, 8980, 8995, 8999, 9000, 
9007, 9013, 9041, 9042, 9047, 9064, 9068, 9077, 9082, 9083, 9095, 9103, 9109, 9117, 
9123, 9127, 9131, 9137, 9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 
9207, 9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281, 9282, 9289, 
9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337, 9343, 9356, 9368, 9370, 9383, 
9392, 9404, 9410, 9421, 9428, 9432, 9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 
9498, 9500, 9510, 9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567, 
9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666, 9672, 9684, 9692, 
9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741, 9744, 9749, 9752, 9753, 9755, 9757, 
9764, 9783, 9784, 9788, 9790, 9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 
9877, 9879, 9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929, 9930, 
9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038, 10045, 10047, 10048, 10058, 
10059, 10067, 10069, 10073, 10075, 10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131) AND order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')

!!! ROI 

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/277099/

___________________________________

SELECT ads_campaign,
       round(avg(price), 2) as avg_check FROM(SELECT ads_campaign,
                                              user_id ,
                                              avg(price) as price
                                       FROM   (SELECT 'Кампания № 1' as ads_campaign,
                                                      user_id,
                                                      order_id,
                                                      sum(price) as price
                                               FROM   products
                                                   LEFT JOIN (SELECT order_id,
                                                                     unnest(product_ids) as product_id
                                                              FROM   orders) t using(product_id)
                                                   LEFT JOIN user_actions using(order_id)
                                               WHERE  user_id in (8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732, 8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810, 8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883, 8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004, 9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085, 9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180, 9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313, 9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450, 9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524, 9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605, 9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667, 9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786, 9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871, 9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971, 9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057, 10064, 10082, 10103, 10105, 10122, 10134, 10135)
                                                  and '09-01-2022' <= time::date
                                                  and time::date <= '09-07-2022'
                                                  and order_id not in (SELECT order_id
                                                                    FROM   user_actions
                                                                    WHERE  action = 'cancel_order')
                                               GROUP BY 2, 3
                                               UNION
SELECT 'Кампания № 2' as ads_campaign,
                                                      user_id,
                                                      order_id,
                                                      sum(price) as price
                                               FROM   products
                                                   LEFT JOIN (SELECT order_id,
                                                                     unnest(product_ids) as product_id
                                                              FROM   orders) t using(product_id)
                                                   LEFT JOIN user_actions using(order_id)
                                               WHERE  user_id in (8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670, 8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713, 8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803, 8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855, 8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923, 8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973, 8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068, 9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137, 9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207, 9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281, 9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337, 9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432, 9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510, 9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567, 9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666, 9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741, 9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790, 9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879, 9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929, 9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038, 10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075, 10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131)
                                                  and '09-01-2022' <= time::date
                                                  and time::date <= '09-07-2022'
                                                  and order_id not in (SELECT order_id
                                                                    FROM   user_actions
                                                                    WHERE  action = 'cancel_order')
                                               GROUP BY 2, 3) t1
                                       GROUP BY 1, 2) t2
GROUP BY 1
ORDER BY avg_check desc

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/277100/

___________________________________

SELECT start_month,
       start_date,
       retention,
       day_number
FROM   (SELECT date_trunc('month', start_date) ::date as start_month ,
               dt,
               start_date,
               round(count(distinct user_id)::decimal / max(count(distinct user_id)) OVER(PARTITION BY start_date),
                     2) as retention ,
               row_number() OVER(PARTITION BY start_date) - 1 as day_number
        FROM   (SELECT user_id,
                       min(time::date) OVER(PARTITION BY user_id) as start_date,
                       time::date as dt
                FROM   user_actions) t1
        GROUP BY 1, 2, 3
        ORDER BY start_date) tt
ORDER BY start_date, day_number

--or

SELECT date_trunc('month', start_date)::date as start_month,
       start_date,
       date - start_date as day_number,
       round(users::decimal / max(users) OVER (PARTITION BY start_date), 2) as retention
FROM   (SELECT start_date,
               time::date as date,
               count(distinct user_id) as users
        FROM   (SELECT user_id,
                       time::date,
                       min(time::date) OVER (PARTITION BY user_id) as start_date
                FROM   user_actions) t1
        GROUP BY start_date, time::date) t2

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/277128/

___________________________________

SELECT concat('Кампания № ', ads_campaign) as ads_campaign,
       start_date,
       day_number,
       round(users::decimal / max(users) OVER (PARTITION BY ads_campaign,
                                                            start_date), 2) as retention
FROM   (SELECT ads_campaign,
               start_date,
               date - start_date as day_number,
               count(distinct user_id) as users
        FROM   (SELECT ads_campaign,
                       user_id,
                       date,
                       min(date) OVER (PARTITION BY ads_campaign,
                                                    user_id) as start_date
                FROM   (SELECT user_id,
                               time::date as date,
                               case when user_id in (8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
                                                     8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791,
                                                     8804, 8810, 8815, 8828, 8830, 8845, 8853, 8859, 8867,
                                                     8869, 8876, 8879, 8883, 8896, 8909, 8911, 8933, 8940,
                                                     8972, 8976, 8988, 8990, 9002, 9004, 9009, 9019, 9020,
                                                     9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085, 9089,
                                                     9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175,
                                                     9180, 9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278,
                                                     9287, 9291, 9313, 9317, 9321, 9334, 9351, 9391, 9398,
                                                     9414, 9420, 9422, 9431, 9450, 9451, 9454, 9472, 9476,
                                                     9478, 9491, 9494, 9505, 9512, 9518, 9524, 9526, 9528,
                                                     9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
                                                     9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660,
                                                     9662, 9667, 9677, 9679, 9689, 9695, 9720, 9726, 9739,
                                                     9740, 9762, 9778, 9786, 9794, 9804, 9810, 9813, 9818,
                                                     9828, 9831, 9836, 9838, 9845, 9871, 9887, 9891, 9896,
                                                     9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971, 9993,
                                                     9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051,
                                                     10057, 10064, 10082, 10103, 10105, 10122, 10134, 10135) then 1
                                    when user_id in (8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
                                                     8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704,
                                                     8712, 8713, 8719, 8729, 8733, 8742, 8748, 8754, 8771,
                                                     8794, 8795, 8798, 8803, 8805, 8806, 8812, 8814, 8825,
                                                     8827, 8838, 8849, 8851, 8854, 8855, 8870, 8878, 8882,
                                                     8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923, 8929,
                                                     8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971,
                                                     8973, 8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042,
                                                     9047, 9064, 9068, 9077, 9082, 9083, 9095, 9103, 9109,
                                                     9117, 9123, 9127, 9131, 9137, 9140, 9149, 9161, 9179,
                                                     9181, 9183, 9185, 9190, 9196, 9203, 9207, 9226, 9227,
                                                     9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
                                                     9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333,
                                                     9335, 9337, 9343, 9356, 9368, 9370, 9383, 9392, 9404,
                                                     9410, 9421, 9428, 9432, 9437, 9468, 9479, 9483, 9485,
                                                     9492, 9495, 9497, 9498, 9500, 9510, 9527, 9529, 9530,
                                                     9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567, 9570,
                                                     9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658,
                                                     9666, 9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719,
                                                     9727, 9735, 9741, 9744, 9749, 9752, 9753, 9755, 9757,
                                                     9764, 9783, 9784, 9788, 9790, 9808, 9820, 9839, 9841,
                                                     9843, 9853, 9855, 9859, 9863, 9877, 9879, 9880, 9882,
                                                     9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
                                                     9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033,
                                                     10038, 10045, 10047, 10048, 10058, 10059, 10067, 10069,
                                                     10073, 10075, 10078, 10079, 10081, 10092, 10106, 10110,
                                                     10113, 10131) then 2
                                    else 0 end as ads_campaign
                        FROM   user_actions) t1
                WHERE  ads_campaign in (1, 2)) t2
        GROUP BY ads_campaign, start_date, date) t3
WHERE  day_number in (0, 1, 7)

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/278975/
____________________________________

with main_table as (SELECT ads_campaign,
                           user_id,
                           order_id,
                           time,
                           product_id,
                           price
                    FROM   (SELECT ads_campaign,
                                   user_id,
                                   order_id,
                                   time
                            FROM   (SELECT user_id,
                                           order_id,
                                           time,
                                           case when user_id in (8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
                                                                 8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791,
                                                                 8804, 8810, 8815, 8828, 8830, 8845, 8853, 8859, 8867,
                                                                 8869, 8876, 8879, 8883, 8896, 8909, 8911, 8933, 8940,
                                                                 8972, 8976, 8988, 8990, 9002, 9004, 9009, 9019, 9020,
                                                                 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085, 9089,
                                                                 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175,
                                                                 9180, 9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278,
                                                                 9287, 9291, 9313, 9317, 9321, 9334, 9351, 9391, 9398,
                                                                 9414, 9420, 9422, 9431, 9450, 9451, 9454, 9472, 9476,
                                                                 9478, 9491, 9494, 9505, 9512, 9518, 9524, 9526, 9528,
                                                                 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
                                                                 9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660,
                                                                 9662, 9667, 9677, 9679, 9689, 9695, 9720, 9726, 9739,
                                                                 9740, 9762, 9778, 9786, 9794, 9804, 9810, 9813, 9818,
                                                                 9828, 9831, 9836, 9838, 9845, 9871, 9887, 9891, 9896,
                                                                 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971, 9993,
                                                                 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051,
                                                                 10057, 10064, 10082, 10103, 10105, 10122, 10134, 10135) then 1
                                                when user_id in (8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
                                                                 8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704,
                                                                 8712, 8713, 8719, 8729, 8733, 8742, 8748, 8754, 8771,
                                                                 8794, 8795, 8798, 8803, 8805, 8806, 8812, 8814, 8825,
                                                                 8827, 8838, 8849, 8851, 8854, 8855, 8870, 8878, 8882,
                                                                 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923, 8929,
                                                                 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971,
                                                                 8973, 8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042,
                                                                 9047, 9064, 9068, 9077, 9082, 9083, 9095, 9103, 9109,
                                                                 9117, 9123, 9127, 9131, 9137, 9140, 9149, 9161, 9179,
                                                                 9181, 9183, 9185, 9190, 9196, 9203, 9207, 9226, 9227,
                                                                 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
                                                                 9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333,
                                                                 9335, 9337, 9343, 9356, 9368, 9370, 9383, 9392, 9404,
                                                                 9410, 9421, 9428, 9432, 9437, 9468, 9479, 9483, 9485,
                                                                 9492, 9495, 9497, 9498, 9500, 9510, 9527, 9529, 9530,
                                                                 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567, 9570,
                                                                 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658,
                                                                 9666, 9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719,
                                                                 9727, 9735, 9741, 9744, 9749, 9752, 9753, 9755, 9757,
                                                                 9764, 9783, 9784, 9788, 9790, 9808, 9820, 9839, 9841,
                                                                 9843, 9853, 9855, 9859, 9863, 9877, 9879, 9880, 9882,
                                                                 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
                                                                 9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033,
                                                                 10038, 10045, 10047, 10048, 10058, 10059, 10067, 10069,
                                                                 10073, 10075, 10078, 10079, 10081, 10092, 10106, 10110,
                                                                 10113, 10131) then 2
                                                else 0 end as ads_campaign,
                                           count(action) filter (WHERE action = 'cancel_order') OVER (PARTITION BY order_id) as is_canceled
                                    FROM   user_actions) t1
                            WHERE  ads_campaign in (1, 2)
                               and is_canceled = 0) t2
                        LEFT JOIN (SELECT order_id,
                                          unnest(product_ids) as product_id
                                   FROM   orders) t3 using(order_id)
                        LEFT JOIN products using(product_id))
SELECT concat('Кампания № ', ads_campaign) as ads_campaign,
       concat('Day ', row_number() OVER (PARTITION BY ads_campaign
                                         ORDER BY date) - 1) as day,
       round(sum(revenue) OVER (PARTITION BY ads_campaign
                                ORDER BY date) / paying_users::decimal, 2) as cumulative_arppu,
       cac
FROM   (SELECT ads_campaign,
               time::date as date,
               sum(price) as revenue
        FROM   main_table
        GROUP BY ads_campaign, time::date) t1
    LEFT JOIN (SELECT ads_campaign,
                      count(distinct user_id) as paying_users,
                      round(250000.0 / count(distinct user_id), 2) as cac
               FROM   main_table
               GROUP BY ads_campaign) t2 using (ads_campaign)

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57852/278983/

____________________________________

SELECT date,
       round(sum(revenue) OVER (ORDER BY date)::decimal / sum(new_users) OVER (ORDER BY date),
             2) as running_arpu,
       round(sum(revenue) OVER (ORDER BY date)::decimal / sum(new_paying_users) OVER (ORDER BY date),
             2) as running_arppu,
       round(sum(revenue) OVER (ORDER BY date)::decimal / sum(orders) OVER (ORDER BY date),
             2) as running_aov
FROM   (SELECT creation_time::date as date,
               count(distinct order_id) as orders,
               sum(price) as revenue
        FROM   (SELECT order_id,
                       creation_time,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t1
            LEFT JOIN products using(product_id)
        GROUP BY date) t2
    LEFT JOIN (SELECT time::date as date,
                      count(distinct user_id) as users
               FROM   user_actions
               GROUP BY date) t3 using (date)
    LEFT JOIN (SELECT time::date as date,
                      count(distinct user_id) as paying_users
               FROM   user_actions
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order')
               GROUP BY date) t4 using (date)
    LEFT JOIN (SELECT date,
                      count(user_id) as new_users
               FROM   (SELECT user_id,
                              min(time::date) as date
                       FROM   user_actions
                       GROUP BY user_id) t5
               GROUP BY date) t6 using (date)
    LEFT JOIN (SELECT date,
                      count(user_id) as new_paying_users
               FROM   (SELECT user_id,
                              min(time::date) as date
                       FROM   user_actions
                       WHERE  order_id not in (SELECT order_id
                                               FROM   user_actions
                                               WHERE  action = 'cancel_order')
                       GROUP BY user_id) t7
               GROUP BY date) t8 using (date)

running_arpu, running_arppu, running_aov 

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57851/278982/

___________________________________________

SELECT date,
       revenue,
       costs,
       tax,
       gross_profit,
       total_revenue,
       total_costs,
       total_tax,
       total_gross_profit,
       round(gross_profit / revenue * 100, 2) as gross_profit_ratio,
       round(total_gross_profit / total_revenue * 100, 2) as total_gross_profit_ratio
FROM   (SELECT date,
               revenue,
               costs,
               tax,
               revenue - costs - tax as gross_profit,
               sum(revenue) OVER (ORDER BY date) as total_revenue,
               sum(costs) OVER (ORDER BY date) as total_costs,
               sum(tax) OVER (ORDER BY date) as total_tax,
               sum(revenue - costs - tax) OVER (ORDER BY date) as total_gross_profit
        FROM   (SELECT date,
                       orders_packed,
                       orders_delivered,
                       couriers_count,
                       revenue,
                       case when date_part('month',
                                                                                                                                                                      date) = 8 then 120000.0 + 140 * coalesce(orders_packed, 0) + 150 * coalesce(orders_delivered, 0) + 400 * coalesce(couriers_count, 0)
                            when date_part('month',
                                                                                                                                                                      date) = 9 then 150000.0 + 115 * coalesce(orders_packed, 0) + 150 * coalesce(orders_delivered, 0) + 500 * coalesce(couriers_count, 0) end as costs,
                       tax
                FROM   (SELECT creation_time::date as date,
                               count(distinct order_id) as orders_packed,
                               sum(price) as revenue,
                               sum(tax) as tax
                        FROM   (SELECT order_id,
                                       creation_time,
                                       product_id,
                                       name,
                                       price,
                                       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
                                            else round(price/120*20, 2) end as tax
                                FROM   (SELECT order_id,
                                               creation_time,
                                               unnest(product_ids) as product_id
                                        FROM   orders
                                        WHERE  order_id not in (SELECT order_id
                                                                FROM   user_actions
                                                                WHERE  action = 'cancel_order')) t1
                                    LEFT JOIN products using (product_id)) t2
                        GROUP BY date) t3
                    LEFT JOIN (SELECT time::date as date,
                                      count(distinct order_id) as orders_delivered
                               FROM   courier_actions
                               WHERE  order_id not in (SELECT order_id
                                                       FROM   user_actions
                                                       WHERE  action = 'cancel_order')
                                  and action = 'deliver_order'
                               GROUP BY date) t4 using (date)
                    LEFT JOIN (SELECT date,
                                      count(courier_id) as couriers_count
                               FROM   (SELECT time::date as date,
                                              courier_id,
                                              count(distinct order_id) as orders_delivered
                                       FROM   courier_actions
                                       WHERE  order_id not in (SELECT order_id
                                                               FROM   user_actions
                                                               WHERE  action = 'cancel_order')
                                          and action = 'deliver_order'
                                       GROUP BY date, courier_id having count(distinct order_id) >= 5) t5
                               GROUP BY date) t6 using (date)) t7) t8

https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57851/272093/