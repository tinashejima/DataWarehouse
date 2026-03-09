CREATE VIEW "lims-temporary".marts.lims_viral_load_results as
SELECT
    facility_id_code,lab,gender,
    COUNT(DISTINCT lab_request_number) AS distinct_lab_request_numbers,
    CASE
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) < 1
            THEN '<1'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 1 AND 4
            THEN '1-4'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 5 AND 9
            THEN '5-9'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 10 AND 14
            THEN '10-14'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 15 AND 19
            THEN '15-19'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 20 AND 24
            THEN '20-24'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 25 AND 29
            THEN '25-29'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 30 AND 34
            THEN '30-34'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 35 AND 39
            THEN '35-39'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 40 AND 44
            THEN '40-44'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 45 AND 49
            THEN '45-49'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 50 AND 54
            THEN '50-54'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 55 AND 59
            THEN '55-59'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 60 AND 64
            THEN '60-64'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) >= 65
            THEN '65+'
        ELSE 'Unknown Age'
    END AS age_category,
    CASE
        WHEN test_results LIKE '%-%'
            THEN NULL
        WHEN UPPER(test_results) = 'TND'
            OR UPPER(test_results) = 'T.N.D'
            OR UPPER(test_results) = 'TARGET NOT DETECTED COPIES/ML'
            OR UPPER(test_results) LIKE '%NOT DETECTED%'
            OR UPPER(test_results) LIKE '%TND%'
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) < 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) < 1000)
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) >= 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) >= 1000)
            THEN 'Not Suppressed'
    END AS viral_suppression
FROM marts.lab_lims_statistics
WHERE
    CAST(shr_date AS DATE) >= '2025-02-18'
    AND test_type LIKE '%Viral Load%'
    AND lab_order_status = 'completed'
GROUP BY
    facility_id_code,
    lab,
    gender,
    viral_suppression,
    age_category
ORDER BY
    facility_id_code,
    viral_suppression,
    age_category,
    gender;

------------------------------------------------------------------------------------------------------------------------
create view "lims-temporary".marts.lims_viral_load_results as

SELECT
    encounter_id, lab_request_number, facility_id_code, facility_name, lab,gender,
    COUNT(DISTINCT lab_request_number) AS distinct_lab_request_numbers,
    CASE
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) < 1
            THEN '<1'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 1 AND 4
            THEN '1-4'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 5 AND 9
            THEN '5-9'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 10 AND 14
            THEN '10-14'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 15 AND 19
            THEN '15-19'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 20 AND 24
            THEN '20-24'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 25 AND 29
            THEN '25-29'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 30 AND 34
            THEN '30-34'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 35 AND 39
            THEN '35-39'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 40 AND 44
            THEN '40-44'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 45 AND 49
            THEN '45-49'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 50 AND 54
            THEN '50-54'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 55 AND 59
            THEN '55-59'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 60 AND 64
            THEN '60-64'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) >= 65
            THEN '65+'
        ELSE 'Unknown Age'
    END AS age_category,
    CASE
        WHEN test_results LIKE '%-%'
            THEN NULL
        WHEN UPPER(test_results) = 'TND'
            OR UPPER(test_results) = 'T.N.D'
            OR UPPER(test_results) = 'TARGET NOT DETECTED COPIES/ML'
            OR UPPER(test_results) LIKE '%NOT DETECTED%'
            OR UPPER(test_results) LIKE '%TND%'
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) < 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) < 1000)
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) >= 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) >= 1000)
            THEN 'Not Suppressed'
    END AS viral_suppression
FROM marts.lab_lims_statistics
WHERE
    CAST(shr_date AS DATE) >= '2025-02-18'
    AND test_type LIKE '%Viral Load%'
    AND lab_order_status = 'completed'
GROUP BY
    encounter_id, lab_request_number,
    facility_id_code, facility_name,
    lab,
    gender,
    viral_suppression,
    age_category
ORDER BY
    encounter_id, lab_request_number,
    facility_id_code,facility_name,
    viral_suppression,
    age_category,
    gender;


-----------------------------------------------------------------------------------------------------------------------

