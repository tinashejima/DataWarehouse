CREATE OR REPLACE view fact_covid_19_testing_v2 as
SELECT patient_id,
       status,
       display,
       string,
       CASE
            WHEN string = 'IgM positive' OR string = 'IgG positive' OR string = 'IgM and IgG positive' THEN 'CONFIRMED_CASE'
            WHEN string = 'NEGATIVE' THEN 'NEGATIVE'
            ELSE 'UNKNOWN'
       END AS result,
       obs_date,
       age_at_test,
       age_category,
       gender,
       organization_id
FROM fact_covid_19_testing_V1;