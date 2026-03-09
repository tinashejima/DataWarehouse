create or replace view fact_malaria_tested_positive as
select patient_id, encounter_id, code, display , string , status, cast(obs_date as date) as date_tested
       from fact_malaria_tested where string in ('Positive', 'POSITIVE', 'positive');