USE ORDER_DDS;

-- Use a database context if needed
-- USE YOUR_DATABASE_NAME;

DECLARE @CurrentDate DATETIME = GETDATE();
DECLARE @EODDate DATETIME = '9999-12-31'; -- End of date for valid current records

-- Handle current records by merging from the staging table
MERGE INTO dim_customers_SCD4_current AS target
USING (
    SELECT 
        CustomerID,
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
        staging_raw_id
    FROM staging_Customers
) AS source
ON target.CustomerID_NK = source.CustomerID

-- Handle when there's a change in the customer data
WHEN MATCHED AND (
       ISNULL(target.CompanyName, '') <> ISNULL(source.CompanyName, '')
    OR ISNULL(target.ContactName, '') <> ISNULL(source.ContactName, '')
    OR ISNULL(target.ContactTitle, '') <> ISNULL(source.ContactTitle, '')
    OR ISNULL(target.Address, '') <> ISNULL(source.Address, '')
    OR ISNULL(target.City, '') <> ISNULL(source.City, '')
    OR ISNULL(target.Region, '') <> ISNULL(source.Region, '')
    OR ISNULL(target.PostalCode, '') <> ISNULL(source.PostalCode, '')
    OR ISNULL(target.Country, '') <> ISNULL(source.Country, '')
    OR ISNULL(target.Phone, '') <> ISNULL(source.Phone, '')
    OR ISNULL(target.Fax, '') <> ISNULL(source.Fax, '')
) THEN
UPDATE SET
    target.CompanyName = source.CompanyName,
    target.ContactName_Prev = target.ContactName,
    target.ContactName_Prev_ValidTo = FORMAT(@CurrentDate, 'yyyyMMdd'),
    target.ContactName = source.ContactName,
    target.ContactTitle = source.ContactTitle,
    target.Address = source.Address,
    target.City = source.City,
    target.Region = source.Region,
    target.PostalCode = source.PostalCode,
    target.Country = source.Country,
    target.Phone = source.Phone,
    target.Fax = source.Fax,
    target.ValidFrom = @CurrentDate

-- Insert any new customers
WHEN NOT MATCHED BY TARGET THEN
INSERT (
    CustomerID_NK,
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
    ValidFrom
)
VALUES (
    source.CustomerID,
    source.CompanyName,
    source.ContactName,
    source.ContactTitle,
    source.Address,
    source.City,
    source.Region,
    source.PostalCode,
    source.Country,
    source.Phone,
    source.Fax,
    @CurrentDate
);

-- Store records from the current table to history as they get updated
INSERT INTO dim_customers_SCD4_history (
    CustomerID_NK,
    CompanyName,
    ContactName,
    ContactName_Prev,
    ContactName_Prev_ValidTo,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    ValidFrom,
    ValidTo
)
SELECT 
    CustomerID_NK,
    CompanyName,
    ContactName_Prev,
    ContactName,
    ContactName_Prev_ValidTo,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    ValidFrom,
    @CurrentDate -- mark history as valid until change date
FROM dim_customers_SCD4_current
WHERE CustomerID_NK IN (
    SELECT CustomerID FROM staging_Customers
)
AND (
    ISNULL(CompanyName, '') <> ISNULL((SELECT sc.CompanyName FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(ContactName, '') <> ISNULL((SELECT sc.ContactName FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(ContactTitle, '') <> ISNULL((SELECT sc.ContactTitle FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(Address, '') <> ISNULL((SELECT sc.Address FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(City, '') <> ISNULL((SELECT sc.City FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(Region, '') <> ISNULL((SELECT sc.Region FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(PostalCode, '') <> ISNULL((SELECT sc.PostalCode FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(Country, '') <> ISNULL((SELECT sc.Country FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(Phone, '') <> ISNULL((SELECT sc.Phone FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
    OR ISNULL(Fax, '') <> ISNULL((SELECT sc.Fax FROM staging_Customers sc WHERE sc.CustomerID = CustomerID_NK), '')
);

-- Log each record processed into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Customers'
FROM staging_Customers;
