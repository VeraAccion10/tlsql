
CREATE PROCEDURE Propagation1
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @dateTimeInput datetime,
    @numberInput DECIMAL
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(199);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';
SET @data = @taintedInputTwo; -- Propagates taint to @data.
EXEC sp_ExecuteSQL @data; -- CWEID 89
EXECUTE sp_ExecuteSQL @dataTwo; -- No issue

SELECT @dataThree = @taintedInOutput; -- Propagates taint to @dataThree
EXECUTE @dataThree; -- CWEID 89

SELECT @dataFour = @numberInput; -- No propagation with numerical value.

--EXEC @dataThree -- No Issue because of comments

RETURN  
GO

CREATE FUNCTION Func2 
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50),
    @dateTimeInput datetime,
    @numberInput DECIMAL
)
RETURNS bit
WITH EXECUTE AS CALLER
AS
BEGIN
declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(199);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';
SET @data = @taintedInputTwo; -- Propagates taint to @data.
EXEC sp_ExecuteSQL @data; -- CWEID 89
EXECUTE sp_ExecuteSQL @dataTwo; -- No issue

/*
SELECT @dataThree = @taintedInOutput; -- Propagates taint to @dataThree
EXECUTE @dataThree; -- No issue because of multiline comments
*/

SELECT @dataFour = @numberInput; -- No propagation with numerical value.

--EXEC @dataThree -- No Issue because of comments
RETURN 1
END
GO