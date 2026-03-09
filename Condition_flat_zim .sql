CREATE OR REPLACE VIEW  condition_flat_zim AS
SELECT C.id AS cond_id, C.subject.patientId AS patient_id,
  C.encounter.encounterId AS encounter_id,  CCC.code, CCC.system as code_system, CCC.display as code_display,
  CClC.code AS clinical_status, CVC.code AS verification_status_code, CVC.system AS verification_status_system,
  CVC.display AS verification_status_display,
  C.onset.DateTime AS onset_datetime, C.recordedDate as recorded_date, CCatC.code as category_code,
  CCatC.display as category_display, CCatC.system as category_system
FROM Condition AS C LATERAL VIEW OUTER explode(C.code.coding) AS CCC
  LATERAL VIEW OUTER explode(C.category) AS CCat
  LATERAL VIEW OUTER explode(CCat.coding) AS CCatC
  LATERAL VIEW OUTER explode(C.clinicalStatus.coding) AS CClC
  LATERAL VIEW OUTER explode(C.verificationStatus.coding) AS CVC;
