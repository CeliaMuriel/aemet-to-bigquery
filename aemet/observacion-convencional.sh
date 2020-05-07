#!/bin/bash
 
########################################################################################
# Script Name       : observacion-convencional.sh
# Description       : Script to download meteorological information from AEMET
#                     OpenData website - observacion-convencional
# Author            : Celia Muriel
# Email             : celiamuriel@google.com
# Creation Date     : May 4th, 2020
# Modified by       :
# Modification Date : 
# Version           : 0.1
# Notes             : .*out files --> information in JSON format to download
#                                     data and metadata.
#                     data_*.json --> Meteorological information in JSON
#                                     format.
#                     metadata_*.json --> Description of the fields in the
#                                         corresponding data_*.json file,
#                                         as well as the origin and periodicity
#                                         of the data.
########################################################################################
 
# Download observacion-convencional
 
DATA_FILE="observacion_convencional"
 
curl --request GET \
  --url 'https://opendata.aemet.es/opendata/api/observacion/convencional/todas/?api_key='$MY_KEY \
  --header 'cache-control: no-cache' \
  -o $DATA_FILE.out
 
# Format $DATA_FILE.out to get the URLs to download data and its metadata
# URLs are stored in variables to use later on to retrieve the actual data
DATA=$(sed -n '4p' ${DATA_FILE}.out | sed 's/[",]//g' | awk '{print $3}')
METADATA=$(sed -n '5p' ${DATA_FILE}.out | sed 's/[",]//g' | awk '{print $3}')
 
# Retrieve the actual data and metadata
curl $DATA > data_${DATA_FILE}.json
curl $METADATA > metadata_${DATA_FILE}.json
 
# BigQuery only accepts new-line delimited JSON, which means one complete
# JSON object per line.
# Use jq to transform the data file with multiple lines to the appropriate
# format
cat data_${DATA_FILE}.json | jq -c '.[]' > data_${DATA_FILE}_line.json
 
# Load data_${DATA_FILE}_line.json to the staging table
bq --location EU \
load \
--autodetect \
--replace=true \
--source_format=NEWLINE_DELIMITED_JSON \
aemet.stg_${DATA_FILE} \
data_${DATA_FILE}_line.json
 
# Add the current date, transform the D(egree)M(inute)S(econd) latitude and longitude into
# decimal, and
bq --location=EU query \
--use_legacy_sql=false \
'insert into aemet.t_observacion_convencional
  (fecha_carga, fecha_obs_UTC, idema, nombre_estacion, geog_estacion, longitud, latitud, altitud, temperatura_suelo, temperatura_aire, temperatura_max_aire, humedad_rel, presion, precipitacion_pluvi, insolacion, visibilidad, stdvvu, vvu, dvu, vmaxu, psoltp, tss5cm, tss20cm, tpr, pacutp, rviento, pres_nmar, dmax, stdvv, stddvu, pliqt, stddv, tamin, dv, vv, vmax, nieve, dmaxu)
select current_date () as fecha_carga
     , fint as fecha_obs_UTC
     , idema
     , ubi as nombre_estacion
     , st_geogpoint (lon, lat) as geog_estacion
     , lon as longitud
     , lat as latitud
     , alt as altitud
     , ts as temperatura_suelo
     , ta as temperatura_aire
     , tamax as temperatura_max_aire
     , hr as humedad_rel
     , pres as presion
     , prec as precipitacion_pluvi
     , inso as insolacion
     , vis as visibilidad
     , stdvvu
     , vvu
     , dvu
     , vmaxu
     , psoltp
     , tss5cm
     , tss20cm
     , tpr
     , pacutp
     , rviento
     , pres_nmar
     , dmax
     , stdvv
     , stddvu
     , pliqt
     , stddv
     , tamin
     , dv
     , vv
     , vmax
     , nieve
     , dmaxu
from aemet.stg_observacion_convencional
where concat (cast (fint as string), idema) not in
     (select concat (cast (fint as string)
           , idema)
      from aemet.t_observacion_convencional);'