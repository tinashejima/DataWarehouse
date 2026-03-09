CREATE OR REPLACE VIEW observation_flat_zim_dedup_hiv_clean AS
SELECT obs_id, patient_id, encounter_id,test_type,
         CASE
            WHEN result= 'POSITIVE' OR result='Positive' OR result='REACTIVE' OR result='HIV POSITIVE AND SYPHILIS NEGATIVE' OR result LIKE '%HIV POSITIVE%' THEN 'Positive'
            WHEN result= 'NEGATIVE' OR result= 'Negative' OR result= 'NON-REACTIVE' OR result= 'HIV NEGATIVE AND SYPHILIS POSITIVE' OR result LIKE '%HIV NEGATIVE%' THEN 'Negative'
             ELSE 'Unknown'
         END AS result
  FROM observation_flat_zim_dedup_hiv;