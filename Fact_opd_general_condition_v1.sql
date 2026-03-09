create or replace view opd_general_condition_v1 as
select dogc.description, dogc.code, cfn.code as  condition_code,
cond_id, patient_id, encounter_id,system, clinical_status, verification_status, onset_datetime,
Cast(recorded_date as DATE) from condition_flat_nyasha cfn  left join  dim_opd_general_condition dogc
on dogc.code = cfn.code where dogc.description is not null;