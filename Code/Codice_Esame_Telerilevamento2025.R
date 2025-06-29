# ESAME TELERILEVAMENTO GEOECOLOGICO 2025
# GIORGIA BAIANO matricola:1176371

# OBBIETTIVO:
# Questo codice ha come scopo quello di visualizzare attraverso l'applicazione degli indici spettrali e un'analisi multitemporale, la variazione della copertura forestale della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio di una tromba d'aria, avvenuta il 10 luglio 2019, che ha portato ad una perdita di oltre 2500 piante.

# DATI UTILIZZATI:
# I dati sono stati ricavati dal seguente sito web: https://earthengine.google.com/ 
# Ho utilizzato il codice fornito da Rocio Beatriz Cortes Lobos durante la lezione in classe su Google Earth Engine: https://code.earthengine.google.com/957b34097e4d6f4dc33ace082ec7cad7
# Successivamente ho copiato il codice all'interno di questo codice vuoto: https://code.earthengine.google.com/
e l'ho modificato con le mie informazioni per ricaavre le immagini per le mie analisi. 

# Ho utilizzato più volte il codice in java script per scaricare più immagini:
# -le immagini "pinetapre" e "pinetapost" con 3 bande (B1=red, B2=green e B3=blue)
# -le immagini "pinetapreNIR" e "pinetapostNIR" con 4 bande (B1=red, B2=green, B3=blue e B8=NIR)
# -le immagini "pinetagiu2019", "pinetalug2019" e "pinetaago2019" con solo la banda B8=NIR per l'analisi multitemporale
# Sono state selezionate solo immagini con una copertura nuvolosa <20%.

# PACCHETTI USATI:
library(terra) #pacchetto per l'utilizzo della funzione rast() per SpatRaster
library(imageRy) #pacchetto per l'utilizzo della funzione im.plotRGB()
library(viridis) #pacchetto che permette di creare plot di immagini con differenti palette di colori di viridis
library(ggridges) #pacchetto che permette di creare i plot ridgeline


# Codice utilizzato in java script su Google Earth Engine per ottenere le immagini della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio della tromba d'aria.

# La prima immagine chiamata "pinetapre" riporta una collection di immagini che vanno dal 2018-06-01 al 2019-06-30, solo immagini con una copertura nuvolosa <20% selezionando le bande relative al rosso, verde e blu.
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
                   .filterBounds(pinetapre)
                   .filterDate('2018-06-01', '2019-06-30')              // Filter by date                                  
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetapre overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetapre);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetapre, 10); // Zoom to the pinetapre

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  bands: ['B4', 'B3', 'B2'],  // True color: Red, Green, Blue
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),  // Select RGB bands
  description: 'Pinetapre',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'pinetapre',
  region: pinetapre ,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});


# La seconda immagine chiamata "pinetapost" riporta una collection di immagini che vanno dal 2019-07-10 al 2020-05-30, selezionando solo immagini con una copertura nuvolosa <20%, selezionando le bande relative al rosso, verde e blu.
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
                   .filterBounds(pinetapost)
                   .filterDate('2019-07-10', '2020-05-30')              // Filter by date                                
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the pinetapost overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(pinetapost);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(pinetapost, 10); // Zoom to the pinetapost

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  bands: ['B4', 'B3', 'B2'],  // True color: Red, Green, Blue
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),  // Select RGB bands
  description: 'Pinetapost',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'pinetapost',
  region: pinetapost ,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});



# VISUALIZZAZIONE DEI DATI SATELLITARI:

# Una volta ottenute le due immagini su Drive, posso impostare la working directory per importarle e visualizzarle su R:

# pinetapre
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") #working directory in cui ho salvato il file da importare
pinetapre= rast("pinetapre.tif") #importo il raster
plot(pinetapre) #plot che mi permette di visualizzare l'immagine
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre") #plot RGB per visualizzare l'immagine nello spettro del visibile
dev.off() #funzione con cui cancello l'ultima immagine visualizzata

# Ripeto le stesse funzioni anche per la seconda immagine:

# pinetapost
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetapost= rast("pinetapost.tif")
plot(pinetapost)
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost") 
dev.off()

# Creo un pannello multiframe per vedere le immagini a confronto nel visibile:

