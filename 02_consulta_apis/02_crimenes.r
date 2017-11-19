#install.packages("httr")

library(httr)

res <- GET("http://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=51.4965946&lon=-0.1436476")
res_d <- content(res)
print(res_d)



lond <- GET("https://data.police.uk/api/crimes-at-location?date=2017-04&lat=51.4965946&lon=-0.1436476")
lond_d <- content(res)
print(lond_d)

rapply(lond_d, sum, lond_d[["category"]])
