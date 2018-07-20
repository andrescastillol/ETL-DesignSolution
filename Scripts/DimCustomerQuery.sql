
SELECT 
	c.CustomerID AS [CustomerKey],
    dg.GeographyKey AS [GeographyKey], 
    CONVERT(nvarchar(15), c.AccountNumber) AS [CustomerAlternateKey], 
    p.Title AS [Title], 
    p.FirstName AS [FirstName], 
    p.MiddleName AS [MiddleName], 
    p.LastName AS [LastName], 
    p.NameStyle AS [NameStyle],
	p.Suffix AS [Suffix], 
	CONVERT(datetime, LEFT(Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";BirthDate','varchar(20)'), 10)) AS [BirthDate],
	Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";MaritalStatus','nchar(1)') AS [MaritalStatus], 	
    Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";Gender','nvarchar(1)') AS [Gender], 
    Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";TotalChildren','tinyint') AS [TotalChildren], 
    Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";NumberChildrenAtHome','tinyint') AS [NumberChildrenAtHome], 
	ea.EmailAddress AS [EmailAddress], 
    CAST(Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";HomeOwnerFlag','bit') AS nchar(1)) AS [HouseOwnerFlag], 
    Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";NumberCarsOwned','tinyint') AS [NumberCarsOwned], 
	a.AddressLine1 AS [AddressLine1], 
	a.AddressLine2 AS [AddressLine2], 
	CONVERT(nvarchar(20), pp.PhoneNumber) AS [Phone], 
	CONVERT(datetime, LEFT(Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";DateFirstPurchase','varchar(20)'), 10)) AS [DateFirstPurchase],     
    Survey.ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";CommuteDistance','nvarchar(15)') AS [CommuteDistance],
	p.Demographics.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";(IndividualSurvey/Education)[1]','nvarchar(40)') as [EnglishEducation],
	p.Demographics.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";(IndividualSurvey/Occupation)[1]','nvarchar(40)') as [EnglishOccupation]
	--cyi.YearlyIncome AS [YearlyIncome], 
	--ifde.EnglishEducation AS [EnglishEducation], 
	--ifde.SpanishEducation AS [SpanishEducation], 
	--ifde.FrenchEducation AS [FrenchEducation], 
	--ifdo.EnglishOccupation AS [EnglishOccupation], 
	--ifdo.SpanishOccupation AS [SpanishOccupation], 
	--ifdo.FrenchOccupation AS [FrenchOccupation]
FROM 
	[Person].[Person] p
		INNER JOIN 
	[Person].[BusinessEntityAddress] bea ON bea.[BusinessEntityID] = p.[BusinessEntityID] 
		INNER JOIN 
	[Person].[Address] a ON a.[AddressID] = bea.[AddressID]
		INNER JOIN 
	[Person].[StateProvince] sp ON sp.[StateProvinceID] = a.[StateProvinceID]
		INNER JOIN 
	[Person].[CountryRegion] cr ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
		INNER JOIN 
	[Person].[AddressType] at ON at.[AddressTypeID] = bea.[AddressTypeID]
		INNER JOIN 
	[Sales].[Customer] c ON c.[PersonID] = p.[BusinessEntityID]
		LEFT OUTER JOIN 
	[Person].[EmailAddress] ea ON ea.[BusinessEntityID] = p.[BusinessEntityID]
		LEFT OUTER JOIN 
	[Person].[PersonPhone] pp ON pp.[BusinessEntityID] = p.[BusinessEntityID]
		LEFT OUTER JOIN 
	[Person].[PhoneNumberType] pnt ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID]
		INNER JOIN 
	[AdventureWorksDW2012].[dbo].[DimGeography] dg ON a.City = dg.City 
													AND sp.StateProvinceCode = dg.StateProvinceCode
													AND cr.CountryRegionCode = dg.CountryRegionCode
													AND a.PostalCode = dg.PostalCode
		CROSS APPLY 
	p.[Demographics].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";IndividualSurvey') AS Survey(ref) 