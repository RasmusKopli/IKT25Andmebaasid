--1. Leia, mitu klienti on tabelis Customer (kasuta COUNT)

select COUNT(*) from SalesLT.Customer

--2. Leia tellimuste koguarv tabelis SalesOrderHeader (TotalDue) (kasuta COUNT_BIG)

select COUNT_BIG(TotalDue) from SalesLT.SalesOrderHeader

--3. Leia suurim tellimuste summa (TotalDue) (kasuta MAX)

select MAX(TotalDue) from SalesLT.SalesOrderHeader

--4. Leia väikseim tellimuse summa (TotalDue) (Kasuta MIN)

select MIN(TotalDue) from SalesLT.SalesOrderHeader

--5. Leia kõigi tellimuste kogusumma (TotalDue) (Kasuta SUM)

select SUM(TotalDue) from SalesLT.SalesOrderHeader

--6. Leia, mitu toodet on tabelis Product, mille hind (ListPrice) on suurem kui 100. (kasuta COUNT ja WHERE)

select COUNT(ListPrice) from SalesLT.Product where ListPrice > 100

--7. Leia kõige kallim toode (ListPrice), mille hind on väiksem kui 1000 (kasuta MAX ja WHERE)

select MAX(ListPrice) from SalesLT.Product where ListPrice < 1000

--8. Leia kõige odavam toode (ListPrice), mille hind on suurem kui 0 (kasuta MIN ja WHERE)

select MIN(ListPrice) from SalesLT.Product where ListPrice > 0

--9. Leia kõikide toodete koguhind (ListPrice), mille värv (Color) ei ole null (kasutada SUM ja WHERE)

select SUM(ListPrice) from SalesLT.Product where Color is not null

--10.Leia, mitu klienti on liitunud pärast aastat 2010 (ModifiedDate) (Kasuta COUNT ja WHERE)

select COUNT(ModifiedDate) from SalesLT.Customer where ModifiedDate < 2010-01-01

--11. Leia, kõige varasem muutus (ModifiedDate) SalesOrderDetail seast, kus on tehtud muutus enne 2009 a. (kasuta MIN ja WHERE)

select MIN(ModifiedDate) from SalesLT.SalesOrderDetail where ModifiedDate > 2009-01-01

--12. Leia tellimuste kogusumma (TotalDue) iga kliendi kohta (kasuta SUM ja GROUP BY CustomerID)

Select SalesLT.SalesOrderHeader.CustomerID, SUM(SalesLT.SalesOrderHeader.TotalDue) 
from SalesLT.SalesOrderHeader
join SalesLT.Customer
on SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID
Group By SalesLT.SalesOrderHeader.CustomerID, SalesLT.SalesOrderHeader.TotalDue

--13. Leia iga kliendi tellimuste arv (Join Customer + SalesOrderHeader, kasuta Count + GroupBy)

select SalesLT.SalesOrderHeader.SalesOrderID, COUNT(SalesLT.Customer.CustomerID)
from SalesLT.SalesOrderHeader
join SalesLT.Customer
on SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID
Group by SalesLT.SalesOrderHeader.SalesOrderID

--14. Leia iga tootekategooria toodete arv (JOIN Product + ProductSubcategory + ProductCategory, kasuta COUNT + GROUP BY)

select SalesLT.ProductCategory.Name, COUNT(SalesLT.Product.ProductCategoryID)
from SalesLT.Product
join SalesLT.ProductCategory
on SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID
Group by SalesLT.ProductCategory.Name

--15. Leia iga kliendi tellimuste kogusumma (TotalDue), kui näita ainult neid, kelle kogusumma on üle 10000 
--(JOIN Customer + SalesOrderHeader, kasuta SUM + GROUP BY + HAVING)

select  SalesLT.SalesOrderHeader.CustomerID, SUM(SalesLT.SalesOrderHeader.TotalDue)
from SalesLT.SalesOrderHeader
join SalesLT.Customer
on SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID
Group By SalesLT.SalesOrderHeader.CustomerID, SalesLT.SalesOrderHeader.TotalDue
Having TotalDue > 10000

