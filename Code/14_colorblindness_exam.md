# Code to solve colorblindness problems

## Packages
` ` ` r
library(terra)
library(imageRy)
` ` ` 

## Installing cblindplot
` ` ` r
library(devtools)
install_github("duciororocchini/cblindplot")
library(cblindplot)
` ` ` 

## Importing data
` ` ` r
setwd("~/Desktop")
vinicunca = rast("vinicunca.jpg")
plot(vinicunca)
vinicunca = flip(vinicunca)
plot(vinicunca)
` ` ` 

## Simulating colorblindness
` ` ` r
im.multiframe(1,2)
im.plotRGB(vinicunca, r=1, g=2, b=3, title="Standard Vision")
im.plotRGB(vinicunca, r=2, g=1, b=3, title="Protanopia")
dev.off()
` ` ` 

## Solving colorblindness
To solve colorblindness we can use the cblindplot package:
` ` ` r
dev.off()
rainbow = rast("rainbow.jpg")
plot(rainbow)
rainbow = flip(rainbow)
plot(rainbow)
cblind.plot(rainbow, cvd="protanopia")
cblind.plot(rainbow, cvd="deuteranopia")
cblind.plot(rainbow, cvd="tritanopia")

Starting from na image in rainbow colors, this can be translate to an image that can be seen by people whit protanopia:

` ` ` 
