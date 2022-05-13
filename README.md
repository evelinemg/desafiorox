## O desafio
A partir de um conjunto de arquivos referentes aos dados de um empresa que produz bicicletas deve-se:
 - Fazer a modelagem conceitual dos dados;
 - Criação da infraestrutura necessária;
 - Criação de todos os artefatos necessários para carregar os arquivos para o banco criado;
 - Desenvolvimento de SCRIPT para análise de dados;
 - (opcional) Criar um relatório em qualquer ferramenta de visualização de dados.
 
 Foram disponibilizados os seguintes arquivos no formato CSV:
|nº| Arquivos    |
|---| ---------------- | 
|1|  Sales.SpecialOfferProduct.csv     | 
|2|Production.Product.csv  | 
|3| Sales.SalesOrderHeader.csv|
|4| Sales.Customer.csv|
|5| Person.Person.csv|
|6|Sales.SalesOrderDetail.csv|


 A partir do diagrama oferecido é possível verificar as chaves estrangeiras e chaves primárias:
 
 ![Diagrama do BD](/img/modelooferecido.png)

## Ferramentas utilizadas

* Workbench
* AzCopy v10
* Azure Storage
* Azure MySQL 8.0
* DataFactory

## Desenvolvimento

#### Banco de Dados

A nuvem escolhida para hospedagem do Banco de Dados MySQL 8.0 foi a Azure. A assinatura da Azure para estudantes oferece 750 horas e 32GB de storage por um periodo de 12 meses, fator relevante para escolha desse serviço de cloud e que atende a realização desse projeto.
Foi criado um Banco de Dados com as seguinte configuração: 
- Burstable, B1ms, 1 vCores, 2 GiB RAM, 20 GiB storage

 ![Banco de Dados Criado na AZ](/img/bdMysql.JPG)
 
 A modelagem da Banco de Dados foi feita utilizando a ferramenta Models do Workbench
 
 ![Modelagem Banco de Dados](/img/modeloconceitual.png)
 
 Após a liberação do IP da máquina local foi feita a conexão conexão do Banco de Dados MySQL com o Workbench como mostra imagem a seguir:
 
  ![Conexão Workbench](/img/workbenchconnection.JPG)
  
  #### Scripts
  
 Assim, através do Workbench foi executado os script que cria o schema e as tabelas:
 ```mysql Cria Schema
 CREATE SCHEMA IF NOT EXISTS `lojabicicletas` DEFAULT CHARACTER SET utf8 ;
 ```
  ```mysql Cria Tabela Person
 CREATE TABLE IF NOT EXISTS `lojabicicletas`.`Person` (
  `BusinessEntityID` INT NOT NULL,
  `PersonType` VARCHAR(45) NULL,
  `NameStyle` VARCHAR(45) NULL,
  `Title` VARCHAR(45) NULL,
  `FistName` VARCHAR(100) NULL,
  `MiddleName` VARCHAR(100) NULL,
  `LastName` VARCHAR(100) NULL,
  `Suffix` VARCHAR(45) NULL,
  `EmailPromotion` INT NULL,
  `AdditionalContactInfo` VARCHAR(2000) NULL,
  `Demographics` VARCHAR(2000) NULL,
  `rowguid` VARCHAR(150) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`BusinessEntityID`))
ENGINE = InnoDB; ;
 ```
 ```mysql Cria tabela Customer
 CREATE TABLE IF NOT EXISTS `lojabicicletas`.`Customer` (
  `CustomerID` INT NOT NULL,
  `PersonID` INT NULL,
  `StoreID` INT NULL,
  `TerritoryID` INT NULL,
  `AccountNumber` VARCHAR(150) NULL,
  `rowguid` VARCHAR(150) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;
 ````
 
 ```mysql
 CREATE TABLE IF NOT EXISTS `lojabicicletas`.`SalesOrderHeader` (
  `SalesOrderID` INT NOT NULL,
  `RevisionNumber` INT NULL,
  `OrderDate` DATETIME NULL,
  `DueDate` DATETIME NULL,
  `ShipDate` DATETIME NULL,
  `Status` INT NULL,
  `OnlineOrderFlag` TINYINT NULL,
  `SalesOrderNumber` VARCHAR(45) NULL,
  `PurchaseOrderNumber` VARCHAR(45) NULL,
  `AccountNumber` VARCHAR(45) NULL,
  `CustomerID` INT NULL,
  `SalesPersonID` INT NULL,
  `TerritoryID` INT NULL,
  `BillToAddressID` INT NULL,
  `ShipToAddressID` INT NULL,
  `ShipMethodID` INT NULL,
  `CreditCardApprovalCode` VARCHAR(150) NULL,
  `CurrencyRateID` INT NULL,
  `SubTotal` FLOAT NULL,
  `TaxAmt` FLOAT NULL,
  `Freight` FLOAT NULL,
  `TotalDue` FLOAT NULL,
  `Comment` VARCHAR(150) NULL,
  `rowguid` VARCHAR(150) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`SalesOrderID`))
