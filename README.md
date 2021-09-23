# Nashville_Housing_Project

The aim of this project was to practice cleaning data in SQL, as a preliminary step to either analysis or data visualisation.

Inspiration for this project, and the data used, came from [Alex The Analyst's](https://www.youtube.com/channel/UC7cs8q-gJRlGwj4A8OmCmXg) Youtube channel.


## Project Overview

Having downloaded the data of interest, the data was imported into Microsoft SQL Server for exploration and cleaning.

### Actions in SQL

#### Standardise date formats

   - This could be done using an update clause and setting the column in question to a date data type with CONVERT(date,*DateColumn*)
   - However, for whatever reason this didn’t seem to work so a new column was added and then that was updated using the CONVERT function. This was only required for the SaleDate column.


#### Populate missing property addresses

   - Originally, 29 records were missing PropertyAddress values. Looking at the PropertyAddress, ParcelID was the same for records with the same PropertyAddress. This meant that ParcelID could be used to determine the PropertyAddress when it was missing.
   - To do this, the table was joined to itself on the ParcelID but when the UniqueID was different, selecting only null PropertyAddress in one half of the JOIN. The null PropertyAddress were then updated with the actual PropertyAddress when present for the given ParcelID.


#### Splitting property and owner address into Street, City and State

   - The original PropertyAddress and OwnerAddress contained street and city (and state for OwnerAddress) delimited with a comma. To split this out the SUBSTRING function was used in conjunction with CHARINDEX to identify the commas and pull out each address component.
   - From here, new columns were added for Street, City and State (where appropriate) and updated with the correct value for both PropertyAddress and OwnerAddress.


#### Standardise 'SoldAsVacant' format

   - Some records had values of ‘Y’ or ‘N’ for SoldAsVacant, whilst others had a full ‘Yes’ or ‘No’. It was decided that ‘Yes’ or ‘No’ would be preferable so the SoldAsVacant field was updated using a CASE statement where required.

#### Delete duplicate rows

   - TWhilst UniqueID was a distinct field, with it removed there were duplicate records. To identify duplicates all rows were assigned a row number which was partitioned by all fields except UniqueID. The returned data was used in a CTE and filtered to row number <> 1, producing 103 duplicate records.
   - These records were then deleted, resulting in a final record count of 56,374.

#### Drop unused columns

   - Having created a correctly formatted SaleDate field and split out both address fields the original SaleDate, OwnerAddress, PropertyAddress became redundant/unused so were dropped from the table as well as any other unused or non-required fields.

## Roundup

In summary, fairly basic concepts and functions were used to carry out fundamental data cleaning SQL. This was straightforward to carry out and saved queries makes for an easy follow along, however in production it’s highly unlikely you would clean/manipulate raw data tables (nor do I think you should). I’d expect you’d clean data as part of the ETL process (prior to import), when creating regularly used views or in python/excel before analysis. Regardless, it’s good to practice these things as it provides options and an understanding if you were setting up an ETL process and automating the cleaning.
