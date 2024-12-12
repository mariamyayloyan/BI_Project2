Use ORDER_DDS;

-- DimCategories SCD1 with delete
DROP TABLE IF EXISTS dim_categories_SCD1;
CREATE TABLE dim_categories_scd1 (
	CategoryID_PK_SK INT IDENTITY(1,1) PRIMARY KEY, 
	CategoryID_NK INT NULL,
	CategoryName VARCHAR(255) NOT NULL,
	Description VARCHAR(500) NULL
);
GO

-- DimCustomers SCD4 
DROP TABLE IF EXISTS dim_customers_SCD4_history;
CREATE TABLE dim_customers_SCD4_history (
	CustomerID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID_NK VARCHAR(50) NULL,
	CompanyName VARCHAR(255) NULL,
	ContactName VARCHAR(255) NULL,
	ContactName_Prev VARCHAR(255) DEFAULT NULL,
	ContactName_Prev_ValidTo char(8) NULL,
	ContactTitle VARCHAR(255) NULL,
	Address VARCHAR(255) NULL,
	City VARCHAR(255) NULL,
	Region VARCHAR(255) NULL,
	PostalCode VARCHAR(255) NULL,
	Country VARCHAR(255) NULL,
	Phone VARCHAR(255) NULL,
	Fax VARCHAR(255) NULL,
	ValidFrom DATETIME NULL,
	ValidTo DATETIME NULL
);
GO

DROP TABLE IF EXISTS dim_customers_SCD4_current;
CREATE TABLE dim_customers_SCD4 (
	CustomerID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID_NK VARCHAR(50) NULL,
	CompanyName VARCHAR(255) NULL,
	ContactName VARCHAR(255) NULL,
	ContactName_Prev VARCHAR(255) DEFAULT NULL,
	ContactName_Prev_ValidTo char(8) NULL,
	ContactTitle VARCHAR(255) NULL,
	Address VARCHAR(255) NULL,
	City VARCHAR(255) NULL,
	Region VARCHAR(255) NULL,
	PostalCode VARCHAR(255) NULL,
	Country VARCHAR(255) NULL,
	Phone VARCHAR(255) NULL,
	Fax VARCHAR(255) NULL,
	ValidFrom DATETIME NULL
);
GO

-- DimEmployees
DROP TABLE IF EXISTS dim_employees_SCD1;
CREATE TABLE dim_employees_SCD1 (
	EmployeeID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID_NK INT NULL,
	LastName VARCHAR(255) NULL,
	FirstName VARCHAR(255) NULL,
	Title VARCHAR(255) NULL,
	TitleOfCourtesy VARCHAR(255) NULL,
	BirthDate DATE NULL,
	HireDate DATE NULL,
	Address VARCHAR(255) NULL,
	City VARCHAR(255) NULL,
	Region VARCHAR(255) NULL,
	PostalCode VARCHAR(255) NULL,
	Country VARCHAR(255) NULL,
	HomePhone VARCHAR(255) NULL,
	Extension VARCHAR(255) NULL,
	Notes VARCHAR(MAX) NULL,
	ReportsTo INT NULL,
	PhotoPath VARCHAR(255) NULL
);
GO

-- DimProducts
DROP TABLE IF EXISTS dim_products_SCD4_history;
CREATE TABLE dim_products_SCD4_history (
	ProductID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	ProductID_NK INT NULL,
	ProductName VARCHAR(255) NOT NULL,
	SupplierID_NK INT NULL,
	CategoryID_NK INT NULL,
	QuantityPerUnit VARCHAR(255) NULL,
	UnitPrice DECIMAL(10, 2),
	UnitsInStock INT NOT NULL,
	UnitsOnOrder INT NOT NULL,
	ReorderLevel INT NULL,
	Discontinued BIT NULL,
	ValidFrom DATETIME NULL,
	ValidTo DATETIME NULL
);
GO

DROP TABLE IF EXISTS dim_products_SCD4_current;
CREATE TABLE dim_products_SCD4_current (
	ProductID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	ProductID_NK INT NULL,
	ProductName VARCHAR(255) NOT NULL,
	SupplierID_NK INT NULL,
	CategoryID_NK INT NULL,
	QuantityPerUnit VARCHAR(255) NULL,
	UnitPrice DECIMAL(10, 2),
	UnitsInStock INT NOT NULL,
	UnitsOnOrder INT NOT NULL,
	ReorderLevel INT NULL,
	Discontinued BIT NULL,
	ValidFrom DATETIME NULL
);
GO

