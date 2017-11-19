install.packages("httr")


library(httr)
res <- GET("http://www.cartociudad.es/services/api/geocoder/reverseGeocode")
res2 <- content(res, lat=36.9003409, lon=-3.4244838)

print(res2)

print(res[["status_code"]])

print(headers(res))
print(res[["headers"]])

