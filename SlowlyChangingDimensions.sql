Create Table dbo.tblSource
(
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblSource_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblSource_LastName default 'N/A',
  Age int not null 
    constraint DF_tblSource_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblSource_Salary default Null,
  DOB Date not null 
    constraint DF_tblSource_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblSource_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblSource_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblSource_ZipCode default 'N/A',
  DimensionCheckSum int not null 
    constraint DF_tblSource_DimensionCheckSum default -1,
  LastUpdated datetime  not null 
    constraint DF_tblSource_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblSource_UpdatedBy default suser_sname()
)
Create Table dbo.tblSCDType1
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget_Salary default Null,
  DOB Date not null 
    constraint DF_tblTarget_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget_ZipCode default 'N/A',
  LastUpdated datetime  not null 
    constraint DF_tblTarget_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget_UpdatedBy default suser_sname()
)

Create PROCEDURE SCDTYPE1
AS
BEGIN

	UPDATE tblSCDType1  
	SET FirstName=T1.FirstName,LastName=T1.LastName,DOB=T1.DOB, Age = T1.Age, CurrentSalary = T1.CurrentSalary, City = T1.City,Country = T1.Country,Zipcode = T1.Zipcode
	FROM tblSource T1
	WHERE 
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.FirstName ,'-1') <> COALESCE (T1.FirstName ,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.LastName ,'-1') <> COALESCE (T1.LastName ,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.Age ,'-1') <> COALESCE (T1.Age ,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.CurrentSalary ,'-1') <> COALESCE (T1.CurrentSalary ,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.DOB ,'-1') <> COALESCE (T1.DOB ,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.City ,'-1') <> COALESCE (T1.City,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.Country ,'-1') <> COALESCE (T1.Country,'-1') or
	tblSCDType1.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType1.Zipcode ,'-1') <> COALESCE (T1.Zipcode,'-1')

	INSERT INTO tblSCDType1 (SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode)
	SELECT  T1.SourceSystemID,T1.FirstName,T1.LastName,T1.Age,T1.CurrentSalary,T1.DOB,T1.City,T1.Country,T1.ZipCode
	FROM 
	tblSource T1 
	LEFT OUTER JOIN
	tblSCDType1 T2 
	ON 
	T1.SourceSystemID=T2.SourceSystemID
	WHERE
	T2.SourceSystemID IS NULL

END


Create Table dbo.tblSCDType2
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget2_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget2_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget2_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget2_Salary default Null,
  DOB Date not null 
    constraint DF_tblTarget2_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget2_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget2_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget2_ZipCode default 'N/A',
  DimensionCheckSum int not null 
    constraint DF_tblTarget2_DimensionCheckSum default -1,
  EffectiveDate date not null 
    constraint DF_tblTarget2_EffectiveDate default getdate(),
  EndDate date not null 
    constraint DF_tblTarget2_EndDate default '12/31/9999',
  CurrentRecord char(1) not null 
    constraint DF_tblTarget2_CurrentRecord default 'Y',
  LastUpdated datetime  not null 
    constraint DF_tblTarget2_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget2_UpdatedBy default suser_sname()
)

Create PROCEDURE SCDTYPE2
AS
BEGIN

