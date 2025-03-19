# Reporting Multitemporal analysis in R

First of all, we should import imahe by: 
``` r
im.list # make a list
gr=im.import("greenland") # to import image

```
Then we might calculate the difference of values of two image
``` r
grdif= gr[[4]] - gr[[1]]
```

This will create the following output image:
