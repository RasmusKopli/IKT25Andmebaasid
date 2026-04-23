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

sp_help spGetNameById

create proc spGetNameById2
@Id int
--Kui on begin, siis on ka end kuskil olemas
as begin
	return (select FirstName from Employees where Id = @Id)
end

--tuleb veateade kuna kutsusime välja int-i, aga Tom on nvarchar
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of employee = ' + @EmployeeName


--Sisseehitaud string funktsioonid
--see konverteerib ASCII tähe väärtuse numbriks
select ASCII('a')

select char(65)

--prindime kogu tähestiku välja
declare @Start int
set @Start = 97
--kasutate while, et näidata kogu tähestik ette
while (@Start <= 122)
begin
	select char(@Start)
	set @Start = @Start + 1
end

--eemaldame tühjad kohad sulgudes
select('                                  Hello')
select LTRIM('                                  Hello')

--tühikute eemaldamine veerust, mis on tabelis
select FirstName, MiddleName,LastName from Employees
--eemaldage tühikud FirstName veerust ära
select LTRIM(FirstName) as FirstName, MiddleName,LastName from Employees

--paremalt poolt tühjad stringid lõikab ära
select rtrim('     Hello           ')

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt lower-iga ja upper-iga saan muuta märkide suurust
--reverse funktsioon pöörab kõik ümber
select Reverse(upper(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--left , right, substring
--vasakult poolt neli esimest tähte
select left('ABCDE', 4)
--paremalt poolt kolm tähte
select right('ABCDE', 3)

--kuvab @-tähemärgi asetust ehk mitmes on @-märk
select CHARINDEX('@', 'sara@aaa.com')

--esimene nr peale komakohta näitab, et mitmendast alustab ja
--siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5, 3)

--@ - märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

--peale @-märki hakkab kuvama tulemust, nr saab kaugust seadistada
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
len('pam@bbb.com') - CHARINDEX('@', 'pam@bbb.com'))


alter table Employees
add Email nvarchar(20)

select * from Employees

update Employees
set Email = 'Tom@aaa.com'
where Id = 1

update Employees
set Email = 'Pam@bbb.com'
where Id = 2

update Employees
set Email = 'John@aaa.com'
where Id = 3

update Employees
set Email = 'Sam@bbb.com'
where Id = 4

update Employees
set Email = 'Todd@bbb.com'
where Id = 5

update Employees
set Email = 'Ben@ccc.com'
where Id = 6

update Employees
set Email = 'Sara@ccc.com'
where Id = 7

update Employees
set Email = 'Valarie@aaa.com'
where Id = 8

update Employees
set Email = 'James@bbb.com'
where Id = 9

update Employees
set Email = 'Russel@bbb.com'
where Id = 10

--soovime teada saada domeeninimesid emailides
select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
len (Email) - charindex('@', Email)) as EmailDomain
from Employees

--alates teisest tähest emailis kuni @ märgini on tärnid
select ltrim(FirstName), LastName, substring(Email, 1, 2) + '******' + 
SUBSTRING(Email, charindex('@', Email), len(Email)) as Email from Employees

--kolm korda näitab stringis olevat väärtust
select replicate('asd', 5)

--tühiku sisestamine
select space(5)

--tühiku sisestamine FirstName ja LastName vahele
select FirstName + space(25) + LastName as FullName from Employees

--PATINDEX
--Sama, mis CHARINDEX, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccourence
from Employees
where PATINDEX('%@aaa.com', Email) > 0
--leian kõik selledomeeni esindajad ja alates mitmendast märgist algab @

--kõik .com emailid asendab .net-iga
select Email, Replace(Email, '.com', '.net') as convertedEmail
from Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedMail
from Employees

create table DateTime
(
	c_time time,
	c_date date,
	c_smalldatetime smalldatetime,
	c_datetime datetime,
	c_datetime2 datetime2,
	c_datetimeoffset datetimeoffset
)

select * from DateTime

