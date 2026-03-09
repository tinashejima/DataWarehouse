create or replace view fact_hiv_viral_load as
SELECT obs_id, encounter_id,patient_id,CONCAT(YEAR(year_month), '-', LPAD(MONTH(year_month), 2, '0')) as year_month , result
FROM viral_load_2;