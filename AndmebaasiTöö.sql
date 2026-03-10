--Variant 1

create database AndmebaasiTöö

--1.
create table Raamatukogu
(
Id Int not null Primary Key,
Pealkiri Nvarchar(100),
Autor Nvarchar(100),
Aasta int,
Hind Decimal(5,2)
)

--2.
select * from Raamatukogu

insert into Raamatukogu (Id, Pealkiri, Autor, Aasta, Hind)
values (1, 'Batman', 'DC', 2010, 6.5),
(2, 'Morgan Freeman Elulugu', 'Morgan Freeman', 2015, 15.2),
(3, 'Superman', 'DC', 2010, 5.5),
(4, 'Spider-Man', 'Marvel', 2010, 7.5),
(5, 'Tom Clancy Rainbow Six Siege', 'Tom Clancy', 2003, 25.5),
(6, '1984', 'George Orwell', 1990, 15.5)

--3.
update Raamatukogu
set Hind = 16.40
where Id = 2

update Raamatukogu
set Autor = 'Marvel'
where Id = 3

--4.
alter table Raamatukogu
add Laos_Kogus int

update Raamatukogu
set Laos_Kogus = 20
where Id = 1

update Raamatukogu
set Laos_Kogus = 30
where Id = 4

update Raamatukogu
set Laos_Kogus = 3
where Id = 6

--5.
alter table Raamatukogu
drop column Hind

--6.
delete from Raamatukogu
where Id = 3