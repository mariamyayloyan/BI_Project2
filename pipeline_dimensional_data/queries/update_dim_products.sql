USE ORDER_DDS;

DECLARE @CurrentDate DATETIME = GETDATE();
DECLARE @EODDate DATETIME = '9999-12-31'; -- End of date for valid current records

-- Ensure auxiliary tables exist or provide placeholders for joining
-- Assumed here as existing and correctly populated for FK purposes

-- Merge operation to handle current product data
MERGE INTO dim_products_SCD4_current AS target
USING (
    SELECT 
        ProductID,
        ProductName,
        SupplierID,
        CategoryID,
        QuantityPerUnit,
        UnitPrice,
        UnitsInStock,
        UnitsOnOrder,
        ReorderLevel,
        Discontinued,
        staging_raw_id
    FROM staging_Products
) AS source
ON target.ProductID_NK = source.ProductID

-- Update current records and preserve historical data when data changes
WHEN MATCHED AND (
       ISNULL(target.ProductName, '') <> ISNULL(source.ProductName, '')
    OR ISNULL(target.SupplierID_FK_SK, 0) <> source.SupplierID
    OR ISNULL(target.CategoryID_FK_SK, 0) <> source.CategoryID
    OR ISNULL(target.QuantityPerUnit, '') <> ISNULL(source.QuantityPerUnit, '')
    OR ISNULL(target.UnitPrice, 0) <> source.UnitPrice
    OR ISNULL(target.UnitsInStock, 0) <> ISNULL(source.UnitsInStock, 0)
    OR ISNULL(target.UnitsOnOrder, 0) <> ISNULL(source.UnitsOnOrder, 0)
    OR ISNULL(target.ReorderLevel, 0) <> ISNULL(source.ReorderLevel, 0)
    OR ISNULL(target.Discontinued, 0) <> ISNULL(source.Discontinued, 0)
) THEN
UPDATE SET
    target.ProductName = source.ProductName,
    target.SupplierID_FK_SK = source.SupplierID,
    target.CategoryID_FK_SK = source.CategoryID,
    target.QuantityPerUnit = source.QuantityPerUnit,
    target.UnitPrice = source.UnitPrice,
    target.UnitsInStock = source.UnitsInStock,
    target.UnitsOnOrder = source.UnitsOnOrder,
    target.ReorderLevel = source.ReorderLevel,
    target.Discontinued = source.Discontinued,
    target.ValidFrom = @CurrentDate

-- Insert new product records
WHEN NOT MATCHED BY TARGET THEN
INSERT (
    ProductID_NK,
    ProductName,
    SupplierID_FK_SK,
    CategoryID_FK_SK,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued,
    ValidFrom
)
VALUES (
    source.ProductID,
    source.ProductName,
    source.SupplierID,
    source.CategoryID,
    source.QuantityPerUnit,
    source.UnitPrice,
    source.UnitsInStock,
    source.UnitsOnOrder,
    source.ReorderLevel,
    source.Discontinued,
    @CurrentDate
);

-- Archive historical records when updates happen
INSERT INTO dim_products_SCD4_history (
    ProductID_NK,
    ProductName,
    SupplierID_FK,
    CategoryID_FK,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued,
    ValidFrom,
    ValidTo
)
SELECT 
    ProductID_NK,
    ProductName,
    SupplierID_FK_SK AS SupplierID_FK,
    CategoryID_FK_SK AS CategoryID_FK,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued,
    ValidFrom,
    @CurrentDate -- Mark history as valid until change date
FROM dim_products_SCD4_current
WHERE ProductID_NK IN (
    SELECT ProductID FROM staging_Products
)
AND (
    ISNULL(ProductName, '') <> ISNULL((SELECT sp.ProductName FROM staging_Products sp WHERE sp.ProductID = ProductID_NK), '')
    OR ISNULL(SupplierID_FK_SK, 0) <> (SELECT sp.SupplierID FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(CategoryID_FK_SK, 0) <> (SELECT sp.CategoryID FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(QuantityPerUnit, '') <> ISNULL((SELECT sp.QuantityPerUnit FROM staging_Products sp WHERE sp.ProductID = ProductID_NK), '')
    OR ISNULL(UnitPrice, 0) <> (SELECT sp.UnitPrice FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(UnitsInStock, 0) <> (SELECT sp.UnitsInStock FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(UnitsOnOrder, 0) <> (SELECT sp.UnitsOnOrder FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(ReorderLevel, 0) <> (SELECT sp.ReorderLevel FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
    OR ISNULL(Discontinued, 0) <> (SELECT sp.Discontinued FROM staging_Products sp WHERE sp.ProductID = ProductID_NK)
);

-- Log processing actions into Dim_SOR for tracking
INSERT INTO Dim_SOR (StagingRawID_NK, TableName)
SELECT DISTINCT staging_raw_id, 'staging_Products'
FROM staging_Products;
