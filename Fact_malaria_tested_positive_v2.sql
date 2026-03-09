create or replace view fact_malaria_tested_positive_v2 as
SELECT  organization_id, result ,age_category, gender, count(distinct (patient_id)) as count
FROM fact_malaria_tested_positive_v1 group by organization_id, result, age_category, gender