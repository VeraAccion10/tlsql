CREATE PROCEDURE EmailArgi
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
    @recipients = @taintedInput; --CWEID 88

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataTwo, -- No issue
    @recipients = 'root@local',
    @blind_copy_recipients = @data; -- CWEID 88

SET @dataThree = @taintedInputTwo; -- propagation of data

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @recipients = 'root@local',
    @copy_recipients = @taintedInOutput; -- CWEID 88

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @recipients = 'root@local',
    @blind_copy_recipients = @taintedInOutput; -- CWEID 88

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @recipients = 'root@local',
    @from_address = @data; -- CWEID 88

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @recipients = 'root@local',
    @reply_to = @taintedInputTwo; -- CWEID 88

RETURN 1
END
GO