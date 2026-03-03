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
