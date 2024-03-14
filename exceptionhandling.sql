CREATE FUNCTION FuncExceptionHandling (@inputData nvarchar(50))
RETURNS datetime
WITH EXECUTE AS CALLER
AS
BEGIN
    EXECUTE xp_cmdshell @inputData -- CWEID 78
   
    BEGIN TRY  
        -- Generate divide-by-zero error.  
        EXECUTE @inputData; -- CWEID 89
        SELECT 1/0;  
    END TRY  
    BEGIN CATCH  
        -- Execute error retrieval routine.  
        EXECUTE usp_GetErrorInfo;  
        EXECUTE xp_delete_file 0, @inputData; -- CWEID 73
    END CATCH; 

    EXEC sp_executesql @inputData; -- CWEID 89

    return 0;
END
GO  

CREATE PROC ProcedureExceptionHandling (@inputData nvarchar(50))
AS
    EXECUTE xp_cmdshell @inputData -- CWEID 78
   
    BEGIN TRY  
        -- Generate divide-by-zero error.  
        EXECUTE @inputData; -- CWEID 89
        SELECT 1/0;  
    END TRY  
    BEGIN CATCH  
        -- Execute error retrieval routine.  
        EXECUTE usp_GetErrorInfo;  
        EXECUTE xp_delete_file 0, @inputData; -- CWEID 73
    END CATCH; 

    EXEC sp_executesql @inputData; -- CWEID 89
GO  