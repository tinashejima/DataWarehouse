create or replace view viral_load as
select obs_id, patient_id, encounter_id, start AS start_date,  date_add(start, 365) AS end_date,result from fact_viral_load_testing_final;
