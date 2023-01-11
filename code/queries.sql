

--"имя контакта" и "город" (contact_name, country) из таблицы customers (только эти две колонки)
select contact_name,
	country
from customers

--идентификатор заказа и разницу между датами формирования (order_date) заказа
-- и его отгрузкой (shipped_date) из таблицы orders
SELECT order_id, (shipped_date - order_date)
from orders

--все города без повторов, в которых зарегестрированы заказчики (customers)
SELECT city
from customers
group by city

--количество заказов (таблица orders)
select count(*)
from orders

--количество стран, в которые откружался товар (таблица orders, колонка ship_country)
select count(DISTINCT ship_country)
from orders

--заказы, доставленные в страны France, Germany, Spain (таблица orders, колонка ship_country)
select *
from orders
where ship_country = 'France' or ship_country = 'Germany' or ship_country = 'Spain'

--уникальные города и страны, куда отправлялись заказы, отсортировать по странам и городам
-- (таблица orders, колонки ship_country, ship_city)
select ship_city, ship_country
from orders
group by ship_city, ship_country
order by ship_city, ship_country

--сколько дней в среднем уходит на доставку товара в Германию
-- (таблица orders, колонки order_date, shipped_date, ship_country)
select avg(shipped_date - order_date)
from orders
where ship_country = 'Germany'

--минимальную и максимальную цену среди продуктов, не снятых с продажи
-- (таблица products, колонки unit_price, discontinued не равно 1)
select max(unit_price), min(unit_price)
from products
where discontinued <> 1

--минимальную и максимальную цену среди продуктов, не снятых с продажи и которых имеется не меньше 20
-- (таблица products, колонки unit_price, units_in_stock, discontinued не равно 1)
select min(unit_price), max(unit_price)
from products
where discontinued <> 1 and units_in_stock >= 20

--заказы, отправленные в города, заканчивающиеся на 'burg'. Вывести без повторений две колонки
-- (город, страна) (см. таблица orders, колонки ship_city, ship_country)
select ship_city, ship_country
from orders
where ship_city like '%burg'
GROUP by ship_city, ship_country

-- из таблицы orders идентификатор заказа, идентификатор заказчика, вес и страну отгузки.
-- Заказ откружен в страны, начинающиеся на 'P'. Результат отсортирован по весу (по убыванию).
-- Вывести первые 10 записей.
select order_id, customer_id, freight, ship_country
from orders
where ship_country like 'P%'
order by freight desc
limit 10

--фамилию и телефон сотрудников, у которых в данных отсутствует регион (см таблицу employees)
select last_name, home_phone
from employees
where region is null

--количество поставщиков (suppliers) в каждой из стран.
-- Результат отсортировать по убыванию количества поставщиков в стране
select count(*) as co, country
from suppliers
group by country
order by co desc

--суммарный вес заказов (в которых известен регион) по странам, но вывести только те результаты,
--где суммарный вес на страну больше 2750. Отсортировать по убыванию суммарного веса
-- (см таблицу orders, колонки ship_region, ship_country, freight)
select sum(freight) as summ, ship_country
from orders
where ship_region is not null
group by ship_country
having sum(freight) > 2750
order by summ desc

--страны, в которых зарегистированы и заказчики (customers) и поставщики (suppliers) и работники (employees).
SELECT customers.country
FROM customers
INTERSECT
SELECT suppliers.country
FROM suppliers
INTERSECT
SELECT employees.country
FROM employees

--страны, в которых зарегистированы и заказчики (customers) и поставщики
-- (suppliers), но не зарегистрированы работники (employees).
SELECT customers.country
FROM customers
INTERSECT
SELECT suppliers.country
FROM suppliers
EXCEPT
SELECT employees.country
FROM employees
