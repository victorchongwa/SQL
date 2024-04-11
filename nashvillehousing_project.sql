SELECT * 
FROM [SQL workbase].dbo.NashvilleHousing
---standerdizing date formate-------
SELECT saledateconverted
FROM [SQL workbase].dbo.NashvilleHousing

SELECT saledateconverted, CONVERT(date,saledate)
FROM [SQL workbase].dbo.NashvilleHousing
----updating date formate in database---
UPDATE [SQL workbase].dbo.NashvilleHousing
SET Saledate = CONVERT(date,Saledate)

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD saledateconverted date;

UPDATE [SQL workbase].dbo.NashvilleHousing
set saledateconverted = CONVERT(date,Saledate)
---------- converted salr date to saledateconverted by altering saledate column-----

----populate property address data---------------------
SELECT propertyaddress
FROM [SQL workbase].dbo.NashvilleHousing
--WHERE PropertyAddress is NULL

--self join, joining a table to its self to check a match--
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [SQL workbase].dbo.NashvilleHousing a
JOIN [SQL workbase].dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a 
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
FROM [SQL workbase].dbo.NashvilleHousing a 
JOIN [SQL workbase].dbo.NashvilleHousing b 
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


---splitting address into seperate columns (adress, city, state)-------------
SELECT *
FROM [SQL workbase].dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS address
FROM [SQL workbase].dbo.NashvilleHousing

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD splitaddress  nvarchar(255);

UPDATE [SQL workbase].dbo.NashvilleHousing
SET splitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD splitcity  nvarchar(255);

UPDATE [SQL workbase].dbo.NashvilleHousing
SET splitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 

--------------splitting ownsers address to separete columns------------------
SELECT 
 PARSENAME(REPLACE(OwnerAddress, ',','.') ,3),
 PARSENAME(REPLACE(OwnerAddress, ',','.') ,2),
 PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
from [SQL workbase].dbo.NashvilleHousing

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD ownersplitaddress  nvarchar(255);
UPDATE [SQL workbase].dbo.NashvilleHousing
SET ownersplitaddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD ownersplitcity  nvarchar(255);
UPDATE [SQL workbase].dbo.NashvilleHousing
SET ownersplitcity =  PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)


ALTER TABLE [SQL workbase].dbo.NashvilleHousing
ADD ownersplitstate  nvarchar(255);
UPDATE [SQL workbase].dbo.NashvilleHousing
SET ownersplitstate =  PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

SELECT *
FROM [SQL workbase].dbo.NashvilleHousing


-------------- change Y and N TO YES AND NO in "sold as vacant" field-------
SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM [SQL workbase].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

---using CASE statement----
SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
     else SoldAsVacant
     END
FROM [SQL workbase].dbo.NashvilleHousing

UPDATE [SQL workbase].dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
     else SoldAsVacant
     END

SELECT SoldAsVacant
FROM [SQL workbase].dbo.NashvilleHousing


---------------------------remove duplicates-------------------------------
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER()OVER (
partition by ParcelID,
             PropertyAddress,
             saleprice,
             saledate,
             legalreference
             ORDER BY 
              uniqueid
                        )row_num
FROM [SQL workbase].dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY propertyAddress

----------delete unused columns-------
SELECT *
FROM [SQL workbase].dbo.NashvilleHousing

ALTER TABLE [SQL workbase].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, taxdistrict, propertyAddress, saleDate