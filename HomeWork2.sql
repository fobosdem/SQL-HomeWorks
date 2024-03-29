use HomeWork2Sql;

select Category from dbo.Sheet1$ group by Category;
--�������� ������� ���������
	CREATE TABLE [dbo].[Category](
		[Id] [int] IDENTITY(1,1) PRIMARY KEY,
		[Catagory] [nvarchar] (100) NOT NULL,
		[ParentCategoryId] [int] NULL
	);
	ALTER TABLE [dbo].[Category] ADD UNIQUE ([Catagory]);
	ALTER TABLE [dbo].[Category] WITH CHECK ADD FOREIGN KEY([ParentCategoryId]) REFERENCES [dbo].[Category] ([Id]);

--���������� ���������
insert into dbo.Category
select Category, NULL from dbo.Sheet1$ group by Category;

--���������� ������� ��������� �������������
insert into dbo.[Category]
select db.[Sub-Category], cat.Id from dbo.Sheet1$ db
left join dbo.[Category] cat ON cat.Catagory = db.Category
group by db.[Sub-Category], cat.Id;

--�������� ������� ���������
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[ProducyId] [nvarchar] (255) NOT NULL,
	[ProductName] [nvarchar] (255) NOT NULL,
	[ProductPrice] [money] not null,
	[ProductProfit] [float] not null,
	[SubCatagoryId] [int] NOT NULL
);
ALTER TABLE [dbo].[Product] ADD UNIQUE ([ProducyId]);
ALTER TABLE [dbo].[Product] WITH CHECK ADD FOREIGN KEY([SubCatagoryId]) REFERENCES dbo.[SubCategory] ([Id]);

--���������� ������� ���������
insert into dbo.Product
select db.[Product ID], db.[Product Name], ROUND((db.Sales/db.Quantity)/(1-db.Discount), 2), ROUND((db.Profit/(db.Quantity*((db.Sales/db.Quantity)/(1-db.Discount)))+db.Discount),2), subcat.Id
from dbo.Sheet1$ db
left join dbo.[SubCategory] subcat ON subcat.[SubCatagory] = db.[Sub-Category]
group by db.[Product ID], db.[Product Name], ROUND((db.Sales/db.Quantity)/(1-db.Discount), 2), ROUND((db.Profit/(db.Quantity*((db.Sales/db.Quantity)/(1-db.Discount)))+db.Discount),2), subcat.Id;


--�������� ������� �������
CREATE TABLE [dbo].[Segment](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[Segment] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[Segment] ADD UNIQUE ([Segment]);
--���������� ������� �������
insert into Segment
Select db.[Segment] from dbo.Sheet1$ db
Group by db.Segment;

--�������� ������� Country
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CountryName] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[Country] ADD UNIQUE ([CountryName]);

--���������� Country
insert into dbo.Country
select db.Country
from dbo.Sheet1$ db
group by db.Country;

--�������� region
CREATE TABLE [dbo].[Region](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[RegionName] [nvarchar] (255) NOT NULL,
	[CountryId] [int] NOT NULL
);
ALTER TABLE [dbo].[Region] ADD UNIQUE ([RegionName]);
ALTER TABLE [dbo].[Region] WITH CHECK ADD FOREIGN KEY([CountryId]) REFERENCES dbo.Country ([Id]);

--���������� Region
insert into dbo.Region
select db.Region, con.Id
from dbo.Sheet1$ db
left join dbo.Country con on con.CountryName = db.Country
group by db.Region, con.Id;

--�������� State
CREATE TABLE [dbo].[State](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[StateName] [nvarchar] (255) NOT NULL,
	[RegionId] [int] NOT NULL
);
ALTER TABLE [dbo].[State] ADD UNIQUE ([StateName]);
ALTER TABLE [dbo].[State] WITH CHECK ADD FOREIGN KEY([RegionId]) REFERENCES dbo.Region ([Id]);
--���������� Region
insert into dbo.[State]
select db.[State], reg.Id
from dbo.Sheet1$ db
left join dbo.Region reg on reg.RegionName = db.Region
group by db.[State], reg.Id;

--�������� City
CREATE TABLE [dbo].[City](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CityName] [nvarchar] (255) NOT NULL,
	[StateId] [int] NOT NULL
);
ALTER TABLE [dbo].[City] ADD CONSTRAINT citiesStates UNIQUE ([CityName], [StateId]);
ALTER TABLE [dbo].[City] WITH CHECK ADD FOREIGN KEY([StateId]) REFERENCES dbo.[State] ([Id]);

