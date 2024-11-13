/*
This file contains a script of Transact SQL (T-SQL) command to interact with a database 'Inventory'.
Requirements:
- SQL Server 2022 is installed and running
- referential integrity is enforced

*/

-- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Inventory')
BEGIN
    ALTER DATABASE Inventory SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Inventory;
END

CREATE DATABASE Inventory;
GO

-- Set the default database to 'Inventory'.
USE Inventory;
GO

-- Create a 'suppliers' table.
CREATE TABLE suppliers (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(150) NOT NULL,
    state CHAR(2) NOT NULL,
    -- Add a unique constraint on the name column
    CONSTRAINT UQ_SupplierName UNIQUE (name),
    -- add a description column with a length of 255 characters
    description VARCHAR(255)
);
GO

-- Create the 'categories' table with a one-to-many relation to the 'suppliers'.
CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Create the 'products' table with a one-to-many relation to the 'categories' table.
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    -- Add a unique constraint on the name column
    CONSTRAINT UQ_ProductName UNIQUE (name),
    -- add a description column with a length of 255 characters
    description VARCHAR(255),
    -- add a created_at column with a default value of the current timestamp
    created_at DATETIME DEFAULT GETDATE(),
    -- add an updated_at column with a default value of the current timestamp
    updated_at DATETIME DEFAULT GETDATE()
);

-- Populate the 'suppliers' table with sample data.
INSERT INTO suppliers (id, name, address, city, state, description)
VALUES (1, 'Supplier A', '123 Main St', 'City A', 'CA', 'Supplier A Description'),
       (2, 'Supplier B', '456 Elm St', 'City B', 'NY', 'Supplier B Description'),
       (3, 'Supplier C', '789 Oak St', 'City C', 'TX', 'Supplier C Description'),
       (4, 'Supplier D', '101 Pine St', 'City D', 'FL', 'Supplier D Description');

-- Populate the 'categories' table with sample data.
INSERT INTO categories (id, name, description, supplier_id)
VALUES (1, 'Category A', 'Category A Description', 1),
       (2, 'Category B', 'Category B Description', 2),
       (3, 'Category C', 'Category C Description', 3),
       (4, 'Category D', 'Category D Description', 4);

-- Populate the 'products' table with sample data.
INSERT INTO products (id, name, price, category_id, description)
VALUES (1, 'Product A', 10.00, 1, 'Product A Description'),
       (2, 'Product B', 20.00, 2, 'Product B Description'),
       (3, 'Product C', 30.00, 3, 'Product C Description'),
       (4, 'Product D', 40.00, 4, 'Product D Description');

-- Create a view named 'product_list' that displays the following columns:
CREATE VIEW product_list AS
SELECT p.id AS product_id, p.name AS product_name, c.name AS category_name, s.name AS supplier_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON c.supplier_id = s.id;

-- Create a stored procedure 'get_product_list' that returns the product list view.
CREATE PROCEDURE get_product_list
AS
BEGIN
    SELECT * FROM product_list;
END;

-- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
CREATE TRIGGER update_products_trigger
ON categories
AFTER DELETE
AS
BEGIN
    DELETE FROM products WHERE category_id IN (SELECT id FROM deleted);
END;

-- Create a function that returns the total number of products in a category.
CREATE FUNCTION get_total_products_in_category (@category_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products WHERE category_id = @category_id;
    RETURN @total_products;
END;

-- Create a function that returns the total number of products supplied by a supplier.
CREATE FUNCTION get_total_products_supplied_by_supplier (@supplier_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE c.supplier_id = @supplier_id;
    RETURN @total_products;
END;

-- End of inventory.sql









