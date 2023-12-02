/*
	2. Range Validation
	Objective:		Confirm that values fall within expected ranges.
	Implementation:	Create a validation test to check if body fat percentage is
					within the range of 0% to 100%, and weight and height are
					within realistic bounds.
	
	Solution:		Create a flag to indicate whether body fat percentage was
					between 0% to 100% in the %BF Validation field. This will
					produce a separate row per error if an id record possess
					more than one error.

					Given the age range of the sample (16-59 years), it was
					assumed that weight between 30kg and 200kg and height between
					1m and 2m are within "realistic bounds". A flag (Y/N) was
					created to indicate whether weight (Weight Validation) or
					height (Height Validation) were invalid.

					It was deduced that sex = 1 is male and sex = 2 is female
					based on average height and weight from the sample.
*/
CREATE TEMPORARY TABLE temp_range_validation AS
SELECT
	id			AS id,
	CASE
		WHEN mbf_quantity < 0 THEN 'N - mbf_quantity is negative'
		WHEN weight < 0 THEN 'N - weight is negative'
		WHEN (mbf_quantity / weight) > 1 THEN 'N - mbf_quantity is greater than weight'
		ELSE 'Y'
	END			AS "%BF Validation",
	CASE
		WHEN weight < 300 OR weight > 20000 THEN 'N'
		ELSE 'Y'
	END			AS "Weight Validation",
	CASE
		WHEN height < 1000 OR height > 2000 THEN 'N'
		ELSE 'Y'
	END			AS "Height Validation"
FROM member_scans
;
SELECT
	id,
	"%BF Validation",
	"Weight Validation",
	"Height Validation"
FROM temp_range_validation
WHERE
	"%BF Validation" LIKE 'N%'
	OR	"Weight Validation" = 'N'
	OR	"Height Validation" = 'N'
;
