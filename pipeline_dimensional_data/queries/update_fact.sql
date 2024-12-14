USE ORDER_DDS;

-- Declare parameters for the database context
DECLARE @DatabaseName NVARCHAR(128), @SchemaName NVARCHAR(128), @TableName NVARCHAR(128);
DECLARE @start_date DATETIME, @end_date DATETIME;



SET @start_date = '2023-01-01'; -- Replace with actual start date
SET @end_date = '2023-12-31'; -- Replace with actual end date

-- Ensure relevant records from staging tables based on date range are processed
MERGE INTO fact_orders AS target
USING (
    SELECT o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate, o.RequiredDate, o.ShippedDate, 
           o.ShipVia, o.Freight, o.ShipName, o.ShipAddress, o.ShipCity, o.ShipRegion, 
           o.ShipPostalCode, o.ShipCountry, od.UnitPrice, od.Quantity, od.Discount, 
           o.TerritoryID, od.ProductID, o.staging_raw_id AS Orders_StagingID, od.staging_raw_id AS Details_StagingID
    FROM staging_Orders o
    INNER JOIN staging_Order_Details od 
        ON o.OrderID = od.OrderID
    WHERE o.OrderDate >= @start_date AND o.OrderDate <= @end_date
) AS source
ON target.OrderID_NK = source.OrderID

WHEN MATCHED THEN 
-- Update existing records
UPDATE SET
    target.OrderDate = source.OrderDate,
    target.RequiredDate = source.RequiredDate,
    target.ShippedDate = source.ShippedDate,
    target.Freight = source.Freight,
    target.ShipName = source.ShipName,
    target.ShipAddress = source.ShipAddress,
    target.ShipCity = source.ShipCity,
    target.ShipRegion = source.ShipRegion,
    target.ShipPostalCode = source.ShipPostalCode,
    target.ShipCountry = source.ShipCountry,
    target.UnitPrice = source.UnitPrice,
    target.Quantity = source.Quantity,
    target.Discount = source.Discount,
    target.ShipVia_FK = (SELECT ShipperID_PK_SK FROM dim_shippers_SCD3 WHERE ShipperID_NK = source.ShipVia),
    target.CustomerID_FK = (SELECT CustomerID_PK_SK FROM dim_customers_SCD4_current WHERE CustomerID_NK = source.CustomerID),
    target.EmployeeID_FK = (SELECT EmployeeID_PK_SK FROM dim_employees_SCD1 WHERE EmployeeID_NK = source.EmployeeID),
    target.ProductID_FK = (SELECT ProductID_PK_SK FROM dim_products_SCD4_current WHERE ProductID_NK = source.ProductID),
    target.TerritoryID_FK = (SELECT TerritoryID_PK_SK FROM dim_territories_SCD2 WHERE TerritoryID_NK = source.TerritoryID AND IsCurrent = 1)

WHEN NOT MATCHED BY TARGET THEN 
-- Insert new records
INSERT (
    OrderID_NK, OrderDate, RequiredDate, ShippedDate, Freight, ShipName, ShipAddress, ShipCity, 
    ShipRegion, ShipPostalCode, ShipCountry, UnitPrice, Quantity, Discount, ShipVia_FK, 
    CustomerID_FK, EmployeeID_FK, ProductID_FK, TerritoryID_FK
)
VALUES (
    source.OrderID, source.OrderDate, source.RequiredDate, source.ShippedDate, source.Freight, 
    source.ShipName, source.ShipAddress, source.ShipCity, source.ShipRegion, source.ShipPostalCode,
    source.ShipCountry, source.UnitPrice, source.Quantity, source.Discount,
    (SELECT ShipperID_PK_SK FROM dim_shippers_SCD3 WHERE ShipperID_NK = source.ShipVia),
    (SELECT CustomerID_PK_SK FROM dim_customers_SCD4_current WHERE CustomerID_NK = source.CustomerID),
    (SELECT EmployeeID_PK_SK FROM dim_employees_SCD1 WHERE EmployeeID_NK = source.EmployeeID),
    (SELECT ProductID_PK_SK FROM dim_products_SCD4_current WHERE ProductID_NK = source.ProductID),
    (SELECT TerritoryID_PK_SK FROM dim_territories_SCD2 WHERE TerritoryID_NK = source.TerritoryID AND IsCurrent = 1)
);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT o.staging_raw_id, 'staging_Orders'
FROM staging_Orders o
WHERE o.OrderDate >= @start_date AND o.OrderDate <= @end_date;

INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT od.staging_raw_id, 'staging_Order_Details'
FROM staging_Order_Details od
WHERE od.OrderID IN (SELECT OrderID FROM staging_Orders WHERE OrderDate >= @start_date AND OrderDate <= @end_date);
