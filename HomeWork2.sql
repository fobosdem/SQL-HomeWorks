use HomeWork2Sql;

select Category from dbo.Sheet1$ group by Category;
--создание таблицы категорий
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Catagory] [nvarchar] (100) NOT NULL
);
ALTER TABLE [dbo].[Category] ADD UNIQUE ([Catagory]);

--наполнение категорий
insert into dbo.Category
select Category from dbo.Sheet1$ group by Category;

--создание таблицы сабкатегорий
CREATE TABLE [dbo].[Sub-Category](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Sub-Catagory] [nvarchar] (100) NOT NULL,
	[Category Id] [int] NOT NULL
);
ALTER TABLE [dbo].[Sub-Category] ADD UNIQUE ([Sub-Catagory]);
ALTER TABLE [dbo].[Sub-Category] WITH CHECK ADD FOREIGN KEY([Category Id]) REFERENCES [dbo].[Category] ([Id]);

--наполнение таблицы сабкатегорий
insert into dbo.[Sub-Category]
select db.[Sub-Category], cat.Id  from dbo.Sheet1$ db
left join dbo.Category cat ON cat.Catagory = db.Category
group by db.[Sub-Category], cat.Id;

--Создание таблицы продуктов
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Producy Id] [nvarchar] (255) NOT NULL,
	[Product Name] [nvarchar] (255) NOT NULL,
	[Product Price] [money] not null,
	[Product Profit] [float] not null,
	[Sub-Catagory Id] [int] NOT NULL
);
ALTER TABLE [dbo].[Product] ADD UNIQUE ([Producy Id]);
ALTER TABLE [dbo].[Product] WITH CHECK ADD FOREIGN KEY([Sub-Catagory Id]) REFERENCES dbo.[Sub-Category] ([Id]);

--наполнение таблицы продуктов
insert into dbo.Product
select db.[Product ID], db.[Product Name], ROUND((db.Sales/db.Quantity)/(1-db.Discount), 2), ROUND((db.Profit/(db.Quantity*((db.Sales/db.Quantity)/(1-db.Discount)))+db.Discount),2), subcat.Id
from dbo.Sheet1$ db
left join dbo.[Sub-Category] subcat ON subcat.[Sub-Catagory] = db.[Sub-Category]
group by db.[Product ID], db.[Product Name], ROUND((db.Sales/db.Quantity)/(1-db.Discount), 2), ROUND((db.Profit/(db.Quantity*((db.Sales/db.Quantity)/(1-db.Discount)))+db.Discount),2), subcat.Id;


--создание таблицы сегмент
CREATE TABLE [dbo].[Segment](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Segment] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[Segment] ADD UNIQUE ([Segment]);
--наполнение таблицы сегмент
insert into Segment
Select db.[Segment] from dbo.Sheet1$ db
Group by db.Segment;

--создание таблицы Country
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CountryName] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[Country] ADD UNIQUE ([CountryName]);

--наполнение Country
insert into dbo.Country
select db.Country
from dbo.Sheet1$ db
group by db.Country;

--создание region
CREATE TABLE [dbo].[Region](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[RegionName] [nvarchar] (255) NOT NULL,
	[CountryId] [int] NOT NULL
);
ALTER TABLE [dbo].[Region] ADD UNIQUE ([RegionName]);
ALTER TABLE [dbo].[Region] WITH CHECK ADD FOREIGN KEY([CountryId]) REFERENCES dbo.Country ([Id]);

--наполнение Region
insert into dbo.Region
select db.Region, con.Id
from dbo.Sheet1$ db
left join dbo.Country con on con.CountryName = db.Country
group by db.Region, con.Id;

--создание State
CREATE TABLE [dbo].[State](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[StateName] [nvarchar] (255) NOT NULL,
	[RegionId] [int] NOT NULL
);
ALTER TABLE [dbo].[State] ADD UNIQUE ([StateName]);
ALTER TABLE [dbo].[State] WITH CHECK ADD FOREIGN KEY([RegionId]) REFERENCES dbo.Region ([Id]);
--Наполнение Region
insert into dbo.[State]
select db.[State], reg.Id
from dbo.Sheet1$ db
left join dbo.Region reg on reg.RegionName = db.Region
group by db.[State], reg.Id;

