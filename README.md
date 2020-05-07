# aemet-to-bigquery

This repository provides the scripting necessary to download meteorological information from the Spanish Meteorological Agency (AEMET) from the AEMET OpenData project and upload it to BigQuery to use it as part of the data analytics.

AEMET provides data in plain JSON format. It contains geographic information, both in DMS (Degree, Minute, Second) and decimal latitude and longitude.

Data is uploaded to staging tables (stg). Then it needs to be transformed to be used for reporting. The master tables with the data necessary for reporting has a “t_*” prefix.

It was done on May 4th, 2020, with the Generally Available features on the different services used for this repository.
