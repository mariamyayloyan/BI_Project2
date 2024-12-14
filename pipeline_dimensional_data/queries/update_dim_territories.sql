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