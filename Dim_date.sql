create or replace view dim_date as
SELECT
  DATE_FORMAT(date, 'yyyyMMdd') AS date_key,  -- Integer representation of the date
  date,
  DAY(date) AS calendar_month_day,
  DAYOFYEAR(date) AS calendar_day_of_year,
  DATE_FORMAT(date, 'EEEE') AS calendar_week_day,
  CEIL(DAY(date) / 7.0) AS calendar_week_of_month,
  WEEKOFYEAR(date) AS calendar_week_of_year,
  CASE MONTH(date)
    WHEN 1 THEN 'January'
    WHEN 2 THEN 'February'
    WHEN 3 THEN 'March'
    WHEN 4 THEN 'April'
    WHEN 5 THEN 'May'
    WHEN 6 THEN 'June'
    WHEN 7 THEN 'July'
    WHEN 8 THEN 'August'
    WHEN 9 THEN 'September'
    WHEN 10 THEN 'October'
    WHEN 11 THEN 'November'
    WHEN 12 THEN 'December'
  END AS calendar_month,
  MONTH(date) AS calendar_month_number,
  YEAR(date) AS calendar_year,
  CASE
    WHEN MONTH(date) IN (10, 11, 12) THEN 'Q4'
    WHEN MONTH(date) IN (1, 2, 3) THEN 'Q1'
    WHEN MONTH(date) IN (4, 5, 6) THEN 'Q2'
    WHEN MONTH(date) IN (7, 8, 9) THEN 'Q3'
  END AS calendar_quarter,
  CONCAT(YEAR(date), "-", LPAD(MONTH(date), 2, '0')) AS calendar_month_year_concatenated,
  CONCAT(YEAR(date), '-Q', CAST(QUARTER(date) AS STRING)) AS calendar_year_quarter,

  -- Reporting fields
  -- Adjusting reporting_day_of_year to start from October 1
  CASE
    WHEN MONTH(date) >= 10 THEN DAYOFYEAR(date) - DAYOFYEAR(DATE_FORMAT(date, 'yyyy-10-01')) + 1
    ELSE DAYOFYEAR(date) + (365 - DAYOFYEAR(DATE_FORMAT(date, 'yyyy-10-01'))) + 1
  END AS reporting_day_of_year,
  -- Adjusting reporting_week_of_year to start from October 1
  CASE
    WHEN MONTH(date) >= 10 THEN FLOOR((DAYOFYEAR(date) - DAYOFYEAR(DATE_FORMAT(date, 'yyyy-10-01')) + 6) / 7) + 1
    ELSE FLOOR((DAYOFYEAR(date) + (365 - DAYOFYEAR(DATE_FORMAT(date, 'yyyy-10-01'))) + 6) / 7) + 1
  END AS reporting_week_of_year,
  CASE MONTH(date)
    WHEN 1 THEN 4
    WHEN 2 THEN 5
    WHEN 3 THEN 6
    WHEN 4 THEN 7
    WHEN 5 THEN 8
    WHEN 6 THEN 9
    WHEN 7 THEN 10
    WHEN 8 THEN 11
    WHEN 9 THEN 12
    WHEN 10 THEN 1
    WHEN 11 THEN 2
    WHEN 12 THEN 3
  END AS reporting_month,
  -- Adjusted reporting year based on reporting quarter
  CASE
    WHEN MONTH(date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9) THEN YEAR(date) - 1
    ELSE YEAR(date)
  END AS reporting_year,
  -- Adjusted reporting quarter
  CASE
    WHEN MONTH(date) IN (10, 11, 12) THEN 'Q1'
    WHEN MONTH(date) IN (1, 2, 3) THEN 'Q2'
    WHEN MONTH(date) IN (4, 5, 6) THEN 'Q3'
    WHEN MONTH(date) IN (7, 8, 9) THEN 'Q4'
  END AS reporting_quarter,
  CONCAT(CASE
    WHEN MONTH(date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9) THEN YEAR(date) - 1
    ELSE YEAR(date)
  END, '-',
    LPAD((MONTH(date) + 2) % 12 + 1, 2, '0')
  ) AS reporting_month_year_concatenated,
 CONCAT(CASE
    WHEN MONTH(date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9) THEN YEAR(date) - 1
    ELSE YEAR(date)
  END, '-', CASE
    WHEN MONTH(date) IN (10, 11, 12) THEN 'Q1'
    WHEN MONTH(date) IN (1, 2, 3) THEN 'Q2'
    WHEN MONTH(date) IN (4, 5, 6) THEN 'Q3'
    WHEN MONTH(date) IN (7, 8, 9) THEN 'Q4'
  END) AS reporting_year_quarter_concatenated

FROM (
  SELECT
    DATE_ADD('1900-01-01', t2.i * 10000 + t1.i * 1000 + t3.i * 100 + t4.i * 10 + t5.i) AS date
  FROM
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t3,
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t4,
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t5
) AS dates
WHERE date BETWEEN '2010-01-01' AND '2030-12-31';