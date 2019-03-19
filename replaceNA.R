tidyr::replace_na(SIMTsubida_3era, "-")
dplyr::mutate_all(funs(replace(., is.na(.), 0)))
