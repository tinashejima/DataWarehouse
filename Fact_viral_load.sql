create or replace view fact_viral_load as
SELECT obs_id, patient_id, encounter_id, explode(sequence(start_date, end_date, interval 1 month)) AS year_month, result
FROM viral_load;