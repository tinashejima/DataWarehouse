CREATE OR REPLACE VIEW encounter_flat_zim   AS
SELECT id as encounter_id, language, text.status as text_status, text.div as text_div, status,
       es.id as statusHistory_id, es.status as statusHistory_status, etc.code as type_code,
       etc.display as type_display, etc.system as type_system,
       subject.patientId as patient_id, period.start as period_start, period.end as period_end,
       ercc.code as reasonCode_code, ercc.display as reasonCode_display, ercc.system as reasonCode_system

FROM encounter e
LATERAL VIEW OUTER EXPLODE (e.statusHistory) AS es
LATERAL VIEW OUTER EXPLODE (e.type) AS et
LATERAL VIEW OUTER EXPLODE (et.coding) AS etc
LATERAL VIEW OUTER EXPLODE (e.reasonCode) AS erc
LATERAL VIEW OUTER EXPLODE (erc.coding) AS ercc;select * FROM encounter_flat_zim