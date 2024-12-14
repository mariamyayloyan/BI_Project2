-- Update dim_employees_SCD1
INSERT INTO dim_employees_SCD1 (
    EmployeeID_NK,
    LastName,
    FirstName,
    Title,
    TitleOfCourtesy,
    BirthDate,
    HireDate,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    HomePhone,
    Extension,
    Notes,
    ReportsTo,
    PhotoPath,
    StagingRawID_NK
)
SELECT 
    s.EmployeeID AS EmployeeID_NK,
    s.LastName,
    s.FirstName,
    s.Title,
    s.TitleOfCourtesy,
    s.BirthDate,
    s.HireDate,
    s.Address,
    s.City,
    s.Region,
    s.PostalCode,
    s.Country,
    s.HomePhone,
    s.Extension,
    s.Notes,
    s.ReportsTo,
    s.PhotoPath,
    sor.StagingRawID_NK
FROM staging_Employees s
JOIN Dim_SOR sor
    ON sor.StagingRawID_NK = s.staging_raw_id
WHERE NOT EXISTS (
    SELECT 1 FROM dim_employees_SCD1 d
    WHERE d.EmployeeID_NK = s.EmployeeID
);

