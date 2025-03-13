#Code to calculate spectral indicies from satellite images

library(terra)
library(imageRy)
library(viridis)

im.list()

# 1 = NIR
# 2 =red
# 3 = green

mato1992= im.import( "matogrosso_l5_1992219_lrg.jpg")
mato1992= flip(mato1992)
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1)

#Import the 2006 image of the Mato Grosso area
mato2006= im.import ( "matogrosso_ast_2006209_lrg.jpg")
mato2006= flip(mato2006)
im.plotRGB(mato2006, r=1, g=2, b=3)
im.plotRGB(mato2006, r=2, g=3, b=1)

im.multiframe (1,2)
im.plotRGB(mato1992, r=2, g=3, b=1, title="MatoGrosso 1992")
im.plotRGB(mato2006, r=2, g=3, b=1, title="MatoGrosso 2006")

#Radiometric resolution
plot(mato1992[[1]], col=inferno(100))
plot(mato2006[[1]], col=inferno(100))

#DVI
#Tree: NIR=255, red=0, DVI= NIR-red=255
#Stress tree: NIR=100, red=20, DIV=NIR-red=100-20=80

#Calculate DVI
im.multiframe(1,2)
plot(mato1992)
plot(mato2006)

#1 = NIR
#2 =red

dvi1992 = mato1992[[1]] - mato1992[[2]] #NIR - red
plot(dvi1992)

#DVI 8bit: range (0-255)
#maximum: NIR - red = 255- 0 =255
#minimum: NIR - red= 0 -22 = -255

plot(dvi1992, col=inferno(100))

#Calculate DVI for 2006:
dvi2006 = mato2006[[1]] - mato2006[[2]] #NIR - red
plot(dvi2006)

plot(dvi2006, col=inferno(100))

im.multiframe(1,2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

# Diffrerent radiometric resolutions

# DVI 8 bit: range (0-255)
# maximum: NIR - red = 255 - 0 = 255
# minimum: NIR - red = 0 - 255 = -255

# DVI 4 bit: range (0-15)
# maximum: NIR - red = 15 - 0 = 15
# minimum: NIR - red = 0 - 15 = -15

# NDVI 8 bit: range (0-255)
# maximum: (NIR - red) / (NIR + red) = (255 - 0) / (255 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 255) / (0 + 255) = -1

# NDVI 4 bit: range (0-15)
# maximum: (NIR - red) / (NIR + red) = (15 - 0) / (15 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 15) / (0 + 15) = -1

# NDVI 3 bit: range (0-7)
# maximum: (NIR - red) / (NIR + red) = (7 - 0) / (7 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 7) / (0 + 7) = -1

ndvi1992 = (mato1992[[1]] - mato1992[[2]]) / (mato1992[[1]] + mato1992[[2]])
# ndvi1992 = dvi1992 / (mato1992[[1]] + mato1992[[2]])
plot(ndvi1992)

ndvi2006 = (mato2006[[1]] - mato2006[[2]]) / (mato2006[[1]] + mato2006[[2]])
# ndvi2006 = dvi2006 / (mato2006[[1]] + mato2006[[2]])
plot(ndvi2006)

# Functions from imageRy
dvi1992auto = im.dvi(mato1992, 1, 2)
dev.off()
plot(dvi1992auto)

dvi2006auto = im.dvi(mato2006, 1, 2)
dev.off()
plot(dvi2006auto)

ndvi1992auto = im.ndvi(mato1992, 1, 2)
dev.off()
plot(ndvi1992auto)

ndvi2006auto = im.ndvi(mato2006, 1, 2)
dev.off()
plot(ndvi2006auto)

im.multiframe(1,2)
plot(ndvi1992)
plot(ndvi1992auto)
