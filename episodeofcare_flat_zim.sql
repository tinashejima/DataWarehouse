Create or replace view episodeofcare_flat_zim as
select e.id as episodeofcare_id, e.status, etc.system as type_code_system , etc.code as type_code, etc.display as type_code_display, patient.patientId as patient_id,
       e.period.start as start_date

    from episodeofcare as e
LATERAL VIEW OUTER  EXPLODE(e.type) as et
LATERAL VIEW  OUTER EXPLODE(et.coding) as etc