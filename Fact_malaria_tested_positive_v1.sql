create or replace view fact_malaria_tested_positive_v1 as
SELECT
    fmtp.patient_id,
    fmtp.display,
    fmtp.date_tested, string as result,
    FLOOR(DATEDIFF(fmtp.date_tested, pf2.birthDate)/365) AS age_at_test,
    CASE
        WHEN FLOOR(DATEDIFF(fmtp.date_tested, pf2.birthDate)/365) < 5 THEN 'Under 5 Years'
        WHEN FLOOR(DATEDIFF(fmtp.date_tested, pf2.birthDate)/365) >=5 THEN '5 Years and Above'
        Else  'Unknown'
    END AS age_category,
    pf2.birthDate,
    pf2.gender,
    pf2.organization_id
FROM
    fact_malaria_tested_positive fmtp
LEFT JOIN
    patient_flat_2 pf2
ON
    fmtp.patient_id = pf2.pat_id;
