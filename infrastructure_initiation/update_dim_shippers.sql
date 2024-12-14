-- Update dim_shippers_SCD3
INSERT INTO dim_shippers_SCD3 (
    ShipperID_NK,
    CompanyName,
    Phone,
    Phone_Prev1,
    Phone_Prev1_ValidTo,
    Phone_Prev2,
    Phone_Prev2_ValidTo,
    StagingRawID_NK
)
SELECT 
    s.ShipperID AS ShipperID_NK,
    s.CompanyName,
    s.Phone,
    NULL AS Phone_Prev1,
    NULL AS Phone_Prev1_ValidTo,
    NULL AS Phone_Prev2,
    NULL AS Phone_Prev2_ValidTo,
    sor.StagingRawID_NK
FROM staging_Shippers s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_shippers_SCD3 d
    WHERE d.ShipperID_NK = s.ShipperID
);
