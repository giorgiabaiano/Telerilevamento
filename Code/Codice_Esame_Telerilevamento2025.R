# ESAME TELERILEVAMENTO GEOECOLOGICO 2025
# GIORGIA BAIANO matricola:1176371

# OBBIETTIVO:
# Questo codice ha come scopo quello di visualizzare attraverso l'applicazione degli indici spettrali e un'analisi multi temporale, la variazione della copertura forestale della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio di una tromba d'aria, avvenuta il 10 luglio 2019, che ha portato ad una perdita di oltre 2500 piante.

# DATI UTILIZZATI:
# I dati sono stati ricavati dal seguente sito web: https://earthengine.google.com/ 
# Ho utilizzato il codice fornito da Rocio Beatriz Cortes Lobos durante la lezione in classe su Google Earth Engine: https://code.earthengine.google.com/957b34097e4d6f4dc33ace082ec7cad7
# Successivamente ho copiato il codice all'interno di questo codice vuoto: https://code.earthengine.google.com/ e l'ho modificato con le mie informazioni per ricaavre le immagini per le mie analisi. 

# Ho utilizzato più volte il codice in java script per scaricare più immagini:
# -le immagini "pinetapreNIR" (rinominata "pinetapre") e "pinetapostNIR" (rinominata "pinetapost") con 4 bande (B1=red, B2=green, B3=blue e B8=NIR)
# -le immagini "pinetagiu2019", "pinetalug2019" e "pinetaago2019" con solo la banda B8=NIR per l'analisi multi temporale
# Sono state selezionate solo immagini con una copertura nuvolosa <20%.

# PACCHETTI USATI:
library(terra) #pacchetto per l'utilizzo della funzione rast() per SpatRaster
library(imageRy) #pacchetto per l'utilizzo della funzione im.plotRGB()
library(viridis) #pacchetto che permette di creare plot di immagini con differenti palette di colori di viridis
library(ggridges) #pacchetto che permette di creare i plot ridgeline


# Codice utilizzato in java script su Google Earth Engine per ottenere le immagini della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio della tromba d'aria.

# Script per ottenere l'immagine "pinetapreNIR": riporta una collection di immagini che vanno dal 2018-06-01, 2019-06-30, selezionando solo immagini con una copertura nuvolosa <20% e le bande relative al rosso, verde, blu e NIR.
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


# Script per ottenere l'immagine "pinetapostNIR": riporta una collection di immagini che vanno dal 2019-07-10 al 2020-05-30, selezionando solo immagini con una copertura nuvolosa <20% e le bande relative al rosso, verde, blu e NIR.
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



#VISUALIZZAZIONE DEI DATI SATELLITARI:

# Una volta ottenute le due immagini su Drive, posso impostare la working directory per importarle e visualizzarle su R:

# pinetapre
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") #working directory in cui ho salvato il file da importare
pinetapre= rast("pinetapreNIR.tif") #importo e nomino il raster
plot(pinetapre) #plot che mi permette di visualizzare l'immagine
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre") #plot RGB per visualizzare l'immagine nello spettro del visibile
dev.off()

# Ripeto le stesse funzioni anche per la seconda immagine:
# pinetapost
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/")
pinetapost= rast("pinetapostNIR.tif")
plot(pinetapost)
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost") 
dev.off() 

# Creo un pannello multiframe per vedere le immagini a confronto nel visibile:

im.multiframe(1,2) #funzione che apre un pannello multiframe che mi permette di vedere le 2 immagini una affianco all'altra (layout: 1 riga, 2 colonne)
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre")
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost")
dev.off()


# Creo un pannello multiframe per confrontare le 4 bande che costituiscono ogniuna delle due immagini:
# Cambio i colori per migliorare la visualizzazione utilizzando il colore "magma" dalla palette dei colori di viridis.

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

# Confronto delle due immagini mettendo in risalto solo le corrispettive bande 8: 

im.multiframe(1,2) #isolo e visualizzo solo le bande 8 relative al NIR delle due immagini una accanto all'altra
plot(pinetapre[[4]], stretch="lin", main = "pinetapreNIR", col=magma(100))
plot(pinetapost[[4]], stretch="lin", main = "pinetapostNIR", col=magma(100))
dev.off()

