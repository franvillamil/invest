# setwd("~/Dropbox/Important/investing/scrap")
library(rvest)
library(stringr)
library(dplyr)

urls_funds = c(
  "https://www.finect.com/fondos-inversion/IE00B42W4L06-Vanguard_glb_smallcp_idx__acc",
  "https://www.finect.com/fondos-inversion/IE0031786696-Vanguard_em_mkts_stk_idx__acc",
  "https://www.finect.com/fondos-inversion/IE0032126645-Vanguard_us_500_stk_idx__acc",
  "https://www.finect.com/fondos-inversion/IE0007987708-Vanguard_pean_stk_idx__acc",
  "https://www.finect.com/fondos-inversion/IE0007472990-Vanguard__govt_bd_idx__acc",
  "https://www.finect.com/fondos-inversion/IE00B18GC888-Vanguard_global_bd_idx_eur_h_acc")

today = as.character(format(Sys.time(), "%Y-%m-%d"))

olddf_funds = read.csv("price_funds.csv")

# Funds

if(!today %in% olddf_funds$fecha){

  print(paste("[FUNDS] Updating with data from today:", today))

  df_funds = data.frame(id = NA, name = NA, fecha = NA, precio = NA)

  for(u in urls_funds){

    textoraw = u %>%
      read_html() %>% 
      html_nodes(xpath = '//*[@id="app"]') %>%
      html_text()

    locating = str_locate(textoraw, "€Fecha de valor liquidativo")
    texto = str_sub(textoraw, locating[1] - 20, locating[2] + 20)

    uname = str_split(gsub(".*inversion/", "", u), "-")[[1]]
    id = uname[1]
    name = uname[2]
    precio = as.numeric(gsub(",", ".", gsub(".*([a-z]|[A-Z])(\\d+,\\d+)€Fecha.*", "\\2", texto)))

    dfr = data.frame(id, name, fecha = today, precio)
    df_funds = rbind(df_funds, dfr)

  }

  newdf_funds = rbind(olddf_funds, df_funds)
  newdf_funds = unique(subset(newdf_funds, !is.na(precio)))
  write.csv(newdf_funds, "price_funds.csv", row.names = FALSE)

} else { print(paste("[FUNDS] Already have data from today, NOT updating:", today)) }