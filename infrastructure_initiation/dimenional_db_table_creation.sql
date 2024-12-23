Use ORDER_DDS;

-- DimCategories SCD1 with delete
DROP TABLE IF EXISTS dim_categories_SCD1;
CREATE TABLE dim_categories_SCD1 (
	CategoryID_PK_SK INT IDENTITY(1,1) PRIMARY KEY, 
	CategoryID_NK INT NULL,
	CategoryName VARCHAR(255) NOT NULL,
	Description VARCHAR(500) NULL
);

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

DROP TABLE IF EXISTS dim_customers_SCD4_current;
CREATE TABLE dim_customers_SCD4_current(
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
	PhotoPath VARCHAR(255) NULL,
	FOREIGN KEY(ReportsTo) references dim_employees_SCD1(EmployeeID_PK_SK)
);

-- DimProducts
DROP TABLE IF EXISTS dim_products_SCD4_history;
CREATE TABLE dim_products_SCD4_history (
	ProductID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	ProductID_NK INT NULL,
	ProductName VARCHAR(255) NOT NULL,
	SupplierID_FK INT NULL,
	CategoryID_FK INT NULL,
	QuantityPerUnit VARCHAR(255) NULL,
	UnitPrice DECIMAL(10, 2),
	UnitsInStock INT NOT NULL,
	UnitsOnOrder INT NOT NULL,
	ReorderLevel INT NULL,
	Discontinued BIT NULL,
	ValidFrom DATETIME NULL,
	ValidTo DATETIME NULL
);

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

DROP TABLE IF EXISTS dim_products_SCD4_current;
CREATE TABLE dim_products_SCD4_current (
	ProductID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	ProductID_NK INT NULL,
	ProductName VARCHAR(255) NOT NULL,
	SupplierID_FK_SK INT NULL,
	CategoryID_FK_SK INT NULL,
	QuantityPerUnit VARCHAR(255) NULL,
	UnitPrice DECIMAL(10, 2),
	UnitsInStock INT NOT NULL,
	UnitsOnOrder INT NOT NULL,
	ReorderLevel INT NULL,
	Discontinued BIT NULL,
	ValidFrom DATETIME NULL,
	FOREIGN KEY(CategoryID_FK_SK) references dim_categories_SCD1(CategoryID_PK_SK),
	FOREIGN KEY(SupplierID_FK_SK) references dim_suppliers_SCD3(SupplierID_PK_SK)
);

-- DimTerritories
DROP TABLE IF EXISTS dim_territories_SCD2;
CREATE TABLE dim_territories_SCD2 (
	TerritoryID_PK_SK INT IDENTITY(1,1) PRIMARY KEY,
	TerritoryID_NK INT NULL,
	TerritoryDescription VARCHAR(255) NULL,
	RegionID_FK_SK INT NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL,
	FOREIGN KEY(RegionID_FK_SK) references dim_region_SCD2(RegionID_PK_SK)
);

-- FactOrders
DROP TABLE IF EXISTS fact_orders;
CREATE TABLE fact_orders (
	Order_Product_SK_PK INT IDENTITY(1, 1) PRIMARY KEY,
	OrderID_NK INT,
	OrderDate datetime NULL,
	RequiredDate datetime NULL,
	ShippedDate datetime NULL,
	Freight money NULL,
	ShipName varchar(40) NULL,
	ShipAddress varchar(60) NULL,
	ShipCity varchar(15) NULL,
	ShipRegion varchar(15) NULL,
	ShipPostalCode varchar(10) NULL,
	ShipCountry varchar(15) NULL,
	UnitPrice money NOT NULL,
	Quantity smallint NOT NULL,
	Discount real NOT NULL,
	ShipVia_FK int NULL,
	CustomerID_FK int NULL,
	EmployeeID_FK int NULL,
	ProductID_FK int NOT NULL,
	TerritoryID_FK int NULL,
	FOREIGN KEY(TerritoryID_FK) references dim_territories_SCD2(TerritoryID_PK_SK),    
	FOREIGN KEY(ProductID_FK) references dim_products_SCD4_current(ProductID_PK_SK),
	FOREIGN KEY(CustomerID_FK) references dim_customers_SCD4_current(CustomerID_PK_SK),
	FOREIGN KEY(EmployeeID_FK) references dim_employees_SCD1(EmployeeID_PK_SK),
	FOREIGN KEY(ShipVia_FK) references dim_shippers_SCD3(ShipperID_PK_SK)
);

DROP TABLE IF EXISTS Dim_SOR;
CREATE TABLE Dim_SOR (
	Source_SK_PK INT IDENTITY(1,1) PRIMARY KEY,
	StagingRawID_NK INT NOT NULL,
	TableName NVARCHAR(255) NOT NULL
);
