library(taskscheduleR)
myscript <- "C:/schedules/descarga.R"
# taskscheduler_create(taskname = "myfancyscript", rscript = myscript, schedule = "ONCE", 
#                      starttime = format(Sys.time() + 62, "%H:%M"))
taskscheduler_create(taskname = "myfancyscript", rscript = myscript, schedule = "MONTHLY",
                     starttime = "10:00", days = c('FRI'),
                     months = c("JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                                "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"))
#taskscheduler_delete(taskname = "myfancyscript")
taskscheduler_create(taskname = "myfancyscript", rscript = myscript, 
                     schedule = "WEEKLY", starttime = "10:10", days = c('FRI'))
