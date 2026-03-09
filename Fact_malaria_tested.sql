create or replace view fact_malaria_tested as
select obs_id, patient_id,encounter_id, code, display, string, status, result_display, obs_date, issued, lastUpdated
       from observation_flat_zim where display = 'Malaria RDT' OR  display ='Malaria Bloodslide';