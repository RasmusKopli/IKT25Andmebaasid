-- teeme andmebaasi ehk db
create database IKT25tar

--andmebaasi valimine
use IKT25tar

--andmebaasi kustutamine koodiga
drop database IKT25tar

--teeme uuesti andmebaasi IKT25tar
create database IKT25tar

--teeme tabeli
create table Gender
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad andmed,
--siis see veerg peab olema täidetud
--tegemist on primaarvõtmega
Id int not null primary key,
--veeru nimi on Gender,
--10 tähemärki on max pikkus,
--andmed peavad olema sisestatud ehk
--ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
--Id = 1, Gender = Male
--Id = 2, Gender = Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--veeru nimed: Id int not null primary key,
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int

Create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, Null, NULL, 2)

--näen tabelis olevat infot
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPersons_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--väärtust, siis automaatselt sisestab sellele reale väärtuse 3
--ehk unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email, GenderId)
values (7, 'Black Panther', 'b@b.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@man.com')

select * from Person

--Piirangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--Kuidas lisada veergu tabelile Person
--Veeru nimi on Age nvarchar(10)
alter table Person
Add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check(Age > 0 and Age < 155)

--Kuidas uuendada andmeid
update Person
set Age = 159
where Id = 7

select * from Person

--Soovin kustutada ühe rea
delete from Person Where Id = 8

--Lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person Where City = 'Gotham City'
--Kõik, kes ei ela Gothamis
select * from Person where City != 'Gotham City'
--Variant nr 2. Kõik kes ei ela Gothamis
select * from Person where City <> 'Gotham City'

--Näitab teatud vanusega inimesi
--valime 151, 35, 26
select * from Person where Age in (151, 35, 26)
select * from Person where Age = 151 or Age = 35 or Age = 26

--soovin näha inimesi vähemikus 22 kuni 41
select * from Person where Age between 22 and 41

--Wildcard ehk näitab kõik g-tähega linnad
select * from Person where City like 'g%'
--Otsib emailid @-märgiga
select * from Person where Email like '%@%'

--Tahan näha, kellel emailis ees ja peale @-märki  üks täht
select * from Person where Email like '_@_.com%'

--Kõik, kelle nimes ei ole esimene täht W, A, S
select * from Person where Name like '[^WAS]%'

--Kõik, kes elavad Gothamis ja New Yorkis
select * from Person where City = 'New York' or City = 'Gotham City'

--Kõik, kes elavad Gothamis ja New Yorkis ning peavad olema
--vanemad, kui 29
Select * from Person where (City = 'New York' or City = 'Gotham City')
and Age > 29

--Kuvab tähestikulises järjekorras inimesi ja võtab aluseks
--Name veeru
select * from Person
Select * from Person order by Name

--Võtab kolm esimest rida Person tabelist
Select top 3 * from Person


--kolm esimest, aga tabeli järjestus on Age ja siis on name
Select top 3 Age, Name from Person


--näita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja näitab vanuselises järjestuses
-- cast abil saab andmetüüpi muuta
select * from Person order by cast(Age as int) desc

-- kõikide isikute koondvanus e liidab kõik kokku
select sum(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i 
-- TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis Genderid järgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--näitab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--näitab tulemust, et mitu inimest on Genderid väärtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

---
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab k]ikide palgad kokku Employees tabelist
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku
-- kõige väiksema palga saaja
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

select * from Employees
select sum(cast(Salary as int)) from Employees --Arvutab kõikide palgad kokku

--lisame veeru City ja pikkus on 30
-- Employees tabelisse lisada
alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as Int)) as TotalSalary
from Employees
group by City, Gender

--Peaaegu sama päring, aga linnad on tähestilukises järjestuses
select City, Gender, sum(cast(Salary as Int)) as TotalSalary
from Employees
group by City, Gender
order by City

--On vaja teada, et mitu inimest on nimekirjas
select count(*) from Employees

--Mitu töötajat on soo ja linna kaupa töötamas
select City, Gender, sum(cast(Salary as Int)) as TotalSalary, 
count(Id) as [TotalEmployee(s)]
from Employees
group by Gender, City

