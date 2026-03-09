create or replace view medicationdispense_flat_zim as
select id as dispense_id, language, text.status as text_status, text.div as text_div, status, mc.code as status_reason_code, mc.system as status_reason_code_system,
mc.display as status_reason_display, mcc.code as category_code, mcc.system as category_code_system, mcc.display as category_display, md.code as medication_code,
md.display as medication_code_display,   md.system as medication_code_system , subject.patientId as patient_id, quantity.value as quantity, mt.code  as type_code,
mt.display as type_code_display, mt.system as type_code_system, whenHandedOver
    from
    medicationdispense as m
LATERAL VIEW OUTER EXPLODE(m.statusReason.codeableConcept.coding) AS mc
LATERAL VIEW OUTER EXPLODE(m.category.coding) as mcc
LATERAL VIEW OUTER EXPLODE(m.medication.codeableConcept.coding) as md
LATERAL VIEW OUTER EXPLODE(m.type.coding) as mt

