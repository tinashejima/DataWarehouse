create or replace view malaria_tested_v3 as
SELECT  organization_id, display ,age_category, gender, count(distinct (patient_id)) as count
FROM malaria_tested_v2 group by organization_id, display, age_category, gender