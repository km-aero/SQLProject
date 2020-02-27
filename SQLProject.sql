/*Q1.1*/
SELECT CustomerID, CompanyName AS 'Company Name',
    Address, City, Region, PostalCode AS 'Postal Code', Country
    FROM Customers
WHERE (City IN ('Paris', 'London'));

/*Q1.2*/
SELECT ProductID AS 'Product ID',
    SupplierID AS 'Supplier ID',
    CategoryID AS 'Category ID',
    ProductName AS 'Product Name',
    QuantityPerUnit AS 'Quantity Per Unit',
    UnitPrice AS 'Unit Price',
    UnitsInStock AS 'Units In Stock',
    UnitsOnOrder AS 'Units On Order',
    ReorderLevel AS 'Reorder Level',
    Discontinued
    FROM Products
WHERE QuantityPerUnit LIKE '%bottles%';

/*Q1.3*/
SELECT 
    ProductID AS 'Product ID',
    p.SupplierID AS 'Supplier ID',
    CategoryID AS 'Category ID',
    CompanyName AS 'Company Name',
    ProductName AS 'Product Name',
    QuantityPerUnit AS 'Quantity Per Unit',
    UnitPrice AS 'Unit Price',
    UnitsInStock AS 'Units In Stock',
    UnitsOnOrder AS 'Units On Order',
    ReorderLevel AS 'Reorder Level',
    Discontinued,
    Country
FROM (Products AS p INNER JOIN 
    (SELECT SupplierID, CompanyName, Country FROM Suppliers) AS s
    ON p.SupplierID = s.SupplierID)
WHERE QuantityPerUnit LIKE '%bottles%';

/*Q1.4*/
SELECT p.CategoryID AS 'Category ID',
c.CategoryName AS 'Category Name',
COUNT(ProductName) AS 'Total'
    FROM (Products AS p INNER JOIN
    (SELECT CategoryID, CategoryName FROM Categories) AS c
    ON c.CategoryID = p.CategoryID)
GROUP BY p.CategoryID, c.CategoryName
ORDER BY COUNT(ProductName) DESC;

/*Q1.5*/
SELECT TitleOfCourtesy + FirstName + ' ' + LastName AS 'Name',
    City AS 'City of Residence'
    FROM Employees
WHERE Country LIKE '%UK%';

/*Q1.6*/
SELECT RegionDescription AS 'Region',
    FORMAT(SUM((UnitPrice*Quantity*(1-Discount))), 'N','en-uk') AS 'Total Sales'
    FROM Region r 
INNER JOIN
    (SELECT TerritoryID, RegionID FROM Territories) t ON r.RegionID = t.RegionID
INNER JOIN
    (SELECT * FROM EmployeeTerritories) e ON e.TerritoryID=t.TerritoryID
INNER JOIN
    (SELECT EmployeeID, OrderID FROM Orders) o ON o.EmployeeID=e.EmployeeID
INNER JOIN
    [Order Details] od ON o.OrderID=od.OrderID
GROUP BY RegionDescription HAVING SUM((od.UnitPrice*od.Quantity*(1-od.Discount))) >= 1000000
ORDER BY [Total Sales] DESC;

/*Q1.7*/
SELECT COUNT(Freight) AS 'Total Orders (> 100 AND UK OR USA)' FROM Orders
WHERE (Freight > 100.00) AND (ShipCountry IN ('USA','UK'));

/*Q1.8*/
SELECT OrderID AS 'Order ID',
    (UnitPrice*Quantity*Discount) AS 'Discount Amount'
    FROM [Order Details]
WHERE (UnitPrice*Quantity*Discount) =
    (SELECT MAX(UnitPrice*Quantity*Discount) FROM [Order Details]);

/*Q2.1*/
CREATE TABLE [Spartans Table](
    studentID INT IDENTITY(1,1),
    title varchar(10) NOT NULL,
    firstName varchar(30) NOT NULL,
    lastName varchar(30) NOT NULL,
    universityAttended varchar(40) DEFAULT NULL,
    courseAttended varchar(40) DEFAULT NULL,
    markAchieved INT DEFAULT NULL,
    PRIMARY KEY (studentID)
);

/*Q2.2*/
INSERT INTO [Spartans Table]
    (title, firstName, lastName, universityAttended, courseAttended, markAchieved)
VALUES ('Mr.', 'Ayman', 'Yousfi', 'West London', 'Computer Science', 69),
    ('Mr.', 'Camile', 'Malungu', 'Brunel', 'Computer Science', 57),
    ('Miss', 'Sara', 'Abdrabu', 'Westminster', 'Computer Networks with Security', 67),
    ('Mr.', 'Adam', 'Mohsen', 'Sussex', 'Computer Science', 70),
    ('Mr.', 'Abdullah', 'Ayyaz', 'Westminster', 'Business Economics', 69),
    ('Mr.', 'Ash', 'Isbitt', 'Brunel', 'Visual Effect and Motion Graphics', 68),
    ('Mr.', 'Elliot', 'Harris', 'CCC', 'History', 58),
    ('Mr.', 'James', 'Hovell', 'Portsmouth', 'Mathematics', 67),
    ('Mr.', 'Mahan', 'Yousfi', 'Portsmouth', 'Mathematics', 82),
    ('Mr.', 'Maksaud', 'Ahmed', '', '', ''),
    ('Mr.', 'Mohammad', 'Uddin', 'Greenwich', 'Computer Science', 46),
    ('Mr.', 'Victor', 'Sibanda', 'Lincoln', 'Electrical Engineering', 74),
    ('Mr.', 'Zack', 'Davenport', 'UEA', 'Film and TV', 55);

/*Q3.1*/

SELECT EmployeeID AS 'Employee ID',
TitleOfCourtesy + ' ' + FirstName + ' ' + LastName AS 'Name',
ReportsTo AS 'Reports To' FROM Employees;

/*Q3.2*/
SELECT s.SupplierID AS 'Supplier ID', s.CompanyName AS 'Company Name',
    FORMAT(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)), 'N', 'en-uk') AS 'Total Sales'
FROM (([Order Details] od
    INNER JOIN Products p ON od.ProductID=p.ProductID)
    INNER JOIN Suppliers s ON s.SupplierID=p.SupplierID)
GROUP BY s.SupplierID, s.CompanyName
    HAVING SUM((od.UnitPrice*od.Quantity*(1-od.Discount)))>10000;

/*Q3.3*/
SELECT TOP 10 o.CustomerID AS 'Customer ID', c.CompanyName AS 'Company Name',
ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)),2) AS 'Total Value',
YEAR(ShippedDate) AS 'Year'
FROM ((Orders o
    INNER JOIN [Order Details] od ON o.OrderID=od.OrderID)
    INNER JOIN Customers c ON c.CustomerID=o.CustomerID)
GROUP BY o.CustomerID, c.CompanyName, YEAR(ShippedDate)
    HAVING YEAR(ShippedDate) = (SELECT YEAR(MAX(ShippedDate)) FROM Orders)
ORDER BY [Total Value] DESC;

/*Q3.4*/
SELECT MONTH(ShippedDate) AS 'Month',
    AVG(DATEDIFF(DD,OrderDate,ShippedDate)) AS 'AVG Ship Time (Days)'
FROM Orders
GROUP BY MONTH(ShippedDate)
    HAVING AVG(DATEDIFF(DD,OrderDate,ShippedDate)) IS NOT NULL
ORDER BY [Month];