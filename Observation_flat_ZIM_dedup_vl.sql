CREATE OR REPLACE VIEW observation_flat_ZIM_dedup_vl AS
WITH observation_with_test AS (
  SELECT obs_id, patient_id, encounter_id,
         CASE
            WHEN display = 'Viral Load' or display='HIV viral load'
            or display = 'HIV Viral Load (PLASMA)' or display like '%Viral Load%' THEN 'Viral Load'
         END AS test_type,
      coalesce(string, result_display) as result
  FROM observation_flat_zim_dedup
)
SELECT obs_id, patient_id, encounter_id, test_type, result
FROM observation_with_test
WHERE test_type IS NOT NULL and test_type = 'Viral Load';

select 