--Создание City
CREATE TABLE [dbo].[City](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CityName] [nvarchar] (255) NOT NULL,
	[StateId] [int] NOT NULL
);
ALTER TABLE [dbo].[City] ADD CONSTRAINT citiesStates UNIQUE ([CityName], [StateId]);
ALTER TABLE [dbo].[City] WITH CHECK ADD FOREIGN KEY([StateId]) REFERENCES dbo.[State] ([Id]);

--наполнение City
insert into dbo.[City]
select db.[City], st.Id
from dbo.Sheet1$ db
left join dbo.State st on st.StateName = db.State
group by db.[City], st.Id;

--создание Postal Code
CREATE TABLE [dbo].[PostalCode](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[PostalCode] [int] NOT NULL,
	[CityId] [int] NOT NULL
);
ALTER TABLE [dbo].[PostalCode] ADD CONSTRAINT postalCodesCity UNIQUE ([PostalCode], [CityId]);
ALTER TABLE [dbo].[PostalCode] WITH CHECK ADD FOREIGN KEY([CityId]) REFERENCES dbo.City ([Id]);

--наполнение Postal Code
insert into dbo.PostalCode
select db.[Postal Code], cit.Id
from dbo.Sheet1$ db
left join dbo.City cit on cit.CityName = db.City
group by db.[Postal Code], cit.Id;

--создание Customer
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CustomerId] [nvarchar] (255) NOT NULL,
	[CustomerName] [nvarchar] (255) NOT NULL,
	[SegmentId] [int] NOT NULL
);
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT uniqCustomer UNIQUE ([CustomerId], [CustomerName]);
ALTER TABLE [dbo].[Customer] WITH CHECK ADD FOREIGN KEY([SegmentId]) REFERENCES dbo.Segment ([Id]);

--наполнение Customer
insert into dbo.Customer
select db.[Customer ID], db.[Customer Name], seg.Id
from dbo.Sheet1$ db
left join dbo.Segment seg on seg.Segment = db.Segment
group by db.[Customer ID], db.[Customer Name], seg.Id;

--создание Ship mode
CREATE TABLE [dbo].[Ship Mode](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[ShipModeName] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[Ship Mode] ADD UNIQUE ([ShipModeName]);

--наполнение Country
insert into dbo.[Ship Mode]
select db.[Ship Mode]
from dbo.Sheet1$ db
group by db.[Ship Mode];


--Создание таблицы Order
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[OrderId] [varchar] (255) NOT NULL,
	[Order Date] [datetime] NOT NULL,
	[Ship Date] [datetime] NOT NULL,
	[ShipModeId] [int] NOT NULL,
	[PostalCodeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [float] NOT NULL,
	[Profit] [money] NOT NULL
);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([ShipModeId]) REFERENCES dbo.[Ship Mode] ([Id]);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([PostalCodeId]) REFERENCES dbo.[PostalCode] ([Id]);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([CustomerId]) REFERENCES dbo.Customer ([Id]);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([ProductId]) REFERENCES dbo.Product ([Id]);

---наполнение таблицы Order
insert into dbo.[Order]
select db.[Order ID], db.[Order Date], db.[Ship Date], sm.Id, pc.Id, cust.Id, prod.Id, db.Quantity, db.Discount, db.Profit
from dbo.Sheet1$ db
left join dbo.[Ship Mode] sm on sm.ShipModeName = db.[Ship Mode]
left join dbo.PostalCode pc on pc.PostalCode = db.[Postal Code]
left join dbo.Customer cust on cust.CustomerId = db.[Customer ID]
left join dbo.Product prod on prod.[Producy Id] = db.[Product ID]
group by db.[Order ID], db.[Order Date], db.[Ship Date], sm.Id, pc.Id, cust.Id, prod.Id, db.Quantity, db.Discount, db.Profit;

--общий профит
select SUM(db.Profit)
from dbo.[Order] db;