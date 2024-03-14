CREATE PROCEDURE HardcodedCreds
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
       @description = 'Profile used for administrative mail.';

SELECT @dataTwo = CONVERT(nvarchar(max),  
    DecryptByAsymKey( AsymKey_Id('JanainaAsymKey02'),   
    'cipheredDataGoesHere', @taintedInput)); -- No Issue

SELECT CONVERT(nvarchar(max),  
    DecryptByAsymKey( AsymKey_Id('JanainaAsymKey02'),   
    'cipheredDataGoesHere', N'pGFD4bb925DGvbd2439587y' )); -- CWE 798 (last argument)  

SELECT convert(nvarchar(max), DecryptByCert(Cert_Id('JanainaCert02'),  
    'ProtectedData', N'pGFD4bb925DGvbd2439587y')) -- CWEID 798 (last argument, constant defined pass)

SELECT convert(nvarchar(max), DecryptByCert(Cert_Id('JanainaCert02'),  
    'ProtectedData', @taintedInput)) -- No Issue

DECLARE @PassphraseEnteredByUser nvarchar(128);  
SET @PassphraseEnteredByUser   
= 'A little learning is a dangerous thing!';  
  
-- Decrypt the encrypted record.  
SET @data = CONVERT(nvarchar, DecryptByPassphrase('12Password45', 'ProtectedData', 1)); -- CWEID 798 on first argument
SET @data = CONVERT(nvarchar, DecryptByPassphrase(@taintedInputTwo, 'ProtectedData', 1)); -- No Issue

SET @data = CONVERT(nvarchar, EncryptByPassPhrase('12Password45', 'InputData', 1)); -- CWEID 798 on first argument
SET @data = CONVERT(nvarchar, EncryptByPassPhrase(@taintedInputTwo, 'InputData', 1)); -- No Issue

SET @dataTwo = SignByAsymKey( AsymKey_Id( 'PrimeKey' ), 'ClearTextDataHere', N'pGFD4bb925DGvbd2439587y' ); -- CWEID 798 on last argument
SET @dataTwo = SignByAsymKey( AsymKey_Id( 'PrimeKey' ), 'ClearTextDataHere', @taintedInput ); -- No Issue

SET @dataThree = SignByCert( Cert_Id( 'ABerglundCert07' ),'SensitiveData', N'pGFD4bb925DGvbd2439587y'); -- CWEID 798 on last argument
SET @dataThree = SignByCert( Cert_Id( 'ABerglundCert07' ),'SensitiveData', @taintedInput ); -- No Issue

exec sp_password 'user', 'oldpass', 'newpass'; -- CWEID 798
exec sp_password @taintedInput, @taintedInputTwo, @taintedInOutput; -- No issue
exec sp_password @taintedInput, @taintedInputTwo, 'newpass'; -- CWEID 798
exec sp_password @taintedInput, 'oldpass', @taintedInOutput; -- CWEID 798
exec sp_password 'username', @taintedInputTwo, @taintedInOutput -- CWEID 798

EXEC sp_xp_cmdshell_proxy_account 'ADVWKS\Max04', 'ds35efg##65'; -- CWEID 798
EXEC sp_xp_cmdshell_proxy_account 'ADVWKS\Max04', @taintedInput; -- CWEID 798
EXEC sp_xp_cmdshell_proxy_account @data, @taintedInput; -- No Issue

RETURN 0 
END
GO

-- We also need flag these signature based without a real scope that injects taint! 
CREATE ASYMMETRIC KEY PacificSales09Asym   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = '12Password34'; -- CWEID 798   

CREATE SYMMETRIC KEY PacificSales09Sym   
    WITH ALGORITHM = AES_256   
    ENCRYPTION BY PASSWORD = '12Password34'; -- CWEID 798  

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AnotherPassword124' -- CWEID 798

SELECT CONVERT(nvarchar(max),  
    DecryptByAsymKey( AsymKey_Id('JanainaAsymKey02'),   
    'cipheredDataGoesHere', N'pGFD4bb925DGvbd2439587y' )); -- CWEID 798 (last argument, constant defined pass)  

SELECT convert(nvarchar(max), DecryptByCert(Cert_Id('JanainaCert02'),  
    'ProtectedData', N'pGFD4bb925DGvbd2439587y')) -- CWEID 798 (last argument, constant defined pass)

EXEC sp_xp_cmdshell_proxy_account 'ADVWKS\Max04', 'ds35efg##65'; -- CWEID 798
exec sp_password 'user', 'oldpass', 'newpass'; -- CWEID 798

GO