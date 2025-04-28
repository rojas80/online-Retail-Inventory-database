-- Create Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY CHECK (CustomerID BETWEEN 10000 AND 99999),
    Country VARCHAR(40) NOT NULL
);

-- Create Invoice table
CREATE TABLE Invoice (
    InvoiceNo VARCHAR(75) PRIMARY KEY,
    InvoiceDate DATE NOT NULL CHECK (InvoiceDate > '2010-01-01'),
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create Product table (fixed InventoryStatus column name)
CREATE TABLE Product (
    ProductCode VARCHAR(75) PRIMARY KEY,
    Description VARCHAR(150) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    InventoryQuantity INT NOT NULL DEFAULT 0,
    InventoryStatus VARCHAR(20) NOT NULL DEFAULT 'Good Inventory'
);

-- Create InvoiceDetails table
CREATE TABLE InvoiceDetails (
    InvoiceNo VARCHAR(75) NOT NULL,
    ProductCode VARCHAR(75) NOT NULL,
    PurchaseQuantity INT NOT NULL DEFAULT 0 CHECK (PurchaseQuantity BETWEEN 0 AND 200),
    PRIMARY KEY (InvoiceNo, ProductCode),
    FOREIGN KEY (InvoiceNo) REFERENCES Invoice(InvoiceNo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductCode) REFERENCES Product(ProductCode)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Trigger function to update InventoryStatus
CREATE OR REPLACE FUNCTION update_inventory_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.InventoryQuantity < 5 THEN
        UPDATE Product
           SET InventoryStatus = 'Need attention'
         WHERE ProductCode = NEW.ProductCode;
    ELSE
        UPDATE Product
           SET InventoryStatus = 'Good Inventory'
         WHERE ProductCode = NEW.ProductCode;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after product updates
CREATE TRIGGER quantity_update
AFTER UPDATE OF InventoryQuantity ON Product
FOR EACH ROW
EXECUTE FUNCTION update_inventory_status();


-- Note: All the data from Online Retail-V2.xlsx file was imported in the client_data, using pgadmin 4 import feature.
-- Insert data from staging table (client_data)
INSERT INTO Customer (CustomerID, Country)
SELECT DISTINCT CustomerID, Country
FROM client_data;

INSERT INTO Invoice (InvoiceNo, InvoiceDate, CustomerID)
SELECT DISTINCT InvoiceNo, InvoiceDate, CustomerID
FROM client_data;

INSERT INTO Product (ProductCode, Description, UnitPrice, InventoryQuantity)
SELECT DISTINCT ProductCode, Description, UnitPrice, InventoryQuantity
FROM client_data;

INSERT INTO InvoiceDetails (InvoiceNo, ProductCode, PurchaseQuantity)
SELECT InvoiceNo, ProductCode, PurchaseQuantity
FROM client_data;

-- Query: customers who purchased both specified products
SELECT Inv.CustomerID
  FROM Invoice Inv
  JOIN InvoiceDetails Det ON Inv.InvoiceNo = Det.InvoiceNo
  JOIN Product P ON Det.ProductCode = P.ProductCode
 WHERE P.Description IN ('CREAM CUPID HEARTS COAT HANGER','SAVE THE PLANET MUG')
 GROUP BY Inv.CustomerID
HAVING COUNT(DISTINCT P.Description) = 2;

-- Query: customer who spent the most money
SELECT Inv.CustomerID,
       SUM(P.UnitPrice * Det.PurchaseQuantity) AS AmountSpent
  FROM Invoice Inv
  JOIN InvoiceDetails Det ON Inv.InvoiceNo = Det.InvoiceNo
  JOIN Product P ON Det.ProductCode = P.ProductCode
 GROUP BY Inv.CustomerID
 ORDER BY AmountSpent DESC
 LIMIT 1;
