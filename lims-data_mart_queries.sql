select * from "lims-temporary".marts.lab_lims_statistics
where event_date >= '2025-10-01' and event_date <= '2026-03-31'


SELECT
    facility_name,
    TO_CHAR(DATE_TRUNC('month', shr_date), 'Month YYYY') AS month,
    COUNT(*) AS record_count
FROM "lims-temporary".marts.lab_lims_statistics
WHERE
    shr_date >= '2025-10-01'
  AND shr_date < '2026-04-30'
  AND facility_id_code IN ('ZW080535','ZW080583','ZW090A66','ZW080582','ZW030332','ZW090A07','ZW06050A','ZW060627',
                           'ZW090A14','ZW030339','ZW090A02','ZW03030A','ZW070445','ZW090A17','ZW050406','ZW090A12')
GROUP BY
    facility_name,
    DATE_TRUNC('month', shr_date)
ORDER BY
    facility_name,
    DATE_TRUNC('month', shr_date);



select distinct (facility_id_code) from "lims-temporary".marts.lab_lims_statistics