#R code for classifying images

#install.packages("patchwork")

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)
plot(mato1992)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

mato1992c = im.classify(mato1992, num_clusters=2)
#class 1 = human
#class 2 = forest

mato2006c = im.classify(mato2006, num_clusters=2)
#class 1 = forest
#class 2 = human

f1992 = freq(mato1992c)
tot1992 = ncell(mato1992c)
prop1992 = f1992 / tot1992
perc1992 = prop1992 * 100
#human =17%, forest =83%

tot2006 = ncell(mato2006)
f2006 = freq(mato2006c)
prop2006 = f2006 / tot2006
perc2006 = prop2006 * 100
#human = 55%, forest = 45%

#Creating dataframe

class = c("Forest","Human")
y1992 = c(83,17)
y2006 = c(45,55)
tabout = data.frame(class, y1992, y2006)

p1= ggplot(tabout, aes(x=class, y=y1992, color=class)) + 
  geom_bar(stat="identity", fill="white") +
  ylim(c(0,100))

p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + 
  geom_bar(stat="identity", fill="white") +
  ylim(c(0,100))

p1 + p2

p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)

p0 + p00 + p1 + p2


#----Solar orbiter

im.list()

solar = im.import( "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# Exercise: classify the image in three classes - im.classify()
solarc= im.classify(solar, num_clusters=3)

#Plot the original image beside the classified one
dev.off()
im.multiframe(1,2)
plot(solar)
plot(solarc)

# 3 = low
# 1 = medium
# 2 = higt

dev.off()
solarcs = subst(solarc, c(3,1,2), c("c1_low", "c2_medium", "c3_higt"))
plot(solacs)

# Exercise: calculate teh percentages of the Sun energy classes whit one line of code
percsolarcs= freq(solarcs)$count*100 / ncell(solarcs)

# create dataframe:
class = c("c1_low", "c2_medium", "c3_higt")
perc = c(38,41,21)
tabsol = data.frame(class,perc)

# final ggplot:
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + 
       geom_bar(stat="identity") #+
       #ylim(c(0,100))

