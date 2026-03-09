CREATE OR REPLACE VIEW fact_hiv_testing AS
SELECT * from observation_flat_zim_dedup_hiv_clean h
LEFT JOIN
    (SELECT enc_id, type_code, CAST(start AS DATE), code, reason_code_display FROM encounter_flat_zim) E ON E.enc_id=h.encounter_id;
