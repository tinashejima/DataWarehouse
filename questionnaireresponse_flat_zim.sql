create or replace view questionnaireresponse_flat_zim as
select qr.id, qr.text.status as status, qr.text.div as text_div, qr.identifier.type, qr.questionnaire, qr.status, qr.subject.resourceId as patient_id, qr.encounter.encounterId
as encounter_id, qri.linkId as item_link_id, qri.text as item_text, qria.value.string as value_string

from questionnaireResponse qr
LATERAL VIEW OUTER explode(qr.item) as qri
LATERAL VIEW OUTER explode(qri.answer) as qria

;