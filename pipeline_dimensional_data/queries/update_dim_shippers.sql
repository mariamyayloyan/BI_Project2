-- USE ORDER_DDS;

-- DECLARE @CurrentDate DATETIME = GETDATE();
-- -- MERGE operation for SCD3 implementation for ShippersMERGE INTO dim_shippers_SCD3 AS target
-- USING(    SELECT 
--         ShipperID,        CompanyName,
--         Phone,        staging_raw_id
--     FROM staging_Shippers) AS source
-- ON target.ShipperID_NK = source.ShipperID
-- -- Handle updates: update current values and preserve prior valuesWHEN MATCHED AND ISNULL(target.Phone, '') <> ISNULL(source.Phone, '') THEN 
-- UPDATE SET    target.Phone_Prev2 = target.Phone_Prev1,
--     target.Phone_Prev2_ValidTo = target.Phone_Prev1_ValidTo,    target.Phone_Prev1 = target.Phone,
--     target.Phone_Prev1_ValidTo = DATEDIFF(DAY, '1900-01-01', GETDATE()), -- Using serialized date    target.Phone = source.Phone,
--     target.CompanyName = source.CompanyName
-- WHEN NOT MATCHED BY TARGET THEN
-- INSERT (ShipperID_NK,
--     CompanyName,
--     Phone,    Phone_Prev1,
--     Phone_Prev1_ValidTo,    Phone_Prev2,
--     Phone_Prev2_ValidTo)
-- VALUES (    source.ShipperID,
--     source.CompanyName,    source.Phone,
--     NULL, -- Initial load; no previous values    NULL,
--     NULL,    NULL
-- );
-- -- Log each record processed into Dim_SOR for tracking
-- INSERT INTO Dim_SOR (StagingRawID_NK, TableName)SELECT DISTINCT staging_raw_id, 'staging_Shippers'
-- FROM staging_Shippers;


USE ORDER_DDS;

DECLARE @CurrentDate DATETIME = GETDATE();

-- MERGE operation for SCD3 implementation for Shippers
MERGE INTO dim_shippers_SCD3 AS target
USING 
(
    SELECT 
        ShipperID,        
        CompanyName,
        Phone,        
        staging_raw_id
    FROM staging_Shippers
) AS source
ON target.ShipperID_NK = source.ShipperID
-- Handle updates: update current values and preserve prior values
WHEN MATCHED AND ISNULL(target.Phone, '') <> ISNULL(source.Phone, '') THEN 
UPDATE 
SET 
    target.Phone_Prev2 = target.Phone_Prev1,
    target.Phone_Prev2_ValidTo = target.Phone_Prev1_ValidTo,    
    target.Phone_Prev1 = target.Phone,
    target.Phone_Prev1_ValidTo = DATEDIFF(DAY, '1900-01-01', @CurrentDate), -- Using serialized date    
    target.Phone = source.Phone,
    target.CompanyName = source.CompanyName
WHEN NOT MATCHED BY TARGET THEN
INSERT 
    (ShipperID_NK, CompanyName, Phone, Phone_Prev1, Phone_Prev1_ValidTo, Phone_Prev2, Phone_Prev2_ValidTo)
VALUES 
    (source.ShipperID, source.CompanyName, source.Phone, NULL, NULL, NULL, NULL);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Shippers'
FROM staging_Shippers;
