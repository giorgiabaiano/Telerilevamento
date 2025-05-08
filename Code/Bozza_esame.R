# I dati sono stati ricavati dal seguente sito web: https://earthobservatory.nasa.gov/
https://earthobservatory.nasa.gov/images/91333/monitoring-mumbais-mangroves


# Pacchetti usati:
library(terra)
library(imageRy)
library(viridis) #pacchetto che permette di plottare immagini con differenti palette di colori di viridis
library()
library()
library()

# Impostazione della working directory e importazione dei dati:
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") #working directory in cui ho salvato il file da importare
mumbai1988= rast("mumbai1988.jpg")
plot(mumbai1988)
mumbai1988= flip(mumbai1988)
plot(mumbai1988)


