CREATE TABLE UserProfile (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DateOfBirth DATE,
    ProfilePictureURL NVARCHAR(255),
    Bio NVARCHAR(MAX),
    Location NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    IsActive BIT DEFAULT 1,
    Role NVARCHAR(20) DEFAULT 'user',
    Preferences NVARCHAR(MAX),
    
);

CREATE TABLE Membership (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    MembershipType NVARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    
    FOREIGN KEY (UserID) REFERENCES UserProfile(UserID) ON DELETE CASCADE
);

CREATE TABLE [Product] (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Category NVARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    QuantityInStock INT DEFAULT 0,
    IsOrganic BIT DEFAULT 1,
    SourcingTransparency NVARCHAR(255),
    ImageURL NVARCHAR(255),
    DietaryRestrictions NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    BrandID INT,
    NutritionalInfoID INT,
    LatestScientificData NVARCHAR(MAX),
    Recommendations NVARCHAR(MAX),

    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID),
);

CREATE TABLE NutritionalInfo (
    NutritionalInfoID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ServingSize NVARCHAR(50),
    Calories INT,
    TotalFat DECIMAL(10, 2),
    SaturatedFat DECIMAL(10, 2),
    TransFat DECIMAL(10, 2),
    Cholesterol INT,
    Sodium INT,
    TotalCarbohydrates DECIMAL(10, 2),
    DietaryFiber DECIMAL(10, 2),
    Sugars DECIMAL(10, 2),
    Protein DECIMAL(10, 2),
    Vitamins NVARCHAR(MAX),
    Minerals NVARCHAR(MAX),

    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Brand (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName NVARCHAR(100) NOT NULL,
    BrandStory NVARCHAR(MAX),
    WebsiteURL NVARCHAR(255)
);

CREATE TABLE ShoppingCart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    ExpirationTime DATETIME,
    IsActive BIT DEFAULT 1,
    ProductID INT,
    Quantity INT DEFAULT 1,
    Saved BIT DEFAULT 0,
    PromotionID INT,
    Action NVARCHAR(50),  
    ActionDate DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES UserProfile(UserID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);

CREATE TABLE Promotions (
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(50) UNIQUE NOT NULL,
    Description NVARCHAR(MAX),
    DiscountType NVARCHAR(50),  
    DiscountValue DECIMAL(10, 2) NOT NULL,
    StartDate DATETIME,
    EndDate DATETIME,
    UsageLimit INT DEFAULT 1,
    MinimumPurchase DECIMAL(10, 2) DEFAULT 0,
    IsActive BIT DEFAULT 1
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'pending', 
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentMethod NVARCHAR(50),  
    DeliveryAddress NVARCHAR(255),
    DeliveryScheduled DATETIME,
    DeliveryInstructions NVARCHAR(MAX),

    FOREIGN KEY (UserID) REFERENCES UserProfile(UserID)
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CartItemID INT,
    ProductID INT,
    Quantity INT DEFAULT 1,
    Price DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CartItemID) REFERENCES ShoppingCart(CartID),  
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Logistics (
    LogisticsID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Carrier NVARCHAR(100),
    TrackingNumber NVARCHAR(100),
    ShippedDate DATETIME,
    ExpectedDeliveryDate DATETIME,
    ActualDeliveryDate DATETIME,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    OrderID INT,
    Message NVARCHAR(MAX),
    NotificationDate DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0,

    FOREIGN KEY (UserID) REFERENCES UserProfile(UserID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    StorageFacility NVARCHAR(255),
    InventoryLevel INT NOT NULL,
    Location NVARCHAR(255),
    LastUpdated DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE DeliveryCoordination (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    InventoryID INT,
    ScheduledDate DATETIME,
    RoutingInfo NVARCHAR(MAX),
    TrackingNumber NVARCHAR(100),
    Status NVARCHAR(50) DEFAULT 'scheduled',  

    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID)
);

CREATE TABLE SupplierManagement (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(255),
    ContactInfo NVARCHAR(255),
    PerformanceMetrics NVARCHAR(MAX),
    LastContacted DATETIME DEFAULT GETDATE()
);

CREATE TABLE CustomerService (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    IssueDescription NVARCHAR(MAX),
    Status NVARCHAR(50) DEFAULT 'open',  
    CreatedAt DATETIME DEFAULT GETDATE(),
    ResolvedAt DATETIME,

    FOREIGN KEY (UserID) REFERENCES UserProfile(UserID)
);

CREATE TABLE Collaborations (
    CollaborationID INT IDENTITY(1,1) PRIMARY KEY,
    PartnerName NVARCHAR(255),
    BrandID INT,
    Type NVARCHAR(50),  
    Description NVARCHAR(MAX),
    ContactInfo NVARCHAR(255),

    FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)
);

CREATE TABLE UserManagement (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    TwoFactorEnabled BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME,
    IsActive BIT DEFAULT 1
);

CREATE TABLE RolesAndPermissions (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL,
    Permissions NVARCHAR(MAX),
    UserID INT,

    FOREIGN KEY (UserID) REFERENCES UserManagement(UserID)
);

CREATE TABLE DataManagement (
    DataID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    AccessLog NVARCHAR(MAX),
    BackupDate DATETIME DEFAULT GETDATE(),
    IsBackupSuccessful BIT DEFAULT 1,

    FOREIGN KEY (UserID) REFERENCES UserManagement(UserID)
);

CREATE TABLE Security (
    SecurityID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    SecurityQuestion NVARCHAR(255),
    SecurityAnswerHash NVARCHAR(255),
    IncidentReport NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES UserManagement(UserID)
);

CREATE TABLE AnalyticsAndReporting (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    MembershipID INT,
    SearchFunctionalityID INT,
    CartID INT,
    DeliveryID INT,
    UsagePatterns NVARCHAR(MAX),
    MembershipInsights NVARCHAR(MAX),
    SalesReport NVARCHAR(MAX),
    InventoryReport NVARCHAR(MAX),
    ForecastingTrends NVARCHAR(MAX),
    InventoryTurnoverRate DECIMAL(10, 2),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES UserManagement(UserID),
    FOREIGN KEY (MembershipID) REFERENCES Membership(MembershipID),
    FOREIGN KEY (CartID) REFERENCES ShoppingCart(CartID),
    FOREIGN KEY (DeliveryID) REFERENCES DeliveryCoordination(DeliveryID)
);






