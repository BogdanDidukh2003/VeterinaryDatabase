SET GLOBAL sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

Use Labor_SQL;

-- 1 Знайти виробників ПК. Вивести: maker, type. Вихідні дані впорядкувати за спаданням за стовпцем maker.
select maker, type
from Product
where type = 'PC'
order by maker desc;

-- 2. З таблиці Pass_in_trip вивести дати, коли були зайняті місця 'c' у будь-якому ряді.
select distinct date
from Pass_in_trip
where place like '%c';

-- 3. Для пасажирів таблиці Passenger вивести дати, коли вони користувалися послугами авіаліній.
select Passenger.name, Pass_in_trip.date as trip_date
from Passenger
         right join Pass_in_trip
                    on Passenger.ID_psg = Pass_in_trip.ID_psg;

-- 4. Вивести класи всіх кораблів України ('Ukraine'). Якщо в БД немає класів кораблів України, тоді вивести класи для
-- всіх наявних у БД країн. Вивести: country, class.
select class, country
from classes
where (if('Ukraine' in (select country from Classes),
          country = 'Ukraine',
          country = country));

-- 5 Виведіть тих виробників ноутбуків, які не випускають принтери.
select distinct maker
from Product
where type = 'Laptop'
  and maker not in (select maker from Product where type = 'Printer');

-- 6 Для таблиці Printer вивести всю інформацію з коментарями в кожній комірці, наприклад, 'модель: 1276', 'ціна:
-- 400,00' і т.д.
select concat('code ', code)   as code,
       concat('model ', model) as model,
       concat('color ', color) as color,
       concat('type ', type)   as type,
       concat('price ', price) as price
from Printer;

-- 7 Для кожної країни визначити рік, у якому було спущено на воду максимальна кількість її кораблів. У випадку, якщо
-- виявиться декілька таких років, тоді взяти мінімальний із них. Вивести: country, кількість кораблів, рік.
select *
from (SELECT classes.country as inner_country, COUNT(*) as number_of_ships, ships.launched as year
            from classes
                     right join ships
                                on classes.class = ships.class
            group by inner_country, year order by inner_country, number_of_ships desc, year) as icnosy
group by inner_country;

-- 8 Для таблиці Product отримати підсумковий набір у вигляді таблиці зі стовпцями maker, pc, laptop та printer,
-- у якій для кожного виробника необхідно вказати кількість продукції, що ним випускається,
-- тобто наявну загальну кількість продукції в таблицях, відповідно, PC, Laptop та Printer.
-- (Підказка: використовувати підзапити в якості обчислювальних стовпців)
select distinct maker,
                (select count(type) from Product where type = 'PC' and Product.maker = maker)      as 'PC',
                (select count(type) from Product where type = 'Laptop' and Product.maker = maker)  as 'Laptop',
                (select count(type) from Product where type = 'Printer' and Product.maker = maker) as 'Printer'
from Product;

-- 9 Для таблиці Product отримати підсумковий набір у вигляді таблиці зі стовпцями maker, laptop, у якій для кожного
-- виробника необхідно вказати, чи виробляє він ('yes'), чи ні ('no') відповідний тип продукції.
-- У першому випадку ('yes') додатково вказати поруч у круглих дужках загальну кількість наявної (тобто, що
-- знаходиться в таблиці Laptop) продукції, наприклад, 'yes(2)'. (Підказка:
-- використовувати підзапити в якості обчислювальних стовпців та оператор CASE)
SELECT maker,
       IF((SELECT COUNT(*) FROM Product WHERE type = 'Laptop' GROUP BY maker HAVING maker = _product.maker) IS NOT NULL,
          concat('yes(',
                 (SELECT COUNT(*) FROM Product WHERE type = 'Laptop' GROUP BY maker HAVING maker = _product.maker),
                 ')'),
          'no')
           AS Laptop
FROM Product _product
GROUP BY maker;

-- 10 Знайдіть класи, до яких входить лише один корабель з усієї БД (врахувати також кораблі в таблиці Outcomes, яких
-- немає в таблиці Ships). Вивести: class. (Підказка: використовувати оператор UNION та операцію EXISTS)
SELECT class,
       (SELECT COUNT(*)
        FROM Ships
        WHERE Ships.class = Classes.class
       ) AS number_of_ships
FROM Classes
WHERE EXISTS(SELECT * FROM Ships WHERE Ships.class = Classes.class)
HAVING number_of_ships = 1
UNION
SELECT class,
       (SELECT COUNT(*)
        FROM Outcomes
        WHERE Classes.class = Outcomes.ship
       ) AS number_of_ships
FROM Classes
WHERE EXISTS(SELECT * FROM Outcomes WHERE Classes.class = Outcomes.ship)
  AND NOT EXISTS(SELECT * FROM Ships WHERE Ships.class = Classes.class)
HAVING number_of_ships = 1;





