#R code for visualizing satellite data




library(terra)
library(imageRy)
libray(viridis)
im.list()
im.import("sentinel.dolomites.b2.tif")
b2= im.import("sentinel.dolomites.b2.tif")
colorRampPalette(c("black","dark grey", "light grey"))(100)
cl=colorRampPalette(c("black","dark grey", "light grey"))(100)
plot(b2, col=cl)
cl = colorRampPalette(c("black", "dark grey", "light grey"))(100)
plot(b2, col=cl)

cl = colorRampPalette(c("black", "dark grey", "light grey"))(3)
plot(b2, col=cl)
# tlumley@u.washington.edu, Thomas Lumley

# Exercise: make your own color ramp
# https://sites.stat.columbia.edu/tzheng/files/Rcolor.pdf

cl = colorRampPalette(c("royalblue3", "seagreen1", "red1"))(100)
plot(b2, col=cl)

# bands
b3 = im.import("sentinel.dolomites.b3.tif")
b4 = im.import("sentinel.dolomites.b4.tif")
b8 = im.import("sentinel.dolomites.b8.tif")

par(mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

dev.off()

im.multiframe(1,4)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# Exercise: plot the bands using im.multiframe() one on top of the other
im.multiframe(4,1)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

im.multiframe(2,2)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

cl = colorRampPalette(c("black", "light grey"))(100)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

cl = colorRampPalette(c("black", "light grey"))(2)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

sent = c(b2, b3, b4, b8)
plot(sent, col=cl)

names(sent) = c("b2-blue", "b3-green", "b4-red", "b8-NIR")
sent

plot(sent, col=cl)
plot(sent)

names(sent) = c("b2blue", "b3green", "b4red", "b8NIR")
dev.off()
plot(sent$b8NIR)

plot(sent[[4]])

# importing several bands altogether
sentdol = im.import("sentinel.dolomites")

# How to import severla sets altogether
pairs(sentdol)

# viridis
plot(sentdol, col=viridis(100))
plot(sentdol, col=mako(100))
plot(sentdol, col=magma(100))

#layers
#1 = blue (b2)
#2 = green (b3)
#3 = red (b4)
#4 = NIR (b8)

#Natural colors
im.plotRGB(sentdol, r=3, g=2, b=1)

#False colors
im.plotRGB(sentdol, r=4, g=2, b=1)

#exercise: plot te image using NIR ontop of the green component of the RGB scheme
im.plotRGB(sentdol, r=3, g=4, b=1)
im.plotRGB(sentdol, r=3, g=4, b=1)
im.plotRGB(sentdol, r=3, g=2, b=4)