--Kuvab kas naised või mehed linnade kaupa
--Kasutage where
select City, Gender, sum(cast(Salary as Int)) as TotalSalary, 
count(Id) as [TotalEmployee(s)]
from Employees
Where Gender = 'Male'
group by Gender, City

--Sama tulemus nagu eelmine kord, aga kasutage Having
select City, Gender, sum(cast(Salary as Int)) as TotalSalary, 
count(Id) as [TotalEmployee(s)]
from Employees
group by Gender, City
Having Gender = 'Male'

--Kõik kes teenivad rohkem, kui 4000
select * from Employees where sum(cast(Salary as Int)) > 4000

--teeme variandi, kus saame tulemuse
select Gender, City, sum(cast(Salary as Int)) as TotalSalary, 
count(Id) as [TotalEmployee(s)]
from Employees
group by Gender, City
Having sum(cast(Salary as int)) > 4000

--Loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

Insert into Test1 Values('X')
Select * from Test1

--Kustutame veeru nimega City Employee tabelist
Alter table Employees
Drop column City

--Inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
--mitte kattuvad read eemaldatakse tulemusest
--ja sellepärast ei näidata Jamesi ja Russelit
--Kuna neil on DepartmentId NULL
select Name, gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, gender, Salary, DepartmentName
from Employees
left join Department --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--näitab anmdeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub
--võõrvõtme reas väärtus

--Right join
select Name, gender, Salary, DepartmentName
from Employees
Right join Department --võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid,
--mis ei ühti vasaku (Employees) tabeliga

--Outer join
select Name, gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mõlemad tabeli read kuvab

--teha cross join
select Name, gender, Salary, DepartmentName
from Employees
cross join Department
--Korrutab kõik omavahel läbi

--teha left join, kus Employees tabelist DepartmentId on NULL
select Name, gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId Is null

--Teine variant ja sama tulemus
select Name, gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id Is NULL
--näitab ainult neid, kellel on vasakus tablis (Employees)
--DepartmentId NULL

select Name, gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId Is NULL
--Näitab ainult paremas tabelis olevat rida,
--mis ei kattu Employees-ga

--Full join
--Mõlema tabeli mitte-kattuvate väärtustega
select Name, gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
or Department.Id is NULL

--Teete AdventureWorksLT2019 andmebaasile join päringuid:
--Inner join, left join, right join, cross join ja full join
--Tabeleid sellesse andmebaasi juurde ei tohi teha

--Mõnikord peab muutuja ette kirjutama tabeli nimetuse nagu on Product.Name,
--et editor saaks aru, et kumma tabeli muutujat soovitakse kasutada ja ei tekikst
--segadust
Select Product.Name as [Product Name], ProductNumber, ListPrice, 
ProductModel.Name as [Product Model Name], 
Product.ProductModelId,ProductModel.ProductModelId
--mõnikord peab ka tabeli ette kirjutama täpsustama info
--nagu on SalesLt.Product
from SalesLT.Product
inner join SalesLT.ProductModel
--Antud juhul Producti tabelis ProductModelId võõrvõti,
--mis ProductModeli tabelis on primaarvõti
on Product.ProductModelId = ProductModel.ProductModelId

--isnull funktsiooni kasutamine
select isnull('Ingvar', 'No Manager') As Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

alter table Employees
add ManagerId int

--neile, kellel ei ole ülemust, siis paneb neile 'No Manager' teksti
--kasutage left joini
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--Kasutame inner joini
--kuvab ainult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

--Lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)

alter table Employees
add LastName Nvarchar(30)

select * from Employees

--muudame olemasoleva veeru nimetust
sp_rename 'Employees.Name', 'FirstName'

update Employees
set MiddleName = 'Nick', Lastname = 'Jones'
where Id = 1

update Employees
set LastName = 'Anderson'
where Id = 2

update Employees
set LastName = 'Smith'
where Id = 4

Update employees
set FirstName = Null, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set MiddleName = 'Ten', LastName = 'Seven'
where Id = 6

