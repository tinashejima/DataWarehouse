create or replace view fact_weekly_surveillence_conditions_v1 as
SELECT  fwsc.patient_id, fwsc.system,  fwsc.verification_status,
       fwsc.recorded_date, fwsc.code, fwsc.condition_category, pf2.birthDate, pf2.gender, pf2.organization_id,
       floor(datediff(fwsc.recorded_date, pf2.birthDate)/365)  as age_at_diagnosis,
       case
           when floor(datediff(fwsc.recorded_date, pf2.birthDate)/365) < 5 then "Under 5 Years"
           when floor(datediff(fwsc.recorded_date, pf2.birthDate)/365) >= 5 then "5 Years and Above"
end as age_cat
from fact_weekly_surveillence_conditions fwsc
        join patient_flat_2 pf2 on fwsc.patient_id = pf2.pat_id
where condition_category is not null