insert into dbo.tblSCDType2
( --Table and columns in which to insert the data
  SourceSystemID,
  FirstName,   
  LastName, 
  Age,
  CurrentSalary,
  DOB,
  City,
  Country,
  ZipCode,
  DimensionCheckSum,
  EffectiveDate,
  EndDate
)
-- Select the rows/columns to insert that are output from this merge statement 
-- In this example, the rows to be inserted are the rows that have changed (UPDATE).
select    
SourceSystemID,
FirstName,
LastName,
Age,
CurrentSalary,
DOB,
City,
Country,
ZipCode,
DimensionCheckSum,
EffectiveDate,
EndDate
from
(
  -- This is the beginning of the merge statement.
  -- The target must be defined, in this example it is our slowly changing
  -- dimension table
  MERGE into dbo.tblSCDType2 AS target
  -- The source must be defined with the USING clause
  USING 
  (
    -- The source is made up of the attribute columns from the staging table.
    SELECT 
    SourceSystemID, FirstName,   LastName, Age,CurrentSalary,DOB,City,Country,ZipCode, DimensionCheckSum
    from dbo.tblSource
  ) AS source 
  ( 
    SourceSystemID,FirstName,   LastName, Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum
  ) ON --We are matching on the SourceSystemID in the target table and the source table.
  (
    target.SourceSystemID = source.SourceSystemID
  )
  -- If the ID's match but the CheckSums are different, then the record has changed;
  -- therefore, update the existing record in the target, end dating the record 
  -- and set the CurrentRecord flag to N
  WHEN MATCHED and target.DimensionCheckSum <> source.DimensionCheckSum 
                                 and target.CurrentRecord='Y'
  THEN 
  UPDATE SET 
    EndDate=getdate()-1, 
    CurrentRecord='N', 
    LastUpdated=getdate(), 
    UpdatedBy=suser_sname()
  -- If the ID's do not match, then the record is new;
  -- therefore, insert the new record into the target using the values from the source.
  WHEN NOT MATCHED THEN  
  INSERT 
  (
    SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum
  )
  VALUES 
  (
    source.SourceSystemID, 
    source.FirstName,
    source.LastName,
    source.Age,
	source.CurrentSalary,
	source.DOB,
	source.City,
	source.Country,
	source.Zipcode,
    source.DimensionCheckSum
  )
  OUTPUT $action, 
    source.SourceSystemID, 
    source.FirstName,
    source.LastName,
    source.Age,
	source.CurrentSalary,
	source.DOB,
	source.City,
	source.Country,
	source.Zipcode,
    source.DimensionCheckSum,
    getdate(),
    '12/31/9999'
) -- the end of the merge statement
--The changes output below are the records that have changed and will need
--to be inserted into the scd.
as changes 
(
  action, 
  SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum,EffectiveDate,EndDate
)
where action='UPDATE';

END

create table dbo.tblSCDType3
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget3_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget3_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget3_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget3_CurrentSalary default Null,
  PreviousSalary int null 
    constraint DF_tblTarget3_PreviousSalary default Null,   
  DOB Date not null 
    constraint DF_tblTarget3_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget3_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget3_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget3_ZipCode default 'N/A',
  LastUpdated datetime  not null 
    constraint DF_tblTarget3_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget3_UpdatedBy default suser_sname()
)

Create Procedure SCDType3
As
Begin

	UPDATE tblSCDType3  
	SET  FirstName=T1.FirstName,LastName=T1.LastName,DOB=T1.DOB,Age = T1.Age, CurrentSalary = T1.CurrentSalary,PreviousSalary=tblSCDType3.CurrentSalary, City = T1.City,Country = T1.Country,Zipcode = T1.Zipcode
	FROM tblSource T1
	WHERE
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.FirstName ,'-1') <> COALESCE (T1.FirstName ,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.LastName ,'-1') <> COALESCE (T1.LastName ,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.Age ,'-1') <> COALESCE (T1.Age ,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.CurrentSalary ,'-1') <> COALESCE (T1.CurrentSalary ,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.DOB ,'-1') <> COALESCE (T1.DOB ,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.City ,'-1') <> COALESCE (T1.City,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.Country ,'-1') <> COALESCE (T1.Country,'-1') or
	tblSCDType3.SourceSystemID=T1.SourceSystemID AND COALESCE (tblSCDType3.Zipcode ,'-1') <> COALESCE (T1.Zipcode,'-1')

	INSERT INTO tblSCDType3 (SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode)
	SELECT  T1.SourceSystemID,T1.FirstName,T1.LastName,T1.Age,T1.CurrentSalary,T1.DOB,T1.City,T1.Country,T1.ZipCode
	FROM 
	tblSource T1 
	LEFT OUTER JOIN
	tblSCDType3 T2 
	ON 
	T1.SourceSystemID=T2.SourceSystemID
	WHERE
	T2.SourceSystemID IS NULL 

End

Create Table dbo.tblSCDType4SNAP
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget4SNAP_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget4SNAP_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget4SNAP_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget4SNAP_Salary default Null,
  DOB Date not null 
    constraint DF_tblTarget4SNAP_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget4SNAP_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget4SNAP_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget4SNAP_ZipCode default 'N/A',
  LastUpdated datetime  not null 
    constraint DF_tblTarget4SNAP_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget4SNAP_UpdatedBy default suser_sname()
)

