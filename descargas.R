library(rvest)
library(stringr)
#set URL to download
page <-  read_html("http://www.dtpm.cl/index.php/programas-de-operacion") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_subset(c("\\.xls", "\\.zip", "\\.rar"))
page2 <-  read_html("http://www.dtpm.cl/index.php/noticias/pov2") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_subset(c("\\.xls", "\\.zip", "\\.rar"))
#complete URL
page2 <- unlist(lapply(page2, FUN = function(x) paste0("http://www.dtpm.cl", x)))
#merge links
pages <- c(page,page2)
#unwanted objects
rm(page, page2)
#file names
file_names <- unlist(lapply(X = pages, FUN = function(x) stringr::str_split(x, pattern = "/")[[1]][6]))
lapply(X = 1:length(pages), FUN = 
         function(x) download.file(url = pages[x], 
            destfile = paste0("C:/Users/Administrador/Documents/PO/Demanda/DTPM/descargas/", 
                              file_names[x]), mode = "wb"))