Update employees
set LastName = 'Connor'
where Id = 7

Update employees
set MiddleName = 'Balerine'
where Id = 8

Update employees
set MiddleName = '007', LastName = 'Bond'
where Id = 9

Update employees
set FirstName = Null, LastName = 'Crowe'
where Id = 10

--Igast reast võtab esimesena täidetud lahti ja kuvab ainult seda
--coalesce
select * from Employees
select Id, coalesce (FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int Identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int Identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers


--Kasutame union all, mis siis näitab kõike ridu
--Union all ühendab tabelid ja näitab sisu
select id, Name, Email from IndianCustomers
union all
select id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select id, Name, Email from IndianCustomers
union
select id, Name, Email from UKCustomers

--kasutad union all, aga sorteerid nime järgi
select id, Name, Email from IndianCustomers
union all
select id, Name, Email from UKCustomers
order by Name

--Stored Procedure
--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
create procedure spGetEmployees
as begin
select FirstName, Gender from Employees
end

--Nüüd saab kasutada selle nimelist sp-d
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--@ tähendab muutujat
@Gender nvarchar(20),
@DepartmentId int
as begin
    select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end


--kui nüüd allolevat käsklust käima panna, siis nõuab gender parameetrit
spGetEmployeesByGenderAndDepartment

--õige variant
spGetEmployeesByGenderAndDepartment 'Female', 1

--niimoodi saab sp kirja pandud järjekorrast mööda minna, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--Saab vaadata sp sisu result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--Kuidas muuta sp-d ja panna sinna võti peale, et keegi teine peale teie ei saaks muuta
--kuskile tuleb lisada with encryption
alter proc spGetEmployeesByGenderAndDepartment
--@ tähendab muutujat
@Gender nvarchar(20),
@DepartmentId int
with encryption
as begin
    select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
    select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--Annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
--tuleb teha declare muutuja @TotalCount, mis on int
--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is Null
--lõpus kasuta printi @TotalCounti puhul

declare @TotalCount int
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if (@TotalCount = 0)
	print '@TotalCount is Null'
else
    Print '@TotalCount is not Null'
print @TotalCount


--Näitab ära, mitu rida vastab nõuetele

--Deklareerimemuutuja @TotalCount, mis on int andmetüüp
declare @TotalCount int
--käivitame stored procedure spGetEmployeeCountByGender sp, kus on parameetrid
--@EmployeeCount = @TotalCount out ja @Gender
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
--prindib konsooli välja, kui TotalCount on null või mitte null
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--Tabeli info vaatamine
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame, millest sõltub meie valitud sp
sp_depends spGetEmployeeCountByGender
--näitab, et sp sõltub Employees tabelist, kuna seal on count(Id)
--ja Id on Employees tabelis

--vaatame tabelit
sp_depends Employees

--teeme sp, mis annab andmeid Id ja Name veergude kohta employee tabelis
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end


--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--on vaja teha uus päring, kus kasutame spTotalCount2 sp-d,
--et saada tabeli ridade arv
--Tuleb deklareerida muutuja @TotalCount, mis on int andmetüüp
--tuleb execute spTotalCount2, kus on parameeter @TotalEmployees
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
print @TotalEmployees

--mis Id all on keegi nime järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

--annab tulemuse, kus Id 1 (Seda numbrit saab muuta) real on keegi koos nimega
--printi tuleb kasutada, et näidata tulemust
declare @FirstName nvarchar (20)
exec spGetNameById1 9, @FirstName output
print 'Name of the employee = ' + @FirstName

--tehke sama, mis eelmine, aga kasutage spGetNameById sp-d
--FirstName lõpus on out
declare @FirstName nvarchar (20)
exec spGetNameById 9, @FirstName out
print 'Name of the employee = ' + @FirstName

--output tagastab muudetud read kohe päringu tulemusena
--See on salvestatud protseduuris ja ühe väärtuse tagastamine
--out ei anna mitte midagi, kui seda ei määra execute käsus