-- DimRegion
DROP TABLE IF EXISTS dim_region_SCD2;
CREATE TABLE dim_region_SCD2 (
	RegionID_PK_SK INT IDENTITY(1, 1) PRIMARY KEY,
	RegionID_NK INT NULL,
	RegionDescription VARCHAR(255) NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
);
GO

-- DimShippers
DROP TABLE IF EXISTS dim_shippers_SCD3;
CREATE TABLE dim_shippers_SCD3 (
	ShipperID_PK_SK INT IDENTITY(1, 1) PRIMARY KEY,
	ShipperID_NK INT NULL,
	CompanyName VARCHAR(255) NOT NULL,
	Phone VARCHAR(25) NULL,
	Phone_Prev1 VARCHAR(255),
	Phone_Prev1_ValidTo INT NULL,
	Phone_Prev2 VARCHAR(255),
	Phone_Prev2_ValidTo INT NULL
);
GO

-- DimSuppliers SCD1
DROP TABLE IF EXISTS dim_suppliers_SCD3;
CREATE TABLE dim_suppliers_SCD3 (
	SupplierID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	SupplierID_NK INT NULL,
	CompanyName VARCHAR(255) NOT NULL,
	ContactName VARCHAR(255) NULL,
	ContactName_Prev1 VARCHAR(255) NULL,
	ContactName_Prev1_ValidTo INT NULL,
	ContactName_Prev2 VARCHAR(255) NULL,
	ContactName_Prev2_ValidTo INT NULL,
	ContactTitle VARCHAR(255) NULL,
	ContactTitle_Prev1 VARCHAR(255) NULL,
	ContactTitle_Prev1_ValidTo INT NULL,
	ContactTitle_Prev2 VARCHAR(255)NULL,
	ContactTitle_Prev2_ValidTo INT NULL,
	Address VARCHAR(255) NULL,
	City VARCHAR(255) NULL,
	Region VARCHAR(255) NULL,
	PostalCode VARCHAR(255) NULL,
	Country VARCHAR(255) NULL,
	Phone VARCHAR(255) NULL,
	Fax VARCHAR(255) NULL,
	HomePage VARCHAR(MAX) NULL,
	ValidFrom datetime NULL
);
GO

-- DimTerritories
DROP TABLE IF EXISTS dim_territories_SCD2;
CREATE TABLE dim_territories_SCD2 (
	TerritoryID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	TerritoryID_NK INT NULL,
	TerritoryDescription VARCHAR(255) NULL,
	RegionID INT NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
);
GO

-- FactOrders
DROP TABLE IF EXISTS fact_orders;
-- CREATE TABLE fact_orders (
-- 	Order_Product_SK_PK INT IDENTITY(1, 1) PRIMARY KEY,
-- 	OrderID_NK INT,
-- 	ProductID_SK_FK INT,
-- 	UnitPrice DECIMAL(20, 2) NOT NULL,
-- 	Quantity INT NOT NULL,
-- 	Discount DECIMAL(20,10) DEFAULT 0.0,
-- 	CustomerID VARCHAR(5),
-- 	CustomerID_SK_FK INT,
-- 	EmployeeID_NK INT,
-- 	EmployeeID_SK_FK INT,
-- 	OrderDate DATE,
-- 	RequiredDate DATE,
-- 	ShippedDate DATE,
-- 	ShipVia_NK INT,
-- 	ShipVia_SK_FK INT,
-- 	Freight DECIMAL(10, 2),
-- 	ShipAddress VARCHAR(255),
-- 	ShipCity VARCHAR(255),
-- 	ShipRegion VARCHAR(255),
-- 	ShipPostalCode VARCHAR(20),
-- 	ShipCountry VARCHAR(255),
-- 	TerritoryID_NK INT, 
-- 	TerritoryID_SK_FK INT
-- );
CREATE TABLE fact_orders (
	OrderKey INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
	CustomerKey INT NOT NULL,
	EmployeeKey INT NOT NULL,
	OrderDate DATETIME,
	RequiredDate DATETIME,
	ShippedDate DATETIME,
	ShipVia INT,
	Freight DECIMAL(18,2),
	ShipName NVARCHAR(255),
	ShipAddress NVARCHAR(MAX),
	ShipCity NVARCHAR(255),
	ShipRegion NVARCHAR(255),
	ShipPostalCode NVARCHAR(255),
	ShipCountry NVARCHAR(255),
	Quantity INT,
	UnitPrice DECIMAL(18,2),
	Discount FLOAT
);
GO

DROP TABLE IF EXISTS fact_orders;
CREATE TABLE Dim_SOR (
	SourceKey INT IDENTITY(1,1) PRIMARY KEY,
	StagingRawID INT NOT NULL,
	TableName NVARCHAR(255) NOT NULL
);
GO
