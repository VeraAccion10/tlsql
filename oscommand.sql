CREATE PROC ProcedureOsCommand
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
)
AS
BEGIN

declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(100);

SET @dataTwo = N'TestTest';

SELECT @data = @taintedInputTwo; -- Propagates taint to @data
EXECUTE xp_cmdshell @data; -- CWEID 78

EXEC xp_cmdshell @numberInput; -- No issue because of numerical arg.

EXECUTE xp_cmdShell @dataTwo; -- No issue due to local data.

SET @dataThree = @taintedInOutput; --propagates taint.
EXEC xp_cmdshell @dataThree; -- CWEID 78 

RETURN  
END
GO

/*
Following statements won't flag for any of this because there is no scope that will inject taint, e.g. body of FUNCTION or PROC[EDURE].
*/
declare @taintedInput nvarchar(50);
EXECUTE xp_cmdshell @taintedInput; -- No issue, data is not the same scope as used in PROC above. 

GO

CREATE FUNCTION FunctionOsCommand
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50),
    @numberInput int
) RETURNS int
AS
BEGIN

declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(100);

SET @dataTwo = N'TestTest';

SELECT @data = @taintedInputTwo; -- Propagates taint to @data
EXECUTE xp_cmdshell @data; -- CWEID 78

EXEC xp_cmdshell @numberInput; -- No issue because of numerical arg.

EXECUTE xp_cmdShell @dataTwo; -- No issue due to local data.

SET @dataThree = @taintedInOutput; --propagates taint.
EXEC xp_cmdshell @dataThree; -- CWEID 78 

--EXEC xp_cmdshell @data; -- No issue do to comment

RETURN  0
END
GO