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

