# ESAME TELERILEVAMENTO GEOECOLOGICO 2025
# GIORGIA BAIANO matricola:1176371

# OBBIETTIVO:
# Questo codice ha come scopo quello di visualizzare attraverso l'applicazione degli indici spettrali e un'analisi multitemporale, la variazione della copertura forestale della Pineta di Cervia - Milano Marittima (RA) prima e dopo il passaggio di una tromba d'aria, avvenuta il 10 luglio 2019, che ha portato ad una perdita di oltre 2500 piante.

#DATI UTILIZZATI:
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



