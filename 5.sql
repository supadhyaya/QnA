/*
1. Following could be our stakeholders and their questions:
	1. Office Manager
	2. Finance Manager
	3. Employees
	4. Maintance Worker, etc.

2. Possible KPIs could be as follows as per the stake holders
	1. Daily coffee consumption -- Office Manager.
	2. Least used time of the day for coffee machine -- Maintance Worker
	3. Expense incured everyday through coffee machine -- Finance Manager
	4. When coffee machine is most busy or which coffee machine is out of function -- Employees
	
	Following fancy KPIs can also be created in addition
	5. Coffee consumed in various seasons.
	6. Most popular drink on every season based on total number of users.
	7. Total money spent on average per user.
	8. Total amount of water, milk and coffee beans used per user.
	9. Total amount of water, milk and coffee beans used per year.
	10. Most coffee consuming department -- Might be indicator of stress ?
	11. Users using coffee machines from other departments. 
	12. Total time spent by each user on coffee machine.
	13. Total time spent on average by each user, etc.


3. 
A simple star schema will be adequate to represent the data model. Script for the star schema is at the bottom of 
this file.

There will be one fact table with 4 dimensions linked to it and will have only one measure called duration
which records the time required for preparing coffee. With all other associated dimension table, analyst
can prepare various reports. 

NOTE: Quantity and price of the products are assumed fixed and known so they are part of the product dimension.

Possible problems with the model: User can work at multiple city or department which our model does not take into account.
Another possible logical restriction to this model is, fact table itself does not contain the quantity of 
ingredients used which means that any customization made by the user when the coffee is being prepared is
not taken into account (Since I am assuming, ingredients are fixed and can't be changed).
*/

--4.
--Average preparation time per user:

select 
	avg(duration_in_seconds) as avg_preparation_time, 
	dim_user_id 
from 
	test.fact_coffee_machine
group by 
	dim_user_id
order by 
	avg(duration_in_seconds) desc


--Coffee made per department per day

select 
	d.date::date, 
	m.department, 
	count(a.*) as coffee_made 
from 
	test.fact_coffee_machine a
left join 
	test.dim_machine m
	on a.dim_machine_id = m.dim_machine_id
left join 
	test.dim_date d
	on d.dim_date_id = a.dim_date_id
group by 
	m.department,d.date::date
order by 
	coffee_made desc


--Expense incured per department per day

select d.date::date, 
	m.department, 
	count(a.*) as coffee_made, 
	sum(p.product_price) as price 
from 
	test.fact_coffee_machine a
left join 
	test.dim_machine m
on a.dim_machine_id = m.dim_machine_id
left join 
	test.dim_date d
on d.dim_date_id = a.dim_date_id
left join 
	test.dim_product p
on p.dim_product_id = a.dim_product_id
group by 
	m.department,d.date::date
order by 
	price desc



/*

create table test.dim_product
(
	dim_product_id INTEGER      NOT NULL,
	product_name varchar(200),
	water_qty integer,
	milk_qty integer,
	coffe_beans_qty integer,
	product_price  FLOAT,
	PRIMARY KEY (dim_product_id)
);

create table test.dim_machine(
	dim_machine_id INTEGER NOT NULL,
	city varchar(200),
	date_bought date,
	is_working BOOLEAN,
	department varchar(200),
	PRIMARY KEY  (dim_machine_id)
);

create table test.dim_date(
	dim_date_id INTEGER NOT NULL,
	date TIMESTAMP,
	year varchar(200),
	month varchar(200),
	day varchar(200),
	hour integer,
	season varchar(200),
	PRIMARY KEY (dim_date_id)
);


create table test.dim_user(
	dim_user_id integer not null,
	user_name varchar (200),
	department varchar(200),
	city varchar(200),
	email varchar(300),
	work_title varchar(300),
	PRIMARY KEY (dim_user_id)
);


create table test.fact_coffee_machine(
	dim_user_id integer
		constraint fact_coffee_machine_dim_user_id_fkey
			references test.dim_user,
	dim_date_id integer
		constraint fact_coffee_machine_dim_date_id_fkey
			references test.dim_date,
	dim_product_id integer
		constraint fact_coffee_machine_dim_product_id_fkey
			references test.dim_product,
	dim_machine_id integer
		constraint fact_coffee_machine_dim_machine_id_fkey
			references test.dim_machine,
	duration_in_seconds integer
);


INSERT INTO test.dim_date (dim_date_id, date, year, month, day, hour, season) VALUES (1, '2019-05-06 16:14:01.770000', '2019', 'may', '1', 15, 'winter');

INSERT INTO test.dim_machine (dim_machine_id, city, date_bought, is_working, department) VALUES (1, 'Munich', null, true, 'BI');
INSERT INTO test.dim_machine (dim_machine_id, city, date_bought, is_working, department) VALUES (2, 'Berlin', null, true, 'Finance');

INSERT INTO test.dim_product (dim_product_id, product_name, water_qty, milk_qty, coffe_beans_qty, product_price) VALUES (1, 'Cappuccino', 2, 1, 5, 10);
INSERT INTO test.dim_product (dim_product_id, product_name, water_qty, milk_qty, coffe_beans_qty, product_price) VALUES (2, 'expresso', 3, 1, 2, 5);

INSERT INTO test.dim_user (dim_user_id, user_name, department, city, email, work_title) VALUES (1, 'sanjiv', 'bi', null, null, null);

INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 1, 1, 200);
INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 1, 1, 300);
INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 1, 1, 500);
INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 2, 1, 50);
INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 2, 2, 50);
INSERT INTO test.fact_coffee_machine (dim_user_id, dim_date_id, dim_product_id, dim_machine_id, duration_in_seconds) VALUES (1, 1, 2, 2, 50);

*/

