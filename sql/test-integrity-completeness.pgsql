/*
	1. Data Integrity Test
	Objective:		Ensure the dataset is clean and contains no missing or incorrect values.
	Implementation:	Check for missing values in key columns such as weight,
					height, and body fat percentage.
	
	4. Completeness Test
	Objective:		Ensure that each record contains all required information.
	Implementation:	Check for completeness by verifying that each record has
					entries for weight, height, body fat percentage, and other
					essential metrics.

	Solution:		The Data Integrity Test and Completeness Test were completed
					with the solution below.
					Query table for any row that has missing values in the
					columns that correspond to the fields in the 'result sheet'
					of the output of the Evlot360 scanner. The results of this
					query will display the full record of any id that has a
					missing (NULL) or blank ('') value for any field.
*/
SELECT
	id,
	age,
	bmr,
	body_age,
	bone_slim,
	bone_slim_low,
	-- bone_slim_top,
	bone_slim_top,
	ecf,
	height,
	icf,
	lbm_low_limit,
	lbm_quantity,
	lbm_top_limit,
	mbf_low_limit,
	mbf_quantity,
	mbf_top_limit,
	mineral_low_limit,
	mineral_quantity,
	mineral_top_limit,
	msf_quantity,
	mvf_quantity,
	protein_low_limit,
	protein_quantity,
	protein_top_limit,
	sex,
	tbw_low_limit,
	tbw_quantity,
	tbw_top_limit,
	total_score,
	weight,
	whr_level,
	macro_goal,
	macro_bodytype,
	macro_activitylevel,
	macro_activitytype,
	macro_fatloss
FROM member_scans
WHERE
	id IS NULL
	OR age IS NULL
	OR bmr IS NULL
	OR body_age IS NULL
	OR bone_slim IS NULL
	OR bone_slim_low IS NULL
	OR bone_slim_top IS NULL
	OR ecf IS NULL
	OR height IS NULL
	OR icf IS NULL
	OR lbm_low_limit IS NULL
	OR lbm_quantity IS NULL
	OR lbm_top_limit IS NULL
	OR mbf_low_limit IS NULL
	OR mbf_quantity IS NULL
	OR mbf_top_limit IS NULL
	OR mineral_low_limit IS NULL
	OR mineral_quantity IS NULL
	OR mineral_top_limit IS NULL
	OR msf_quantity IS NULL
	OR mvf_quantity IS NULL
	OR protein_low_limit IS NULL
	OR protein_quantity IS NULL
	OR protein_top_limit IS NULL
	OR sex IS NULL
	OR tbw_low_limit IS NULL
	OR tbw_quantity IS NULL
	OR tbw_top_limit IS NULL
	OR total_score IS NULL
	OR weight IS NULL
	OR whr_level IS NULL
;