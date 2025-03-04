#R code for visualizing satellite data




library(terra)
library(imageRy)
im.list()
im.import("sentinel.dolomites.b2.tif")
b2= im.import("sentinel.dolomites.b2.tif")
colorRampPalette(c("black","dark grey", "light grey"))(100)
cl=colorRampPalette(c("black","dark grey", "light grey"))(100)
plot(b2, col=cl)
