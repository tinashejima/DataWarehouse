CREATE OR  REPLACE VIEW ServiceRequest_flat_zim AS
select s.id as servicerequest_id, s.status, scc.code as catetgory_code, scc.display as catetgory_code_display,
       scc.system as catetgory_code_system, subject.patientId as patient_id, slc.code as locationCode_code,
       slc.display as locationCode_code_display, slc.system as locationCode_code_system, s.encounter as encounter_id, sn.text as note,
       slr.locationId as location_id, slr.type as location_type
    from servicerequest as s
LATERAL VIEW OUTER EXPLODE(s.category) as sc
LATERAL VIEW OUTER EXPLODE(sc.coding) as scc
LATERAL VIEW OUTER EXPLODE(s.locationCode) as sl
LATERAL VIEW OUTER EXPLODE(sl.coding) as slc
LATERAL VIEW OUTER EXPLODE(s.note) as sn
LATERAL VIEW OUTER EXPLODE(s.locationReference) as slr