CREATE  OR REPLACE VIEW fact_viral_load_testing as
Select OBV.obs_id, OBV.patient_id, OBV.encounter_id, OBV.test_type, OBV.viral_suppression,
        EFZ.type_code, Cast(EFZ.start as DATE), EFZ.code, EFZ.reason_code
from observation_flat_zim_dedup_VL_clean OBV
LEFT JOIN encounter_flat_zim EFZ ON OBV.encounter_id = EFZ.enc_id;