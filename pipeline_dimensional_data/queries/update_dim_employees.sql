USE ORDER_DDS;


-- MERGE operation for SCD1 implementation for Employees
MERGE INTO dim_employees_SCD1 AS target
USING (
    SELECT 
        EmployeeID,
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
        staging_raw_id
    FROM staging_Employees
) AS source
ON target.EmployeeID_NK = source.EmployeeID

-- Update existing records to latest data
WHEN MATCHED THEN 
UPDATE SET
    target.LastName = source.LastName,
    target.FirstName = source.FirstName,
    target.Title = source.Title,
    target.TitleOfCourtesy = source.TitleOfCourtesy,
    target.BirthDate = source.BirthDate,
    target.HireDate = source.HireDate,
    target.Address = source.Address,
    target.City = source.City,
    target.Region = source.Region,
    target.PostalCode = source.PostalCode,
    target.Country = source.Country,
    target.HomePhone = source.HomePhone,
    target.Extension = CAST(source.Extension AS VARCHAR(255)), -- Ensure correct type mapping
    target.Notes = source.Notes,
    target.ReportsTo = source.ReportsTo,
    target.PhotoPath = source.PhotoPath

-- Insert new records
WHEN NOT MATCHED BY TARGET THEN
INSERT (
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
    PhotoPath
)
VALUES (
    source.EmployeeID,
    source.LastName,
    source.FirstName,
    source.Title,
    source.TitleOfCourtesy,
    source.BirthDate,
    source.HireDate,
    source.Address,
    source.City,
    source.Region,
    source.PostalCode,
    source.Country,
    source.HomePhone,
    CAST(source.Extension AS VARCHAR(255)), -- Ensure correct type mapping
    source.Notes,
    source.ReportsTo,
    source.PhotoPath
);

-- Optionally log actions into Dim_SOR
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Employees'
FROM staging_Employees;
