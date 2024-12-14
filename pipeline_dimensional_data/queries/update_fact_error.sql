USE ORDER_DDS;

-- Create the fact_error table if it doesn't exist
DROP TABLE IF EXISTS fact_error;
CREATE TABLE fact_error (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    CustomerID NVARCHAR(5),
    EmployeeID INT,
    TerritoryID NVARCHAR(5),
    ShipVia INT,
    ErrorDescription NVARCHAR(255),
    Staging_RawID_Orders INT,
    Staging_RawID_Details INT,
    ErrorDate DATETIME DEFAULT GETDATE()
);

-- Declare parameters for the database context
DECLARE @DatabaseName NVARCHAR(128), @SchemaName NVARCHAR(128), @TableName NVARCHAR(128);
DECLARE @start_date DATETIME, @end_date DATETIME;

-- Sample values (replace with actual input when running in an ETL tool)
SET @DatabaseName = N'YourDatabase';
SET @SchemaName = N'dbo';
SET @TableName = N'fact_orders';
SET @start_date = '2023-01-01'; -- Replace with actual start date
SET @end_date = '2023-12-31'; -- Replace with actual end date

-- Insert faulty records from staging into fact_error
INSERT INTO fact_error (
    OrderID,
    ProductID,
    CustomerID,
    EmployeeID,
    TerritoryID,
    ShipVia,
    ErrorDescription,
    Staging_RawID_Orders,
    Staging_RawID_Details
)
SELECT 
    o.OrderID, 
    od.ProductID, 
    o.CustomerID, 
    o.EmployeeID, 
    o.TerritoryID, 
    o.ShipVia,
    CASE
        WHEN (SELECT COUNT(*) FROM dim_customers_SCD4_current WHERE CustomerID_NK = o.CustomerID) = 0 THEN 'Invalid CustomerID'
        WHEN (SELECT COUNT(*) FROM dim_employees_SCD1 WHERE EmployeeID_NK = o.EmployeeID) = 0 THEN 'Invalid EmployeeID'
        WHEN (SELECT COUNT(*) FROM dim_products_SCD4_current WHERE ProductID_NK = od.ProductID) = 0 THEN 'Invalid ProductID'
        WHEN (SELECT COUNT(*) FROM dim_territories_SCD2 WHERE TerritoryID_NK = o.TerritoryID AND IsCurrent = 1) = 0 THEN 'Invalid TerritoryID'
        WHEN (SELECT COUNT(*) FROM dim_shippers_SCD3 WHERE ShipperID_NK = o.ShipVia) = 0 THEN 'Invalid ShipVia'
        ELSE 'Unknown Error'
    END AS ErrorDescription,
    o.staging_raw_id AS Staging_RawID_Orders,
    od.staging_raw_id AS Staging_RawID_Details
FROM staging_Orders o
INNER JOIN staging_Order_Details od
    ON o.OrderID = od.OrderID
WHERE o.OrderDate >= @start_date AND o.OrderDate <= @end_date
AND (
    (SELECT COUNT(*) FROM dim_customers_SCD4_current WHERE CustomerID_NK = o.CustomerID) = 0
    OR (SELECT COUNT(*) FROM dim_employees_SCD1 WHERE EmployeeID_NK = o.EmployeeID) = 0
    OR (SELECT COUNT(*) FROM dim_products_SCD4_current WHERE ProductID_NK = od.ProductID) = 0
    OR (SELECT COUNT(*) FROM dim_territories_SCD2 WHERE TerritoryID_NK = o.TerritoryID AND IsCurrent = 1) = 0
    OR (SELECT COUNT(*) FROM dim_shippers_SCD3 WHERE ShipperID_NK = o.ShipVia) = 0
);