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

