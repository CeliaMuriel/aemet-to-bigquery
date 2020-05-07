#!/bin/bash
 
########################################################################################
# Script Name       : aemet.sh
# Description       : Script to execute the scripts which download the different
#                     files from AEMET OpenData and upload the data to BigQuery
# Author            : Celia Muriel
# Email             : celiamuriel@google.com
# Creation Date     : May 4th, 2020
# Modified by       :
# Modification Date : 
# Version           : 0.1
# Notes             : API Key hardcoded in MY_KEY variable. Improve security
#                     from production.
########################################################################################
 
# API Key provided by AEMET to retrieve meteorological data from their website
export MY_KEY="XXXXXX"
 
# GCP Project ID where we are working
export PROJECT_ID="[PROJECT ID]"
 
# BigQuery dataset where we are going to load the data
export DATASET="aemet"
 
# export TODAY=$(date '+%Y%m%d')
 
# Execute the scripts
./todasestaciones.sh
./observacion-convencional.sh