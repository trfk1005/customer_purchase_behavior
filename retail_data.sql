Create table Customers(
CustomerID	integer	not null primary key,
Year_Birth	integer,				
Education varchar(255),		
Marital_Status varchar(255),		
Income	float,		
Kidhome	integer,		
Teenhome integer,		
Ct_Customer2 timestamp,		
Complain integer
);


Create table Campaign(
CustomerID	integer,
CampaignID integer Not null Primary key,
AcceptedCmp3 integer,	
AcceptedCmp4 integer,	
AcceptedCmp5 integer,	
AcceptedCmp1 integer,	
AcceptedCmp2 integer,	
Response integer,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


create table Transactions(
CustomerID	integer	not null,
TransactionID integer not null primary key,
Recency	integer,		
 MntWines 	float,		
 MntFruits 	float,		
 MntMeatProducts 	float,		
 MntFishProducts 	float,		
 MntSweetProducts 	float,		
 MntGoldProds 	float,		
NumDealsPurchases	integer,		
NumWebPurchases	integer,		
NumCatalogPurchases	integer,		
NumStorePurchases	integer,		
NumWebVisitsMonth	integer,	
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--Checking for empty cells in data
select count(*)
from Customers c 
where Income = '';

--Converting '' cells to null

update Customers  
set Income = nullif(Income, '');

select count(*)
from Customers c 
where Income = '';

select count(*)
from customers 
where income is null;

--Updating the Null Values to the Average value of the Income Coulmn

update Customers 
set Income = (select avg(Income) from Customers)
where Income is Null;

select count(*)
from Customers 
where Income is Null;

--Calculating the Total Number of Customer Encounters in the marketing Campaign Dataset

select count(*) as Total_Customers
from Customers c ;

--Identifying top 10 products

select product, 
ROUND(sum(total_spent),2) as total_spent
from (select 'Wines' as product, MntWines  as total_spent from transactions
union all
select 'Fruits' as product, MntFruits  as total_spent from transactions
union all
select 'Meat Products' as product, MntMeatProducts  as total_spent from Transactions 
union all
select 'Fish Products' as product, MntFishProducts  as total_spent from transactions
union all
select 'Sweet Products' as product, MntSweetProducts  as total_spent from transactions
union all
select 'Gold Products' as product, MntGoldProds  as total_spent from transactions
)p
group by p.product order by total_spent desc
limit 10;

-- Count the Response Values

select ca.response, 
count(*) as Response_Count
from Campaign ca 
group by ca.response;

--Customer Distribution based on Education and Marriage Status

select c.education,
c.marital_status,
count(*) as cust_count
from Customers c 
group by c.Education,
c.Marital_Status 
order by c.Education ,
c.Marital_Status ;

-- Average income of customers participating in the Marketing Campaign

select ROUND(AVG(c.Income), 2) as avg_income
from Customers c
inner join Campaign ca on c.CustomerID = ca.CustomerID
where ca.AcceptedCmp1 = 1
   or ca.AcceptedCmp2 = 1
   or ca.AcceptedCmp3 = 1
   or ca.AcceptedCmp4 = 1
   or ca.AcceptedCmp5 = 1;

--Total number of Promotions Accepted by Customers in each Campaign

select sum(ca.AcceptedCmp1) as Campaign1,
sum(ca.AcceptedCmp2) as Campaign2, 
sum(ca.AcceptedCmp3) as Campaign3, 
sum(ca.AcceptedCmp4) as Campaign4, 
sum(ca.AcceptedCmp5) as Campaign5
from campaign ca
where ca.AcceptedCmp1 = 1
   or ca.AcceptedCmp2 = 1
   or ca.AcceptedCmp3 = 1
   or ca.AcceptedCmp4 = 1
   or ca.AcceptedCmp5 = 1;

-- Distribution of Customers' Responses to the Last Campaign

select ca.response,
count(*) as count,
ROUND(count(*) * 100.0 / sum(count(*)) over (), 2) as pct
from campaign ca
group by response;

-- The average number of children and teenagers in customers' household

select round(avg(c.kidhome),2) as AVG_Kids,
round(avg(c.teenhome),2) as AVG_Teen
from customers c;


-- Create an age column by subtracting year_birth from the current year

/*alter table customers add column Age integer;
update customers 
set Age = cast(strftime('%Y', 'now') as integer) - customers.Year_Birth ;*/

select *
from customers c;

-- Create an Age_group columns

/*alter table Customers add column Age_Group varchar(255); 
Update Customers  
set Age_Group = Case
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	else '56+'
end;*/

select Age_Group,
age
from customers;

--Determin average number of visits per month for customers in each age group

select c.age_group,
round(avg(t.numwebvisitsmonth),2) as AVG_Vistits_Per_month,
count(distinct c.customerID) as Unique_customer_count
from customers c 
inner join Transactions t on c.CustomerID = t.CustomerID
group by c.age_group
order by c.age_group;

--Planning of Connection code for Python
select c.*, 
ca.AcceptedCmp3,	
ca.AcceptedCmp4,	
ca.AcceptedCmp5,	
ca.AcceptedCmp1,	
ca.AcceptedCmp2,	
ca.Response, 
t.Recency,		
t.MntWines,		
t.MntFruits,		
t.MntMeatProducts,		
t.MntFishProducts ,		
t.MntSweetProducts,		
t.MntGoldProds,		
t.NumDealsPurchases,		
t.NumWebPurchases,		
t.NumCatalogPurchases,		
t.NumStorePurchases,		
t.NumWebVisitsMonth
FROM Customers c
LEFT JOIN Campaign ca ON c.CustomerID = ca.CustomerID
LEFT JOIN Transactions t ON c.CustomerID = t.CustomerID;
