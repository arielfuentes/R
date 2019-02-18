library(ff)
library(ETLUtils)
library(odbc)
library(RODBC)
#query
sql <- "SELECT par_subida, par_bajada, serv_un_zp2, etapas201504_transparencia.tipo_dia, 
        peri_mh.PER_DTPM, SUM(CAST(factor_exp_etapa AS float)) as pax_transportados
        FROM [uchile].[dbo].[etapas201504_transparencia] INNER JOIN [uchile].[dbo].[peri_mh] ON 
             (etapas201504_transparencia.media_hora = peri_mh.HR_MH) AND 
             (etapas201504_transparencia.tipo_dia = peri_mh.TIPO_DIA)
        WHERE (factor_exp_etapa <> '-') AND (peri_mh.PER_DTPM = 'PMA')
        GROUP BY par_subida, par_bajada, serv_un_zp2, 
        etapas201504_transparencia.tipo_dia, peri_mh.PER_DTPM;"
etapas <- ETLUtils::read.odbc.ffdf(query = sql, 
                       odbcConnect.args = list(dsn = "uchile", uid = "sa", pwd = "Estudios2017.."), 
                       VERBOSE = T)
#DataFrame
etapas <- as.data.frame(etapas)
