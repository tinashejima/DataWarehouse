create or replace view fact_malaria_tested_v1 as
select patient_id, encounter_id, code, display , cast(obs_date as date) as date_tested
       from fact_malaria_tested;