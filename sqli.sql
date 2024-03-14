
-- sp_send_dbmail [  [ @execute_query_database = ] T ]  
CREATE PROCEDURE EmailSqli 
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
    @recipients = 'root@local';

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataTwo, -- No issue
    @recipients = 'root@local';

SET @dataThree = @taintedInputTwo; -- propagation of data

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdventureWorks Administrator',
    @query = @dataThree, -- CWEID 89
    @recipients = 'root@local';

RETURN 1
END
GO

/*
- EXEC T
- EXECUTE T
- sp_ExecuteSQL T, x
*/
CREATE PROCEDURE ExecuteSqli 
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

EXEC @taintedInput; -- CWEID 89
EXECUTE @taintedInputTwo; -- CWEID 89
EXEC sp_ExecuteSQL @taintedInOutput -- CWEID 89

EXEC @dataTwo; -- No Issue
SET @dataFour = @taintedInputTwo; -- Propagates taint 
EXECUTE @dataFour; -- CWEID 89

EXECUTE sp_ExecuteSQL @dataTwo; -- No Issue

RETURN 1
END
GO

CREATE PROCEDURE ExecuteCursorSqli 
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

DECLARE @cursor INT;

EXEC sp_cursoropen @cursor OUTPUT, @taintedInput; -- CWEID 89
EXEC sp_cursoropen @cursor OUTPUT, @dataTwo, 2, 8193 -- No Issue

EXECUTE sp_cursoropen @cursor OUTPUT, @data; -- CWEID 89

RETURN 1
END
GO