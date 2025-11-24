# data201-group-project
# DATA201/422 Group Project Work

## Purpose
The purpose of our project is to find information regarding the count of people in different busy cities in order to determine the optimal dates and times to perform road works. The three cities we are looking at are Auckland, Wellington, and Christchurch. The supplied code takes telecommunications data from Spark and Vodafone and converts it into a clean dataset containing the Territorial Authority code, Statistical Area Level 2 Code, a datetime in NZST, and a count of people in the area.

## Script Explanation:
A brief description of each script, what it does and any requirements it has
### 00_load.R
Loads the dataset from the file provided, sets the column names and the data types.
This script requires the following pacakages:
- Nanoparquet
- tidyverse
### 01_clean.R
Cleans the datasets provide. All the cleaning steps are on the two telecommunication dataset
Some steps required for this dataset
- remove duplicate rows
- remove different counts for the same area at the same time 
- set correct data types
- set the correct time zone (vodfone data)
- convert to the correct time zone (spark data)
- There are also a couple of code segments in here to highlight any issues that may be occuring
### 02_preprocess.R
- extracts relevant population data
- joins datasets together for all relevant information
### 03_compute.R
- creates summarised datasets to use for calculations
- combines new datasets to primary dataset
- calculates estimate population
- currently produce 3 estimates with different methods
- makes a basic graph to see how well the population has been predicted
### 04_visualize.R
Graphs are produce and dataset that was specified is exported in this file. 
Export can contain more information if select statement for export_dataset is altered
This script reqiures the egg package to combine plots together
- exports the data to filename.csv.gz
## Dataset Explanation:
### sp_data.csv
This is the spark telecommunications data provides the number of cellphones at a given time per area
- has time stamp
- sa2 
- count 
### sa2_2023.csv
Provides sa2 codes to descriptor information
### sa2_ta_concord_2023.csv
This dataset provides a link between SA2s and TAs. 
- has SA2 codes, SA2 names, mapping, territorial authority (TA) codes, and TA names
### subnational_pop_ests.scv
This dataset provides population information or total population and under 14 years olds in catagories of sa2, ta or full country
- has population by sa2, ta and total country
- has population of 0-14 year olds by sa2, ta and total country
### urban_rural_to_indicator_2023.csv
This dataset maps urban rural codes to different indicators
It was not used in our code as it was not deemed necessary to come to any conclusions.
- has UR (urban rural) code, UR name, mapping, indicator, and indicator name
### urban_rural_to_sa2_concord_2023.csv
This dataset links urban rural codes to SA2 codes
It was not used in our code as it was not deemed necessary to come to any conclusions.
- has sa2, sa2 names, mapping, UR Codes, and UR names
### vf_data.parquet
This is the vodafone telecommunications data provides the number of cellphones at a given time per area
- has time stamp
- sa2 
- count 

## Project managment
https://trello.com/invite/b/66f0ed8ffa9afca8927b8c52/ATTIe27834d08572c3a221e5484a58ce476003B5A4AC/data201-422-group-project
