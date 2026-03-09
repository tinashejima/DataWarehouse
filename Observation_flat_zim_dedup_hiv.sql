CREATE OR REPLACE VIEW observation_flat_zim_dedup_hiv AS
WITH observation_with_test_type AS (
  SELECT obs_id, patient_id, encounter_id,
         CASE
            WHEN display = 'Rapid)' OR display = 'HIV' or display = 'HIV DNA PCR' or display = 'Hiv/Syphilis Duo Test' THEN 'HIV Test'
            WHEN display = 'Viral Load' THEN 'Viral Load'
         END AS test_type,
      coalesce(string,result_display) as result
  FROM observation_flat_zim_dedup
)
SELECT obs_id, patient_id, encounter_id, test_type,result
FROM observation_with_test_type
WHERE test_type IS NOT NULL and test_type = 'HIV Test';
