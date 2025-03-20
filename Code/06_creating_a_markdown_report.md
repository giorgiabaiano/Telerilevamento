# Reporting Multitemporal analysis in R

First of all, we should import image by: 

``` r
im.list # make a list
gr=im.import("greenland") # to import image

```
Then we might calculate the difference of values of two image
``` r
grdif= gr[[4]] - gr[[1]]
```

This will create the following output image:

<img scr="../Pics/difgreen.jpeg" widht=100% />

>Note 1: If you want to put pdf files you can rely on:https://stackoverflow.com/questions/39777166/display-pdf-image-in-markdown

>Note 2: information about Copernicus programme can be found at: https://www.copernicus.eu/en

>Note 3: Here are the [Sentinel date used] (https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2)
