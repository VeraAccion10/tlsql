

CREATE PROCEDURE EmailPathTraversal
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50),
    @dateTimeInput datetime,
    @numberInput DECIMAL
)
AS
BEGIN
declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(199);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';
SET @data = @taintedInputTwo; -- Propagates taint to @data.

--Make sure we have the profile available, will throw UNIQUE key error if already present.
EXECUTE msdb.dbo.sysmail_add_profile_sp  
       @profile_name = 'AdventureWorks Administrator',  
       @description = 'Profile used for administrative mail.' ;
       --@profile_id = @profileId OUTPUT ; 

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @taintedInOutput, -- CWEID 89
    @file_attachments = @data, -- CWEID 73
    @recipients = 'root@local';

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataTwo, -- No issue
    @file_attachments = @dataFour, -- No issue
    @recipients = 'root@local';

SET @dataThree = @taintedInputTwo; -- propagation of data

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @file_attachments = @taintedInOutput, -- CWEID 73
    @recipients = 'root@local';

RETURN 1
END
GO

CREATE PROCEDURE DeleteFilePathTraversal
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50),
    @dateTimeInput datetime,
    @numberInput DECIMAL,
    @dateInput DATE
)
AS
BEGIN
declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(199);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';
SET @data = @taintedInputTwo; -- Propagates taint to @data.

EXECUTE xp_delete_file 0, @taintedInput; -- CWEID 73

RETURN 1
END
GO

