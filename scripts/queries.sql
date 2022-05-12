SELECT COUNT(*), SalesOrderID
FROM `sales.salesorderdetail`
GROUP BY SalesOrderID
HAVING COUNT(*)>=3;


SELECT product.Name, SUM(OrderQty), DaysToManufacture
FROM lojabicicletas.salesorderdetail, lojabicicletas.specialofferproduct,lojabicicletas.product
WHERE lojabicicletas.product.ProductID=lojabicicletas.specialofferproduct.ProductID
AND lojabicicletas.specialofferproduct.SpecialOfferID=lojabicicletas.salesorderdetail.SpecialOfferID
AND lojabicicletas.specialofferproduct.ProductID=lojabicicletas.salesorderdetail.ProductID
GROUP BY DaysToManufacture,product.Name
ORDER BY SUM(OrderQty) DESC
LIMIT 3;


 
 SELECT concat(FistName,' ', LastName) as Name, COUNT(SalesOrderID)
 FROM lojabicicletas.person, lojabicicletas.customer, lojabicicletas.salesorderheader
 WHERE lojabicicletas.person.BusinessEntityID=lojabicicletas.customer.PersonID
 AND lojabicicletas.customer.CustomerID=lojabicicletas.salesorderheader.CustomerID
 GROUP BY FistName, MiddleName, LastName;
 
 
 SELECT SUM(OrderQty),Name, Product.ProductID, OrderDate
 FROM lojabicicletas.salesorderdetail, lojabicicletas.salesorderheader, lojabicicletas.product
 WHERE lojabicicletas.product.ProductID=lojabicicletas.salesorderdetail.ProductID
 AND lojabicicletas.salesorderdetail.SalesOrderID=lojabicicletas.salesorderheader.SalesOrderID
 GROUP BY  ProductID, OrderDate
 ORDER BY SUM(OrderQty) DESC;
 
 
 SELECT SalesOrderID, OrderDate, TotalDue
 FROM SalesOrderHeader
 WHERE OrderDate BETWEEN '2011/09/01' AND '2011/09/30'
 AND TotalDue>1000
 