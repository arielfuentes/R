#First we need to go to the Administrative Tools and set up the Data Sources with each data base we want to explore
library(RODBC)
#######Set the conexion in R
cube <- odbcConnect("ESTUDIOS", uid="Estudios", pwd="estudios2015..", believeNRows=FALSE)
#Make the query
p <- sqlQuery(cube, "SELECT [Fecha]
      ,CAST(REPLACE([KM], ',', '.') AS float) AS KM
      ,[IDMH]
      ,[IDTipoDia]
      ,[id_servicio]
      ,[IDMaquina]
      ,[IDServicio]
 FROM [ESTUDIOS].[dbo].[KM] where MONTH(Fecha) = MONTH('2015-05-01') and YEAR(Fecha) = YEAR('2015-04-01')");
