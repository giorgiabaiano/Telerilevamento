# I dati sono stati ricavati dal seguente sito web: https://earthobservatory.nasa.gov/
https://earthobservatory.nasa.gov/images/91333/monitoring-mumbais-mangroves


# Pacchetti usati:
library(terra)
library(imageRy)
library(viridis) #pacchetto che permette di creare plot di immagini con differenti palette di colori di viridis
library(ggridges) #pacchetto che permette di creare i plot ridgeline
library()
library()

# Impostazione della working directory e importazione dei dati:

setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") #working directory in cui ho salvato il file da importare
mumbai1988= rast("mumbai1988.jpg")
plot(mumbai1988)
mumbai1988= flip(mumbai1988)
plot(mumbai1988)
dev.off()

setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/")
mumbai2017= rast("mumbai2017.jpg")
plot(mumbai2017)
mumbai2017= flip(mumbai2017)
plot(mumbai2017)
dev.off()

im.multiframe(1,2)
plot(mumbai1988)
plot(mumbai2017)
dev.off()

# Possiamo calcolare il DVI (Difference Vegetation Index che ci dà informazione sullo stato delle piante) basandosi sulle ultime due bande:
indicemangrovie1988 = mumbai1988[[3]] - mumbai1988[[2]]
plot(indicemangrovie1988)
plot(indicemangrovie1988, col=inferno(100))

indicemangrovie2017 = mumbai2017[[3]] - mumbai2017[[2]]
plot(indicemangrovie2017)
plot(indicemangrovie2017, col=inferno(100))

im.multiframe(1,4)
plot(mumbai1988)
plot(mumbai2017)
plot(indicemangrovie1988, col=inferno(100))
plot(indicemangrovie2017, col=inferno(100))


# Creare plot delle due immagini in RGB nella banda del rosso, del blu e del verde
#banda 1 = red
#banda 2 = verde
#banda 3 = NIR
im.multiframe(1,3)
im.plotRGB(mumbai1988, r=1, g=2, b=3) 
im.plotRGB(mumbai1988, r=2, g=1, b=3)
im.plotRGB(mumbai1988, r=3, g=2, b=1)

im.multiframe(1,3)
im.plotRGB(mumbai2017, r=1, g=2, b=3)
im.plotRGB(mumbai2017, r=2, g=1, b=3)
im.plotRGB(mumbai2017, r=3, g=2, b=1)

