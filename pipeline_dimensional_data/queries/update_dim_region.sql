USE ORDER_DDS;

DECLARE @CurrentDate DATETIME = GETDATE();
DECLARE @SerializedDate INT = DATEDIFF(DAY, '1900-01-01', @CurrentDate);
DECLARE @EODDate INT = 99991231; -- End of date for valid current records

-- Step 1: Expire existing current records where changes are detected
UPDATE dim_region_SCD2
SET
    ValidTo = @SerializedDate, -- Set valid to date to current date when expiring
    IsCurrent = 0
WHERE RegionID_NK IN (
    SELECT RegionID FROM staging_Region
)
AND IsCurrent = 1
AND ISNULL(RegionDescription, '') <> ISNULL((SELECT sr.RegionDescription FROM staging_Region sr WHERE sr.RegionID = RegionID_NK), '');

-- Step 2: Insert new versions for changed records from staging
INSERT INTO dim_region_SCD2 (
    RegionID_NK,
    RegionDescription,
    ValidFrom,
    ValidTo,
    IsCurrent
)
SELECT
    sr.RegionID,
    sr.RegionDescription,
    @SerializedDate, -- Valid from current date
    @EODDate, -- Set valid to a far future date to signify current version
    1 -- Set as current
FROM staging_Region sr
WHERE sr.RegionID IN (
    SELECT RegionID_NK FROM dim_region_SCD2 WHERE IsCurrent = 1
)
AND ISNULL(sr.RegionDescription, '') <> ISNULL((SELECT dr.RegionDescription FROM dim_region_SCD2 dr WHERE dr.RegionID_NK = sr.RegionID AND dr.IsCurrent = 1), '');

-- Step 3: Handle new entries (not in current dimension)
INSERT INTO dim_region_SCD2 (
    RegionID_NK,
    RegionDescription,
    ValidFrom,
    ValidTo,
    IsCurrent
)
SELECT
    sr.RegionID,
    sr.RegionDescription,
    @SerializedDate, -- Valid from current date
    @EODDate, -- Set valid to a far future date
    1 -- Set as current
FROM staging_Region sr
WHERE sr.RegionID NOT IN (
    SELECT RegionID_NK FROM dim_region_SCD2
);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Region'
FROM staging_Region;