Create Table dbo.tblSCDType4History
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget4History_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget4History_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget4History_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget4History_Salary default Null,
  DOB Date not null 
    constraint DF_tblTarget4History_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget4History_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget4History_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget4History_ZipCode default 'N/A',
  DimensionCheckSum int not null 
    constraint DF_tblTarget4History_DimensionCheckSum default -1,
  EffectiveDate date not null 
    constraint DF_tblTarget4History_EffectiveDate default getdate(),
  EndDate date not null 
    constraint DF_tblTarget4History_EndDate default '12/31/9999',
  CurrentRecord char(1) not null 
    constraint DF_tblTarget4History_CurrentRecord default 'Y',
  LastUpdated datetime  not null 
    constraint DF_tblTarget4History_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget4History_UpdatedBy default suser_sname()
)

Create PROCEDURE SCDType4
AS
BEGIN

	Truncate table tblSCDType4SNAP
	INSERT INTO tblSCDType4SNAP(SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode)
	SELECT  T1.SourceSystemID,T1.FirstName,T1.LastName,T1.Age,T1.CurrentSalary,T1.DOB,T1.City,T1.Country,T1.ZipCode
	FROM 
	tblSCDType2 T1 
	LEFT OUTER JOIN
	tblSCDType4SNAP T2 
	ON 
	T1.SourceSystemID=T2.SourceSystemID
	WHERE
	T1.CurrentRecord='Y'

	Truncate table tblSCDType4History
	INSERT INTO tblSCDType4History(SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode)
	SELECT  T1.SourceSystemID,T1.FirstName,T1.LastName,T1.Age,T1.CurrentSalary,T1.DOB,T1.City,T1.Country,T1.ZipCode
	FROM 
	tblSCDType2 T1 
	LEFT OUTER JOIN
	tblSCDType4History T2 
	ON 
	T1.SourceSystemID=T2.SourceSystemID
	WHERE
	T1.CurrentRecord='N'


END


Create Table dbo.tblSCDType6
(
  SurrogateKey int not null identity(1,1) PRIMARY KEY,
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblTarget6_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblTarget6_LastName default 'N/A',
  Age int not null 
    constraint DF_tblTarget6_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblTarget6_Salary default Null,
  PreviousSalary int null 
    constraint DF_tblTarget6_PreviousSalary default Null,  
  DOB Date not null 
    constraint DF_tblTarget6_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblTarget6_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblTarget6_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblTarget6_ZipCode default 'N/A',
  DimensionCheckSum int not null 
    constraint DF_tblTarget6_DimensionCheckSum default -1,
  EffectiveDate date not null 
    constraint DF_tblTarget6_EffectiveDate default getdate(),
  EndDate date not null 
    constraint DF_tblTarget6_EndDate default '12/31/9999',
  CurrentRecord char(1) not null 
    constraint DF_tblTarget6_CurrentRecord default 'Y',
  LastUpdated datetime  not null 
    constraint DF_tblTarget6_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblTarget6_UpdatedBy default suser_sname()
)

Create procedure SCDType6
as
Begin

--update dbo.tblSource set DimensionCheckSum=
	--BINARY_CHECKSUM(FirstName, LastName,Age, CurrentSalary, DOB,City,Country,Zipcode)

