create or replace view malaria_tested_v2 as
SELECT
    fmt1.patient_id,
    fmt1.code,
    fmt1.display,
    fmt1.date_tested,
    FLOOR(DATEDIFF(fmt1.date_tested, pf2.birthDate)/365) AS age_at_test,
    CASE
        WHEN FLOOR(DATEDIFF(fmt1.date_tested, pf2.birthDate)/365) < 5 THEN 'Under 5 Years'
        WHEN FLOOR(DATEDIFF(fmt1.date_tested, pf2.birthDate)/365) >=5 THEN '5 Years and Above'
        Else  'Unknown'
    END AS age_category,
    pf2.birthDate,
    pf2.gender,
    pf2.organization_id
FROM
    fact_malaria_tested_v1 fmt1
LEFT JOIN
    patient_flat_2 pf2
ON
    fmt1.patient_id = pf2.pat_id;