im.multiframe(1,2) #funzione che apre un pannello multiframe che mi permette di vedere le 2 immagini una affianco all'altra (layout: 1 riga, 2 colonne)
plotRGB(pinetapre, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapre")
plotRGB(pinetapost, r = 1, g = 2, b = 3, stretch = "lin", main = "pinetapost")
dev.off()

# Creo un pannello multiframe per confrontare le 3 bande che costituiscono ogniuna delle due immagini:
# Cambio i colori per migliorare la visualizzazione utilizzando il colore "magma" dalla palette dei colori di viridis.

im.multiframe(2,3) #(layout: 2 righe, 3 colonne)
plot(pinetapre[[1]], col = magma(100), main = "Pre - Banda 1")
plot(pinetapre[[2]], col = magma(100), main = "Pre - Banda 2")
plot(pinetapre[[3]], col = magma(100), main = "Pre - Banda 3")

plot(pinetapost[[1]], col = magma(100), main = "Post - Banda 1")
plot(pinetapost[[2]], col = magma(100), main = "Post - Banda 2")
plot(pinetapost[[3]], col = magma(100), main = "Post - Banda 3")
dev.off()


# Scarico le immagini "pinetapreNIR" e "pinetapostNIR" aggiungendo una quarta banda, la B8 relativa al NIR:

# Script per ottenere l'immagine "pinetapreNIR", riporta una collection di immagini che vanno dal 2018-06-01, 2019-06-30, selezionando solo immagini con una copertura nuvolosa <20% selezionando le bande relative al rosso, verde, blu e NIR.
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


# Script per ottenere l'immagine "pinetapostNIR", riporta una collection di immagini che vanno dal 2019-07-10 al 2020-05-30, selezionando solo immagini con una copertura nuvolosa <20%, selezionando le bande relative al rosso, verde, blu e NIR.
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


# Una volta ottenute le due immagini su Drive, posso impostare la working directory per importarle e visualizzarle su R:
# Ripeto le stesse funzioni viste in precedenza:

# pinetapreNIR
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/") 
pinetapreNIR= rast("pinetapreNIR.tif")
plot(pinetapreNIR)
plot(pinetapreNIR, col=magma(100))
dev.off()

# pinetapostNIR
setwd("C://Users/gdemo/Desktop/Telerilevamento geoecologico/")
pinetapostNIR= rast("pinetapostNIR.tif")
plot(pinetapostNIR)
plot(pinetapostNIR, col=magma(100))
dev.off()

# Confronto delle due immagini mettendo in risalto solo le corrispettive bande 8: 

im.multiframe(1,2) #isolo e visualizzo solo le bande 8 relative al NIR delle due immagini una accanto all'altra
plot(pinetapreNIR[[4]], stretch="lin", main = "pinetapreNIR", col=magma(100))
plot(pinetapostNIR[[4]], stretch="lin", main = "pinetapostNIR", col=magma(100))
dev.off()

# Visualizzazione del suolo nudo rispetto alla vegetazione:
im.multiframe(1,2)
plotRGB(pinetapreNIR, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapreNIR") #ho montato sulla componente blue (b) dello schema RGB, la banda dell’infrarosso corrispondente alla 4. Quindi vedo le piante di colore blu, mentre appare nella scala del giallo tutto ciò che non è vegetazione (questa funzione con il blu si usa di solito per evidenziare aree con suolo nudo).
plotRGB(pinetapostNIR, r = 1, g = 2, b = 4, stretch="lin", main = "pinetapostNIR")
dev.off()



# CALCOLO DEGLI INDICI SPETTRALI

# Ricordiamo le bande:
# banda 4 = NIR
# banda 1 =red

# Calcolo il DVI: Difference Vegetation Index, è un indice che ci dà informazione sullo stato delle piante, basandosi sulla riflettanza della vegetazione nelle bande del rosso (B1) e sulla banda B8 relativa al NIR. Se l’albero è stressato, le cellule a palizzata collassano, allora la riflettanza nel NIR sarà più bassa.
# Calcolo: DVI= NIR - red

DVIpre = pinetapreNIR[[4]] - pinetapreNIR[[1]] #NIR - red
plot(DVIpre)
plot(DVIpre, col=inferno(100))
dev.off()

DVIpost = pinetapostNIR[[4]] - pinetapostNIR[[1]] #NIR - red
plot(DVIpost)
plot(DVIpost, col=inferno(100))
dev.off()

# Creo un pannello multiframe per confrontare le immagini su cui è stato calcoalto il DVI:
im.multiframe(1,2)
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
dev.off()

# Nella prima immagine si vede un maggior valore della biomassa (colori tendenti al giallo), rispetto alla seconda, dove sono chiaramente visibili i danni causati dal passaggio della tromba d'aria al centro della pineta.


# Calcolo l'NDVI: Normalized Difference Vegetation Index, si tratta sempre di un indice per analizzare la vegetazione, ma è normalizzato tra -1 e +1; più adatto per confrontare immagine in tempi diversi.
# Calcolo: NDVI= (NIR - red) / (NIR + red)

NDVIpre = (pinetapreNIR[[4]] - pinetapreNIR[[1]]) / (pinetapreNIR[[4]] + pinetapreNIR[[1]]) # NDVI= (NIR - RED) / (NIR+RED)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=mako(100))

NDVIpost = (pinetapostNIR[[4]] - pinetapostNIR[[1]]) / (pinetapostNIR[[4]] + pinetapostNIR[[1]]) # NDVI= (NIR - RED) / (NIR+RED)
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=mako(100))

im.multiframe(1,2)
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=mako(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=mako(100))
dev.off()
