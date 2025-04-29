#Code to solve colorblindness problems

#Packages
library(terra)
library(imagery)

#Installing cblindplot
library(cblindplot)

#Vinicunca

#Importing data
setwd("~/Desktop")
vinicunca = rast("vinicunca.jpg")
plot(vinicunca)
vinicunca = flip(vinicunca)
plot(vinicunca)

#Simulating colorblindness:
im.multiframe(1,2)
im.plotRGB(vinicunca, r=1, g=2, b=3, title="Standard vision")

im.plotRGB(vinicunca, r=2, g=1, b=3, title="Protanopia")

#Solving colorblindness:
dev.off()
rainbow = rast("rainbow.jpg")
plot(rainbow)
rainbow = flip(rainbow)
plot(rainbow)
cblind.plot(rainbow, cvd="protanopia")
cblind.plot(rainbow, cvd="deuteranopia")
cblind.plot(rainbow, cvd="tritanopia")

