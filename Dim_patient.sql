CREATE OR REPLACE VIEW dim_patient AS
SELECT pat_id,active,family,given,gender,deceased,age,DOB_YEAR,city,organization_id,
       CASE
            WHEN age <18 THEN '<18'
            WHEN age <26 THEN '18-25'
           WHEN age <51 THEN '26-50'
           WHEN age <100 THEN '51-100'
         END AS age_cat
       FROM patient_flat_zim_dedup2;
select * from dim_patient;