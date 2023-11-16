
ALTER TABLE nashvillehousing
ADD saledateconverted date;

select saledateconverted, convert(date,saledate)
from bootcam.dbo.nashvillehousing

update nashvillehousing
set saledate = CONVERT(date,saledate)


update nashvillehousing
set Saledateconverted = CONVERT(date,saledate)

 -----populate property address-----------

 select *
 from nashvillehousing
 --where propertyaddress is null
 order by PropertyAddress

 select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from bootcam.dbo.nashvillehousing a
 join bootcam.dbo.nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from bootcam.dbo.nashvillehousing a
 join bootcam.dbo.nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null



----------- breaking out address in ti individual columns (adress, city, state)------------------
select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as adress,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , LEN(propertyaddress)) as adress
 from bootcam.dbo.nashvillehousing

 ALTER TABLE nashvillehousing
ADD propertysplitaddress NVARCHAR(255);

update nashvillehousing
set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

 ALTER TABLE nashvillehousing
ADD propertysplitcity NVARCHAR(255);

update nashvillehousing
set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , LEN(propertyaddress))

select OwnerAddress
from nashvillehousing

select 
PARSENAME(REPLACE(owneraddress, ',', '.'), 3),
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
from nashvillehousing


ALTER TABLE nashvillehousing
 ADD ownersplitaddress NVARCHAR(255);
  update nashvillehousing
   set ownersplitaddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 3)

ALTER TABLE nashvillehousing
 ADD ownersplitcity NVARCHAR(255);
  update nashvillehousing
   set ownersplitcity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

ALTER TABLE nashvillehousing
 ADD ownersplitstate NVARCHAR(255);
  update nashvillehousing
   set ownersplitstate = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)

select *
from nashvillehousing


--------- change Y and N to YES and NO in "sold as vacant" field ----------
select distinct(SoldAsVacant), count(SoldAsVacant)
from nashvillehousing
group by SoldAsVacant
order by 2

---using case statement
select SoldAsVacant,
  CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from nashvillehousing

update nashvillehousing
 SET SoldAsVacant =  CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--------------------- removing duplicates ----------------------------
with rownumCTE as(
----
select *,
   ROW_NUMBER()OVER(
   PARTITION BY parcelid,
                propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by
				uniqueid)row_num
from nashvillehousing
) select *  --delete
from rownumCTE
where row_num > 1
order by PropertyAddress --



---------- delete unused colums------------------
select *
from bootcam.dbo.nashvillehousing

ALTER TABLE bootcam.dbo.nashvillehousing
DROP COLUMN owneraddress, taxdistrict

ALTER TABLE bootcam.dbo.nashvillehousing
DROP COLUMN saledate