ENGINE = InnoDB;
```
```mysql
CREATE TABLE IF NOT EXISTS `lojabicicletas`.`Product` (
  `ProductID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `ProductNumber` VARCHAR(45) NULL,
  `MakeFlag` TINYINT NULL,
  `FinishedGoodsFlag` TINYINT NULL,
  `Color` VARCHAR(45) NULL,
  `SafetyStockLevel` INT NULL,
  `ReorderPoint` INT NULL,
  `StandardCost` FLOAT NULL,
  `ListPrice` FLOAT NULL,
  `Size` VARCHAR(45) NULL,
  `SizeUnitMeasureCode` VARCHAR(45) NULL,
  `WeightUnitMeasureCode` VARCHAR(45) NULL,
  `Weight` FLOAT NULL,
  `DaysToManufacture` INT NULL,
  `ProductLine` CHAR(1) NULL,
  `Class` CHAR(1) NULL,
  `Style` CHAR(1) NULL,
  `ProductSubcategoryID` INT NULL,
  `ProductModelID` INT NULL,
  `SellStartDate` DATETIME NULL,
  `SellEndDate` DATETIME NULL,
  `DiscontinuedDate` DATETIME NULL,
  `rowguid` VARCHAR(150) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`ProductID`))
ENGINE = InnoDB;
```
````mysql
CREATE TABLE IF NOT EXISTS `lojabicicletas`.`SpecialOfferProduct` (
  `SpecialOfferID` INT NOT NULL,
  `ProductID` INT NOT NULL,
  `rowguid` VARCHAR(150) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`SpecialOfferID`, `ProductID`))
ENGINE = InnoDB;
````
```mysql
REATE TABLE IF NOT EXISTS `lojabicicletas`.`SalesOrderDetail` (
  `SalesOrderID` INT NOT NULL,
  `SalesOrderDetailID` INT NOT NULL,
  `CarrierTrackingNumber` VARCHAR(45) NULL,
  `OrderQty` INT NULL,
  `ProductID` INT NULL,
  `SpecialOfferID` INT NULL,
  `UnitPrice` FLOAT NULL,
  `UnitPriceDiscount` FLOAT NULL,
  `LineTotal` FLOAT NULL,
  `rowguid` VARCHAR(45) NULL,
  `ModifiedDate` DATETIME NULL,
  PRIMARY KEY (`SalesOrderID`,`SalesOrderDetailID`))
ENGINE = InnoDB;
````
 #### Azure Storage
 
 Utilizando o AZCopy todos os arquivos CSV foram enviados de uma pasta local para a Azure Storage
 
 ![Sincronização Diretório Local Azure](/img/azcopyenvio.JPG)
 
 #### Ingestão dos Dados no Azure MySQL com Azure Data Factory
 
 Para a ingestão dos dados contidos nos arquivos CSV já disponibilizados na Azure Storage foi utilizada uma Pipeline feita no Azure Data Factory
 O processo de construção da pipeline foi feito a partir da definição dos datasets de source e sink para cada uma das tabelas.
 A pipeline é formada de 6 Copy activity e foram necessárias poucas intervenções no Mapping, já que as tabelas do Banco de Dados já haviam sido criadas conforme os arquivos CSV.
 
 
 ![Sincronização Diretório Local Azure](/img/pipelineAzure.JPG)
 
 ## Análise de dados
 Foi gerado um resultado completo das queries salvos no formato csv que podem ser acessado [aqui](/resultadoanalisedados). No corpo do textos segue uma prévia dos resultado limitado até 10 linhas.
 
 1. Escreva uma query que retorna a quantidade de linhas na tabela Sales.SalesOrderDetail pelo campo SalesOrderID, desde que tenham pelo menos três linhas de detalhes.
 ```mysql
