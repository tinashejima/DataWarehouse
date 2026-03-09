create or replace view immunizationrecommendation_flat_zim as
SELECT
  ir.id as immunization_id,
  ir.text.status as status,
  ir.patient.patientId as patient,
  irvc.code as vaccine_code,
  irvc.display as vaccine,
  irvc.system as vaccine_code_system,
  irtc.code as target_disease_code,
  irtc.display as target_disease,
  irtc.system as target_disease_code_system,
  ircd.code as date_criterion_code,
  ircd.display as date_criterion_display,
  ircd.system as date_criterion_system,
  cast(irdc.value as date) as date_criterion_value,
  irr.series as vaccine_series,
  irr.doseNumber.positiveInt as dose_number,
  irr.doseNumber.string as dose_number_string,
  irr.seriesDoses.positiveInt as seriesdoses_number,
  irr.seriesDoses.string as seriesdoses_string
FROM
  immunizationrecommendation as ir
LATERAL VIEW OUTER explode(ir.recommendation) as irr
LATERAL VIEW OUTER explode(irr.vaccineCode) as irv
LATERAL VIEW OUTER explode(irv.coding) as irvc
LATERAL VIEW OUTER explode(irr.targetDisease.coding) as irtc
LATERAL VIEW OUTER explode(irr.dateCriterion) as irdc
LATERAL VIEW OUTER explode(irdc.code.coding) as ircd

----------------------------------------------------------------------------------
drop view immunizationrecommendation_flat