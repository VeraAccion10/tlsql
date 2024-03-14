
-- - OUT = CAST ( IN AS x )  
CREATE PROCEDURE PropCast
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = CAST(@taintedInput as varchar(50)); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(10);
SET @dataTwo = CAST(@numberInput as varchar(50)); --numerical data does not propagate taint.
EXEC @dataTwo; -- No Issue

RETURN  
GO

-- - OUT = CONVERT ( x , IN [ , x ] )  
CREATE PROCEDURE PropConvert
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = CONVERT(varchar(50), @taintedInput); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(10);
SET @dataTwo = CONVERT(nvarchar(10), @numberInput); --numerical data does not propagate taint.
EXEC @dataTwo; -- No Issue

RETURN  
GO

-- - OUT = PARSE ( IN AS x [ USING x ] ) --convert from text to numerical/date no propagation.

-- - OUT = TRY_CAST ( IN AS x [ ( x ) ] ) 
CREATE PROCEDURE PropTryCast
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = TRY_CAST(@taintedInput as varchar(50)); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(10);
SET @dataTwo = TRY_CAST(@numberInput as nvarchar(10)); --numerical data does not propagate taint.
EXEC @dataTwo; -- No Issue

RETURN  
GO

-- - OUT = TRY_CONVERT ( x, IN [, x ] )
CREATE PROCEDURE PropTryConvert
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = TRY_CONVERT(varchar(50), @taintedInput); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(10);
SET @dataTwo = TRY_CONVERT(nvarchar(10), @numberInput); --numerical data does not propagate taint.
EXEC @dataTwo; -- No Issue

RETURN  
GO

-- - OUT = JSON_VALUE ( IN , x ) 
CREATE PROCEDURE PropJsonValue
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = JSON_VALUE(@taintedInput, '.'); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(50);
SET @dataTwo=N'{  
     "info":{    
       "type":1,  
       "address":{    
         "town":"Bristol",  
         "county":"Avon",  
         "country":"England"  
       },  
       "tags":["Sport", "Water polo"]  
    },  
    "type":"Basic"  
 }'; 

SET @dataTwo = JSON_VALUE(@dataTwo,@taintedInput); --no issue, selector does not propagate
EXEC @dataTwo; 

RETURN  
GO 
-- - OUT = JSON_QUERY ( IN [ , x ] ) 
CREATE PROCEDURE PropJsonQuery
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = JSON_QUERY(@taintedInput, '.'); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(50);
SET @dataTwo=N'{  
     "info":{    
       "type":1,  
       "address":{    
         "town":"Bristol",  
         "county":"Avon",  
         "country":"England"  
       },  
       "tags":["Sport", "Water polo"]  
    },  
    "type":"Basic"  
 }'; 

SET @dataTwo = JSON_QUERY(@dataTwo,@taintedInput); --no issue, selector does not propagate
EXEC @dataTwo; 

RETURN  
GO 

-- - OUT = JSON_MODIFY ( IN , x , IN ) 
CREATE PROCEDURE PropJsonModify
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);

SET @data = JSON_MODIFY(@taintedInput, '.', 'test'); --propgates taint to @data
EXEC @data; -- CWEID 89

declare @dataTwo nvarchar(50);
declare @dataThree nvarchar(50);
declare @dataFour nvarchar(50);
SET @dataTwo=N'{  
     "info":{    
       "type":1,  
       "address":{    
         "town":"Bristol",  
         "county":"Avon",  
         "country":"England"  
       },  
       "tags":["Sport", "Water polo"]  
    },  
    "type":"Basic"  
 }';  

SET @dataThree = JSON_MODIFY(@dataTwo,@taintedInput,'test'); --no issue, selector does not propagate
EXEC @dataThree; 

SET @dataFour = JSON_MODIFY(@dataTwo,'.',@taintedInput); --CWEID 89
EXEC @dataFour; 

RETURN  
GO 

-- - OUT = IIF ( x, IN, IN )
CREATE PROCEDURE PropIIF
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = IIF(@dataTwo = N'test', @taintedInput, @dataTwo); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = IIF(@taintedInput = N'test', @numberInput, @numberInput); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = IIF(@numberInput > 39, 'test', @taintedInputTwo); --propgates through last arg.
EXEC @dataFour;-- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = IIF(@numberInput = 14, @taintedInputTwo, 'data'); --propgates through 2nd arg.
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = CHOOSE ( x, IN1, IN2 [ , INX ].. ) 
CREATE PROCEDURE PropChoose
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = CHOOSE(1, @taintedInput, @dataTwo); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = CHOOSE(2, @numberInput, @numberInput); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = CHOOSE(5, 'test', @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo); --propgates through one of args
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = CHOOSE(3, 'data', 'data', 'data', @numberInput); --no propagation
EXEC @dataFive; -- No Issue

RETURN  
GO

