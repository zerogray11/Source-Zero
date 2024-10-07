--Supplier Management Table: addSupplier method
CREATE PROCEDURE addSupplier
    @SupplierID INT,
    @SupplierName NVARCHAR(100),
    @ContactInfo NVARCHAR(255),
    @PerformanceMetrics NVARCHAR(255),
    @LastContact DATETIME
AS
BEGIN
    INSERT INTO SupplierManagement (SupplierID, SupplierName, ContactInfo, PerformanceMetrics, LastContact)
    VALUES (@SupplierID, @SupplierName, @ContactInfo, @PerformanceMetrics, @LastContact);
END

--Product Table: addProduct method
CREATE PROCEDURE AddProduct
    @ProductID INT,
    @ProductName NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Category NVARCHAR(50),
    @Price DECIMAL(18, 2),
    @QuantityInStock INT,
    @IsOrganic BIT,
    @SourcingTransparency NVARCHAR(255),
    @ImageURL NVARCHAR(255),
    @DietaryRestrictions NVARCHAR(255),
    @BrandID INT,
    @NutritionalInfoID INT,
    @LatestScientificData NVARCHAR(MAX),
    @Recommendations NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Product (ProductID, ProductName, Description, Category, Price, QuantityInStock, 
                         IsOrganic, SourcingTransparency, ImageURL, DietaryRestrictions, 
                         CreatedAt, UpdatedAt, BrandID, NutritionalInfoID, 
                         LatestScientificData, Recommendations)
    VALUES (@ProductID, @ProductName, @Description, @Category, @Price, @QuantityInStock, 
            @IsOrganic, @SourcingTransparency, @ImageURL, @DietaryRestrictions, 
            GETDATE(), GETDATE(), @BrandID, @NutritionalInfoID, 
            @LatestScientificData, @Recommendations);
END

--Product Table: removeProduct method
CREATE PROCEDURE RemoveProduct
    @ProductID INT
AS
BEGIN
    DELETE FROM Product
    WHERE ProductID = @ProductID;
END

--Brand Table: addBrand method
CREATE PROCEDURE AddBrand
    @BrandID INT,
    @BrandName NVARCHAR(100),
    @BrandStory NVARCHAR(MAX),
    @WebsiteURL NVARCHAR(255)
AS
BEGIN
    INSERT INTO Brand (BrandID, BrandName, BrandStory, WebsiteURL)
    VALUES (@BrandID, @BrandName, @BrandStory, @WebsiteURL);
END

--Brand Table: removeBrand method
CREATE PROCEDURE RemoveBrand
    @BrandID INT
AS
BEGIN
    DELETE FROM Brand
    WHERE BrandID = @BrandID;
END

--Promotions Table: addPromotion method
CREATE PROCEDURE AddPromotion
    @PromotionID INT,
    @Code NVARCHAR(50),
    @Description NVARCHAR(MAX),
    @DiscountType NVARCHAR(20),
    @DiscountValue DECIMAL(18, 2),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @UsageLimit INT,
    @MinimumPurchase DECIMAL(18, 2),
    @IsActive BIT
AS
BEGIN

    INSERT INTO Promotions (PromotionID, Code, Description, DiscountType, DiscountValue, 
                            StartDate, EndDate, UsageLimit, MinimumPurchase, isActive)
    VALUES (@PromotionID, @Code, @Description, @DiscountType, @DiscountValue, 
            @StartDate, @EndDate, @UsageLimit, @MinimumPurchase, @IsActive);
END

--Promotions Table: removePromotion method
CREATE PROCEDURE RemovePromotion
    @PromotionID INT
AS
BEGIN

    DELETE FROM Promotions
    WHERE PromotionID = @PromotionID;
END

--UserProfile Table: login method
CREATE PROCEDURE Login
    @Username NVARCHAR(50),
    @Password NVARCHAR(255),
    @IsAuthenticated BIT
AS
BEGIN
    DECLARE @PasswordHash NVARCHAR(255);
    
    SET @PasswordHash = HASHBYTES('Password', @Password);

    IF EXISTS (
        SELECT 1 
        FROM UserProfile 
        WHERE Username = @Username 
        AND PasswordHash = @PasswordHash
        AND IsActive = 1
    )
    BEGIN
        SET @IsAuthenticated = 1;  -- Successful login
    END
    ELSE
    BEGIN
        SET @IsAuthenticated = 0;  -- Failed login
    END
END

--UserProfile Table: resetPassword method
CREATE PROCEDURE ResetPassword
    @Username NVARCHAR(50),
    @NewPassword NVARCHAR(255)
AS
BEGIN
    DECLARE @NewPasswordHash NVARCHAR(255);
    
    SET @NewPasswordHash = HASHBYTES('Password', @NewPassword);

    UPDATE UserProfile
    SET PasswordHash = @NewPasswordHash
    WHERE Username = @Username;
END

--UserProfile Table: signUp method
CREATE PROCEDURE SignUp
    @Username NVARCHAR(50),
    @Password NVARCHAR(255)
AS
BEGIN
    DECLARE @PasswordHash NVARCHAR(255);
    
    SET @PasswordHash = HASHBYTES('Password', @Password);

    INSERT INTO UserProfile (Username, PasswordHash, IsActive)
    VALUES (@Username, @PasswordHash, 1);
END

--Orders Table: confirmOrder method
CREATE PROCEDURE ConfirmOrder
    @OrderID INT
AS
BEGIN

    UPDATE Orders
    SET Status = 'Confirmed',
        OrderDate = GETDATE()
    WHERE OrderID = @OrderID;

END