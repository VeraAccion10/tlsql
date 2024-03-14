/*
Any call to `PWDENCRYPT(x)`, `PWDCOMPARE(x,x)` or `HASHBYTES(ALG, x)` where `ALG` is either `MD2 | MD4 | MD5 | SHA | SHA1` should be flagged for CWE 327.

- https://docs.microsoft.com/en-us/sql/t-sql/functions/hashbytes-transact-sql?view=sql-server-ver15
- https://docs.microsoft.com/en-us/sql/t-sql/functions/pwdencrypt-transact-sql?view=sql-server-ver15
- https://docs.microsoft.com/en-us/sql/t-sql/functions/pwdcompare-transact-sql?view=sql-server-ver15
*/
CREATE PROC ProcedureCrypto
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS
BEGIN

declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(100);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';

SET @dataThree = PWDENCRYPT(@data); -- CWEID 327
SELECT @dataThree = PWDENCRYPT(@dataTwo); -- CWEID 327

SET @dataTwo = PWDCOMPARE(@taintedInputTwo, @taintedInOutput); -- CWEID 327
SET @dataTwo = PWDCOMPARE('FIRST', 'SECOND'); -- CWEID 327

--No isue SHA2_256 | SHA2_512
SET @dataFour = HASHBYTES('MD2',@taintedInputTwo); -- CWEID 327
SET @dataFour = HASHBYTES('MD4', 'SECOND'); -- CWEID 327
SET @dataFour = HASHBYTES('SHA2_256', 'SECOND'); -- No issue with SHA2_256
SET @dataFour = HASHBYTES('MD5', @taintedInOutput); -- CWEID 327
SET @dataFour = HASHBYTES('SHA', @taintedInput); -- CWEID 327
SET @dataFour = HASHBYTES('SHA2_512', @dataThree); -- No issue with SHA2_512

-- DES | TRIPLE_DES | TRIPLE_DES_3KEY | RC2 | RC4 | RC4_128  | DESX | AES_128

CREATE SYMMETRIC KEY JanainaKey02   
WITH ALGORITHM = DES -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey03   
WITH ALGORITHM = TRIPLE_DES -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey04   
WITH ALGORITHM = TRIPLE_DES_3KEY -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey05   
WITH ALGORITHM = RC2 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey06   
WITH ALGORITHM = RC4 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey07   
WITH ALGORITHM = RC4_128 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey07   
WITH ALGORITHM = DESX -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey09   
WITH ALGORITHM = AES_128 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey10   
WITH ALGORITHM = AES_192 -- No Issue 
ENCRYPTION BY CERTIFICATE Shipping04;  

CREATE SYMMETRIC KEY JanainaKey11   
WITH ALGORITHM = AES_256 -- No Issue 
ENCRYPTION BY CERTIFICATE Shipping04;  

RETURN  
END
GO

declare @taintedInput nvarchar(50)
declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(100);
SET @dataTwo = N'TestTest';

-- Even without a real scope of tainted data we should still flag _any_ occurance of the this based on it's signature. 
SET @dataThree = PWDENCRYPT(@data); -- CWEID 327
SELECT @dataThree = PWDENCRYPT(@dataTwo); -- CWEID 327

SET @dataTwo = PWDCOMPARE(@taintedInput, @dataTwo); -- CWEID 327
SET @dataTwo = PWDCOMPARE('FIRST', 'SECOND'); -- CWEID 327 

--No isue SHA2_256 | SHA2_512
SET @dataThree = HASHBYTES('MD2', @data); -- CWEID 327
SET @dataThree = HASHBYTES('MD4', 'SECOND'); -- CWEID 327
SET @dataThree = HASHBYTES('SHA2_256', 'SECOND'); -- No issue with SHA2_256
SET @dataThree = HASHBYTES('MD5', @dataTwo); -- CWEID 327
SET @dataThree = HASHBYTES('SHA', @taintedInput); -- CWEID 327
SET @dataThree = HASHBYTES('SHA2_512', @dataThree); -- No issue with SHA2_512

GO

CREATE FUNCTION FunctionCrypto
(
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50),
    @numberInput int
)
returns BIT
AS
BEGIN

declare @data varchar(50);
declare @dataTwo varchar(50);
declare @dataThree nvarchar(100);
declare @dataFour varchar(MAX);

SET @dataTwo = N'TestTest';

SET @dataThree = PWDENCRYPT(@data); -- CWEID 327
SELECT @dataThree = PWDENCRYPT(@dataTwo); -- CWEID 327

SET @dataTwo = PWDCOMPARE(@taintedInputTwo, @taintedInOutput); -- CWEID 327
SET @dataTwo = PWDCOMPARE('FIRST', 'SECOND'); -- CWEID 327

--No isue SHA2_256 | SHA2_512
SET @dataFour = HASHBYTES('MD2',@taintedInputTwo); -- CWEID 327
SET @dataFour = HASHBYTES('MD4', 'SECOND'); -- CWEID 327
SET @dataFour = HASHBYTES('SHA2_256', 'SECOND'); -- No issue with SHA2_256
SET @dataFour = HASHBYTES('MD5', @taintedInOutput); -- CWEID 327
SET @dataFour = HASHBYTES('SHA', @taintedInput); -- CWEID 327
SET @dataFour = HASHBYTES('SHA2_512', @dataThree); -- No issue with SHA2_512

CREATE SYMMETRIC KEY JanainaKey02   
WITH ALGORITHM = DES -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey03   
WITH ALGORITHM = TRIPLE_DES -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey04   
WITH ALGORITHM = TRIPLE_DES_3KEY -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey05   
WITH ALGORITHM = RC2 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey06   
WITH ALGORITHM = RC4 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey07   
WITH ALGORITHM = RC4_128 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey07   
WITH ALGORITHM = DESX -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey09   
WITH ALGORITHM = AES_128 -- CWEID 327  
ENCRYPTION BY CERTIFICATE Shipping04;

CREATE SYMMETRIC KEY JanainaKey10   
WITH ALGORITHM = AES_192 -- No Issue 
ENCRYPTION BY CERTIFICATE Shipping04;  

CREATE SYMMETRIC KEY JanainaKey11   
WITH ALGORITHM = AES_256 -- No Issue 
ENCRYPTION BY CERTIFICATE Shipping04; 

RETURN 1;  
END
GO