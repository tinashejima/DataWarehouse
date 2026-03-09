create or replace view fact_opd_chronic_conditions as
select condition_id, docc.code, cfn.code as  condition_code, docc.description,
       cond_id, patient_id, encounter_id,system, clinical_status,verification_status, onset_datetime, recorded_date from dim_opd_chronic_conditions docc
left join condition_flat_zim cfn on docc.code = cfn.code
where condition_id is not null;
