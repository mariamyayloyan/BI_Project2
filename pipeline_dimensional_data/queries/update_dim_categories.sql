-- Parameterized SQL scripts for every dimension table update

-- Update dim_categories_SCD1
INSERT INTO dim_categories_SCD1 (
    CategoryID_NK,
    CategoryName,
    Description,
    StagingRawID_NK
)
SELECT 
    s.CategoryID AS CategoryID_NK,
    s.CategoryName,
    s.Description,
    sor.StagingRawID_NK
FROM staging_Categories s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_categories_SCD1 d
    WHERE d.CategoryID_NK = s.CategoryID
);

-- Update dim_customers_SCD4_current
INSERT INTO dim_customers_SCD4_current (
    CustomerID_NK,
    CompanyName,
    ContactName,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    ValidFrom,
    StagingRawID_NK
)
SELECT 
    s.CustomerID AS CustomerID_NK,
    s.CompanyName,
    s.ContactName,
    s.ContactTitle,
    s.Address,
    s.City,
    s.Region,
    s.PostalCode,
    s.Country,
    s.Phone,
    s.Fax,
    GETDATE() AS ValidFrom,
    sor.StagingRawID_NK
FROM staging_Customers s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_customers_SCD4_current d
    WHERE d.CustomerID_NK = s.CustomerID
);

-- Update dim_employees_SCD1
INSERT INTO dim_employees_SCD1 (
    EmployeeID_NK,
    LastName,
    FirstName,
    Title,
    TitleOfCourtesy,
    BirthDate,
    HireDate,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    HomePhone,
    Extension,
    Notes,
    ReportsTo,
    PhotoPath,
    StagingRawID_NK
)
SELECT 
    s.EmployeeID AS EmployeeID_NK,
    s.LastName,
    s.FirstName,
    s.Title,
    s.TitleOfCourtesy,
    s.BirthDate,
    s.HireDate,
    s.Address,
    s.City,
    s.Region,
    s.PostalCode,
    s.Country,
    s.HomePhone,
    s.Extension,
    s.Notes,
    s.ReportsTo,
    s.PhotoPath,
    sor.StagingRawID_NK
FROM staging_Employees s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_employees_SCD1 d
    WHERE d.EmployeeID_NK = s.EmployeeID
);

-- Update dim_products_SCD4_current
INSERT INTO dim_products_SCD4_current (
    ProductID_NK,
    ProductName,
    SupplierID_FK_SK,
    CategoryID_FK_SK,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued,
    ValidFrom,
    StagingRawID_NK
)
SELECT 
    s.ProductID AS ProductID_NK,
    s.ProductName,
    NULL AS SupplierID_FK_SK, -- Replace with appropriate FK mapping
    NULL AS CategoryID_FK_SK, -- Replace with appropriate FK mapping
    s.QuantityPerUnit,
    s.UnitPrice,
    s.UnitsInStock,
    s.UnitsOnOrder,
    s.ReorderLevel,
    s.Discontinued,
    GETDATE() AS ValidFrom,
    sor.StagingRawID_NK
FROM staging_Products s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_products_SCD4_current d
    WHERE d.ProductID_NK = s.ProductID
);

-- Update dim_region_SCD2
INSERT INTO dim_region_SCD2 (
    RegionID_NK,
    RegionDescription,
    ValidFrom,
    ValidTo,
    IsCurrent,
    StagingRawID_NK
)
SELECT 
    s.RegionID AS RegionID_NK,
    s.RegionDescription,
    GETDATE() AS ValidFrom,
    NULL AS ValidTo,
    1 AS IsCurrent,
    sor.StagingRawID_NK
FROM staging_Region s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_region_SCD2 d
    WHERE d.RegionID_NK = s.RegionID AND d.IsCurrent = 1
);

-- Update dim_shippers_SCD3
INSERT INTO dim_shippers_SCD3 (
    ShipperID_NK,
    CompanyName,
    Phone,
    Phone_Prev1,
    Phone_Prev1_ValidTo,
    Phone_Prev2,
    Phone_Prev2_ValidTo,
    StagingRawID_NK
)
SELECT 
    s.ShipperID AS ShipperID_NK,
    s.CompanyName,
    s.Phone,
    NULL AS Phone_Prev1,
    NULL AS Phone_Prev1_ValidTo,
    NULL AS Phone_Prev2,
    NULL AS Phone_Prev2_ValidTo,
    sor.StagingRawID_NK
FROM staging_Shippers s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_shippers_SCD3 d
    WHERE d.ShipperID_NK = s.ShipperID
);
-- Update dim_suppliers_SCD3
INSERT INTO dim_suppliers_SCD3 (
    SupplierID_NK,
    CompanyName,
    ContactName,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    HomePage,
    ValidFrom,
    StagingRawID_NK
)
SELECT 
    s.SupplierID AS SupplierID_NK,
    s.CompanyName,
    s.ContactName,
    s.ContactTitle,
    s.Address,
    s.City,
    s.Region,
    s.PostalCode,
    s.Country,
    s.Phone,
    s.Fax,
    s.HomePage,
    GETDATE() AS ValidFrom,
    sor.StagingRawID_NK
FROM staging_Suppliers s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_suppliers_SCD3 d
    WHERE d.SupplierID_NK = s.SupplierID
);

-- Update dim_territories_SCD2
INSERT INTO dim_territories_SCD2 (
    TerritoryID_NK,
    TerritoryDescription,
    RegionID_FK_SK,
    ValidFrom,
    ValidTo,
    IsCurrent,
    StagingRawID_NK
)
SELECT 
    s.TerritoryID AS TerritoryID_NK,
    s.TerritoryDescription,
    NULL AS RegionID_FK_SK, -- Replace with appropriate FK mapping
    GETDATE() AS ValidFrom,
    NULL AS ValidTo,
    1 AS IsCurrent,
    sor.StagingRawID_NK
FROM staging_Territories s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_territories_SCD2 d
    WHERE d.TerritoryID_NK = s.TerritoryID AND d.IsCurrent = 1
);

-- Update fact_orders
INSERT INTO fact_orders (
    OrderID_NK,
    OrderDate,
    RequiredDate,
    ShippedDate,
    Freight,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipRegion,
    ShipPostalCode,
    ShipCountry,
    UnitPrice,
    Quantity,
    Discount,
    ShipVia_FK,
    CustomerID_FK,
    EmployeeID_FK,
    ProductID_FK,
    TerritoryID_FK
)
SELECT 
    s.OrderID AS OrderID_NK,
    s.OrderDate,
    s.RequiredDate,
    s.ShippedDate,
    s.Freight,
    s.ShipName,
    s.ShipAddress,
    s.ShipCity,
    s.ShipRegion,
    s.ShipPostalCode,
    s.ShipCountry,
    od.UnitPrice,
    od.Quantity,
    od.Discount,
    NULL AS ShipVia_FK, -- Replace with appropriate FK mapping
    NULL AS CustomerID_FK, -- Replace with appropriate FK mapping
    NULL AS EmployeeID_FK, -- Replace with appropriate FK mapping
    NULL AS ProductID_FK, -- Replace with appropriate FK mapping
    NULL AS TerritoryID_FK -- Replace with appropriate FK mapping
FROM staging_Orders s
JOIN staging_Order_Details od
    ON s.OrderID = od.OrderID
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM fact_orders f
    WHERE f.OrderID_NK = s.OrderID AND f.ProductID_FK = od.ProductID
);