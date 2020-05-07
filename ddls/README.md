Before loading the meteorological information in BigQuery for the first time, we need to create the dataset and objects where we are going to store the data. The next commands are meant to create the database objects using the bq command-line tool from the Cloud Shell. You can also use the BigQuery console and run the DDLs from there.

If you want BigQuery to automatically delete data older than a certain number of days, add the table --default_table_expiration flag to the bq mk dataset, or the --expiration flag to the bq mk table.

Remember to replace [PROJECT ID] in the DDL scripts by your actual GCP Project ID.
