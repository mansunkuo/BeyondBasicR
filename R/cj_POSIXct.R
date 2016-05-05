library(data.table)
country = c("Taipei", "Japan")
datetime1 = lubridate::ymd_h("2015-08-01 00", "2015-08-01 01")
dt1 = CJ(country, datetime1)
dt1

datetime2 = lubridate::ymd_h("2015-08-01 00", "2015-08-01 01", tz = "CST")
dt1 = CJ(country, datetime2)
dt1

Sys.time()
sessionInfo()
