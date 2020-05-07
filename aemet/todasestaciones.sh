#!/bin/bash
 
########################################################################################
# Script Name       : todasestaciones.sh
# Description       : Script to download meteorological information from AEMET
#                     OpenData website - todasestaciones
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
 
# Download valores-climatologicos --> todasestaciones
 
DATA_FILE="todasestaciones"
 
curl --request GET \
  --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/inventarioestaciones/todasestaciones/?api_key='$MY_KEY \
  --header 'cache-control: no-cache' \
  -o $DATA_FILE.out
 
# Format $DATA_FILE.out to get the URLs to download data and its metadata
# URLs are stored in variables to use later on to retrieve the actual data
DATA=$(sed -n '4p' todasestaciones.out | sed 's/[",]//g' | awk '{print $3}')
METADATA=$(sed -n '5p' todasestaciones.out | sed 's/[",]//g' | awk '{print $3}')
 
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
--parameter=longitudW:STRING:"W" \
--parameter=latitudS:STRING:"S" \
'insert into aemet.t_todasestaciones
  (fecha_carga, geog_estacion, longitud_DMS, longitud_dec, latitud_DMS, latitud_dec, altitud, nombre, indicativo, indsinop, provincia)
    with lat_long_dec as
    (select longitud as longitud_DMS
          , case
             when substr (longitud, 7, 1) = @longitudW
              then -1 * (cast (substr (longitud, 1, 2) as float64) + cast (substr (longitud, 3, 2) as float64)/60 + cast (substr (longitud, 5, 2) as float64)/3600)
              else cast (substr (longitud, 1, 2) as float64) + cast (substr (longitud, 3, 2) as float64)/60 + cast (substr (longitud, 5, 2) as float64)/3600
            end as longitud_dec
          , latitud as latitud_DMS
          , case
             when substr (latitud, 7, 1) = @latitudS
              then -1 * (cast (substr (latitud, 1, 2) as float64) + cast (substr (latitud, 3, 2) as float64)/60 + cast (substr (latitud, 5, 2) as float64)/3600)
              else cast (substr (latitud, 1, 2) as float64) + cast (substr (latitud, 3, 2) as float64)/60 + cast (substr (latitud, 5, 2) as float64)/3600
            end as latitud_dec
          , altitud
          , nombre
          , indicativo
          , indsinop
          , provincia
    from aemet.stg_todasestaciones)
select current_date () as fecha_carga
     , st_geogpoint (longitud_dec, latitud_dec) as geog_estacion
     , longitud_DMS
     , longitud_dec
     , latitud_DMS
     , latitud_dec
     , altitud
     , nombre
     , indicativo
     , indsinop
     , provincia
from lat_long_dec as ll
where concat (cast (current_date () as string), cast (indsinop as string)) not in
     (select concat (cast (fecha_carga as string)
           , cast (indsinop as string))
      from aemet.t_todasestaciones);'