--���������� City
insert into dbo.[City]
select db.[City], st.Id
from dbo.Sheet1$ db
left join dbo.State st on st.StateName = db.State
group by db.[City], st.Id;

--�������� Postal Code
CREATE TABLE [dbo].[PostalCode](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[PostalCode] [int] NOT NULL,
	[CityId] [int] NOT NULL
);
ALTER TABLE [dbo].[PostalCode] ADD CONSTRAINT postalCodesCity UNIQUE ([PostalCode], [CityId]);
ALTER TABLE [dbo].[PostalCode] WITH CHECK ADD FOREIGN KEY([CityId]) REFERENCES dbo.City ([Id]);

--���������� Postal Code
insert into dbo.PostalCode
select db.[Postal Code], cit.Id
from dbo.Sheet1$ db
left join dbo.City cit on cit.CityName = db.City
group by db.[Postal Code], cit.Id;

--�������� Customer
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[CustomerId] [nvarchar] (255) NOT NULL,
	[CustomerName] [nvarchar] (255) NOT NULL,
	[SegmentId] [int] NOT NULL
);
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT uniqCustomer UNIQUE ([CustomerId], [CustomerName]);
ALTER TABLE [dbo].[Customer] WITH CHECK ADD FOREIGN KEY([SegmentId]) REFERENCES dbo.Segment ([Id]);

--���������� Customer
insert into dbo.Customer
select db.[Customer ID], db.[Customer Name], seg.Id
from dbo.Sheet1$ db
left join dbo.Segment seg on seg.Segment = db.Segment
group by db.[Customer ID], db.[Customer Name], seg.Id;

--�������� Ship mode
CREATE TABLE [dbo].[ShipMode](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[ShipModeName] [nvarchar] (255) NOT NULL
);
ALTER TABLE [dbo].[ShipMode] ADD UNIQUE ([ShipModeName]);

--���������� Country
insert into dbo.[ShipMode]
select db.[Ship Mode]
from dbo.Sheet1$ db
group by db.[Ship Mode];


--�������� ������� Order
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[OrderId] [varchar] (255) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NOT NULL,
	[ShipModeId] [int] NOT NULL,
	[PostalCodeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL
);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([ShipModeId]) REFERENCES dbo.[ShipMode] ([Id]);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([PostalCodeId]) REFERENCES dbo.[PostalCode] ([Id]);
ALTER TABLE [dbo].[Order] WITH CHECK ADD FOREIGN KEY([CustomerId]) REFERENCES dbo.Customer ([Id]);

---���������� ������� Order
insert into dbo.[Order]
select db.[Order ID], db.[Order Date], db.[Ship Date], sm.Id, pc.Id, cust.Id
from dbo.Sheet1$ db
left join dbo.[ShipMode] sm on sm.ShipModeName = db.[Ship Mode]
left join dbo.PostalCode pc on pc.PostalCode = db.[Postal Code]
left join dbo.Customer cust on cust.CustomerId = db.[Customer ID]
group by db.[Order ID], db.[Order Date], db.[Ship Date], sm.Id, pc.Id, cust.Id;






CREATE TABLE [dbo].[OrderDetails](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [float] NOT NULL,
	[Profit] [money] NOT NULL
);
ALTER TABLE [dbo].[OrderDetails] ADD CONSTRAINT uniqOrderDet UNIQUE ([OrderId], [ProductId], [Quantity], [Discount]);
ALTER TABLE [dbo].[OrderDetails] WITH CHECK ADD FOREIGN KEY([ProductId]) REFERENCES dbo.Product ([Id]);
ALTER TABLE [dbo].[OrderDetails] WITH CHECK ADD FOREIGN KEY([OrderId]) REFERENCES dbo.[Order] ([Id]);

insert into dbo.[OrderDetails]
select ord.Id, prod.Id, db.Quantity, db.Discount, db.Profit
from dbo.Sheet1$ db
left join dbo.[Order] ord on ord.OrderId = db.[Order ID]
left join dbo.Product prod on prod.ProducyId = db.[Product ID]
group by ord.Id, prod.Id, db.Quantity, db.Discount, db.Profit;

--����� ������
select SUM(db.Profit)
from dbo.[OrderDetails] db;