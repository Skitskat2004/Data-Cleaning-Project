Select*
From [Portfolio Project].dbo.[Nashville Housing]


Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Portfolio Project].dbo.[Nashville Housing]

Update [Nashville Housing]
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE [Nashville Housing]
Add SaleDateConverted Date;

Update [Nashville Housing]
Set SaleDateConverted = CONVERT(Date, SaleDate)

--Populate property Address Data

Select*
From [Portfolio Project].dbo.[Nashville Housing]
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].dbo.[Nashville Housing] a
Join [Portfolio Project].dbo.[Nashville Housing] b
on a.ParcelID = b.ParcelID
And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].dbo.[Nashville Housing] a
Join [Portfolio Project].dbo.[Nashville Housing] b
on a.ParcelID = b.ParcelID
And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into individual columns (address, City, State

Select PropertyAddress
From [Portfolio Project].dbo.[Nashville Housing]
Where PropertyAddress is null
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project].dbo.[Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE [Nashville Housing]
Add PropertySplitCity NVarchar(255);

Update [Nashville Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select*
From [Portfolio Project].dbo.[Nashville Housing]


Select OwnerAddress
From [Portfolio Project].dbo.[Nashville Housing]

--Changing yes to no in "sold as Vacant"

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].dbo.[Nashville Housing]
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, Case When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
END
From [Portfolio Project].dbo.[Nashville Housing]



Update [Nashville Housing]
Set SoldAsVacant= Case When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
END

--Duplicate Removal

With RowmumCTE AS (
Select*,
  ROW_NUMBER() Over (
  PARTITION By ParcelID,
             PropertyAddress, 
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
			 UniqueID
			 ) row_num
From[Portfolio Project].dbo.[Nashville Housing]
--Order By ParcelID
)
Select*
From RowmumCTE
Where row_num > 1
--Order by PropertyAddress

--Delete unused columns

Select*
From[Portfolio Project].dbo.[Nashville Housing]


Alter table [Portfolio Project].dbo.[Nashville Housing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter table [Portfolio Project].dbo.[Nashville Housing]
Drop Column SaleDate


