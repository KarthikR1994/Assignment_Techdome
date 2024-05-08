	/*1. Orders (OrderID, CustomerID, OrderDate, TotalAmount) 
	2. Customers (CustomerID, FirstName, LastName, Email) 
	3. Products (ProductID, ProductName, UnitPrice) 
	4. OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)*/ 

 1. Retrieve a list of customers who have made at least one purchase, along with their total spending.
 
	SELECT CONCAT(C.FirstName,C.LastName) as Customer_Name, 
	O.TotalAmount as Total_Spending,
	COUNT(O.OrderID) as Toatl_Purchase
	from Customers C
	join Orders O
	on C.CustomerID = O.CustomerID
	group by Customer_Name, Total_Spending
	having COUNT(O.OrderID) >= 1;
	
 2. Calculate the total revenue generated from sales in the year 2022.
 
	Select sum(P.Quantity * OD.UnitPrice) as Total_Revenue_Generated
	from Products as P
	join OrderDetails as OD
	on P.ProductID = OD.ProductID
	join Orders as O
	on O.OrderID = OD.OrderID
	where year(O.OrderDate) = '2022';
	
3. Identify the top 5 products by revenue in descending order.

	select top 5 P.ProductID, P.ProductName, sum(P.Quantity * OD.UnitPrice) as Revenue
	from Products as P
	join OrderDetails as OD
	on P.ProductID = OD.ProductID
	group by P.ProductID, P.ProductName
	order by Revenue desc;
	
4. Find the customer with the highest total spending and list their details. 
	
	Select C.CustomerID, CONCAT(C.FirstName,C.LastName) as Customer_Name, max(sum(P.Quantity * OD.UnitPrice)) as TOtal_Spending
	from Customers as C 
	Left Join Orders as O
	on O.CustomerID = C.CustomerID
	Left Join OrderDetails as OD
	on OD.OrderID = O.OrderID
	Left Join Products as P 
	on P.ProductID = OD.ProductID
	group by C.CustomerID, Customer_Name;
	
5. Determine the average order value (AOV) for each year between 2020 and 2022.

	select CustomerID, avg(TotalAmount) as AOV
	from Orders 
	WHERE year(OrderDate) >= '2020' and year(OrderDate) <='2022'
	group by CustomerID;
	
6. Calculate the total number of products sold for each product category. 
    
	 SELECT P.ProductID, P.ProductName, count(OD.ProductID) as Products_Sold
	 from Products as P
	 join OrderDetails as OD
	 on P.ProductID = OD.ProductID
	 group by P.ProductID, P.ProductName;
	 
7. Identify the product with the highest quantity sold in each product category. 
     
	with CTE
	AS
	(
		 SELECT P.ProductID, P.ProductName, count(OD.ProductID) as Products_Sold,
		 DENSE_RANK() over (order by count(OD.ProductID) desc) as Highest_Quantity_Sold
		 from Products as P
		 join OrderDetails as OD
		 on P.ProductID = OD.ProductID
		 group by P.ProductID, P.ProductName;
	)
	select ProductID, ProductName from CTE
	where Highest_Quantity_Sold = 1;