-- - OUT = CONCAT ( IN1, IN2, IN.. )
CREATE PROCEDURE PropConcat
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = CONCAT(@taintedInput, @dataTwo); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = CONCAT(@numberInput, @numberInput) --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = CONCAT('test', @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo); --propgates through one of args
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = CONCAT('data', 'data', 'data', @numberInput); --no propagation
EXEC @dataFive; -- No Issue

RETURN  
GO

-- - OUT = CONCAT_WS ( x, IN1, IN2 [ , INX ].. )
CREATE PROCEDURE PropConcatWS
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = CONCAT_WS(',',@taintedInput, @dataTwo); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = CONCAT_WS(',',@numberInput, @numberInput) --no issue
EXEC @dataThree -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = CONCAT_WS(',','test', @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo, @taintedInputTwo); --propgates through one of args
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = CONCAT_WS(',','data', 'data', 'data', @numberInput); --no propagation
EXEC @dataFive; -- No Issue

RETURN  
GO

-- - OUT = LEFT ( IN , x )
CREATE PROCEDURE PropLeft
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = LEFT(2, @taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = LEFT(4, @dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = LEFT(2, @taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = LEFT(7, @taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO
-- - OUT = RIGHT ( IN , x )
CREATE PROCEDURE PropRight
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = RIGHT(2, @taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = RIGHT(4, @dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = RIGHT(2, @taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = RIGHT(7, @taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO
-- - OUT = LOWER ( IN )
CREATE PROCEDURE PropLower
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = LOWER(@taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = LOWER(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = LOWER(@taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = LOWER(@taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = LTRIM ( IN )
CREATE PROCEDURE PropLtrim
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = LTRIM(@taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = LTRIM(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = LTRIM(@taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = LTRIM(@taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = QUOTENAME ( IN , x )
CREATE PROCEDURE PropQuotename
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = QUOTENAME(@taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = QUOTENAME(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = QUOTENAME(@taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = QUOTENAME(@taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = REPLACE ( IN , x , IN )
CREATE PROCEDURE PropReplace
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = REPLACE(@taintedInput,'test', 'test'); --propgates taint through 1st arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = REPLACE(@dataTwo,@taintedInputTwo,'test'); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = REPLACE(@dataTwo,'test',@taintedInputTwo); --propagates taint on last argument
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = REPLACE(@taintedInOutput, 'test', @taintedInputTwo); --propagates taint on 1st and last argument.
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = REPLICATE ( IN , x )
CREATE PROCEDURE PropReplicate
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = REPLICATE(@taintedInput,2); --propgates taint through 1st arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = REPLICATE(@dataTwo,9) --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = REPLICATE(@taintedInputTwo,11); --propagates taint on last argument
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = REPLICATE(@taintedInOutput, @numberInput); --propagates taint on 1st and last argument.
EXEC @dataFive; -- CWEID 89

declare @dataSix varchar(50);
SET @dataSix = REPLICATE(@numberInput, 10); -- No propagation due to numerical arg
EXEC @dataSix; -- No issue

RETURN  
GO

-- - OUT = REVERSE ( IN )
CREATE PROCEDURE PropReverse
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = REVERSE(@taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = REVERSE(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = REVERSE(@taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = REVERSE(@taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

declare @dataSix varchar(50);
SET @dataSix = REVERSE(@numberInput); -- No propagation due to numerical arg
EXEC @dataSix; -- No issue

RETURN  
GO

-- - OUT = RTRIM ( IN )
CREATE PROCEDURE PropRTrim
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = RTRIM(@taintedInput); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = RTRIM(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = RTRIM(@taintedInputTwo); --propagates taint
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = RTRIM(@taintedInOutput); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = STRING_AGG ( IN , IN )
CREATE PROCEDURE PropStringAgg
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = STRING_AGG(@taintedInput,','); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = STRING_AGG(@dataTwo, ',') --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = STRING_AGG(@dataTwo, @taintedInOutput); --propagates taint on 2nd arg
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = STRING_AGG(@taintedInOutput, '-'); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = STRING_ESCAPE ( IN , x )
CREATE PROCEDURE PropStringEscape
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = STRING_AGG(@taintedInput,','); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = STRING_AGG(@dataTwo, ','); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = STRING_AGG(@dataTwo, @taintedInOutput); --propagates taint on 2nd arg
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = STRING_AGG(@taintedInOutput, '-'); --propagates taint
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = STUFF ( IN , x , x , IN )
CREATE PROCEDURE PropStuff
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = STUFF(@taintedInput,2,3,'test'); --propgates taint through 2nd arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = STUFF(@dataTwo,1,4,'test'); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = STUFF(@taintedInOutput, 2,10, @numberInput); --propagates taint on 1st arg
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = STUFF(@dataTwo,1,4,@taintedInputTwo); --propagates taint on last argument
EXEC @dataFive; -- CWEID 89

RETURN  
GO

-- - OUT = SUBSTRING ( IN , x , x )
CREATE PROCEDURE PropSubString
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = SUBSTRING(@taintedInput,1,5); --propgates taint through 1st arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = SUBSTRING(@dataTwo, 2,6); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = SUBSTRING(@taintedInputTwo, 1, 10); --propagates taint on 1st arg
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = SUBSTRING(@taintedInOutput, 5, 20); --propagates taint on 1st arg
EXEC @dataFive;-- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = SUBSTRING(@numberInput, 2,6); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO
-- - OUT = TRANSLATE ( IN, IN, IN )
CREATE PROCEDURE PropTranslate
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = TRANSLATE(@taintedInput,'1','5'); --propgates taint through 1st arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = TRANSLATE(@dataTwo, '2','6'); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = TRANSLATE('test', @taintedInputTwo, '10'); --propagates taint on 2st arg
EXEC @dataFour; -- CWEID 89

declare @dataFive varchar(50);
SET @dataFive = TRANSLATE('test', '5', @taintedInOutput); --propagates taint on last arg
EXEC @dataFive; -- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = TRANSLATE(@numberInput, '2','6'); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO

-- - OUT = TRIM ( IN )
CREATE PROCEDURE PropTrim
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = TRIM(@taintedInput); --propgates taint arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = TRIM(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = TRIM('   test   '); --no propagation
EXEC @dataFour; -- No Issue

declare @dataFive varchar(50);
SET @dataFive = TRIM(@taintedInOutput); --propagates taint on arg
EXEC @dataFive; -- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = TRIM(@numberInput); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO

-- - OUT = UPPER ( IN )
CREATE PROCEDURE PropUpper
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = UPPER(@taintedInput); --propgates taint arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = UPPER(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = UPPER('   test   '); --no propagation
EXEC @dataFour; -- No Issue

declare @dataFive varchar(50);
SET @dataFive = UPPER(@taintedInOutput); --propagates taint on arg
EXEC @dataFive; -- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = UPPER(@numberInput); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO

-- - OUT = COMPRESS ( IN )
CREATE PROCEDURE PropCompress
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = COMPRESS(@taintedInput); --propgates taint arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = COMPRESS(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = COMPRESS('   test   '); --no propagation
EXEC @dataFour; -- No Issue

declare @dataFive varchar(50);
SET @dataFive = COMPRESS(@taintedInOutput); --propagates taint on arg
EXEC @dataFive; -- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = COMPRESS(@numberInput); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO

-- - OUT = DECOMPRESS ( IN )
CREATE PROCEDURE PropDecompress
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = DECOMPRESS(@taintedInput); --propgates taint arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = DECOMPRESS(@dataTwo); --no issue
EXEC @dataThree; -- No Issue

declare @dataFour nvarchar(100);
SET @dataFour = DECOMPRESS('   test   '); --no propagation
EXEC @dataFour; -- No Issue

declare @dataFive varchar(50);
SET @dataFive = DECOMPRESS(@taintedInOutput); --propagates taint on arg
EXEC @dataFive; -- CWEID 89

declare @dataSix nvarchar(100);
SET @dataSix = DECOMPRESS(@numberInput); --no issue
EXEC @dataSix; -- No Issue

RETURN  
GO

-- - OUT = FORMATMESSAGE ( IN , [ IN1, IN2 [ ,INX ] ] )
CREATE PROCEDURE PropDecompress
    @taintedInput nvarchar(50),
    @taintedInputTwo varchar(50),
    @taintedInOutput nvarchar(50) OUTPUT,
    @numberInput int
AS

declare @data varchar(50);
declare @dataTwo varchar(50);
SET @dataTwo = N'TestTest';

SET @data = FORMATMESSAGE(@taintedInput, @dataTwo, @numberInput); --propgates taint arg to @data
EXEC @data; -- CWEID 89

declare @dataThree nvarchar(100);
SET @dataThree = FORMATMESSAGE('test %s', @taintedInput); --propagates on 2nd arg
EXEC @dataThree; -- CWEID 89

declare @dataFour nvarchar(100);
SET @dataFour = FORMATMESSAGE('test %s-%s', 'test', @numberInput); --numerical does not propagate taint.
EXEC @dataFour; -- No Issue

declare @dataFive varchar(50);
SET @dataFive = FORMATMESSAGE(@dataTwo, 'test'); --no propagation
EXEC @dataFive; -- No Issue

declare @dataSix nvarchar(100);
SET @dataSix = FORMATMESSAGE('test %s-%s-%s-%s', 'test', 'test', @taintedInOutput); -- propagates on 4rd arg
EXEC @dataSix; -- CWEID 89

RETURN  
GO