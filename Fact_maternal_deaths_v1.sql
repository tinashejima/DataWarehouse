create or replace view fact_maternal_deaths_v1 as
select obs_id as observation_id, patient_id, encounter_id, status, code, code_sys,
       string, result_display, obs_date, issued from fact_maternal_deaths