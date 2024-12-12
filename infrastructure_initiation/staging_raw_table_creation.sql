USE ORDER_DDS;

-- Staging table for Categories
DROP TABLE IF EXISTS staging_Categories;
CREATE TABLE staging_Categories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

-- Staging table for Customers
DROP TABLE IF EXISTS staging_Customers;
CREATE TABLE staging_Customers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(5) NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(255),
    Country NVARCHAR(255),
    Phone NVARCHAR(255),
    Fax NVARCHAR(255)
);

-- Staging table for Employees
DROP TABLE IF EXISTS staging_Employees;
CREATE TABLE staging_Employees (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    LastName NVARCHAR(255),
    FirstName NVARCHAR(255),
    Title NVARCHAR(255),
    TitleOfCourtesy VARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(255),
    Country NVARCHAR(255),
    HomePhone NVARCHAR(255),
    Extension INT,
    Notes NVARCHAR(255),
    ReportsTo INT NULL,
    PhotoPath VARCHAR(500)
);

-- Staging table for Order Details
DROP TABLE IF EXISTS staging_Order_Details;
CREATE TABLE staging_Order_Details (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice MONEY,
    Quantity INT,
    Discount REAL
);

-- Staging table for Orders
DROP TABLE IF EXISTS staging_Orders;
CREATE TABLE staging_Orders (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    CustomerID NVARCHAR(5) NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(255),
    ShipRegion NVARCHAR(255),
    ShipPostalCode NVARCHAR(255),
    ShipCountry NVARCHAR(255),
    TerritoryID NVARCHAR(5) NOT NULL
);

-- Staging table for Products
DROP TABLE IF EXISTS staging_Products;
CREATE TABLE staging_Products (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName NVARCHAR(255),
    SupplierID INT NOT NULL,
    CategoryID INT NOT NULL,
    QuantityPerUnit NVARCHAR(255),
    UnitPrice MONEY,
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

-- Staging table for Region
DROP TABLE IF EXISTS staging_Region;
CREATE TABLE staging_Region (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT NOT NULL,
    RegionDescription NVARCHAR(255),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

-- Staging table for Shippers
DROP TABLE IF EXISTS staging_Shippers;
CREATE TABLE staging_Shippers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT NOT NULL,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(255)
);

-- Staging table for Suppliers
DROP TABLE IF EXISTS staging_Suppliers;
CREATE TABLE staging_Suppliers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(255),
    Region NVARCHAR(255),
    PostalCode NVARCHAR(255),
    Country NVARCHAR(255),
    Phone NVARCHAR(255),
    Fax NVARCHAR(255),
    HomePage NVARCHAR(255)
);

-- Staging table for Territories
DROP TABLE IF EXISTS staging_Territories;
CREATE TABLE staging_Territories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(255),
    TerritoryCode NVARCHAR(15),
    RegionID INT
);
