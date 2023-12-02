/*
	Count number of records per measurement type with measurements that fell
	outside the upper and lower limits
*/
SELECT
	"Metric Type",
	COUNT(id) AS count
FROM
	temp_outliers
GROUP BY
	"Metric Type"
ORDER BY
	"Metric Type"
;