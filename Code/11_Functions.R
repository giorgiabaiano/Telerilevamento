#Code to build your own functions

# Scelgo il nome della funzione
somma <- function (x,y) { 
  z=x+y
  return(z)
  }

differenza <-function(x,y) { 
  z=x-y
  return(z)
  }

mf <-function(nrow,ncol) {
  par(mfrow=c(nrow,ncol))
  }

positivo <- function (x)  {
  if(x>0) {
    print("Questo numero è positivo")
    }

  
  else if (x<0) {
    print ("Questo numero è negativo")
  }


