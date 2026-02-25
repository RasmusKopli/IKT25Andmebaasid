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
