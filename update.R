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



# urls_stocks = data.frame(
#   Stock = c("NOVA US", "IBE", "VOW GY"),
#   u = c(
#   "https://tools.morningstar.es/es/stockreport/default.aspx?SecurityToken=0P0001I1Y5]3]0]E0WWE$$ALL",
#   "https://tools.morningstar.es/es/stockreport/default.aspx?SecurityToken=0P0000A4Z3%5D3%5D0%5DE0WWE%24%24ALL",
#   "https://tools.morningstar.es/es/stockreport/default.aspx?SecurityToken=0P0000EP8W%5D3%5D0%5DE0WWE%24%24ALL"))

urls_stocks = data.frame(
  Stock = c("NOVA US", "IBE", "VOW GY"),
  u = c(
    "https://www.morningstar.com/stocks/xnys/nova/quote",
    "https://www.morningstar.com/stocks/xmad/ibe/quote",
    "https://www.morningstar.com/stocks/xfra/vow/quote"))

https://finance.yahoo.com/quote/NOVA/
https://query1.finance.yahoo.com/v7/finance/quote?fields=longName%2CregularMarketPrice%2CregularMarketChange%2CregularMarketChangePercent%2CshortName%2CpriceHint&symbols=VWAGY%2CIBE.MC%2CNOVA&lang=en-US&region=US&crumb=huChO%2FYsVH9
check this!!!


https://finance.yahoo.com/quote/IBE.MC/
https://finance.yahoo.com/quote/VOW.DE/


today = as.character(format(Sys.time(), "%Y-%m-%d"))

olddf_funds = read.csv("price_funds.csv")
olddf_stocks = read.csv("price_stocks.csv")

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

# Stocks

if(!today %in% olddf_stocks$fecha){

  # print(paste("[STOCKS] Updating with data from today:", today))

  # df_stocks = data.frame(Stock = NA, precio = NA, fecha = NA)

  # for(i in 1:nrow(urls_stocks)){

  #   precio = urls_stocks$u[i] %>%
  #     read_html() %>% 
  #     html_nodes(xpath = '//*[@class="stock-quote__price-section__mdc"]') %>%
  #     html_text()
  #   precio = as.numeric(gsub(",", ".", precio))
  #   dfr = data.frame(Stock = urls_stocks$Stock[i], precio = precio, fecha = today)
  #   df_stocks = rbind(df_stocks, dfr)

  # }

  # newdf_stocks = rbind(olddf_stocks, df_stocks)
  # newdf_stocks = unique(subset(newdf_stocks, !is.na(precio)))
  # write.csv(newdf_stocks, "price_stocks.csv", row.names = FALSE)

} else { print(paste("[STOCKS] Already have data from today, NOT updating:", today)) }