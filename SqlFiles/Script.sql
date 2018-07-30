Create table dbo.FileLoadInformation (
PkgId int identity(1,1),
PackageName VARCHAR(100),
FileName VARCHAR(100),
RecordCnt Int,
StartDateTime DateTime,
EndDateTime DateTime)
GO
Create table dbo.Customer(
CustomerId int,
CustomerName VARCHAR(100),
)


Truncate table dbo.FileLoadInformation
Select * From dbo.FileLoadInformation

Truncate table  dbo.customer
Select * from  dbo.Customer
-----------------------------------


--Create Procedure To Insert Information Before Data Flow Task Start
Create procedure dbo.InsertLogInfo
@PackageName VARCHAR(100),
@fileName VARCHAR(100),
@PkgID int output
AS
BEGIN
insert into dbo.FileLoadInformation (PackageName,FileName,StartDateTime)
values ( @PackageName,@fileName,getdate())

Set @PkgID= SCOPE_IDENTITY()
return
END


--Test if Stored Procedure is working fine
Declare @id int
EXEC dbo.InsertLogInfo 'PackageName','TestFile',@id output
Print @id

Truncate table dbo.FileLoadInformation
Select * from dbo.FileLoadInformation

--Script to use in Execute SQL task To Insert A Record
--and Return Identity Value to Output Parameter
EXEC dbo.InsertLogInfo ?,?,? output


--Create Procedure to Update the Same Row that we inserted before
--Data Flow Task Started to Update EndDatetime and RecordCount
Create procedure dbo.UpdateLogInfo
@pkgid int,
@RecordCnt int
AS
BEGIN
update dbo.FileLoadInformation
set EndDateTime=getdate()
,RecordCnt=@RecordCnt
where PkgId=@pkgid
END

--Script used in Execute SQL Task to Run the SP
EXEC dbo.UpdateLogInfo ?,?
