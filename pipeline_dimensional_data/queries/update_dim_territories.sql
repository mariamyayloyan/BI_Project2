-- DECLARE @CurrentDate INT = DATEDIFF(DAY, '1900-01-01', GETDATE());DECLARE @EODDate INT = 99991231; -- End of date for valid current records
-- -- Step 1: Expire existing current records where changes are detected
-- UPDATE dim_territories_SCD2SET
--     ValidTo = @CurrentDate, -- Set valid to serialized current date when expiring    IsCurrent = 0
-- WHERE TerritoryID_NK IN (    SELECT CAST(TerritoryID AS INT) FROM staging_Territories
-- )AND IsCurrent = 1
-- AND (    ISNULL(TerritoryDescription, '') <> ISNULL((SELECT st.TerritoryDescription FROM staging_Territories st WHERE st.TerritoryID = CAST(TerritoryID_NK AS NVARCHAR(20))), '')
--     OR RegionID_FK_SK <> (SELECT st.RegionID FROM staging_Territories st WHERE st.TerritoryID = CAST(TerritoryID_NK AS NVARCHAR(20))));
-- -- Step 2: Insert new versions for changed records from staging
-- INSERT INTO dim_territories_SCD2 (    TerritoryID_NK,
--     TerritoryDescription,    RegionID_FK_SK,
--     ValidFrom,
--     ValidTo,    IsCurrent
-- )SELECT
--     CAST(st.TerritoryID AS INT),    st.TerritoryDescription,
--     st.RegionID,    @CurrentDate, -- Valid from current date
--     @EODDate, -- Set valid to a far future date to signify current version    1 -- Set as current
-- FROM staging_Territories stWHERE st.TerritoryID IN (
--     SELECT CAST(TerritoryID_NK AS NVARCHAR(20)) FROM dim_territories_SCD2 WHERE IsCurrent = 1)
-- AND (    ISNULL(st.TerritoryDescription, '') <> ISNULL((SELECT dt.TerritoryDescription FROM dim_territories_SCD2 dt WHERE dt.TerritoryID_NK = CAST(st.TerritoryID AS INT) AND dt.IsCurrent = 1), '')
--     OR st.RegionID <> (SELECT dt.RegionID_FK_SK FROM dim_territories_SCD2 dt WHERE dt.TerritoryID_NK = CAST(st.TerritoryID AS INT) AND dt.IsCurrent = 1));
-- -- Step 3: Handle new entries (not in current dimension)
-- INSERT INTO dim_territories_SCD2 (    TerritoryID_NK,
--     TerritoryDescription,    RegionID_FK_SK,
--     ValidFrom,    ValidTo,
--     IsCurrent)
-- SELECT    CAST(st.TerritoryID AS INT),
--     st.TerritoryDescription,    st.RegionID,
--     @CurrentDate, -- Valid from current date    @EODDate, -- Set valid to a far future date
--     1 -- Set as currentFROM staging_Territories st
-- WHERE CAST(st.TerritoryID AS INT) NOT IN (    SELECT TerritoryID_NK FROM dim_territories_SCD2
-- );
-- -- Log each record processed into Dim_SOR for trackingINSERT INTO Dim_SOR (StagingRawID_NK, TableName)
-- SELECT DISTINCT staging_raw_id, 'staging_Territories'FROM staging_Territories;


DECLARE @CurrentDate INT = DATEDIFF(DAY, '1900-01-01', GETDATE());
DECLARE @EODDate INT = 99991231; -- End of date for valid current records

-- Step 1: Expire existing current records where changes are detected
UPDATE dim_territories_SCD2
SET
    ValidTo = @CurrentDate, -- Set valid to serialized current date when expiring
    IsCurrent = 0
WHERE TerritoryID_NK IN (
    SELECT CAST(TerritoryID AS INT) FROM staging_Territories
)
AND IsCurrent = 1
AND (
    ISNULL(TerritoryDescription, '') <> ISNULL(
        (SELECT st.TerritoryDescription 
         FROM staging_Territories st 
         WHERE st.TerritoryID = CAST(TerritoryID_NK AS NVARCHAR(20))), '')
    OR RegionID_FK_SK <> (
        SELECT st.RegionID 
        FROM staging_Territories st 
        WHERE st.TerritoryID = CAST(TerritoryID_NK AS NVARCHAR(20))
    )
);

-- Step 2: Insert new versions for changed records from staging
INSERT INTO dim_territories_SCD2 (
    TerritoryID_NK,
    TerritoryDescription,
    RegionID_FK_SK,
    ValidFrom,
    ValidTo,
    IsCurrent
)
SELECT
    CAST(st.TerritoryID AS INT),
    st.TerritoryDescription,
    st.RegionID,
    @CurrentDate, -- Valid from current date
    @EODDate,     -- Set valid to a far future date to signify current version
    1             -- Set as current
FROM staging_Territories st
WHERE st.TerritoryID IN (
    SELECT CAST(TerritoryID_NK AS NVARCHAR(20)) 
    FROM dim_territories_SCD2 
    WHERE IsCurrent = 1
)
AND (
    ISNULL(st.TerritoryDescription, '') <> ISNULL(
        (SELECT dt.TerritoryDescription 
         FROM dim_territories_SCD2 dt 
         WHERE dt.TerritoryID_NK = CAST(st.TerritoryID AS INT) 
         AND dt.IsCurrent = 1), '')
    OR st.RegionID <> (
        SELECT dt.RegionID_FK_SK 
        FROM dim_territories_SCD2 dt 
        WHERE dt.TerritoryID_NK = CAST(st.TerritoryID AS INT) 
        AND dt.IsCurrent = 1
    )
);

-- Step 3: Handle new entries (not in current dimension)
INSERT INTO dim_territories_SCD2 (
    TerritoryID_NK,
    TerritoryDescription,
    RegionID_FK_SK,
    ValidFrom,
    ValidTo,
    IsCurrent
)
SELECT 
    CAST(st.TerritoryID AS INT),
    st.TerritoryDescription,
    st.RegionID,
    @CurrentDate, -- Valid from current date
    @EODDate,     -- Set valid to a far future date
    1             -- Set as current
FROM staging_Territories st
WHERE CAST(st.TerritoryID AS INT) NOT IN (
    SELECT TerritoryID_NK FROM dim_territories_SCD2
);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT 
    staging_raw_id, 
    'staging_Territories'
FROM staging_Territories;
