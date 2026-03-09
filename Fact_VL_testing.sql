CREATE OR REPLACE VIEW fact_VL_testing AS
SELECT * from observation_flat_zim_dedup_vl vl
LEFT JOIN
    (SELECT enc_id, type_code, CAST(start AS DATE), code, reason_code_display FROM encounter_flat_zim) E ON E.enc_id=vl.encounter_id;

//DROP VIEW IF EXISTS observation_flat_ZIM_dedup;
//DROP VIEW IF EXISTS observation_flat_ZIM_dedup_vl;
//DROP VIEW IF EXISTS observation_flat_zim_dedup_hiv;