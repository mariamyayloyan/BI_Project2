-- DECLARE @CurrentDate DATETIME = GETDATE();
-- -- MERGE operation for SCD3 implementationMERGE INTO dim_suppliers_SCD3 AS target
-- USING (SELECT     SupplierID,
--     CompanyName,    ContactName,
--     ContactTitle,    Address,
--     City,    Region,
--     PostalCode,    Country,
--     Phone,    Fax,
--     HomePage,    staging_raw_id
-- FROM staging_Suppliers) AS sourceON target.SupplierID_NK = source.SupplierID
-- -- Handle updates: update current values and preserve prior values
-- WHEN MATCHED AND (       ISNULL(target.ContactName, '') <> ISNULL(source.ContactName, '')
--     OR ISNULL(target.ContactTitle, '') <> ISNULL(source.ContactTitle, '')) THEN 
-- UPDATE SET    target.ContactName_Prev2 = target.ContactName_Prev1,
--     target.ContactName_Prev2_ValidTo = target.ContactName_Prev1_ValidTo,    target.ContactName_Prev1 = target.ContactName,
--     target.ContactName_Prev1_ValidTo = DATEDIFF(DAY, '1900-01-01', GETDATE()),  -- Using serialized date    target.ContactName = source.ContactName,
--     target.ContactTitle_Prev2 = target.ContactTitle_Prev1,
--     target.ContactTitle_Prev2_ValidTo = target.ContactTitle_Prev1_ValidTo,    target.ContactTitle_Prev1 = target.ContactTitle,
--     target.ContactTitle_Prev1_ValidTo = DATEDIFF(DAY, '1900-01-01', GETDATE()),    target.ContactTitle = source.ContactTitle,
--     target.CompanyName = source.CompanyName,
--     target.Address = source.Address,    target.City = source.City,
--     target.Region = source.Region,    target.PostalCode = source.PostalCode,
--     target.Country = source.Country,    target.Phone = source.Phone,
--     target.Fax = source.Fax,    target.HomePage = source.HomePage,
--     target.ValidFrom = @CurrentDate
-- WHEN NOT MATCHED BY TARGET THENINSERT (
--     SupplierID_NK,    CompanyName,
--     ContactName,    ContactName_Prev1,
--     ContactName_Prev1_ValidTo,    ContactName_Prev2,
--     ContactName_Prev2_ValidTo,    ContactTitle,
--     ContactTitle_Prev1,    ContactTitle_Prev1_ValidTo,
--     ContactTitle_Prev2,    ContactTitle_Prev2_ValidTo,
--     Address,    City,
--     Region,    PostalCode,
--     Country,    Phone,
--     Fax,    HomePage,
--     ValidFrom)
-- VALUES (    source.SupplierID,
--     source.CompanyName,    source.ContactName,
--     NULL, -- Initial load; no previous values
--     NULL,    NULL,
--     NULL,    source.ContactTitle,
--     NULL,    NULL,
--     NULL,    NULL,
--     source.Address,    source.City,
--     source.Region,    source.PostalCode,
--     source.Country,    source.Phone,
--     source.Fax,    source.HomePage,
--     @CurrentDate);
-- -- Log each record processed into Dim_SOR for tracking
-- INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
-- SELECT DISTINCT staging_raw_id, 'staging_Suppliers'FROM staging_Suppliers;



-- DECLARE @CurrentDate DATETIME = GETDATE();

-- -- MERGE operation for SCD3 implementation
-- MERGE INTO dim_suppliers_SCD3 AS target
-- USING (
--     SELECT 
--         SupplierID,
--         CompanyName,
--         ContactName,
--         ContactTitle,
--         Address,
--         City,
--         Region,
--         PostalCode,
--         Country,
--         Phone,
--         Fax,
--         HomePage,
--         staging_raw_id
--     FROM staging_Suppliers
-- ) source
-- ON target.SupplierID_NK = source.SupplierID

-- -- Handle updates: update current values and preserve prior values
-- WHEN MATCHED AND (
--     ISNULL(target.ContactName, '') <> ISNULL(source.ContactName, '') OR
--     ISNULL(target.ContactTitle, '') <> ISNULL(source.ContactTitle, '')
-- ) THEN 
-- UPDATE SET
--     target.ContactName_Prev2 = target.ContactName_Prev1,
--     target.ContactName_Prev2_ValidTo = target.ContactName_Prev1_ValidTo,
--     target.ContactName_Prev1 = target.ContactName,
--     target.ContactName_Prev1_ValidTo = @CurrentDate,
--     target.ContactName = source.ContactName,
--     target.ContactTitle_Prev2 = target.ContactTitle_Prev1,
--     target.ContactTitle_Prev2_ValidTo = target.ContactTitle_Prev1_ValidTo,
--     target.ContactTitle_Prev1 = target.ContactTitle,
--     target.ContactTitle_Prev1_ValidTo = @CurrentDate,
--     target.ContactTitle = source.ContactTitle,
--     target.CompanyName = source.CompanyName,
--     target.Address = source.Address,
--     target.City = source.City,
--     target.Region = source.Region,
--     target.PostalCode = source.PostalCode,
--     target.Country = source.Country,
--     target.Phone = source.Phone,
--     target.Fax = source.Fax,
--     target.HomePage = source.HomePage,
--     target.ValidFrom = @CurrentDate

