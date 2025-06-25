-- OrderPriority Table
CREATE TABLE OrderPriority(
    OrderPriorityID INT PRIMARY KEY,
    PriorityLevel VARCHAR(20)
);
-- ShiMode Table
CREATE TABLE ShipMode(
    ShipModeID INT PRIMARY KEY,
    ShipMode VARCHAR(50)
);

-- Segment Table
CREATE TABLE Segment(
    SegmentID INT PRIMARY KEY,
    SegmentName VARCHAR(50)
);

-- Location Table
CREATE TABLE Location (
    LocationID INT PRIMARY KEY,
    City VARCHAR(50),
    "State" VARCHAR(50),
    Region VARCHAR(50),
    Country VARCHAR(50),
    Market VARCHAR(50)
);

-- 5. ProductCategory Table
CREATE TABLE ProductCategory (
    SubCategoryID INT PRIMARY KEY,
    Category VARCHAR(50),
    SubCategory VARCHAR(50)
);

-- Product Table
CREATE TABLE Product(
    ProductID VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(100),
    SubCategoryID INT,
    FOREIGN KEY (SubCategoryID) REFERENCES ProductCategory(SubCategoryID)
); 

-- Customer Table
CREATE TABLE Customer(
    CustomerID VARCHAR(15) PRIMARY KEY,
    CustomerName VARCHAR(100),
    SegmentID INT,
    LocationID INT,
    FOREIGN KEY (SegmentID) REFERENCES Segment(SegmentID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

-- Orders Table
CREATE TABLE Orders(
    OrderID VARCHAR(20) PRIMARY KEY,
    CustomerID VARCHAR(15),
    OrderDate DATE,
    OrderPriorityID INT,
    Discount DECIMAL(10,2),
    ShipDate DATE,
    ShipModeID INT,
    "Year" INT,
    weeknum INT,
    Sales DECIMAL(12,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (OrderPriorityID) REFERENCES OrderPriority(OrderPriorityID),
    FOREIGN KEY (ShipModeID) REFERENCES ShipMode(ShipModeID)
);

-- OrderDetails table 
CREATE TABLE OrderDetails(
    OrderID VARCHAR(20),
    ProductID VARCHAR(20),
    Quantity INT,
    Profit DECIMAL(12,2),
    PRIMARY KEY(OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
); 

-- Inserting data to tables
INSERT INTO OrderPriority(OrderPriorityID, PriorityLevel) VALUES
(1, 'High'),
(2, 'Medium'),
(3, 'Low'),
(4, 'Critical');

INSERT INTO ShipMode (ShipModeID, ShipMode) VALUES
(1, 'Regular Air'),
(2, 'Express Air'),
(3, 'Ground');


INSERT INTO Segment (SegmentID, SegmentName) VALUES
(101, 'Consumer'),
(102, 'Corporate'),
(103, 'Home Office');

INSERT INTO Location (LocationID, City, "State", Region, Country, Market) VALUES
(201, 'Los Angeles', 'California', 'West', 'United States', 'US'),
(202, 'New York City', 'New York', 'East', 'United States', 'US'),
(203, 'London', 'England', 'North', 'United Kingdom', 'EU'),
(204, 'Tokyo', 'Tokyo', 'Kanto', 'Japan', 'Asia Pacific');

INSERT INTO ProductCategory (SubCategoryID, Category, SubCategory) VALUES
(301, 'Furniture', 'Chairs'),
(302, 'Furniture', 'Tables'),
(303, 'Office Supplies', 'Pens & Art Supplies'),
(304, 'Technology', 'Phones');

INSERT INTO Product (ProductID, ProductName, SubCategoryID) VALUES
('FUR-CH-1001', 'Ergonomic Chair', 301),
('FUR-TAB-1005', 'Conference Table', 302),
('OFF-PEN-2002', 'Ballpoint Pens - Pack of 12', 303),
('TEC-PHO-3001', 'Smart Phone X', 304),
('FUR-CH-1009', 'Folding Chair', 301);


INSERT INTO Customer (CustomerID, CustomerName, SegmentID, LocationID) VALUES
('CUS-001', 'John Smith', 101, 201),
('CUS-002', 'Alice Johnson', 102, 202),
('CUS-003', 'Bob Williams', 103, 201),
('CUS-004', 'Eva Brown', 101, 203),
('CUS-005', 'Charlie Green', 102, 204);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderPriorityID, Discount, ShipDate, ShipModeID, "Year", weeknum, Sales) VALUES
('ORD-001', 'CUS-001', '2025-05-01', 1, 0.10, '2025-05-05', 1, 2025, 18, 250.50),
('ORD-002', 'CUS-002', '2025-05-02', 2, 0.05, '2025-05-04', 2, 2025, 18, 1200.75),
('ORD-003', 'CUS-003', '2025-05-03', 1, 0.15, '2025-05-07', 1, 2025, 18, 75.20),
('ORD-004', 'CUS-001', '2025-05-05', 3, 0.00, '2025-05-08', 3, 2025, 19, 480.99),
('ORD-005', 'CUS-004', '2025-05-06', 2, 0.08, '2025-05-09', 2, 2025, 19, 920.15);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Profit) VALUES
('ORD-001', 'FUR-CH-1001', 1, 50.25),
('ORD-001', 'OFF-PEN-2002', 5, 10.50),
('ORD-002', 'TEC-PHO-3001', 2, 300.00),
('ORD-003', 'OFF-PEN-2002', 2, 4.20),
('ORD-004', 'FUR-TAB-1005', 1, 150.75),
('ORD-005', 'TEC-PHO-3001', 1, 150.00),
('ORD-005', 'FUR-CH-1009', 3, 25.80);

