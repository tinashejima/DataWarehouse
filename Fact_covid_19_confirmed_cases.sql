create or replace view fact_covid_19_confirmed_cases as
SELECT patient_id,
       display, result,
       obs_date,
       age_at_test,
       age_category,
       gender,
       organization_id
FROM fact_covid_19_testing_v2
         where result= 'CONFIRMED_CASE'