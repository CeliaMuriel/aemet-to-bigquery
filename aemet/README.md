When you are ready to get the meteorological information, you can execute the aemet.sh script.
./aemet.sh

Comment out those lines with data you are not interested in using for your analysis.

You can schedule the execution of the aemet.sh script daily.

aemet.sh executes the Shell scripts which download every data file from the AEMET OpenData website and loads them in BigQuery. The API Key is hardcoded in the script. This is NOT a good practice for Production. Secure this Key as per your organization’s security standard and policy.
Set [PROJECT ID] to your actual project ID.