SELECT
   mf.province, mf.district, facility_id_code ,facility_name,gender,
    CASE
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) < 1
            THEN '<1'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 1 AND 4
            THEN '1-4'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 5 AND 9
            THEN '5-9'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 10 AND 14
            THEN '10-14'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 15 AND 19
            THEN '15-19'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 20 AND 24
            THEN '20-24'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 25 AND 29
            THEN '25-29'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 30 AND 34
            THEN '30-34'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 35 AND 39
            THEN '35-39'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 40 AND 44
            THEN '40-44'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 45 AND 49
            THEN '45-49'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 50 AND 54
            THEN '50-54'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 55 AND 59
            THEN '55-59'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 60 AND 64
            THEN '60-64'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) >= 65
            THEN '65+'
        ELSE 'Unknown Age'
    END AS age_category,
    CASE
        WHEN test_results LIKE '%-%'
            THEN NULL
        WHEN UPPER(test_results) = 'TND'
            OR UPPER(test_results) = 'T.N.D'
            OR UPPER(test_results) = 'TARGET NOT DETECTED COPIES/ML'
            OR UPPER(test_results) LIKE '%NOT DETECTED%'
            OR UPPER(test_results) LIKE '%TND%'
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) < 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) < 1000)
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) >= 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) >= 1000)
            THEN 'Not Suppressed'
    END AS viral_suppression,
   COUNT(DISTINCT lab_request_number) AS count
FROM marts.lab_lims_statistics lab
left join marts.mapping_file mf
on lab.facility_id_code = mf."Facility ID"
WHERE
    CAST(shr_date AS DATE) >= '2025-02-18'
    AND test_type LIKE '%Viral Load%'
    AND lab_order_status = 'completed'
GROUP BY

     mf.province, mf.district,
    facility_id_code,facility_name,
    lab,
    gender,
    viral_suppression,
    age_category
ORDER BY
    mf.province, mf.district,
    facility_id_code, facility_name,
    viral_suppression,
    age_category,
    gender;


select * from marts.lab_lims_statistics
where test_results is null and lab_order_status = 'completed'
------------------------------------------------------------------------------------------------------------------------

create view "lims-temporary".marts.lims_viral_load_results as

SELECT
    encounter_id, lab_request_number, facility_id_code, facility_name, lab,gender,
    COUNT(DISTINCT lab_request_number) AS distinct_lab_request_numbers,
    CASE
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) < 1
            THEN '<1'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 1 AND 4
            THEN '1-4'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 5 AND 9
            THEN '5-9'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 10 AND 14
            THEN '10-14'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 15 AND 19
            THEN '15-19'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 20 AND 24
            THEN '20-24'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 25 AND 29
            THEN '25-29'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 30 AND 34
            THEN '30-34'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 35 AND 39
            THEN '35-39'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 40 AND 44
            THEN '40-44'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 45 AND 49
            THEN '45-49'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 50 AND 54
            THEN '50-54'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 55 AND 59
            THEN '55-59'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) BETWEEN 60 AND 64
            THEN '60-64'
        WHEN FLOOR(EXTRACT(YEAR FROM AGE(CAST(dw_date_created AS DATE), birthdate))) >= 65
            THEN '65+'
        ELSE 'Unknown Age'
    END AS age_category,
    CASE
        WHEN test_results LIKE '%-%'
            THEN NULL
        WHEN UPPER(test_results) = 'TND'
            OR UPPER(test_results) = 'T.N.D'
            OR UPPER(test_results) = 'TARGET NOT DETECTED COPIES/ML'
            OR UPPER(test_results) LIKE '%NOT DETECTED%'
            OR UPPER(test_results) LIKE '%TND%'
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) < 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) < 1000)
            THEN 'Suppressed'
        WHEN (test_results ~ '^\d+$' AND CAST(test_results AS INTEGER) >= 1000)
            OR (CAST(SUBSTRING(test_results FROM '\d+') AS INTEGER) >= 1000)
            THEN 'Not Suppressed'
        else test_results
    END AS viral_suppression
FROM marts.lab_lims_statistics
WHERE
    CAST(shr_date AS DATE) >= '2025-02-18'
    AND test_type LIKE '%Viral Load%'
    AND lab_order_status = 'completed'
GROUP BY
    encounter_id, lab_request_number,
    facility_id_code, facility_name,
    lab,
    gender,
    viral_suppression,
    age_category
ORDER BY
    encounter_id, lab_request_number,
    facility_id_code,facility_name,
    viral_suppression,
    age_category,
    gender;

----------------------------------------------------------------------------------------------------------------------
select * from consultation.laboratory_request_order
where tenant_id = 'ZW090A17' and (date_sample_taken >= '2025-01-01' and date_sample_taken <= '2025-12-31')
and laboratory = 'MPILO'




select *
from consultation.laboratory_request_order_status
where tenant_id = 'ZW090A17' and (date >= '2025-01-01' and date <= '2025-12-31')




Create table marts.lab_lims_statistics
