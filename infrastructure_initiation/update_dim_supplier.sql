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

