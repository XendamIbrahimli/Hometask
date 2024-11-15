create database myDataBase
use myDataBase


create table Authors(
Id int primary key identity,
[Name] nvarchar(20),
Surname nvarchar(20)
)
drop table Authors
insert into Authors
values('Author1','AuthorSurname1'),
('Author2','AuthorSurname2'),
('Author3','AuthorSurname3')

select *from Authors



create table Books(
Id int primary key identity,
[Name] nvarchar(100) check(len(name)>=2 and len(name)<=100),
AuthorId int foreign key references Authors(Id),
[PageCount] int Check(PageCount>=10)
)


drop table Books


insert into Books
values('Book1',2,89),
('Book2',3,130),
('Book3',2,169),
('Book4',1,40),
('Book5',2,70),
('Book6',3,200)

select *from Books



--/////////////////////////////////////////////////////////////////////////////////////////

alter view Get_Books
as
select Books.Id,Books.[Name] as [Book Name],Books.PageCount,Concat(Authors.[Name],' ',Authors.Surname) as [Author FullName] from Books
join Authors
on Books.AuthorId=Authors.Id

select *from Get_Books




--/////////////////////////////////////////////////////////////////////////////////////////



alter procedure Get_Books_By_Name (@name nvarchar(20))
as
begin
select Books.Id, Books.Name,  Books.PageCount, Concat(Authors.Name, ' ', Authors.Surname)as [Author FullName] from Books
join Authors
on Authors.Id=Books.AuthorId
where @name=Authors.Name
end

execute Get_Books_By_Name @name='Author3'


--//////////////////////////////////////////////////////////////////////////////////////////////////////////

create Procedure Insert_Authors(@AuthorId int)
as
begin
select *from Authors
where Authors.Id=@AuthorId
end

exec Insert_Authors 2



alter procedure Update_Authors(@AuthorId int)
as
begin 
update Authors
set Authors.Name='NewAuthor'
where Authors.Id=@AuthorId
end

exec Update_Authors 2

select *from Authors


alter procedure Delete_Authors(@AuthorID int)
as
begin
Delete from Books where AuthorId=@AuthorID
Delete from Authors where Authors.Id=@AuthorID
end

exec Delete_Authors @AuthorID=1

--//////////////////////////////////////////////////////////////

create view Get_Authors
as
select Authors.Id, Concat(Authors.Name,' ',Authors.Surname)as[Author Fullname], Count(Books.Id)as[Books Count], Max(Books.PageCount) as [Max PageCount]from Books
join Authors 
on Authors.Id=Books.AuthorId
group by Authors.Id, Authors.Name, Authors.Surname

select *from Get_Authors
