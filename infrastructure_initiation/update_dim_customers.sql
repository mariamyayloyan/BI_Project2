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

