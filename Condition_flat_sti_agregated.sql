
select count(distinct(patient_id)) as total, organization_id, recorded_date_year,
recorded_date_month, code, gender, age_at_diagnosis
 from condition_flat_sti group by organization_id,
 recorded_date_year,recorded_date_month, code, gender, age_at_diagnosis;