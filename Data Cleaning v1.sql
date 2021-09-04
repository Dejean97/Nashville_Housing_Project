--All Data

SELECT *
  FROM [PortfolioProject_NashvilleHousing2].[dbo].[NashvilleHousing]



  --Standardise Date Formats

  Select SaleDate, CONVERT(date,SaleDate)
  FROM NashvilleHousing

  UPDATE NashvilleHousing
  SET SaleDate = CONVERT(date,SaleDate)
		 --Doesn't Work?

  ALTER TABLE NashvilleHousing
  ADD SaleDateConverted Date

  UPDATE NashvilleHousing
  SET SaleDateConverted = CONVERT(date,SaleDate)

  Select SaleDate, SaleDateConverted, CONVERT(date,SaleDate)
  FROM NashvilleHousing

  EXEC sp_rename'NashvilleHousing.SaleDateConverted', 'SaleDateOnly', 'COLUMN'
		--Rename column

  --Populate missing property address

  Select PropertyAddress
  FROM NashvilleHousing
  WHERE PropertyAddress is null
		--29 null

  Select *
  FROM NashvilleHousing
  WHERE PropertyAddress is null

  Select *
  FROM NashvilleHousing
  --WHERE PropertyAddress is null
  ORDER BY ParcelID

    Select *
  FROM NashvilleHousing
  WHERE ParcelID = '033 15 0 123.00'
  ORDER BY ParcelID
		--Use parcelID to fill missing property addresses

  Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM NashvilleHousing a
  JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress is null

  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM NashvilleHousing a
  JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress is null

  Select *
  FROM NashvilleHousing
  WHERE PropertyAddress is null
		--0 null



  --Splitting out property and owner address by street address, city, state
  
  Select PropertyAddress
  FROM NashvilleHousing
		--Delimited by a comma

  Select PropertyAddress,
	SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+2, CHARINDEX(',', PropertyAddress)) as City
  FROM NashvilleHousing

  ALTER TABLE NashvilleHousing
  ADD PropertyAddressStreet varchar(255)

  ALTER TABLE NashvilleHousing
  ADD PropertyAddressCity varchar(255)

  UPDATE NashvilleHousing
  SET PropertyAddressStreet = 	SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

  UPDATE NashvilleHousing
  SET PropertyAddressCity = 	SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+2, CHARINDEX(',', PropertyAddress))

  Select OwnerAddress
  FROM NashvilleHousing
		--Delimited by a comma

  Select PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
  FROM NashvilleHousing

  ALTER TABLE NashvilleHousing
  ADD OwnerAddressStreet varchar(255)

  ALTER TABLE NashvilleHousing
  ADD OwnerAddressCity varchar(255)

  ALTER TABLE NashvilleHousing
  ADD OwnerAddressState varchar(255)

  UPDATE NashvilleHousing
  SET OwnerAddressStreet = 	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

  UPDATE NashvilleHousing
  SET OwnerAddressCity = 	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

  UPDATE NashvilleHousing
  SET OwnerAddressState = 	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



  --Uniform Data in SoldAsVacant

  Select DISTINCT(SoldAsVacant)
  FROM NashvilleHousing

  Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM NashvilleHousing
  GROUP BY (SoldAsVacant)
  ORDER BY 2

  Select SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END as SoldAsVacantClean
  FROM NashvilleHousing

  UPDATE NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

  Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM NashvilleHousing
  GROUP BY (SoldAsVacant)
  ORDER BY 2



  --Remove Duplicates

  Select *,
	ROW_NUMBER() OVER (
	PARTITION BY UniqueID
		ORDER BY UniqueID)
		as RowNum
  FROM NashvilleHousing
		--UniqueID still unique but there are duplicate values

  WITH DuplicateCTE AS(
  Select *,
	ROW_NUMBER() OVER (
	PARTITION BY [ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateOnly]
      ,[PropertyAddressStreet]
      ,[PropertyAddressCity]
      ,[OwnerAddressStreet]
      ,[OwnerAddressCity]
      ,[OwnerAddressState]
		ORDER BY UniqueID)
		as RowNum
  FROM NashvilleHousing
  )
  Select * From DuplicateCTE
  WHERE RowNum <>1
		--103 duplicate records


  Select *
  FROM NashvilleHousing
		--56,477 records

  WITH DuplicateCTE AS(
  Select *,
	ROW_NUMBER() OVER (
	PARTITION BY [ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateOnly]
      ,[PropertyAddressStreet]
      ,[PropertyAddressCity]
      ,[OwnerAddressStreet]
      ,[OwnerAddressCity]
      ,[OwnerAddressState]
		ORDER BY UniqueID)
		as RowNum
  FROM NashvilleHousing
  )
  Delete From DuplicateCTE
  WHERE RowNum <>1

   Select *
  FROM NashvilleHousing
		--56,374 records



  --Drop Unused Columns

  Select *
  FROM NashvilleHousing

  ALTER TABLE NashvilleHousing
  DROP COLUMN SaleDate, OwnerAddress, PropertyAddress, TaxDistrict



  --Final Dataset

  SELECT [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[SalePrice]
	  ,[SaleDateOnly]
	  ,[PropertyAddressStreet]
      ,[PropertyAddressCity]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
	  ,[OwnerAddressStreet]
      ,[OwnerAddressCity]
      ,[OwnerAddressState]
      ,[Acreage]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath] 
  FROM [PortfolioProject_NashvilleHousing2].[dbo].[NashvilleHousing]
