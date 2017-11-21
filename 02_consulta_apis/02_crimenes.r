#install.packages("httr")
library(httr)
  
res <- GET("http://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=51.4965946&lon=-0.1436476")
res_d <- content(res)
print(res_d)
  
  
lond <- GET("https://data.police.uk/api/crimes-at-location?date=2017-04&lat=51.4965946&lng=-0.1436476")
lond_d <- content(lond)
  
categorias <- c()
valores <- c()
  
for (i in 1:length(lond_d)) {
  categorias <- c(categorias, lond_d[[i]]$category)
  valores <- c(valores, 1)
  i <- i + 1 
}
  
crimenes <- aggregate(valores, by=list(categorias), FUN=sum)
  
print(crimenes)