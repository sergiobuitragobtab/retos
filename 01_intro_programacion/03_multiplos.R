numero <- 0
total <- 0
while(numero < 1000) {
  if (numero %% 3 == 0) {
     total <- total + numero
  } else if (numero %% 5 == 0) {
    total <- total + numero
  }
  numero <- numero + 1
}
print(total)