# Visualizzazione del suolo nudo rispetto alla vegetazione:
im.multiframe(1,2)
plotRGB(pinetapre, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapre") 
plotRGB(pinetapost, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapost")
dev.off()

# Ho montato sulla componente blue (b) dello schema RGB, la banda dell’infrarosso corrispondente alla 4. Quindi vedo le piante di colore blu, mentre appare nella scala del giallo tutto ciò che non è vegetazione (questa funzione con il blu si usa di solito per evidenziare aree con suolo nudo).



# CALCOLO DEGLI INDICI SPETTRALI

# Ricordiamo le bande:
# banda 4 = NIR
# banda 1 =red

# Calcolo il DVI: Difference Vegetation Index, è un indice che ci dà informazione sullo stato delle piante, basandosi sulla riflettanza della vegetazione nelle bande del rosso B1 e sulla banda B8 relativa al NIR. Se l’albero è stressato, le cellule a palizzata collassano, allora la riflettanza nel NIR sarà più bassa.
# Calcolo: DVI= NIR - red

DVIpre = pinetapre[[4]] - pinetapre[[1]] #NIR - red
plot(DVIpre)
plot(DVIpre, col=inferno(100))
dev.off()

DVIpost = pinetapost[[4]] - pinetapost[[1]] #NIR - red
plot(DVIpost)
plot(DVIpost, col=inferno(100))
dev.off()

# Creo un pannello multiframe per confrontare le immagini su cui è stato calcoalto il DVI:
im.multiframe(1,2)
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
dev.off()

# Nella prima immagine si vede un maggior valore della biomassa (colori tendenti al giallo), rispetto alla seconda, dove sono chiaramente visibili i danni causati dal passaggio della tromba d'aria al centro della pineta.


# Calcolo l'NDVI: Normalized Difference Vegetation Index, si tratta sempre di un indice per analizzare la vegetazione, ma è normalizzato tra -1 e +1; più adatto per confrontare immagine in tempi diversi. In questo caso è stato calcolato per val'utare l'impatto della tromba d'aria sulla vegetazione.
# Calcolo: NDVI= (NIR - red) / (NIR + red)

NDVIpre = (pinetapre[[4]] - pinetapre[[1]]) / (pinetapre[[4]] + pinetapre[[1]]) # NDVI= (NIR - red) / (NIR + red)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
dev.off()

NDVIpost = (pinetapost[[4]] - pinetapost[[1]]) / (pinetapost[[4]] + pinetapost[[1]]) # NDVI= (NIR - red) / (NIR + red)
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()

im.multiframe(1,2)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()

# Dalle immagini si vede come in NDVIpre si osservano valori tipici di copertura vegetale densa e sana, con valori tra 0.8 e 0.6 (colore chiaro). Dopo la tromba d’aria in NDVIpost, si nota una riduzione dei valori NDVI, con aree che scendono sotto a 0.6 fino ad arrivare a 0.3-0.2, indicando perdita di copertura fogliare, quindi alberi abbattuti o suolo esposto.


# Confronto delle immagini pre e post passaggio tromba d'aria, ottenute attraverso il calcolo del DVI e dell'NDVI:

im.multiframe(2,2)
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()



# ANALISI MULTI TEMPORALE

# Possiamo usare R per effettuare un'analisi multi temporale: vedere come cambia un'area nel tempo.
# Sottraiamo l’immagine della pineta post tromba d'aria da quella pre tromba d'aria per vedere le differenze:

pinetadif = pinetapre[[1]] - pinetapost[[1]] # ho estratto il livello 1 da entrambe le immagini
plot(pinetadif, stretch = "lin", main = "Pinetadif", col=mako(100)) 

# Tutto ciò che ha un colore più scuro ha un valore maggiore, che va ad indicare un cambiamento delle condizioni di un territorio rispetto a prima, in questo caso il cambaimento è dato dalla perdita della copertura vegetale. In questo modo è ben visibile la traccia lasciata dal passaggio della tromba d'aria. 


# Per poter fare un'analisi multi temporale utilizzando la funzione ridgeline, occorre avere layer temporali e non bande spettrali, come nel caso delle immagini "pinetapre" e "pinetapost", quindi è necessario creare nuovi raster focalizzandosi solo sulle bande del NIR per tre periodi differenti, in questo caso giugno 2019, luglio 2019 e agosto 2019, dato che la tromba d'aria si è verificata il 10 luglio 2019.

# Utilizzo lo stesso codice in java script su Google Earth Engine per ottenere le 3 immagini della Pineta di Cervia, ricavando solo la banda 8 del NIR nei mesi di giugno, luglio e agosto 2019.

# Script per ottenere l'immagine "pinetagiu2019", riporta una collection di immagini che vanno dal 2019-06-01 al 2019-06-30, selezionando solo immagini con una copertura nuvolosa <20% con solo la banda 8 relativa al NIR.
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


# Script per ottenere l'immagine "pinetalug2019", riporta una collection di immagini che vanno dal 2019-07-01 al 2019-07-31, selezionando solo immagini con una copertura nuvolosa <20% con solo la banda 8 relativa al NIR.
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


# Script per ottenere l'immagine "pinetaago2019", riporta una collection di immagini che vanno dal 2019-08-01 al 2019-08-31, selezionando solo immagini con una copertura nuvolosa <20% con solo la banda 8 relativa al NIR.
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

# Ottenute le tre immagini, ripeto le stesse funzioni per scaricare e visualizzare le immagini su R viste in precedenza:

# pinetagiu2019
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetagiu2019= rast("pinetagiu2019.tif")
plot(pinetagiu2019)
dev.off()

# pinetalug2019
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetalug2019= rast("pinetalug2019.tif")
plot(pinetalug2019)
dev.off()

# pinetago2019
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetaago2019= rast("pinetaago2019.tif")
plot(pinetaago2019)
dev.off()

# Vedimao le 3 immagini a confronto:
im.multiframe(1,3)
plot(pinetagiu2019, col=rocket(100))
plot(pinetalug2019, col=rocket(100))
plot(pinetaago2019, col=rocket(100))

# Unisco i 3 raster con un pacchetto chiamato stack: si tratta di un pacchetto dove si prendono tanti dati e si mettono tutti insieme, un unico oggetto che contiene più raster. In questo pacchetto le bande vengono viste come elementi di un vettore.
pineta2019 = c(pinetagiu2019, pinetalug2019, pinetaago2019) #funzione per creare un vettore
names(pineta2019) =c("1)giugno2019", "2)luglio2019", "3)agosto2019") #funzione per dare un nome ai layer del vettore


# Per eseguire l'analisi multi temporale possiamo confrontare le immagini di giugno, luglio e agosto 2019 utilizzando la funzione Ridgeline: funzione che prende tutti i pixel di ogni periodo e calcola la frequenza dei pixel per poi creare grafici che mostrano la distribuzione delle frequenze di ogni singolo momento e le distribuiscono in una serie temporale.
im.ridgeline(pineta2019, scale=2, palette="rocket") #Imposto scale=2 con cui vado ad indicare l’altezza del grafico che si va a sovrapporre al grafico successivo creando un effetto 3D e imposto un colore.



# RISULTATI E CONCLUSIONI:
# Ci vorrebbero analisi a più alta risoluzione per rendere visibile ogni singolo albero.
# Le immagini a falsi colori mostrano più o meno chiaramente il passaggio della tromba d'aria. E' abbastanza evidente invece quando ho montato la banda del NIR sulla componente del blu per mettere in risalto il suolo nudo, che nell'immagine "pinetapost" appare come una striscia al cnetro della pineta coincidente con il passaggio della tromba d'aria.
# Le immagini che derivano dal calcolo del DVI mostrano con chiarezza la traccia lasciata dalla tromba d'aria: pixel più chiari rappresentano valori più alti, quindi più vegetazione, al contrario pixel più scuri che rappresentano valori bassi. L'analisi NDVI mostra ancora meglio qusta differenza di colore: nella prima immagine "NDVIpre" vediamo come all'interno della pineta predominano valori chiari (tra 0.8 e 0.6) che si vanno a differenziare da quelli più scuri relativi alle abitazioni, alla fascia costiera, al mare e ad altri specchi d'acqua. Nell'immagine NDVIpost la scia interna alla pineta è costituita da pixel di colore molto più scuro (arrivando fino a 0.2), è ben visibile l'impatto e il danneggiamento della copertura forestale.
# Il grafico pinetadif delle differenze, ottenuto dall sottrazione dell'immagine post evento da quella pre evento, mostra l'area che ha subito un cambiamento, attraverso pixel più scuri e intensi, coincidenti all'area in cui c'è stata una perdita di vegetazione.
