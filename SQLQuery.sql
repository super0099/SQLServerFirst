select * from sales.customers 
right join sales.orders
on orders.customer_id = customers.customer_id
;
select * from sales.order_items o
right  join production.products p
on p.product_id = o.product_id
;

select c.* , b.* from sales.customers  c
cross join production.brands b
;
select * from  sales.customers;
select * from  production.brands;

select * fRom sales.staffs

seleCT manager_id frOm  sales.staffs 
WherE last_name = 'David'

seleCT * frOm  sales.staffs 
WherE staff_id = 1;

select m.staff_id 经理id,m.last_name 经理名字,e.staff_id
from  sales.staffs  e
inner join sales.staffs  m
on e.manager_id = m.staff_id

where e.last_name ='David'


select c.last_name , o.order_id frOm sales.customers c
full outer join sales.orders o
on c.customer_id = o.customer_id
oRdEr by c.last_name


select customer_id,store_id,max(order_date)
from  sales.orders
group by customer_id,store_id;

select * from  sales.orders
-- 查询返回客户按年度下达的订单数：
select customer_id ,count(*) 下单数
from sales.orders
group by customer_id
order by customer_id
;

select category_id,avg(list_price) 
from production.products
group by category_id
order by category_id desc 

select * from sales.customers;
-- 每个城市有多少客户,筛选城市客户数量大于50的城市
select city,count(customer_id)
from  sales.customers
group by city
having count(customer_id) >50
;

--用子查询来查找位于纽约(`New York`)的客户的销售订单

select * from sales.customers where city = 'New York';


select * from sales.orders 
where customer_id 
= (select customer_id 
	from sales.customers 
	where city = 'New York' 
	and customer_id in( select customer_id 
						from sales.customers
						where customer_id <20
						)
	);
--- 查找价格高于`'上海永久'`和`'凤凰'`品牌的所有产品
--的平均定价的产品。

SELECT
  *
FROM
  production.products
WHERE
  list_price > (
    SELECT
      avg(list_price)
    FROM
      production.products
    WHERE
      product_name LIKE '%上海永久%'
      OR product_name LIKE '%凤凰%'
  );

---提问1：每个员工的上级领导名字
--- 每个经理的下属员工
select manager_id,staff_id,last_name from sales.staffs 
where manager_id is not null
order by manager_id
--- 员工‘Wiggins’ 的经理管理的所有员工


select  manager_id,staff_id,last_name from sales.staffs
where manager_id = (
select manager_id 
			from sales.staffs 
			where last_name = 'Wiggins'
			)


select  manager_id,staff_id,last_name from sales.staffs
where manager_id = (
			select manager_id 
			from sales.staffs 
			where last_name = 'Wiggins'
			);

---提问2：返回所有型号年份为`2018`的最低和最高价产品：

select category_id,max(list_price),min(list_price),AVG(list_price),count(*)
from production.products
where model_year = 2018
group by category_id


---返回型号年份为`2018`年的所有产品的平均价格
--- select * from a,b
--- select * from a,b where ...
--- select * from a cross join b 
--- 使用`SUM()`函数获取每个订单的总价值：sum（单个条目价格（数量*价格））

select * from sales.customers  c,sales.orders o
where c.customer_id = o.customer_id

select * from sales.customers  c 
inner join
sales.orders o
on c.customer_id > 0



----



--- 价格等于其类别的最高价格的产品。

select * from  production.products p1
inner join
(
select category_id,max(list_price) max_price
from production.products
group by category_id
) p2
on p1.category_id =p2.category_id  and p1.list_price = p2.max_price
;
select * from production.products
order by category_id,list_price
;

--- 价格等于其类别的最高价格的产品。
select * from  production.products p1
where list_price in (
select max(list_price) from production.products p2
where p1.category_id = p2.category_id
group by category_id
);

--- 查找已下过两个以上订单的所有客户： 用exists  相关子查询

select * from sales.customers c
where exists (
select customer_id,count(*) from sales.orders o
where c.customer_id = o.customer_id
group by customer_id
having count(*) >2)
;

SELECT
  *
FROM
  sales.customers c
WHERE
  c.customer_id IN (
    SELECT
      customer_id
    FROM
      sales.orders o
    GROUP BY
      customer_id
    HAVING
      count(*) > 2
  );

select * from sales.customers 
where exists (
	
	select  phone from sales.customers where phone  = '123456789'
)


--查找销售订单中销售数量超过`2`个的产品：

select  product_id,sum(quantity) from sales.order_items 
group by product_id
having  sum(quantity) >2

select * from production.products
where product_id = any (
select  product_id from sales.order_items 
group by product_id
having  sum(quantity) >2
);


select * from production.products 
where list_price  < any (
	select distinct list_price from production.products 
	where list_price in (379.99,749.99,999.99)
);

select * from production.products 
where list_price  < all (
	select distinct list_price from production.products 
	where list_price in (379.99,749.99,999.99)
);

  -- union (all)

  -- 1444
  select     first_name,last_name from sales.customers
  union all
  -- 10
  select last_name,first_name from sales.staffs

  order  by first_name
  ;

  select   * from sales.customers
SELECT
  first_name,
  last_name
FROM
  sales.customers
WHERE
  city = 'Buffalo'
INTERSECT
SELECT
  first_name,
  last_name
FROM
  sales.customers
WHERE
  city = 'Uniondale'
;
-- 1 4 567
select distinct brand_id, category_id from production.products where brand_id = 9
intersect
--467
select distinct brand_id, category_id from production.products where brand_id = 8
;

-- except 


--4 6 7 
select distinct  category_id from production.products where brand_id = 8
except
-- 1 4 567
select distinct  category_id from production.products where brand_id = 9
;

--
drop table sales.promotions;
CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
);
select * from sales.promotions;

set identity_insert  sales.promotions on;
insert  into sales.promotions (promotion_name,discount,start_date,expired_date)
values ('test123459',0.256,'2022-03-10','2022-12-10');
set identity_insert  sales.promotions off;

-- 1000
insert  into sales.promotions (promotion_name,discount,start_date,expired_date)
values ('test123457',0.256,'2022-03-10','2022-12-10'),
		('test123458',0.23,'2022-03-10','2022-12-10');

select * from sales.addresses;

insert into sales.addresses (street,city,state,zip_code)
select street,city,state,zip_code from sales.customers




select * from sales.customers

select * from sales.taxes;

update sales.taxes set updated_at ='2022-03-10';
update sales.taxes set updated_at =getdate();

select * from sales.taxes where state = 'Alabama';

update sales.taxes set max_local_tax_rate +=0.01
,avg_local_tax_rate +=0.01
where state = 'Alabama';

delete from sales.taxes where  state = 'Alabama';

select * from sales.category; --target
select * from sales.category_staging; --source

merge sales.category t using sales.category_staging s
on t.category_id = s.category_id
when matched
	then update set t.category_name = s.category_name
			,t.amount = s.amount
when not matched by target 
	then insert (category_id,category_name,amount)  --此处不能使用别名
		values (s.category_id,s.category_name,s.amount)
when  not matched by source
	then delete;

select * from sales.category
































