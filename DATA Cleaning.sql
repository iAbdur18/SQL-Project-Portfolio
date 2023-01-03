/*	Cleaning DATA in SQL Queries
*/

-- Selecting all of the data
SELECT *
FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning];

-- Sales Date Standarization

SELECT SaleDate, SaleDateConverted, CONVERT(date,SaleDate) AS SalesDateFormatted
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

UPDATE [Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(date, SaleDate);

-- Adding a Column
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD SaleDateConverted Date;

-- updatating column value
UPDATE [Nashville Housing Data for Data Cleaning]
SET SaleDateConverted = CONVERT(date, SaleDate);

/*	 Property Address
*/

--
SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

-- Populate Property Address

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning] AS A
JOIN PortfolioProject..[Nashville Housing Data for Data Cleaning] AS B
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE A
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning] AS A
JOIN PortfolioProject..[Nashville Housing Data for Data Cleaning] AS B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] != B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

/*	 Property Address
*/

SELECT PropertyAddress
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS FirstAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress) ) AS LastAddress
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress) );

SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

/*	 Parsing
*/

-- OWNER ADDRESS

SELECT * 
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

SELECT OwnerAddress
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

-- Applying parsing instead of SUBSTRING

SELECT
PARSENAME ( REPLACE(OwnerAddress,',','.'), 3),
PARSENAME ( REPLACE(OwnerAddress,',','.'), 2),
PARSENAME ( REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

-- once the queries have been generetaed, we can update the tables

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD OwnerSplitLine Nvarchar(255);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD OwnerSplitCity Nvarchar(255);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitLine = PARSENAME ( REPLACE(OwnerAddress,',','.'), 3)

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME ( REPLACE(OwnerAddress,',','.'), 2)

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME ( REPLACE(OwnerAddress,',','.'), 1)

SELECT * 
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

/*	 Change Y and N to Yes and No respectively
*/
-- generate the right query to extract the possible language statements describing YES and No

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]
GROUP BY SoldAsVacant
ORDER BY 2

-- Building Case STUDIES

SELECT SoldAsVacant
, CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]

-- UPDATE the tables based on the CASE STUDIES AND the QUERY

UPDATE [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = 
				 CASE 
					WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END

SELECT SoldAsVacant 
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]
WHERE SoldAsVacant = 'No'


/*	 Remove Duplications ROWS
*/
SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning];

-- creating temp table and quering the duplicated rows out
WITH RowNumCTE AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY 
			ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID
			) row_num

FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;


-- DELETING the rows
WITH RowNumCTE AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY 
			ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID
			) row_num

FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;


-- DELETE Unused Columns
SELECT *
FROM PortfolioProject..[Nashville Housing Data for Data Cleaning]

ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, SaleDate, TaxDistrict
