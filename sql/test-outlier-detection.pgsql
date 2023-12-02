/*
	3. Outlier Detection
	Objective:		Identify unusual values that might indicate errors.
	Implementation:	Implement a test to flag records with extreme values in body
					composition metrics for further investigation.

	Solution:		Each query below returns the id for every record where the
					'quantity' value for each body composition metric is outside
					the 'low_limit' and 'top_limit'. This produces a list of
					records to investigate the source of the incorrect
					measurement.
*/
DROP TABLE IF EXISTS temp_outliers;
CREATE TEMPORARY TABLE temp_outliers AS 
SELECT
	id,
	'Lean body mass'       AS "Metric Type",
	lbm_low_limit          AS "Lower Limit",
	lbm_quantity           AS "Client Measurement",
	lbm_top_limit          AS "Upper Limit"
FROM
	member_scans
WHERE
	lbm_quantity < lbm_low_limit OR lbm_quantity > lbm_top_limit

UNION

SELECT
	id,
	'Skeletal muscle mass' AS "Metric Type",
	bone_slim_low          AS "Lower Limit",
	bone_slim              AS "Client Measurement",
	bone_slim_top          AS "Upper Limit"
FROM
	member_scans
WHERE
	bone_slim < bone_slim_low OR bone_slim > bone_slim_top

UNION

SELECT
	id,
	'Protein'              AS "Metric Type",
	protein_low_limit      AS "Lower Limit",
	protein_quantity       AS "Client Measurement",
	protein_top_limit      AS "Upper Limit"
FROM
	member_scans
WHERE
	protein_quantity < protein_low_limit OR protein_quantity > protein_top_limit

UNION

SELECT
	id,
	'Mineral'              AS "Metric Type",
	mineral_low_limit      AS "Lower Limit",
	mineral_quantity       AS "Client Measurement",
	mineral_top_limit      AS "Upper Limit"
FROM
	member_scans
WHERE
	mineral_quantity < mineral_low_limit OR mineral_quantity > mineral_top_limit

UNION

SELECT
	id,
	'Total body water'     AS "Metric Type",
	tbw_low_limit          AS "Lower Limit",
	tbw_quantity           AS "Client Measurement",
	tbw_top_limit          AS "Upper Limit"
FROM
	member_scans
WHERE
	tbw_quantity < tbw_low_limit OR tbw_quantity > tbw_top_limit

UNION

SELECT
	id,
	'Body fat mass'        AS "Metric Type",
	mbf_low_limit          AS "Lower Limit",
	mbf_quantity           AS "Client Measurement",
	mbf_top_limit          AS "Upper Limit"
FROM
	member_scans
WHERE
	mbf_quantity < mbf_low_limit OR mbf_quantity > mbf_top_limit

ORDER BY
	id,"Metric Type";
/*
	Display all records with measurements that fell outside the upper and lower
	limits
*/
SELECT * FROM temp_outliers
;