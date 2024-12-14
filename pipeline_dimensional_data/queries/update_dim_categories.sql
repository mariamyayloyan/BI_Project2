USE ORDER_DDS;

-- MERGE operation for SCD1 implementation for Categories with delete
MERGE INTO dim_categories_SCD1 AS target
USING (
    SELECT 
        CategoryID,
        CategoryName,
        Description,
        staging_raw_id
    FROM staging_Categories
) AS source
ON target.CategoryID_NK = source.CategoryID

-- Update existing records
WHEN MATCHED THEN 
UPDATE SET
    target.CategoryName = source.CategoryName,
    target.Description = source.Description

-- Insert new records
WHEN NOT MATCHED BY TARGET THEN
INSERT (
    CategoryID_NK,
    CategoryName,
    Description
)
VALUES (
    source.CategoryID,
    source.CategoryName,
    source.Description
);

-- Optionally log actions into Dim_SOR
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Categories'
FROM staging_Categories;

-- Delete records that do not exist in the staging table anymore
-- (This simple approach assumes all records should be validated each cycle)
DELETE FROM dim_categories_SCD1
WHERE CategoryID_NK NOT IN (SELECT CategoryID FROM staging_Categories);