SELECT COUNT(*) as Total FROM(
SELECT COUNT(*) as oders, SalesOrderID
FROM lojabicicletas.salesorderdetail
GROUP BY SalesOrderID
HAVING COUNT(*)>=3)a;
 ```
 #### Resultado
<html>
<body>
 <table>
<tr>
<td bgcolor=silver class='medium'>Total</td>
</tr>
<tr>
<td class='normal' valign='top'>12757</td>
</tr>
 </table>
 </body>
 </html>

 2. Escreva uma query que ligue as tabelas Sales.SalesOrderDetail, Sales.SpecialOfferProduct e Production.Product e retorne os 3 produtos (Name) mais vendidos (pela soma de OrderQty), agrupados pelo número de dias para manufatura (DaysToManufacture).
```mysql
SELECT product.Name, SUM(OrderQty), DaysToManufacture
FROM lojabicicletas.salesorderdetail, lojabicicletas.specialofferproduct,lojabicicletas.product
WHERE lojabicicletas.product.ProductID=lojabicicletas.specialofferproduct.ProductID
AND lojabicicletas.specialofferproduct.SpecialOfferID=lojabicicletas.salesorderdetail.SpecialOfferID
AND lojabicicletas.specialofferproduct.ProductID=lojabicicletas.salesorderdetail.ProductID
GROUP BY DaysToManufacture,product.Name
ORDER BY SUM(OrderQty) DESC
LIMIT 3;
```
#### Resultado
<html>
<body>
<table border=1>
<tr>
<td bgcolor=silver class='medium'>Name</td>
<td bgcolor=silver class='medium'>SUM(OrderQty)</td>
<td bgcolor=silver class='medium'>DaysToManufacture</td>
</tr>

<tr>
<td class='normal' valign='top'>AWC Logo Cap</td>
<td class='normal' valign='top'>8311</td>
<td class='normal' valign='top'>0</td>
</tr>

<tr>
<td class='normal' valign='top'>Water Bottle - 30 oz.</td>
<td class='normal' valign='top'>6815</td>
<td class='normal' valign='top'>0</td>
</tr>

<tr>
<td class='normal' valign='top'>Sport-100 Helmet, Blue</td>
<td class='normal' valign='top'>6743</td>
<td class='normal' valign='top'>0</td>
</tr>
</table>
</body></html>

3. Escreva uma query ligando as tabelas Person.Person, Sales.Customer e Sales.SalesOrderHeader de forma a obter uma lista de nomes de clientes e uma contagem de pedidos efetuados.
 ```mysql
  SELECT concat(FistName,' ', LastName) as Name, COUNT(SalesOrderID)
 FROM lojabicicletas.person, lojabicicletas.customer, lojabicicletas.salesorderheader
 WHERE lojabicicletas.person.BusinessEntityID=lojabicicletas.customer.PersonID
 AND lojabicicletas.customer.CustomerID=lojabicicletas.salesorderheader.CustomerID
 GROUP BY FistName, MiddleName, LastName;
 ```
 #### Resultado (10 linhas)
 <html>
<head>
</head>
<body>
<table border=1>
<tr>
<td bgcolor=silver class='medium'>Name</td>
<td bgcolor=silver class='medium'>COUNT(SalesOrderID)</td>
</tr>

<tr>
<td class='normal' valign='top'>James Hendergart</td>
<td class='normal' valign='top'>12</td>
</tr>

<tr>
<td class='normal' valign='top'>Takiko Collins</td>
<td class='normal' valign='top'>6</td>
</tr>

<tr>
<td class='normal' valign='top'>Jauna Elson</td>
<td class='normal' valign='top'>12</td>
</tr>

<tr>
<td class='normal' valign='top'>Robin McGuigan</td>
<td class='normal' valign='top'>12</td>
</tr>

<tr>
<td class='normal' valign='top'>Jimmy Bischoff</td>
<td class='normal' valign='top'>8</td>
</tr>

<tr>
<td class='normal' valign='top'>Sandeep Katyal</td>
<td class='normal' valign='top'>4</td>
</tr>

<tr>
<td class='normal' valign='top'>Richard Bready</td>
<td class='normal' valign='top'>12</td>
</tr>

<tr>
<td class='normal' valign='top'>Abraham Swearengin</td>
<td class='normal' valign='top'>4</td>
</tr>

<tr>
<td class='normal' valign='top'>Scott MacDonald</td>
<td class='normal' valign='top'>5</td>
</tr>

<tr>
<td class='normal' valign='top'>Ryan Calafato</td>
<td class='normal' valign='top'>12</td>
</tr>
</table>
</body></html>

 4. Escreva uma query usando as tabelas Sales.SalesOrderHeader, Sales.SalesOrderDetail e Production.Product, de forma a obter a soma total de produtos (OrderQty) por ProductID e OrderDate.
 ```mysql
  SELECT SUM(OrderQty),Name, Product.ProductID, OrderDate
 FROM lojabicicletas.salesorderdetail, lojabicicletas.salesorderheader, lojabicicletas.product
 WHERE lojabicicletas.product.ProductID=lojabicicletas.salesorderdetail.ProductID
 AND lojabicicletas.salesorderdetail.SalesOrderID=lojabicicletas.salesorderheader.SalesOrderID
 GROUP BY  ProductID, OrderDate
 ORDER BY SUM(OrderQty) DESC;
 ```
 #### Resultado (10 linhas)
 <html>
<head>
</head>
<body>
<table border=1>
<tr>
<td bgcolor=silver class='medium'>SUM(OrderQty)</td>
<td bgcolor=silver class='medium'>Name</td>
<td bgcolor=silver class='medium'>ProductID</td>
<td bgcolor=silver class='medium'>OrderDate</td>
</tr>

<tr>
<td class='normal' valign='top'>498</td>
<td class='normal' valign='top'>Classic Vest, S</td>
<td class='normal' valign='top'>864</td>
<td class='normal' valign='top'>2013-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>465</td>
<td class='normal' valign='top'>Classic Vest, S</td>
<td class='normal' valign='top'>864</td>
<td class='normal' valign='top'>2013-07-31 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>444</td>
<td class='normal' valign='top'>Short-Sleeve Classic Jersey, XL</td>
<td class='normal' valign='top'>884</td>
<td class='normal' valign='top'>2013-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>427</td>
<td class='normal' valign='top'>Women's Mountain Shorts, S</td>
<td class='normal' valign='top'>867</td>
<td class='normal' valign='top'>2013-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>424</td>
<td class='normal' valign='top'>Classic Vest, S</td>
<td class='normal' valign='top'>864</td>
<td class='normal' valign='top'>2014-03-31 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>420</td>
<td class='normal' valign='top'>Short-Sleeve Classic Jersey, XL</td>
<td class='normal' valign='top'>884</td>
<td class='normal' valign='top'>2013-07-31 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>415</td>
<td class='normal' valign='top'>AWC Logo Cap</td>
<td class='normal' valign='top'>712</td>
<td class='normal' valign='top'>2013-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>409</td>
<td class='normal' valign='top'>Full-Finger Gloves, L</td>
<td class='normal' valign='top'>863</td>
<td class='normal' valign='top'>2012-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>406</td>
<td class='normal' valign='top'>Long-Sleeve Logo Jersey, L</td>
<td class='normal' valign='top'>715</td>
<td class='normal' valign='top'>2013-06-30 00:00:00</td>
</tr>

<tr>
<td class='normal' valign='top'>397</td>
<td class='normal' valign='top'>Hitch Rack - 4-Bike</td>
<td class='normal' valign='top'>876</td>
<td class='normal' valign='top'>2013-07-31 00:00:00</td>
</tr>
</table>
</body></html>

 5. Escreva uma query mostrando os campos SalesOrderID, OrderDate e TotalDue da tabela Sales.SalesOrderHeader. Obtenha apenas as linhas onde a ordem tenha sido feita durante o mês de setembro/2011 e o total devido esteja acima de 1.000. Ordene pelo total devido decrescente.
 ```mysql
 SELECT SalesOrderID, OrderDate, TotalDue
 FROM SalesOrderHeader
 WHERE OrderDate BETWEEN '2011/09/01' AND '2011/09/30'
 AND TotalDue>1000
 ORDER BY TotalDue DESC;
 ````
#### Resultado (10 linhas)
<html>
<head>

</head>
<body>
<table border=1>
<tr>
<td bgcolor=silver class='medium'>SalesOrderID</td>
<td bgcolor=silver class='medium'>OrderDate</td>
<td bgcolor=silver class='medium'>TotalDue</td>
</tr>

<tr>
<td class='normal' valign='top'>44324</td>
<td class='normal' valign='top'>2011-09-01 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44326</td>
<td class='normal' valign='top'>2011-09-01 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44327</td>
<td class='normal' valign='top'>2011-09-02 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44328</td>
<td class='normal' valign='top'>2011-09-02 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44329</td>
<td class='normal' valign='top'>2011-09-02 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44330</td>
<td class='normal' valign='top'>2011-09-02 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44331</td>
<td class='normal' valign='top'>2011-09-03 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44332</td>
<td class='normal' valign='top'>2011-09-03 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44338</td>
<td class='normal' valign='top'>2011-09-04 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>

<tr>
<td class='normal' valign='top'>44334</td>
<td class='normal' valign='top'>2011-09-04 00:00:00</td>
<td class='normal' valign='top'>39539884.00</td>
</tr>
</table>
</body></html>
