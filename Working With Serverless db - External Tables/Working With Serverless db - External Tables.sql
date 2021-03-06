/*CREATE SERVERLESS DATABASE*/
CREATE DATABASE SERVERLESSWH

/*Switch Into DB*/
USE SERVERLESSWH

/*Create some schemas*/
CREATE SCHEMA DIM
CREATE SCHEMA FACT


/*Create the External Data Source,
Make sure to update the location information to fit your ADLS storage account
*/


CREATE EXTERNAL DATA SOURCE [WORKSPACEFS] 
WITH (LOCATION = N'HTTPS://{your storage account}.DFS.CORE.WINDOWS.NET/{your adls container}')


/*Create External file format for Parquet files*/
CREATE EXTERNAL FILE FORMAT [PARQUET] WITH (FORMAT_TYPE = PARQUET)
GO


/*Create Dim Address table*/
CREATE EXTERNAL TABLE DIM.ADDRESS
WITH (
LOCATION = '/CURATED/SERVERLESSWH/DIM/ADDRESS/',
DATA_SOURCE = [WORKSPACEFS],
FILE_FORMAT = [PARQUET]
)

AS

SELECT * FROM [HIVE_SALESDATA].DBO.ADDRESS


/*Create Fact OrderValue Table*/
CREATE EXTERNAL TABLE FACT.ORDERVALUE
WITH (
LOCATION = '/CURATED/SERVERLESSWH/FACT/ORDERVALUE/',
DATA_SOURCE = [WORKSPACEFS],
FILE_FORMAT = [PARQUET]
)

AS

SELECT [ORDERDATE]
      ,[SHIPTOADDRESSID] FK_SHIPTOADDRESSID
      ,[BILLTOADDRESSID] FK_BILLTOADDRESSID
      ,ORDERTOTAL = SUM([TOTALDUE])  
	  FROM [HIVE_SALESDATA].[DBO].[SALESORDERHEADER]

	  GROUP BY [ORDERDATE]
      ,[SHIPTOADDRESSID] 
      ,[BILLTOADDRESSID] 