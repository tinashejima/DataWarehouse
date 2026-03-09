Create or Replace view fact_death_records as
 select obs_id, patient_id, status, code, display, string, result_display,
        cast(obs_date as date) as observation_date, cast(issued as date) as date_issued, component_code, component_display
 from observation_flat_zim
 where code = "DEATH_RECORD"