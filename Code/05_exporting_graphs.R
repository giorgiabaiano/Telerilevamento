# Exporting data
setwd("/Users/ducciorocchini/Downloads")
setwd("~/Desktop")
# Windowds users: C://comp/Downloads
# \
# setwd("C://nome/Downloads")

getwd()

plot(gr)

png("greenland_output.png")
plot(gr)
dev.off()

pdf("greenland_output.pdf")
plot(gr)
dev.off()

pdf("difgreen.pdf")
plot(difgreen)
dev.off()

jpeg("difgreen.jpeg")
plot(difgreen)
dev.off()
