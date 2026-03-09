create or replace view viral_load_2 as
SELECT obs_id, encounter_id, patient_id, explode(sequence(start_date, end_date, interval 1 month)) AS year_month, result
FROM viral_load;