create or replace view fact_opd_chronic_conditions_3 as
select focc1.patient_id, focc1.description, focc1.code, focc1.recorded_date,focc1.verification_status, pf2.gender, floor(datediff(focc1.recorded_date, pf2.birthDate)/365) as age_at_diagnosis,
       CASE
            WHEN age <= 24 and gender ="male" THEN '0-24 Yrs Male'
           WHEN age <= 24 and gender ="female" THEN '0-24 Yrs Female'
           WHEN age > 24 and gender ="male" THEN '25+ Yrs Male'
           WHEN age> 24 and gender ="female" THEN '25+ Yrs Female'
         END AS age_cat , pf2.organization_id, focc1.month_year_concaternated, focc1.month, focc1.year
    from fact_opd_chronic_conditions_v1 focc1 left join
        patient_flat_2 pf2 on focc1.patient_id=pf2.pat_id;