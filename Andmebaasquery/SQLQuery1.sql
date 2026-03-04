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
--mis on t‰isarv andmet¸¸p,
--kui sisestad andmed,
--siis see veerg peab olema t‰idetud
--tegemist on primaarvıtmega
Id int not null primary key,
--veeru nimi on Gender,
--10 t‰hem‰rki on max pikkus,
--andmed peavad olema sisestatud ehk
--ei tohi olla t¸hi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
--Id = 1, Gender = Male
--Id = 2, Gender = Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
-- * t‰hendab, et n‰ita kıike seal sees olevat infot
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

--n‰en tabelis olevat infot
select * from Person

--vıırvıtme ¸henduse loomine kahe tabeli vahel
alter table Person add constraint tblPersons_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--v‰‰rtust, siis automaatselt sisestab sellele reale v‰‰rtuse 3
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

--Soovin kustutada ¸he rea
delete from Person Where Id = 8

--Lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kıik, kes elavad Gothami linnas
select * from Person Where City = 'Gotham City'
--Kıik, kes ei ela Gothamis
select * from Person where City != 'Gotham City'
--Variant nr 2. Kıik kes ei ela Gothamis
select * from Person where City <> 'Gotham City'

--N‰itab teatud vanusega inimesi
--valime 151, 35, 26
select * from Person where Age in (151, 35, 26)
select * from Person where Age = 151 or Age = 35 or Age = 26

--soovin n‰ha inimesi v‰hemikus 22 kuni 41
select * from Person where Age between 22 and 41

--Wildcard ehk n‰itab kıik g-t‰hega linnad
select * from Person where City like 'g%'
--Otsib emailid @-m‰rgiga
select * from Person where Email like '%@%'

--Tahan n‰ha, kellel emailis ees ja peale @-m‰rki  ¸ks t‰ht
select * from Person where Email like '_@_.com%'

--Kıik, kelle nimes ei ole esimene t‰ht W, A, S
select * from Person where Name like '[^WAS]%'

--Kıik, kes elavad Gothamis ja New Yorkis
select * from Person where City = 'New York' or City = 'Gotham City'

--Kıik, kes elavad Gothamis ja New Yorkis ning peavad olema
--vanemad, kui 29
Select * from Person where (City = 'New York' or City = 'Gotham City')
and Age > 29

--Kuvab t‰hestikulises j‰rjekorras inimesi ja vıtab aluseks
--Name veeru
select * from Person
Select * from Person order by Name

--Vıtab kolm esimest rida Person tabelist
Select top 3 * from Person


--kolm esimest, aga tabeli j‰rjestus on Age ja siis on name
Select top 3 Age, Name from Person


--n‰ita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--j‰rjestab vanuse j‰rgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja n‰itab vanuselises j‰rjestuses
-- cast abil saab andmet¸¸pi muuta
select * from Person order by cast(Age as int) desc

-- kıikide isikute koondvanus e liidab kıik kokku
select sum(cast(Age as int)) from Person

--kıige noorem isik tuleb ¸les leida
select min(cast(Age as int)) from Person

--kıige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- n‰eme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmet¸¸pi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas v‰lja toodud j‰rjestuses ja kuvab Age-i 
-- TotalAge-ks
--j‰rjestab City-s olevate nimede j‰rgi ja siis Genderid j‰rgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--n‰itab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--n‰itab tulemust, et mitu inimest on Genderid v‰‰rtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--n‰itab ‰ra inimeste koondvanuse, mis on ¸le 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ‰ra
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
select sum(cast(Salary as int)) from Employees --arvutab kıikide palgad kokku
-- kıige v‰iksema palga saaja
select min(cast(Salary as int)) from Employees

--n‰itab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

select * from Employees
select sum(cast(Salary as int)) from Employees --Arvutab kıikide palgad kokku

--lisame veeru City ja pikkus on 30
-- Employees tabelisse lisada
alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as Int)) as TotalSalary
from Employees
group by City, Gender

--Peaaegu sama p‰ring, aga linnad on t‰hestilukises j‰rjestuses
select City, Gender, sum(cast(Salary as Int)) as TotalSalary
from Employees
group by City, Gender
order by City

--On vaja teada, et mitu inimest on nimekirjas
select count(*) from Employees

--Mitu tˆˆtajat on soo ja linna kaupa tˆˆtamas
select City, Gender, sum(cast(Salary as Int)) as TotalSalary, 
count(Id) as [TotalEmployee(s)]
from Employees
group by Gender, City

--Kuvab kas naised vıi mehed linnade kaupa
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

--Kıik kes teenivad rohkem, kui 4000
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
--kuvab neid, kellel on DepartmentName all olemas v‰‰rtus
--mitte kattuvad read eemaldatakse tulemusest
--ja sellep‰rast ei n‰idata Jamesi ja Russelit
--Kuna neil on DepartmentId NULL
select Name, gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, gender, Salary, DepartmentName
from Employees
left join Department --vıib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--n‰itab anmdeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub
--vıırvıtme reas v‰‰rtus

--Right join
select Name, gender, Salary, DepartmentName
from Employees
Right join Department --vıib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join n‰itab paremas (Department) tabelis olevaid v‰‰rtuseid,
--mis ei ¸hti vasaku (Employees) tabeliga

--Outer join
select Name, gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mılemad tabeli read kuvab

--teha cross join
select Name, gender, Salary, DepartmentName
from Employees
cross join Department
--Korrutab kıik omavahel l‰bi

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
--n‰itab ainult neid, kellel on vasakus tablis (Employees)
--DepartmentId NULL

select Name, gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId Is NULL
--N‰itab ainult paremas tabelis olevat rida,
--mis ei kattu Employees-ga

--Full join
--Mılema tabeli mitte-kattuvate v‰‰rtustega
select Name, gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
or Department.Id is NULL



