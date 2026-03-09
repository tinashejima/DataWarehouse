CREATE OR REPLACE view fact_covid_19_testing_v1 as
select fct.patient_id, fct.status,  fct.display, fct.string
       , fct.obs_date, pf2.birthDate,
           FLOOR(DATEDIFF(fct.obs_date, pf2.birthDate)/365) AS age_at_test,
    CASE
        WHEN FLOOR(DATEDIFF(fct.obs_date, pf2.birthDate)/365) < 5 THEN 'Under 5 Years'
        WHEN FLOOR(DATEDIFF(fct.obs_date, pf2.birthDate)/365) >=5 THEN '5 Years and Above'
        Else  'Unknown'
    END AS age_category, pf2.gender, pf2.organization_id
from fact_covid_19_testing fct left join patient_flat_2 pf2 on fct.patient_id= pf2.pat_id