-- -- Handle new records
-- WHEN NOT MATCHED BY TARGET THEN 
-- INSERT (
--     SupplierID_NK,
--     CompanyName,
--     ContactName,
--     ContactName_Prev1,
--     ContactName_Prev1_ValidTo,
--     ContactName_Prev2,
--     ContactName_Prev2_ValidTo,
--     ContactTitle,
--     ContactTitle_Prev1,
--     ContactTitle_Prev1_ValidTo,
--     ContactTitle_Prev2,
--     ContactTitle_Prev2_ValidTo,
--     Address,
--     City,
--     Region,
--     PostalCode,
--     Country,
--     Phone,
--     Fax,
--     HomePage,
--     ValidFrom
-- )
-- VALUES (
--     source.SupplierID,
--     source.CompanyName,
--     source.ContactName,
--     NULL, -- Initial load; no previous values
--     NULL,
--     NULL,
--     NULL,
--     source.ContactTitle,
--     NULL,
--     NULL,
--     NULL,
--     NULL,
--     source.Address,
--     source.City,
--     source.Region,
--     source.PostalCode,
--     source.Country,
--     source.Phone,
--     source.Fax,
--     source.HomePage,
--     @CurrentDate
-- );

-- -- Log each record processed into Dim_SOR for tracking
-- INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
-- SELECT DISTINCT staging_raw_id, 'staging_Suppliers'
-- FROM staging_Suppliers;



DECLARE @CurrentDate DATETIME = GETDATE();

-- Serialized date as an integer (days since 1900-01-01)
DECLARE @CurrentDateAsInt INT = DATEDIFF(DAY, '1900-01-01', @CurrentDate);

-- MERGE operation for SCD3 implementation
MERGE INTO dim_suppliers_SCD3 AS target
USING (
    SELECT 
        SupplierID,
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
        staging_raw_id
    FROM staging_Suppliers
) source
ON target.SupplierID_NK = source.SupplierID

-- Handle updates: update current values and preserve prior values
WHEN MATCHED AND (
    ISNULL(target.ContactName, '') <> ISNULL(source.ContactName, '') OR
    ISNULL(target.ContactTitle, '') <> ISNULL(source.ContactTitle, '')
) THEN 
UPDATE SET
    target.ContactName_Prev2 = target.ContactName_Prev1,
    target.ContactName_Prev2_ValidTo = target.ContactName_Prev1_ValidTo,
    target.ContactName_Prev1 = target.ContactName,
    target.ContactName_Prev1_ValidTo = @CurrentDateAsInt, -- Use serialized date
    target.ContactName = source.ContactName,
    target.ContactTitle_Prev2 = target.ContactTitle_Prev1,
    target.ContactTitle_Prev2_ValidTo = target.ContactTitle_Prev1_ValidTo,
    target.ContactTitle_Prev1 = target.ContactTitle,
    target.ContactTitle_Prev1_ValidTo = @CurrentDateAsInt, -- Use serialized date
    target.ContactTitle = source.ContactTitle,
    target.CompanyName = source.CompanyName,
    target.Address = source.Address,
    target.City = source.City,
    target.Region = source.Region,
    target.PostalCode = source.PostalCode,
    target.Country = source.Country,
    target.Phone = source.Phone,
    target.Fax = source.Fax,
    target.HomePage = source.HomePage,
    target.ValidFrom = @CurrentDate

-- Handle new records
WHEN NOT MATCHED BY TARGET THEN 
INSERT (
    SupplierID_NK,
    CompanyName,
    ContactName,
    ContactName_Prev1,
    ContactName_Prev1_ValidTo,
    ContactName_Prev2,
    ContactName_Prev2_ValidTo,
    ContactTitle,
    ContactTitle_Prev1,
    ContactTitle_Prev1_ValidTo,
    ContactTitle_Prev2,
    ContactTitle_Prev2_ValidTo,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    HomePage,
    ValidFrom
)
VALUES (
    source.SupplierID,
    source.CompanyName,
    source.ContactName,
    NULL, -- Initial load; no previous values
    NULL,
    NULL,
    NULL,
    source.ContactTitle,
    NULL,
    NULL,
    NULL,
    NULL,
    source.Address,
    source.City,
    source.Region,
    source.PostalCode,
    source.Country,
    source.Phone,
    source.Fax,
    source.HomePage,
    @CurrentDate
);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Suppliers'
FROM staging_Suppliers;
