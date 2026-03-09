create or replace view fact_opd_chronic_conditions_v1 as
select focc.description, focc.code, focc.patient_id, focc.recorded_date ,month(focc.recorded_date) as month, year(focc.recorded_date) as year,
       pf2.gender, pf2.organization_id, concat(year(focc.recorded_date), "-", lpad(month(focc.recorded_date), 2, '0')) as month_year_concaternated,
       dd.reporting_year_quarter_cancatenated as reporting_year_quarter_concatenated, dd.reporting_quarter, ofz.name,
       floor(datediff(focc.recorded_date, pf2.birthDate)/365) as age,
       CASE
            WHEN age <=5 and gender ="male" THEN 'under 5 Male'
           WHEN age <=5 and gender ="female" THEN 'under 5 Female'
           WHEN age> 5 and gender ="male" THEN 'Over 5 Male'
           WHEN age> 5 and gender ="female" THEN 'Over 5 Female'
         END AS age_cat
from fact_opd_chronic_conditions focc
left join
 patient_flat_2 pf2 on focc.patient_id=pf2.pat_id
left join dim_date dd on dd.month_year_concaternated = concat(year(focc.recorded_date), "-", lpad(month(focc.recorded_date), 2, '0'))
left join organization_flat_zim ofz where ofz.org_id =  pf2.organization_id;