insert into dbo.tblSCDType6
( --Table and columns in which to insert the data
  SourceSystemID,
  FirstName,   
  LastName, 
  Age,
  CurrentSalary,
  DOB,
  City,
  Country,
  ZipCode,
  DimensionCheckSum,
  EffectiveDate,
  EndDate
)
-- Select the rows/columns to insert that are output from this merge statement 
-- In this example, the rows to be inserted are the rows that have changed (UPDATE).
select    
SourceSystemID,
FirstName,
LastName,
Age,
CurrentSalary,
DOB,
City,
Country,
ZipCode,
DimensionCheckSum,
EffectiveDate,
EndDate
from
(
  -- This is the beginning of the merge statement.
  -- The target must be defined, in this example it is our slowly changing
  -- dimension table
  MERGE into dbo.tblSCDType6 AS target
  -- The source must be defined with the USING clause
  USING 
  (
    -- The source is made up of the attribute columns from the staging table.
    SELECT 
    SourceSystemID, FirstName,   LastName, Age,CurrentSalary,DOB,City,Country,ZipCode, DimensionCheckSum
    from dbo.tblSource
  ) AS source 
  ( 
    SourceSystemID,FirstName,   LastName, Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum
  ) ON --We are matching on the SourceSystemID in the target table and the source table.
  (
    target.SourceSystemID = source.SourceSystemID 
  )
  -- If the ID's match but the CheckSums are different, then the record has changed;
  -- therefore, update the existing record in the target, end dating the record 
  -- and set the CurrentRecord flag to N
  WHEN MATCHED and target.DimensionCheckSum <> source.DimensionCheckSum 
                                 and target.CurrentRecord='Y'
								  AND COALESCE (target.CurrentSalary ,'-1') <> COALESCE (source.CurrentSalary ,'-1')
  THEN 
  UPDATE SET 
  CurrentSalary = source.CurrentSalary,PreviousSalary=target.CurrentSalary,
    EndDate=getdate()-1, 
    CurrentRecord='N', 
    LastUpdated=getdate(), 
    UpdatedBy=suser_sname()
  -- If the ID's do not match, then the record is new;
  -- therefore, insert the new record into the target using the values from the source.
  WHEN NOT MATCHED THEN  
  INSERT 
  (
    SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum
  )
  VALUES 
  (
    source.SourceSystemID, 
    source.FirstName,
    source.LastName,
    source.Age,
	source.CurrentSalary,
	source.DOB,
	source.City,
	source.Country,
	source.Zipcode,
    source.DimensionCheckSum
  )
  OUTPUT $action, 
    source.SourceSystemID, 
    source.FirstName,
    source.LastName,
    source.Age,
	source.CurrentSalary,
	source.DOB,
	source.City,
	source.Country,
	source.Zipcode,
    source.DimensionCheckSum,
    getdate(),
    '12/31/9999'
) -- the end of the merge statement
--The changes output below are the records that have changed and will need
--to be inserted into the scd.
as changes 
(
  action, 
  SourceSystemID,FirstName,LastName,Age,CurrentSalary,DOB,City,Country,ZipCode,DimensionCheckSum,EffectiveDate,EndDate
)
where action='UPDATE';


End

Create Table dbo.tblStaging
(
  SourceSystemID int not null,
  FirstName varchar(20) not null 
    constraint DF_tblStaging_FirstName default 'N/A',
  LastName varchar(20) not null 
    constraint DF_tblStaging_LastName default 'N/A',
  Age int not null 
    constraint DF_tblStaging_Age default Null,
  CurrentSalary int not null 
    constraint DF_tblStaging_Salary default Null,
  DOB Date not null 
    constraint DF_tblStaging_DOB default Null,
  City varchar(20) not null 
    constraint DF_tblStaging_City default 'N/A',
  Country varchar(20) not null 
    constraint DF_tblStaging_Country default 'N/A',
  ZipCode varchar(20) not null 
    constraint DF_tblStaging_ZipCode default 'N/A',
  DimensionCheckSum int not null 
    constraint DF_tblStaging_DimensionCheckSum default -1,
  LastUpdated datetime  not null 
    constraint DF_tblStaging_LastUpdated default getdate(),
  UpdatedBy varchar(50) not null 
    constraint DF_tblStaging_UpdatedBy default suser_sname()
)

Create procedure dropduplicate
as
begin
with EmpCTE As
(
Select *, ROW_NUMBER()Over (Partition by SourceSystemID Order by LastUpdated DESC ) As Rownumber
From tblSource
)
Delete from EmpCTE where Rownumber > 1
end

Create procedure scd12346
as
begin

		
	update dbo.tblSource set DimensionCheckSum=
	BINARY_CHECKSUM(SourceSystemID,FirstName,LastName, Age, CurrentSalary,DOB, City,Country,Zipcode)
	Execute dbo.[SCDTYPE1]
	Execute dbo.[SCDTYPE2]
	Execute dbo.[SCDTYPE3]
	Execute dbo.[SCDTYPE4]
	Execute dbo.[SCDTYPE6]
	--Truncate table tblsource
	Execute dbo.[dropduplicate]
end








insert into dbo.tblSource
(SourceSystemID, FirstName,   LastName, Age, CurrentSalary,DOB,City,Country,Zipcode)
values (1 , 'Anil',' SHINDE', 53 , 65000,'12/12/1998','Thane','India','400601')


update tblSource
set CurrentSalary=99999
where SourceSystemID=2

scd12346

Select * from tblSource
Select * from tblSCDType1
Select * from tblSCDType2
Select * from tblSCDType3
Select * from tblSCDType4Snap
Select * from tblSCDType4History
Select * from tblSCDType6


Truncate table tblSource
Truncate table tblSCDType1
Truncate table tblSCDType2
Truncate table tblSCDType3
Truncate table tblSCDType4Snap
Truncate table tblSCDType4History
Truncate table tblSCDType6








