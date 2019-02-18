#selected columns
tidyr::unite(x, "nodos_num|nodos_nombre|linea", c("nodos_num","nodos_nombre","linea"))
#all columns
tidyr::unite(x, ruta)
