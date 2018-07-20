 --AndresWDW prep for constraints (disable)
IF (OBJECT_ID('dbo.FK_DimCustomer_DimGeography') IS NOT NULL)
BEGIN
 ALTER TABLE DimCustomer
	DROP CONSTRAINT FK_DimCustomer_DimGeography
END
GO