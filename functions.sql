
CREATE FUNCTION Func1 (@inputData nvarchar(50))
RETURNS int
AS
BEGIN
    EXEC sp_sqlexec @inputData; -- CWEID 89
    return 0;
END
GO

CREATE FUNCTION Func2 (@inputData nvarchar(50))
RETURNS bit
WITH EXECUTE AS CALLER
AS
BEGIN
    EXECUTE @inputData; -- CWEID 89
    return 0;
END
GO

CREATE FUNCTION Func3 (@inputData nvarchar(50))
RETURNS datetime
WITH EXECUTE AS CALLER
AS
BEGIN
    EXECUTE xp_cmdshell @inputData; -- CWEID 78
    EXECUTE xp_delete_file 0, @inputData; -- CWEID 73
    EXECUTE @inputData; -- CWEID 89
    return 0;
END
GO  

CREATE FUNCTION Func4(@inputData nvarchar(50))
RETURNS datetime
WITH EXECUTE AS CALLER
AS
BEGIN
    EXECUTE xp_cmdshell @inputData -- CWEID 78
    --EXECUTE xp_delete_file 0, @inputData -- No issue due to comments
    EXECUTE @inputData; -- CWEID 89
    return 0;
END
GO 

CREATE FUNCTION Func4(@inputData nvarchar(50))
RETURNS int
AS
BEGIN
    /*EXECUTE xp_cmdshell @inputData -- No issue due multi-line comments
    EXECUTE xp_delete_file 0, @inputData -- No issue due to multi-line comments*/
    EXECUTE @inputData; -- CWEID 89
    return 0;
END
GO 


