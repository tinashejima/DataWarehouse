CREATE OR REPLACE  VIEW observation_flat_zim_dedup_VL_clean as
SELECT obs_id, patient_id, encounter_id, test_type,
    case
      when result = 'TND' or result = 'tnd' or result = 'Target not detected'
               or result ='undetected' or result = 'Undetected' or result like '<%' then 'Suppressed'
      when result like '%>%' or result like '1000%' then 'Not Suppressed'
      when (CAST(result as BIGINT) < 1000) then 'Suppressed'
      when (CAST(result as BIGINT) >= 1000) then 'Not Suppressed'
           else 'Unknown'
    end as viral_suppression
FROM observation_flat_zim_dedup_vl;
