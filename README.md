# aemet-to-bigquery

This repository provides the (Shell) scripting necessary to download meteorological information from the Spanish Meteorological Agency (AEMET) and upload it to BigQuery to use it as part of the data analytics.

AEMET provides data in plain JSON format. It contains geographic information, both in DMS (Degree, Minute, Second) and decimal latitude and longitude.

Tables to upload data to BigQuery must be created upfront as shown in directory ddls. When you are ready to get the meteorological information, you can execute the aemet.sh script in aemet directory.

Data is transformed to make it easy to use for reporting, calculate distances, and represent it in Data Studio (adding Google Maps representation) and BigQuery Geo Viz.


https://celiamuriel.blogspot.com/2020/05/meteorological-data-to-bigquery.html
