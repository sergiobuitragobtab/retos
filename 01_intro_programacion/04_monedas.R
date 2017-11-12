install.packages('gtools')
#load library
library(gtools)

p01 <- 1
p02 <- 2
p05 <- 5
p10 <- 10
p20 <- 20
p50 <- 50
l01 <- 100
l02 <- 0

x <- c(0, 1, 2, 3, 4, 5, 6, 7, 8)
pos <- permutations(n=2+1,r=8,v=x,repeats.allowed=T)
val <- 0
res <- 0
i <- 0
while(i <= nrow(pos)) {
  val <- (pos[i,1]*l02 + pos[i,2]*l01 + pos[i,3]*p50 + pos[i,4]*p20 + pos[i,5]*p10 + pos[i,6]*p05 + pos[i,7]*p02 + pos[i,8]*p01)
  if (val <= 200) { res <- res + 1} 
  i <- i + 1  
}