--konkreetse masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values(getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

select * from DateTime

update DateTime
set c_datetimeoffset = '2026-04-08 14:49:28.1933333 + 10:00'
where c_datetimeoffset = '2026-03-19 14:25:09.8900000 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' --veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' -- täpe aeg koos ajalise nihkega
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg

--Saab kontrollida, kas on õige andmetüüp
select ISDATE('asd') --tagastab 0 kuna string ei ole date
select ISDATE(GETDATE()) --Kuidas saada vastuseks 1 isdate puhul
select ISDATE('2026-04-08 14:49:28.1933333') --tagastab 0 kuna max kolm komakohta võib olla
select ISDATE('2026-04-08 14:49:28.193') --tagastab 1
select DAY(GETDATE()) --annab tänase päeva numbri
select DAY('01/24/2026') --annab stringis oleva kuupäeva ja järjestus peab olema õige
select MONTH(GETDATE()) --annab jooksva kuu numbri
select MONTH('01/24/2026') --annab stringis oleva kuu ja järjestus peab olema õige
select YEAR(GETDATE()) --annab jooksva aasta numbri
select YEAR('01/24/2026') --annab stringis oleva aasta ja järjestus peab olema õige

select DATENAME(DAY, '2026-04-08 14:49:28.193') --annab stringis oleva päeva numbri
select DATENAME(WEEKDAY, '2026-04-08 14:49:28.193') --annab stringis oleva päeva sõnana
select DATENAME(MONTH, '2026-04-08 14:49:28.193') --Annab stringis oleva kuu sõnana

create table EmployeesWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

select * from EmployeesWithDates

insert into EmployeesWithDates(Id, Name, DateOfBirth)
values (1, 'Sam', '1980-12-30 00:00:00.000'),
(2, 'Pam', '1982-09-01 12:02:36.260'),
(3, 'John', '1985-08-22 12:03:30.370'),
(4, 'Sara', '1979-11-29 12:59:30.670')

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud

--vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
select Name, DateOfBirth, DATENAME(weekday, DateOfBirth) as [Day],
	--Vaatab DoB veerust kuupäevasid ja kuvab kuu nr
	Month(DateOfBirth) as MonthNumber,
	--vaatab DoB veerust kuud ja kuvab sõnana
	DateName(Month, DateOfBirth) as [MonthName],
	--võtab DoB veerust aasta
	Year(DateOfBirth) as [Year]
from EmployeesWithDates

--kuvab 3 kuna USA nädal algab pühapäeval
select DATEPART(weekday, '2026-03-24 12:59:30.670')
--tehke sama, aga kasutage kuu-d
select DATEPART(MONTH, '2026-03-24 12:59:30.670')
--liidab stringis olevale kp 20 päeva juurde
select DATEADD(day, 20 ,'2026-03-24 12:59:30.670')
--lahutab 20 päeva maha
select DATEADD(day, -20 ,'2026-03-24 12:59:30.670')
--kuvab kahe stringis oleva kuudevahelist aega nr-na
select DATEDIFF(MONTH, '11/20/2026', '01/20/2024')
--tehke sama, aga kasutage aastat
select DATEDIFF(YEAR, '11/20/2026', '01/20/2028')

--alguses uurite mis on funktsioon MS SQL
-- Andmebaasifunktsioonid on SQL-käskude kogum,
-- mida kasutatakse konkreetsete andmebaasitehingute tegemiseks.
-- Eelkirjutatud toimingud, salvestatud tegevus

--miks seda vaja on
-- Pakkuda DB-s koduvkasutatud funktsionaalsust

--mis on selle eelised ja puudused
--Eelised
	-- Saad kiiresti kasutada toiminguid ja ei pea uuesti koodi kirjutama
--Puudused
	--Funktsioon ei tohi muuta DB olekut

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
	select @tempdate = @DOB

	select @years = DATEDIFF(year, @tempdate, getdate()) - case when (month(@DOB) >
	month(GETDATE())) or (month(@DOB) = month(GETDATE()) and DAY(@DOB) > day(getdate()))
	then 1 else 0 end
	select @tempdate = DATEADD(year, @years, @tempdate)

	select @months = DATEDIFF(month, @tempdate, getdate()) - case when day(@DOB) > day(GETDATE())
	then 1 else 0 end
	select @tempdate = DATEADD(month, @months, @tempdate)

	select @days = DATEDIFF(day, @tempdate, GETDATE())

	declare @Age nvarchar(50)
		set @Age = CAST(@years as nvarchar(4)) + 'Years ' + CAST(@months as nvarchar(2)) 
		+ 'Months ' + CAST(@days as nvarchar(2)) + 'Days old '
	return @Age
end

select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

--
select SalesLT.ProductModel.ProductModelID, SalesLT.ProductModel.rowguid, SalesLT.ProductModel.ModifiedDate
from SalesLT.ProductModel
left join SalesLT.ProductModelProductDescription
on SalesLT.ProductModelProductDescription.ProductModelID = SalesLT.ProductModel.ProductModelID

--
select SalesLT.Address.AddressID, SalesLT.Address.rowguid, SalesLT.Address.ModifiedDate
from SalesLT.Address
Right join SalesLT.CustomerAddress
on SalesLT.CustomerAddress.AddressID = SalesLT.Address.AddressID

--
select SalesLT.SalesOrderHeader.SalesOrderID, SalesLT.SalesOrderHeader.rowguid, SalesLT.SalesOrderHeader.ModifiedDate
from SalesLT.SalesOrderHeader
Inner Join SalesLT.SalesOrderDetail
on SalesLT.SalesOrderDetail.SalesOrderID = SalesLT.SalesOrderHeader.SalesOrderID

--
select SalesLT.Product.ProductCategoryID
from SalesLT.Product
full outer join SalesLT.ProductCategory
on SalesLT.ProductCategory.ProductCategoryID = SalesLT.Product.ProductCategoryID

--
select SalesLT.Customer.CustomerID
from SalesLT.Customer
cross join SalesLT.CustomerAddress


create procedure spGetAllCustomers
as begin
	select CustomerID, Title, FirstName, LastName from SalesLT.Customer
end

execute spGetAllCustomers

create proc spGetCustomerById
@CustomerID int
as begin
	select FirstName, LastName, EmailAddress from SalesLT.Customer
end

execute spGetCustomerById 1

create proc spGetOrdersByDateRange
@StartDate date,
@EndDate date
as begin
	select OrderDate from SalesLT.SalesOrderHeader
end

declare @StartDate date, @EndDate date
execute spGetOrdersByDateRange @StartDate 2008-06-13 00:00:00.000, @EndDate 2009-06-13 00:00:00.000

create proc spAddNewProduct
@Name nvarchar(30),
@ProductNumber int,
@ListPrice int,
@StandardCost int,
@SellStartDate = getdate()
as begin
	insert into SalesLT.Product values (@Name, @ProductNumber, @ListPrice, @StandardCost, @SellStartDate)
end

create proc spUpdateProductPrice
@ProductNumber int,
@NewPrice int
as begin
	update SalesLT.Product set ListPrice = @NewPrice
	where ProductID = @ProductNumber
end

create proc spDeleteCustomer
as begin
	delete from SalesLT.Customer where CustomerID not in (select) 
end



create proc spGetOrderCountByCustomer
@CustomerID
as begin
	
end



select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet stringis välja tooduga
select dbo.fnComputeAge('02/24/2010') as Age

--number peale DOB muutujat näitab, et mismoodi kuvada DOB
select Id, Name, DateOfBirth,
CONVERT(nvarchar, DateOfBirth, 110) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + CAST(Id as nvarchar) as [Name-Id] from EmployeesWithDates

select CAST(GETDATE() as date) --tänane kuupäev
--tänane kuupäev, aga kasutate convert-i, et kuvada stringina
select CONVERT(date, GETDATE())

--matemaatilised funktsioonid
select ABS(-5) --ABS on absoluutväärtusega number ja tulemuseks saame ilma miinus märgita 5
select CEILING(4.2) --CEILING on funktsioon, mis ümardab ülespoole ja tulemuseks saame 5
select CEILING(-4.2) --CEILING ümardab ka miinus numbrid ülespoole, mis tähendab, et saame -4
select FLOOR(15.2) --floor on funktsioon, mis ümardab alla ja tulemuseks saame 15
select FLOOR(-15.2) --floor ümardab ka miinus numbrid alla, mis tähendab, et saame -16
select POWER(2, 4) --kaks astmes neli
select SQUARE(9) --antud juhul 9 ruudus
select SQRT(16) --antud juhul 16 ruutujuur

select RAND() --RAND on funktsioon, mis genereerib juhusliku numbri vahemikus 0 kuni 1
--kuidas saada täisnumber iga kord
select FLOOR(RAND() * 100) --korrutab sajaga iga suvalise numbri

--Iga kord näitab 10 suvalist numbrit
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print floor(rand() * 1000)
	set @counter = @counter + 1
end

select ROUND(850.556, 2)
--Round on funktsioon, mis ümardab kaks komakohta 
--ja tulemuseks saame 850.560
select ROUND(850.556, 2, 1)
--ROUND on funktsioon, mis ümardab kaks komakohta ja
--kui kolmas parameeter on 1, siis ümardab alla
select ROUND(850.556, 1)
--ROUND on funktsioon, mis ümardab ühe komakoha ja
--tulemuseks saame 850.6
select ROUND(850.556, 1, 1)
--ümardab alla ühe komakoha pealt ja 
--tulemuseks saame 850.5
select ROUND(850.556, -2) 
--ümardab täisnumbri ülessepoole ja tulemus on 900
select ROUND(850.556, -1) 
--ümardab täisnumbri alla ja tulemus on 850

---
create function dbo.CalculateAge(@DOB date)
returns int
as begin 
declare @Age int
	set @Age = DATEDIFF(year, @DOB, GETDATE()) -
	case
		when (MONTH(@DOB) > MONTH(GETDATE())) or
		(month(@DOB) = MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
		then 1 else 0 end
	return @Age
end

exec dbo.CalculateAge '1980-12-30'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36


--inline table valued functions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

select * from EmployeesWithDates

update EmployeesWithDates
set DepartmentId = 1, Gender = 'Male'
where Id = 1

update EmployeesWithDates
set DepartmentId = 2, Gender = 'Female'
where Id = 2

update EmployeesWithDates
set DepartmentId = 1, Gender = 'Male'
where Id = 3

update EmployeesWithDates
set DepartmentId = 3, Gender = 'Female'
where Id = 4

insert into EmployeesWithDates(Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', '1978-11-29 12:59:30.670', 1, 'Male')

--scalar function annab mingis vahemikus olevaid andmeid,
--inline table values ei kasuta begin ja end funktsioone
--scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--Kuidas leida kõik naised tabelis EmployeesWithDates
-- ja kaustada funktsiooni fn_EmployeesByGender
select * from fn_EmployeesByGender('Female')

--tahaks ainult Pami nime näha
select * from fn_EmployeesByGender('Female') where Name = 'Pam'

select * from Department

--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--Esimene on funktsioon ja teine tabel

select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--Multi tabel statement
--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, CAST(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
--funktsiooni nimi on fn_MS_GetEmployees()
--peab edastama meile Id, Name, DOB tabelist EmployeesWithDates
create function fn_MS_GetEmployees()
returns @Table table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, CAST(DateOfBirth as date) from EmployeesWithDates
	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena
--multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

--muudame andmeid ja vaatame, kas inline funktsioonis on muutused kajastatud
update fn_GetEmployees() set Name = 'Sam1' where Id = 1
select * from fn_GetEmployees() --saab muuta andmeid

update fn_MS_GetEmployees set Name = 'Sam2' where Id = 1
--ei saa muuta andmeid multi state funktsioonis,
--kuna see on nagu stored procedure

--deterministic vs non-deterministic functions
--deterministic funktsioonid annavad alati sama tulemuse, kui sisend on sama
select COUNT(*) from EmployeesWithDates
select SQUARE(4)

--non-deterministic funktsioonid annavad erineva tulemuse, kui sisend on sama
select getdate()
select CURRENT_TIMESTAMP
select RAND()


--Ülesanded
create function fn_GetAllCustomers_ITVF()
returns table as
return (select * from SalesLT.Customer)

select * from fn_GetAllCustomers_ITVF()

create function fn_GetCustomerByID_ITVF(@CustomerID int)
returns table as
return (select CustomerID, FirstName, LastName from SalesLT.Customer where (CustomerID = @CustomerID))

select * from fn_GetCustomerByID_ITVF(1)

create function fn_GetOrdersByCustomer_ITVF(@CustomerID int)
returns table as
return (select * from SalesLT.SalesOrderHeader where (@CustomerID = CustomerID))

select * from fn_GetOrdersByCustomer_ITVF(30019)

create function fn_GetProductsByPrice_ITVF(@MinPrice int, @MaxPrice int)
returns table as
return (select * from SalesLT.Product where (ListPrice between @MinPrice and @MaxPrice))

select * from fn_GetProductsByPrice_ITVF(100, 500)

create function fn_GetTopExpensiveProducts_ITVF()
returns table as
return (select top 10 * from SalesLT.Product order by ListPrice)

select * from fn_GetTopExpensiveProducts_ITVF()

create function fn_GetCustomerFullInfo_MSTVF(@CustomerID int)
returns @Result table (CustomerID int, Name nvarchar(50), Email nvarchar(50), Phone nvarchar(15))
as begin
	insert into @Result
	select CustomerID, coalesce(FirstName, LastName) as Name, EmailAddress, Phone from SalesLT.Customer where (@CustomerID = CustomerID)
	return
end

select * from fn_GetCustomerFullInfo_MSTVF(1)

create function fn_GetProductOrderSummary_MSTVF(@CustomerID int)
returns @Result table (CustomerID int, TotalDue int)
as begin
	insert into @Result
	select CustomerID, TotalDue from SalesLT.SalesOrderHeader where (@CustomerID = CustomerID)
	return
end

select * from fn_GetProductOrderSummary_MSTVF

create function fn_GetProductPriceCategory_MSTVF
returns @Result table (Name nvarchar(50), ListPrice int)
as begin
	insert into @Result
	select Name, ListPrice from SalesLT.Product
		if (ListPrice > 150, 'Odav', '')

Create function fn_GetTopCustomersBySpending_MSTVF
returns @Result Table
(
	CustomerID int,
	FullName nvarchar(200),
	TotalSpent MONEY
)
as begin
	insert into @Result
	select TOP 5
	c.CustomerID, c.FirstName + ' ' + c.LastName, SUM(soh.TotalDue)
	from SalesLT.Customer c
	join SalesLT.SalesOrderHeader soh
		on c.CustomerID = soh.CustomerID
	Group by c.CustomerID, c.FirstName, c.LastName
	order by TotalSpent DESC;
	return
end

--loome funktsiooni
create function fn_GetNameById(@Id int)
returns nvarchar(30)
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

--kasutame funktsiooni, leides Id 1 all oleva inimene
select dbo.fn_GetNameById(1)

select * from EmployeesWithDates

--saab näha funktsiooni sisu
sp_helptext fn_GetNameById

--nüüd muudate funktsiooni nimega fn_GetNameById
--ja panete sinna encryption, et keegi peale teie ei saaks sisu näha
alter function fn_GetNameById(@Id int)
returns nvarchar(30)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

--kui nüüd sp_helptexti kasutada, siis ei näe funktsiooni sisu
sp_helptext fn_GetNameById

--kasutame schemabindingut, et näha, mis on funktsiooni sisu
alter function dbo.fn_GetNameById(@Id int)
returns nvarchar(30)
with schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @Id)
end
--schemabinding tähendab, et kui keegi üritab muuta EmployeesWithDates
--tabelit, siis ei lase seda teha, kuna see on seotud
--fn_GetNameById funktsiooniga

--ei saa kustutadaa ega muuta tabelit EmployeesWithDates,
--kuna see on seotud fn_GetNameById funktsiooniga
drop table dbo.EmployeesWithDates

--temporary tables
--see on ainult olemas ainult selle sessiooni jooksul
--kasutatakse # sümbolit, et saada aru, et tegemist on temporary tabeliga
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails

--temporary tabelite nimekirja ei näe, kui kasutada sysobjects
--tabelit, kuna need on ajutised
select Name from sysobjects
where name like '#PersonDetails%'

--kustutame temporary table
drop table #PersonDetails

--loome sp, mis loob temporary tabeli ja paneb sinna andmed
create proc spCreateLocalTempTable
as begin
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--globaalne temp tabel on olemas kogu
--serveris ja kõigile kasutajatele, kes on ühendatud
create table ##GlobalPersonDetails (Id int, Name nvarchar(20))

--Index
create table EmployeeWithSalary
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10)
)

insert into EmployeeWithSalary(Id, Name, Salary, Gender)
values (1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary


--otsime inimesi, kelle palgavahemik on 5000 kuni 7000
select * from EmployeeWithSalary
where Salary between 5000 and 7000

--loome indeksi Salary veerule, et kiirendada otsingut
--mis asetab andmed Salary veeru järgi järjestatult
create Index IX_EmployeeSalary
on EmployeeWithSalary(Salary asc)

--Saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--tahaks IX_EmployeeSalary indeksi kasutada, et otsing oleks kiirem
select * from EmployeeWithSalary
where Salary between 5000 and 7000

--näitab, et kaustakse indeksi IX_EmployeeSalary,
--kuna see on järjestatud Salary veeru järgi
select * from EmployeeWithSalary with (index(IX_EmployeeSalary))

--Indeksi kustutamine
drop index IX_EmployeeSalary on EmployeeWithSalary --1 variant
drop index EmployeeWithSalary.IX_EmployeeSalary --2 variant

----Indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

-- Klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse
-- ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

create table EmployeeCity
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeCity

-- andmete õige järjestuse loovad klastris olevad indeksid
-- ja kasutab selleks Id nr-t
-- põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis
--ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity
create clustered index IX_EmployeeCityName
on EmployeeCity(Name)
--põhjus, miks ei saa luua klastris olevat
--indeksit Name veerule, on see, et tabelis on juba klastris
--olev indeks Id, veerul, kuna see on primaarvõti

--loome composite indeksi, mis tähendab, et see on mitme veeru indeks
--enne tuleb kustutada klastris olev indeks, kuna composite indeks
--on klastris olev indeksi tüüp
create clustered index IX_EmployeeGenderSalary
on EmployeeCity(Gender desc, Salary asc)
-- kui teed select päringu sellele tabelile, siis peaksid nägema andmeid,
-- mis järjestatud selliselt: Esimeseks võetakse aluseks Gender veerg
-- kahanevas järjestuses ja siis Salary veerg tõusvas järjestuses

select * from EmployeeCity

--mitte klastris olev indeks on eraldi struktuur,
--mis hoiab indeksi veeru väärtusi
create nonclustered index IX_EmployeeCityName
on EmployeeCity(Name)
--kui nüüd teed select päringu, siis näed, et andmed on
--järjestatud Id veeru järgi
select * from EmployeeCity

-- Erinevused kahe indeksi vahel
-- 1. Ainult üks klastris olev indeks saab olla tabeli peale,
-- mitte-klastris olevaid indekseid saab olla mitu
-- 2. Klastris olevad indeksid on kiiremad kuna indeks peab tagasi
-- viitama tabelite juhul, kui selekteeritud veerg ei ole olemas indeksis
-- 3. Klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
-- ja ei näus kettal lisa ruumi. Samas mitte klastris olevad indeksid on
-- salvsestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName 
(
	Id int Primary Key,
	FirstName nvarchar(20),
	LastName nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeFirstName

insert into EmployeeFirstName values(1, 'John', 'Smith', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC07849ED657
-- kui käivitad ülevalpool oleva koodi, siis tuleb veateade
-- et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste
-- unikaalsust ja primaarvõvtit koodiga Unikaalseid Indekseid
-- ei saa kustutada, aga käsitsi saab

create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, LastName)

--lisame uue piirangu peale
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstNameCity
unique nonclustered (City)

--Sisestage kolmas rida andmetega, mis on Id-s 3, FirstName-s John,
--LastName-s Menco ja linn on London
insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'London')

--Saab vaadata indeksite infot
exec sp_helpconstraint EmployeeFirstName

-- 1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi,
-- samas unikaalne piirang loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit või piirangut ei saa luue olemasolevasse tabelis
-- kui tabel juba sisaldab väärtusi võtmeveerus
-- 3. Vaikimisi korduvaid väärtuseid ei ole veerus lubatud,
-- kui peaks olema unikaalne indeks või piirand. NT, kui tahad sisestada
-- 10 rida andmeid, milles 5 sisaldavad korduvaid andmeid,
-- siis kõik 10 lükatakse tagasi. Kui soovin ainult 5
-- rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks
-- kasutatakse INGORE_DUP_KEY

--koodinäide
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(4, 'John', 'Menco', 3512, 'Male', 'London1')
insert into EmployeeFirstName values(5, 'John', 'Menco', 3123, 'Male', 'London2')
insert into EmployeeFirstName values(5, 'John', 'Menco', 3220, 'Male', 'London2')
-- Enne ingore käsku oleks kõik kolm rida tagasi lükatud, aga
-- nüüd läks keskmine rida läbi kuna linna nimi on unikaalne
select * from EmployeeFirstName

--View on virtuaalne tabel, mis on loodud ühe või mitme tabeli põhjal
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId

create view vw_EmployeesByDetails
as 
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
--otsige ülesse view

--kuidas view-d kasutada: vw_EmployeesByDetails
select * from vw_EmployeesByDetails
-- View ei salvesta andmeid vaikimisi
-- Seda tasub võtta, kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks,
-- mitte IT-inimesele
-- piiratud ligipääs andmetele, ei näe kõiki veerge

--teeme view, kus näeb ainult IT töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
where Department.DepartmentName = 'IT'
-- ülevalpool olevat päringut saab liigitada reataseme turvalisuse
-- alla. Tahan ainult näidata IT osakonna töötajaid

select * from vITEmployeesInDepartment

--veeru taseme turvalisus
--peale selecti määratled veergude näitamise ära
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, COUNT(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--Kui soovid vaadata view sisu?
sp_helptext vEmployeesCountByDepartment
--kui soovid muuta, siis kasutad alter view

--kui soovid kustutada, siis kasutad drop view
drop view vEmployeesCountByDepartment

--andmete uuendamine läbi view
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

update vEmployeesDataExceptSalary
set [FirstName] = 'Pam' where Id = 2

select * from Employees

--kustutage Id 2 rida ära
delete from vEmployeesDataExceptSalary where Id = 2
--andmete sisestamine läbi view: vEmployeesDataExceptSalary
-- Id 2, Female, osakond 2 ja nimi on Pam
insert into vEmployeesDataExceptSalary(Id, FirstName, Gender, DepartmentId)
values(2, 'Pam', 'Female', 2)

--Idekseeritud view
--MS SQL-s on indekseeritud view nime all ja
--Oracles materjaliseeritud view nimega

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product(Id, Name, UnitPrice)
values(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

select * from Product

create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values (1, 10)
insert into ProductSales values (3, 23)
insert into ProductSales values (4, 21)
insert into ProductSales values (2, 12)
insert into ProductSales values (1, 13)
insert into ProductSales values (3, 12)
insert into ProductSales values (4, 13)
insert into ProductSales values (1, 11)
insert into ProductSales values (2, 12)
insert into ProductSales values (1, 14)

select * from ProductSales

--Loome view, mis annab meile veerud TotalSales ja TotalTransaction

create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
count_big(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by name

select * from vTotalSalesByProduct

-- kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
-- 1. View tuleb luua koos schemabinding-ga
-- 2. Kui lisafunktsioon select list viitab väljedile ja selle tulemuseks
-- võib olla NULL, siis asendusväärtus peaks olema täpsustatud.
-- Andutd juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
-- 3. Kui GroupBy on täpsustatud, siis view select list peab
-- sisaldama COUNT_BIG(*) väljendit
-- 4. Baastabelis peaksid view-d olema viidatud kaheosalise nimega
-- ehk antud juhul dbo.Product ja dbo.ProductSales.

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)

select * from vTotalSalesByProduct

-- View piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
Select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender
--Mis on selles views valesti??
--Vaatesse ehk View-sse ei saa kaasa panna parameetreid ehk antud juhul Gender

-- Teha funktsioon, kus parameetriks on Gender
-- soovin näha veerge: Id, FirstName, Gender, DepartmentId
-- Tabeli nimi on Employees
-- Funktsiooni nimi on fnEmployeeDetails
create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return 
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

-- Kasutame funktsiooni fnEmployeeDetils koos parameetriga
select * from fnEmployeeDetails('Male')

--Order by kasutamine
create view vEmployeeDetailsStored
as
select Id, FirstName, Gender, DepartmentId
from Employees
order by Id
--Order by-id ei saa kasutada

-- temp tabeli kasutamine
create table ##TestTempTable
(Id int, FirstName nvarchar(20), Gender nvarchar(20))

insert into ##TestTempTable values(101, 'Mart', 'Male')
insert into ##TestTempTable values(102, 'Joe', 'Female')
insert into ##TestTempTable values(103, 'Pam', 'Female')
insert into ##TestTempTable values(104, 'James', 'Male')

--View nimi on vOnTempTable
--kasutame ##TestTempTable
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--View-id ja funktsioone ei saa teha ajutistele tabelitele

-- Triggerid

--DML trigger
--kokku on kolme tüüpi: DML, DDL ja LOGON

-- Trigger on stored procedure eriliik, mis automaatselt käivitub,
-- kui mingi teguvus
-- peaks andmebaasis aset leidma

-- DML - Data Manipulation Language
-- DML-i põhuilised käsklused: insert, update ja delete

-- DML triggereid saab klassifitseerida kahte tüüpi:
-- 1. After trigger (kutsutakse ka FOR triggeriks)
-- 2. Instead of trigger (selmet trigger ehk selle asemel trigger)

-- After trigger käivitub peale sündmus, kui kuskil on tehtud insert,
-- update ja delete

-- Loome uue tabeli
create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

-- peale iga töötaja sisestamis tahame teada saada töötaja Id-d,
-- päeva ning aega (millal sisestati)
-- kõik andmed tulevad EmployeeAudit tabelisse
-- andmeid sisestame Employees tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New Employee with Id = ' + cast(@Id as nvarchar(5)) + ' is added at ' 
+ cast(getdate() as nvarchar(20)))
end

select * from Employees

insert into Employees values (11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3, 'bob@bob.com')
go
select * from EmployeeAudit

-- Delete trigger
create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id = ' + cast(@Id as nvarchar(5)) +
	' is deleted at ' + cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11
select * from EmployeeAudit

-- Update trigger
create trigger trEmployeeForUpdate
on Employees
for Update
as begin
	--Muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId
	declare @OldManagerId int, @NewManagerId
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)

	--Muutuja, kuhu läheb lõppetekst
	declare @AuditString nvarchar(1000)

	--Laeb kõik uuendatud andmed temp tabeli alla
	select * from #TempTable 
	from inserted

	--Käib läbi kõik andemd temp tabelist
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		--Selekteerib esimese rea andmed temp tabel-st
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		--Võtab vanad andmed kustutatud tabelist
		select top 1 @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id
end












