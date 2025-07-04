# ESAME TELERILEVAMENTO GEOECOLOGICO 2025
## GIORGIA BAIANO 
>matricola:1176371

## OBBIETTIVO🎯
Questo codice ha come scopo quello di visualizzare attraverso l'applicazione degli **indici spettrali** e un'**analisi multi temporale**, la **variazione della copertura forestale della Pineta di Cervia - Milano Marittima (RA)** prima e dopo il passaggio di una **tromba d'aria**, avvenuta il **10 luglio 2019**, che ha portato ad una perdita di oltre 2500 piante.


## DATI UTILIZZATI🛰️
I dati sono stati ricavati dal [sito di Google Earth Engine](https://earthengine.google.com/)


## PACCHETTI USATI📚
``` r
library(terra) #pacchetto per l'utilizzo della funzione rast() per SpatRaster
library(imageRy) #pacchetto per l'utilizzo della funzione im.plotRGB() per la visualizzazione delle immagini; e le funzioni im.dvi() e im.ndvi()
library(viridis) #pacchetto che permette di creare plot di immagini con differenti palette di colori di viridis
library(ggridges) #pacchetto che permette di creare i plot ridgeline
```

A seguire i codici in **java script** utilizzati su **Google Earth Engine** per ottenere le immagini della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio della tromba d'aria🌪️

Script per ottenere l'immagine **"pinetapreNIR"**: riporta una collection di immagini che vanno **dal 2018-06-01 al 2019-06-30**, selezionando solo immagini con una *copertura nuvolosa <20%* e le *bande relative al rosso, verde, blu e NIR*.

```javascript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(pinetapreNIR)
                   .filterDate('2018-06-01', '2019-06-30')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetapreNIR overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetapreNIR);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetapreNIR, 10); // Zoom to the pinetapreNIR

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B4', 'B3', 'B2', 'B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B4', 'B3', 'B2', 'B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8']),  // Select NIR band
  description: 'PinetapreNIR',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'pinetapreNIR',
  region: pinetapreNIR,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
```

Script per ottenere l'immagine **"pinetapostNIR"**: riporta una collection di immagini che vanno **dal 2019-07-10 al 2020-05-30**, selezionando solo immagini con una *copertura nuvolosa <20%* e le *bande relative al rosso, verde, blu e NIR*.
```javascript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(pinetapostNIR)
                   .filterDate('2019-07-10', '2020-05-30')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetapostNIR overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetapostNIR);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetapostNIR, 10); // Zoom to the pinetapostNIR

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B4', 'B3', 'B2', 'B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B4', 'B3', 'B2', 'B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8']),  // Select NIR band
  description: 'PinetapostNIR',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'pinetapostNIR',
  region: pinetapostNIR,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
```



## VISUALIZZAZIONE DEI DATI SATELLITARI🌈

Una volta ottenute le due immagini su Google Drive posso impostare la working directory per importare e visualizzare le immagini in formato .tif su R:

**pinetapre**
```r
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") #working directory in cui ho salvato il file da importare
pinetapre= rast("pinetapreNIR.tif") #importo e nomino il raster
plot(pinetapre) #plot che mi permette di visualizzare l'immagine
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre") #plot RGB per visualizzare l'immagine nello spettro del visibile
dev.off()
```
**pinetapost**
```r
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/")
pinetapost= rast("pinetapostNIR.tif")
plot(pinetapost)
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost") 
dev.off() 
```

Creo un pannello multiframe per vedere le immagini della pineta prima e dopo il passaggio della tromba d'aria a confronto nel visibile (RGB):
```r
im.multiframe(1,2) #funzione che apre un pannello multiframe che mi permette di vedere le 2 immagini una affianco all'altra (layout: 1 riga, 2 colonne)
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre")
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost")
dev.off()
```
![Confronto pinetapre e pinetapost](https://github.com/user-attachments/assets/00df67fb-2f88-4eac-8232-a585d0be14e7)

Creo un pannello multiframe per visualizzare le 4 bande (rosso, verde, blu e NIR) che costituiscono ogniuna delle due immagini:
```r
im.multiframe(2,4) #(layout: 2 righe, 4 colonne)
plot(pinetapre[[1]], col = magma(100), main = "Pre - Banda 1")
plot(pinetapre[[2]], col = magma(100), main = "Pre - Banda 2")
plot(pinetapre[[3]], col = magma(100), main = "Pre - Banda 3")
plot(pinetapre[[4]], col = magma(100), main = "Pre - Banda 8")

plot(pinetapost[[1]], col = magma(100), main = "Post - Banda 1")
plot(pinetapost[[2]], col = magma(100), main = "Post - Banda 2")
plot(pinetapost[[3]], col = magma(100), main = "Post - Banda 3")
plot(pinetapost[[4]], col = magma(100), main = "Post - Banda 8")
dev.off()
```
![Visualizzazione bande pineta pre e post](https://github.com/user-attachments/assets/8d73449c-0830-4c29-aace-5b80bebc36b5)


Visualizzazione del suolo nudo rispetto alla vegetazione:
```r
im.multiframe(1,2)
plotRGB(pinetapre, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapre") 
plotRGB(pinetapost, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapost")
dev.off()
```
![Confronto pineta pre e post Nir su b](https://github.com/user-attachments/assets/75f34433-7a99-4499-86ed-1c53f1e1551c)
>Ho montato sulla componente blu (b) dello schema RGB, la banda dell’infrarosso corrispondente alla 4. Quindi vedo le piante di colore blu, mentre appare nella scala del giallo tutto ciò che non è vegetazione (questa funzione con il blu si usa di solito per evidenziare aree con suolo nudo).



## CALCOLO DEGLI INDICI SPETTRALI📊

Ricordiamo le bande:

banda 4 = NIR

banda 1 =red

## Calcolo il DVI🍃 
*Difference Vegetation Index*:  **DVI= NIR - red**, è un indice che ci dà informazione sullo stato di salute o di presenza delle piante, basandosi sulla riflettanza della vegetazione nelle bande del rosso B1 e sulla banda B8 relativa al NIR. Se l’albero è stressato, le cellule a palizzata collassano, allora la riflettanza nel NIR sarà più bassa.

```r
DVIpre = pinetapre[[4]] - pinetapre[[1]] #NIR - red
plot(DVIpre)
plot(DVIpre, col=inferno(100))
dev.off()
```

```r
DVIpost = pinetapost[[4]] - pinetapost[[1]] #NIR - red
plot(DVIpost)
plot(DVIpost, col=inferno(100))
dev.off()
```

```r
im.multiframe(1,2)
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
dev.off()
```

E' possibile calcolare il DVI usando una funzione di imageRy invece di scrivere le formule per esteso:
```r
dvipreauto = im.dvi(pinetapre, 4, 1) #funzione per il calcolo automatico del DVI dove specifico l'immagine di riferimento e le bande relative al NIR(4) e al rosso (1)
plot(dvipreauto, col=inferno(100))
dev.off()
```
```r
dvipostauto = im.dvi(pinetapost, 4, 1)
plot(dvipostauto, col=inferno(100))
dev.off()
```
```r
im.multiframe(1,2)
plot(dvipreauto, stretch = "lin", main = "dvipreauto", col=inferno(100))
plot(dvipostauto, stretch = "lin", main = "dvipostauto", col=inferno(100))
dev.off()
```

## Calcolo l'NDVI🍃
*Normalized Difference Vegetation Index*: **NDVI= (NIR - red) / (NIR + red)**, si tratta sempre di un indice per analizzare la vegetazione, ma è normalizzato tra -1 e +1; più adatto per confrontare immagini in tempi diversi. In questo caso è stato calcolato per valutare l'impatto della tromba d'aria sulla vegetazione.

```r
NDVIpre = (pinetapre[[4]] - pinetapre[[1]]) / (pinetapre[[4]] + pinetapre[[1]]) # NDVI= (NIR - red) / (NIR + red)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
dev.off()
```

```r
NDVIpost = (pinetapost[[4]] - pinetapost[[1]]) / (pinetapost[[4]] + pinetapost[[1]]) # NDVI= (NIR - red) / (NIR + red)
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()
```

```r
im.multiframe(1,2)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()
```

E' possibile calcoalre l'NDVI usando una funzione di imageRy invece di scrivere le formule per esteso:
```r
ndvipreauto = im.ndvi(pinetapre, 4, 1) #funzione per il calcolo automatico dell'NDVI dove specifico l'immagine di riferimento e le bande relative al NIR(4) e al rosso (1)
plot(ndvipreauto, col=inferno(100))
dev.off()
```
```r
ndvipostauto = im.ndvi(pinetapost, 4, 1)
plot(ndvipostauto, col=inferno(100))
dev.off()
```
```r
im.multiframe(1,2)
plot(ndvipreauto, stretch = "lin", main = "ndvipreauto", col=inferno(100))
plot(ndvipostauto, stretch = "lin", main = "ndvipostauto", col=inferno(100))
dev.off()
```

Confronto delle immagini pre e post passaggio tromba d'aria, ottenute attraverso il calcolo del DVI e dell'NDVI:

```r
im.multiframe(2,2)
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()
```

![Confronto pre e post DVI e NDVI](https://github.com/user-attachments/assets/cb9d08af-ac65-4994-ab69-1f9b93296f95)

>DVI: nella prima immagine si vede un maggior valore della biomassa (colori tendenti al giallo), rispetto alla seconda, dove sono chiaramente visibili i danni causati dal passaggio della tromba d'aria al centro della pineta.

>NDVI: dalle immagini si vede come in NDVIpre si osservano valori tipici di copertura vegetale densa e sana, con valori tra 0.8 e 0.6 (colore chiaro). Dopo la tromba d’aria in NDVIpost, si nota una riduzione dei valori NDVI, con aree che scendono sotto a 0.6 fino ad arrivare a 0.3-0.2, indicando perdita di copertura fogliare, quindi alberi abbattuti o suolo esposto.


## ANALISI MULTI TEMPORALE⏲️

Possiamo usare R per effettuare un'**analisi multi temporale**: vedere come cambia un'area nel tempo.

Calcolo la **differenza** nella **banda del rosso (B1)** e dell'**NDVI** tra l’immagine della **pineta post tromba d'aria e quella pre tromba d'aria** per vedere le differenze:

```r
pinetadif = pinetapre[[1]] - pinetapost[[1]] # ho estratto il livello 1 da entrambe le immagini
plot(pinetadif, stretch = "lin", main = "Pinetadif", col=mako(100)) 
```

![Pinetadif](https://github.com/user-attachments/assets/a1595389-e5fb-4d3c-acaf-69e43d1cd7e6)

```r
pinetadifNDVI = ndvipostauto - ndvipreauto #differenza NDVI tra pineta post e pre impatto 
plot(pinetadifNDVI, stretch = "lin", main = "PinetadifNDVI", col=mako(100))
dev.off()
```
![PinetadifNDVI](https://github.com/user-attachments/assets/28c0ab76-83ca-49a3-80a8-b2c70199102b)

> Tutto ciò che ha un colore più scuro ha un valore maggiore, che va ad indicare un cambiamento delle condizioni di un territorio rispetto a prima, in questo caso il cambaimento è dato dalla perdita della copertura vegetale. In questo modo è ben visibile la traccia lasciata dal passaggio della tromba d'aria. 


Creazione di nuovi raster, sempre con una *copertura nuvolosa <20%*, solo con la **banda 8 del NIR** di tre periodi differenti: **giugno 2019, luglio 2019 e agosto 2019**, (dato che la tromba d'aria si è verificata il 10 luglio 2019) per poter fare un'analisi multi temporale.

**pinetagiu2019**
```javascript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(pinetagiu2019)
                   .filterDate('2019-06-01', '2019-06-30')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetagiu2019 overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetagiu2019);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetagiu2019, 10); // Zoom to the pinetagiu2019

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B8']),  // Select NIR band
  description: 'pinetagiu2019',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'sentinel2_median_2020',
  region: pinetagiu2019,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

```

**pinetalug2019**
```javascript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(pinetalug2019)
                   .filterDate('2019-07-01', '2019-07-31')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetalug2019 overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetalug2019);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetalug2019, 10); // Zoom to the pinetalug2019

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B8']),  // Select NIR band
  description: 'pinetalug2019',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'sentinel2_median_2020',
  region: pinetalug2019,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

```

**pinetaago2019**
```javascript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(pinetaago2019)
                   .filterDate('2019-08-01', '2019-08-31')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetaago2019 overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetaago2019);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetaago2019, 10); // Zoom to the pinetaago2019

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B8']),  // Select NIR band
  description: 'pinetaago2019',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'sentinel2_median_2020',
  region: pinetaago2019,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

```

Ottenute le tre immagini, ripeto le stesse funzioni per scaricare e visualizzare le immagini su R viste in precedenza:

**pinetagiu2019**
```r
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetagiu2019= rast("pinetagiu2019.tif")
plot(pinetagiu2019)
dev.off()
```

**pinetalug2019**
```r
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetalug2019= rast("pinetalug2019.tif")
plot(pinetalug2019)
dev.off()
```

**pinetago2019**
```r
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetaago2019= rast("pinetaago2019.tif")
plot(pinetaago2019)
dev.off()
```

Unisco i 3 raster con un pacchetto chiamato **stack** e rinomino i layer del vettore appena creato.

```r
pineta2019 = c(pinetagiu2019, pinetalug2019, pinetaago2019) #funzione per creare un vettore
names(pineta2019) =c("1)giugno2019", "2)luglio2019", "3)agosto2019") #funzione per dare un nome ai layer del vettore

```

Per eseguire l'analisi multi temporale possiamo confrontare le immagini di giugno, luglio e agosto 2019 utilizzando la funzione **Ridgeline**: funzione che prende tutti i pixel di ogni periodo e calcola la frequenza dei pixel, per poi creare grafici che mostrano la distribuzione delle frequenze di ogni singolo momento e le distribuiscono in una serie temporale.

```r
im.ridgeline(pineta2019, scale=2, palette="rocket") #Imposto scale=2 con cui vado ad indicare l’altezza del grafico che si va a sovrapporre al grafico successivo creando un effetto 3D e imposto un colore.
```
![Ridgeline pineta2019](https://github.com/user-attachments/assets/778c499e-f02f-44ab-a30a-159fb7f9184d)


## RISULTATI E CONCLUSIONI✍️

* Ci vorrebbero analisi a più alta risoluzione per rendere visibile ogni singolo albero.

* Le immagini a falsi colori mostrano più o meno chiaramente il passaggio della tromba d'aria. E' abbastanza evidente invece, quando ho montato la banda del NIR sulla componente del blu per mettere in risalto il suolo nudo, che nell'immagine "pinetapost" appare come una striscia al cnetro della pineta coincidente con il passaggio della tromba d'aria.

* Le immagini che derivano dal calcolo del DVI mostrano con chiarezza la traccia lasciata dalla tromba d'aria: pixel più chiari rappresentano valori più alti, quindi più vegetazione, al contrario pixel più scuri che rappresentano valori bassi. L'analisi NDVI mostra ancora meglio qusta differenza di colore: nella prima immagine "NDVIpre" vediamo come all'interno della pineta predominano valori chiari (tra 0.8 e 0.6) che si vanno a differenziare da quelli più scuri relativi alle abitazioni, alla fascia costiera, al mare e ad altri specchi d'acqua. Nell'immagine NDVIpost la scia interna alla pineta è costituita da pixel di colore molto più scuro (arrivando fino a 0.2), è ben visibile l'impatto e il danneggiamento della copertura forestale.

* I grafici pinetadif e pinetadifNDVI delle differenze, ottenuti dall sottrazione delle immagini post evento da quelle pre evento, mostrano l'area che ha subito un cambiamento, attraverso pixel più scuri e intensi, coincidenti all'area in cui c'è stata una perdita di vegetazione.

* Dal grafico si vede come da giugno 2019 a luglio 2019 siano cambiati i picchi dei valori più bassi, relativi alle zone dove si è persa la vegetazione, proprio nel mese di luglio quando è avvento l'evento che ha portato a questo impatto sulla pineta.
