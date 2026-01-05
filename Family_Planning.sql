
create view report.family_planning_dpl as

with base as (select
                  fper.patient_family_planning_enrollment_id,
                  fper.person_id,
                  fper.patient_id,
                  pd.sex,
                  pd.marital as marital_status,
                  fper.enrollment_date as event_date,
                  fper.enrollment_date,
                  fper.family_planning_reason as reason_for_fp,
                  fper.gravida,
                  fper.parity,
                  fper.tenant_id as facility_id,
                  pr.blood_pressure as vital_observations_bp,
                  pr.weight as vital_observations_weight,
                  date_part('year', age(fper.enrollment_date, pd.birthdate)) as age,
                  fper.updated_at


              from report.family_planning_enrollment_register fper
              left join report.person_demographic pd
               on fper.person_id = pd.person_id
              left join report.patient_register pr
              on fper.patient_id = pr.patient_id
              ),

     prev_method as (     SELECT fcp.family_planning_enrollment_id,
                               COALESCE(prev.short_term_method, prev.long_term_method, prev.permanent_method) AS previous_method
                              FROM report.family_planning_care_plan_register fcp
                            LEFT JOIN report.family_planning_care_plan_register prev
                            ON prev.family_planning_enrollment_id = fcp.family_planning_enrollment_id
                            AND prev.care_plan_number = fcp.care_plan_number - 1
                             WHERE fcp.care_plan_number > 1


     ),
     fp_care_plan as (select fcp.family_planning_client_status as client_status, fcp.bmi as vital_observations_bmi  ,
                             fcp.family_planning_enrollment_id, fcp.patient_id, fcp.family_planning_removal_reason,


                             CASE
                                 WHEN fcp.method_switch = 'PERMANENT' OR fcp.method_switch = 'LARC' THEN 'Yes'
                                 ELSE NULL
                                 END                           AS client_switch_to_PM_or_LARC,

                             CASE
                                 WHEN fcp.method_switch = 'SHORT' THEN 'Yes'
                                 ELSE NULL
                                 END                           AS client_switch_to_short_term_method,

                             CASE
                                 WHEN fcp.method_switch = 'EMERGENCY' THEN 'Yes'
                                 ELSE NULL
                                 END                           AS emergency_contraception,

                             CASE
                                 WHEN fcp.family_planning_removal_reason = 'PLANNING_PREGNANCY' THEN 'Planning Pregnancy'
                                 ELSE NULL END AS planning_pregnacy,

                              CASE
                                 WHEN fcp.family_planning_removal_reason = 'SIDE_EFFECTS' THEN 'Side Effect'
                                 ELSE NULL END AS side_effects,

                              CASE
                                 WHEN fcp.family_planning_removal_reason = 'ADVERSE_EVENT' THEN 'Adverse Event'
                                 ELSE NULL END AS adverse_event,


                              CASE
                                 WHEN fcp.family_planning_removal_reason = ' METHOD_FAILURE' THEN 'Method Failure'
                                 ELSE NULL END AS method_failure,

                               CASE
                                 WHEN fcp.family_planning_removal_reason = 'PARTNER_REFUSAL' THEN 'Partner Refusal'
                                 ELSE NULL END AS partner_refusal,

                               CASE
                                 WHEN fcp.family_planning_removal_reason = ' PRODUCT_EXPIRED' THEN 'Product Expired'
                                 ELSE NULL END AS product_expired,

                               CASE
                                   WHEN fcp.permanent_method = 'TUBAL_LITIGATION' THEN 'T' ELSE NULL END AS tubal_ligation,

                                CASE
                                   WHEN fcp.permanent_method = 'VASECTOMY' THEN 'V' ELSE NULL END AS vasectomy

                      from report.family_planning_care_plan_register fcp

                      ),


     short_method_qty as (select

                             cp.person_id, cp.patient_id,
                          CASE
                              WHEN fcp.short_term_method = 'COC' AND fcp.family_planning_client_status = 'FIRST_TIME_FP_USER' THEN
                                  COALESCE(cd.quantity / 28.0, 0) END AS coc_new_user_cycles,

                            CASE
                              WHEN fcp.short_term_method = 'COC' AND fcp.family_planning_client_status = 'REPEAT_FP_USER' THEN
                                  COALESCE(cd.quantity / 28.0, 0) END AS coc_repeat_user_cycles,

                           CASE
                              WHEN fcp.short_term_method = 'POP' AND fcp.family_planning_client_status = 'FIRST_TIME_FP_USER' THEN
                                  COALESCE(cd.quantity / 28.0, 0) END AS pop_new_user_cycles,

                            CASE
                              WHEN fcp.short_term_method = 'POP' AND fcp.family_planning_client_status = 'REPEAT_FP_USER' THEN
                                  COALESCE(cd.quantity / 28.0, 0) END AS pop_repeat_user_cycles,

                           CASE
                              WHEN fcp.short_term_method = 'INTRA_MUSCULAR' AND fcp.family_planning_client_status = 'FIRST_TIME_FP_USER' THEN
                               'Yes' ELSE NULL END AS injectable_DMPA_Intra_Muscular_New_User,

                            CASE
                              WHEN fcp.short_term_method = 'INTRA_MUSCULAR' AND fcp.family_planning_client_status = 'REPEAT_FP_USER' THEN
                                  'Yes' ELSE NULL  END AS injectable_DMPA_Intra_Muscular_Repeat_User

                      from report.family_planning_care_plan_register fcp
                      left join consultation.prescription cp
                      on cp.patient_id = fcp.patient_id
                      left join consultation.dispense cd
                      on cd.prescription_id = cp.prescription_id

                      where cp.prescription_id IS NOT NULL and medicine_id IN ('C001', 'C002', 'ADN123', 'G03AC06')
                      and short_term_method IN ('COC', 'POP', 'INTRA_MUSCULAR' )
                               ),

     larc as (select er.patient_id,
                     er.person_id,


                   CASE
                            WHEN fpcr.long_term_method = 'IUCD' AND fpcr.family_planning_client_status = 'FIRST_TIME_FP_USER' AND cpp.procedure_id = '60' THEN
                               'Yes' ELSE NULL END AS iucd_new_user_insertion,

                    CASE         WHEN fpcr.long_term_method = 'IUCD' AND fpcr.family_planning_client_status = 'REPEAT_FP_USER' AND cpp.procedure_id = '60' THEN
                               'Yes' ELSE NULL END AS iucd_repeat_user_insertion,


                    CASE         WHEN fpcr.long_term_method = 'IUCD' AND cpp.procedure_id = '61' THEN
                               'Yes' ELSE NULL END AS iucd_removal,


                    CASE
                            WHEN fpcr.long_term_method = 'JADELLE' AND fpcr.family_planning_client_status = 'FIRST_TIME_FP_USER' AND cpp.procedure_id = '66' THEN
                               'Yes' ELSE NULL END AS jadelle_new_user_insertion,

                    CASE         WHEN fpcr.long_term_method = 'JADELLE' AND fpcr.family_planning_client_status = 'REPEAT_FP_USER' AND cpp.procedure_id = '66' THEN
                               'Yes' ELSE NULL END AS jadelle_repeat_user_insertion ,

                     CASE        WHEN fpcr.long_term_method = 'JADELLE' AND cpp.procedure_id = '67' THEN
                               'Yes' ELSE NULL END AS jadelle_removal,

                     CASE
                            WHEN fpcr.long_term_method = 'IMPLANON' AND fpcr.family_planning_client_status = 'FIRST_TIME_FP_USER' AND cpp.procedure_id = '68' THEN
                               'Yes' ELSE NULL END AS implanon_new_user_insertion,

                    CASE         WHEN fpcr.long_term_method = 'IMPLANON' AND fpcr.family_planning_client_status = 'REPEAT_FP_USER' AND cpp.procedure_id = '68' THEN
                               'Yes' ELSE NULL END AS implanon_repeat_user_insertion ,

                     CASE        WHEN fpcr.long_term_method = 'IMPLANON' AND cpp.procedure_id = '69' THEN
                               'Yes' ELSE NULL END AS implanon_removal



                  from report.family_planning_enrollment_register er
                  left join report.family_planning_care_plan_register fpcr
                  on er.patient_family_planning_enrollment_id = fpcr.family_planning_enrollment_id
                  left join consultation.person_procedure cpp
                  on er.person_id = cpp.person_id
                  where long_term_method IN ('IUCD', 'JADELLE', 'IMPLANON' )
                  ),

     hts_screening as (select fpr.patient_id,

                              CASE
                                  WHEN fpr.patient_id = hts.patient_id THEN 'Yes' ELSE NULL END AS hts

                          from report.family_planning_enrollment_register fpr
                          left join consultation.hts hts
                          on fpr.patient_id = hts.patient_id

                          ),

     investigations as (select pi.person_id,
                            CASE
                                WHEN pi.test = 'Syphilis' or pi.test = 'Syphilis Test' THEN 'Yes' ELSE NULL END AS sti_screening,

                            CASE
                                WHEN pi.test = 'VIAC' THEN 'Yes' ELSE NULL END AS viac,

                            CASE
                                WHEN pi.test = 'Pap Smear' THEN 'Yes' ELSE NULL END AS pap_smear


                            from report.family_planning_enrollment_register fe
                            left join consultation.person_investigation pi
                            on fe.person_id = pi.person_id
                            where pi.test in ('VIAC', 'Pap Smear', 'Syphilis' ,'Syphilis Test', 'HIV')

                            ),

     hiv_cl_status as (select  f.person_id,
                               ROW_NUMBER() OVER (PARTITION BY f.person_id ORDER BY pi.date DESC) AS rn,
                           CASE
                                WHEN pi.test = 'HIV' AND result = 'POSITIVE' OR result = 'Positive' THEN 'Positive'

                                WHEN pi.test = 'HIV' AND result = 'NEGATIVE' OR result = 'Negative' THEN 'Negative'

                                ELSE 'unknown'
                            END AS hiv_client_status

                        from report.family_planning_enrollment_register f
                            left join consultation.person_investigation pi
                            on f.person_id = pi.person_id
                            where pi.test in ('HIV')
   ),

     fp_linkage as ( select er.patient_id,

                            CASE
                                WHEN pl.destination = 'LOCAL' THEN 'Yes' ELSE NULL END AS referral_In,

                           CASE
                                WHEN pl.destination = 'EXTERNAL' THEN 'Yes' ELSE NULL END AS referral_Out



                       from report.family_planning_enrollment_register er
                       left join consultation.patient_linkage pl
                       on er.patient_id = pl.patient_id
                         )


select  base.patient_family_planning_enrollment_id as encounter_id, base.person_id, base.patient_id, sex, marital_status, age,
        CASE
            WHEN age < 15 THEN '14 & below'
            WHEN age >= 15 AND age <= 19 THEN '15 - 19'
            WHEN age >= 20 AND age <= 24 THEN '20 - 24'
            WHEN age >= 25 AND age <= 49 THEN '25 - 49'
            WHEN age >= 50 THEN '50 & above'
        END as age_group,

        event_date,
        enrollment_date, reason_for_fp, gravida, parity, facility_id, vital_observations_bp,
        vital_observations_weight, vital_observations_bmi, hiv_client_status, fp_care_plan.client_status,
        previous_method, client_switch_to_PM_or_LARC, client_switch_to_short_term_method,
        emergency_contraception,coc_new_user_cycles, coc_repeat_user_cycles, pop_new_user_cycles,
        pop_repeat_user_cycles, injectable_DMPA_Intra_Muscular_New_User, injectable_DMPA_Intra_Muscular_Repeat_User,
        iucd_new_user_insertion, iucd_repeat_user_insertion, jadelle_new_user_insertion, jadelle_repeat_user_insertion,
        jadelle_removal, implanon_new_user_insertion, implanon_repeat_user_insertion, implanon_removal,
        planning_pregnacy,side_effects, adverse_event, method_failure, partner_refusal, product_expired,
        tubal_ligation, vasectomy, hts, sti_screening, viac, pap_smear, referral_In, referral_Out, updated_at


from base
left join fp_care_plan on base.patient_family_planning_enrollment_id = fp_care_plan.family_planning_enrollment_id
left join prev_method on base.patient_family_planning_enrollment_id = prev_method.family_planning_enrollment_id
left join short_method_qty on base.patient_id = short_method_qty.patient_id
left join larc on base.person_id = larc.person_id
left join hts_screening on base.patient_id = hts_screening.patient_id
left join investigations on base.person_id = investigations.person_id
left join hiv_cl_status on base.person_id = hiv_cl_status.person_id and rn = 1
left join fp_linkage on base.patient_id = fp_linkage.patient_id

group by base.patient_family_planning_enrollment_id, base.person_id, base.patient_id, sex, marital_status, age,
          event_date,
        enrollment_date, reason_for_fp, gravida, parity, facility_id, vital_observations_bp,
        vital_observations_weight, vital_observations_bmi, hiv_client_status, fp_care_plan.client_status,
        previous_method, client_switch_to_PM_or_LARC, client_switch_to_short_term_method,
        emergency_contraception,coc_new_user_cycles, coc_repeat_user_cycles, pop_new_user_cycles,
        pop_repeat_user_cycles, injectable_DMPA_Intra_Muscular_New_User, injectable_DMPA_Intra_Muscular_Repeat_User,
        iucd_new_user_insertion, iucd_repeat_user_insertion, jadelle_new_user_insertion, jadelle_repeat_user_insertion,
        jadelle_removal, implanon_new_user_insertion, implanon_repeat_user_insertion, implanon_removal,
        planning_pregnacy,side_effects, adverse_event, method_failure, partner_refusal, product_expired,
        tubal_ligation, vasectomy, hts, sti_screening, viac, pap_smear, referral_In, referral_Out,updated_at



-- =====================================================================================================================
---validation

select
                  fper.patient_family_planning_enrollment_id,
                  fper.person_id,
                  fper.patient_id,
                  pd.sex,
                  pd.marital as marital_status,
                  fper.enrollment_date as event_date,
                  fper.enrollment_date,
                  fper.family_planning_reason as reason_for_fp,
                  fper.gravida,
                  fper.parity,
                  fper.tenant_id as facility_id,
                  pr.blood_pressure as vital_observations_bp,
                  pr.weight as vital_observations_weight,
                  date_part('year', age(fper.enrollment_date, pd.birthdate)) as age,
                  fper.updated_at


              from report.family_planning_enrollment_register fper
              left join report.person_demographic pd
               on fper.person_id = pd.person_id
              left join report.patient_register pr
              on fper.patient_id = pr.patient_id
where pd.tenant_id = 'ZW000A01' and enrollment_date >= '2025-04-30' and enrollment_date <= '2025-07-30'



select * from client.person where person_id = 'b7535ea3-7a6f-49dc-ad22-7f77fa0abd9b'

 select * from report.family_planning_dpl limit 500

select * from report.family_planning_dpl_test
where facility_id= 'ZW090A17' and  event_date >= '2025-01-01'

--===========================================

select facility_id, event_date, count (distinct person_id)
from report.family_planning_dpl

where  facility_id= 'ZW000A01' and  event_date >=  '2025-04-01' and event_date <= '2025-04-30'

group by facility_id, event_date, person_id
order by event_date


select * from report.family_planning_enrollment_register limit 500

------------------------------------------------------------------------------------------------------------------------------

select *
from report.family_planning_dpl
where  facility_id= 'ZW000A01' and  event_date >=  '2025-04-01' and event_date <= '2025-07-31'




select * from consultation.person_investigation
where person_id = '22360644-d9c4-40aa-b44e-7f1e5687e564'


select *
from report.family_planning_report
where  tenant_id= 'ZW000A01' and  visit_date between '2025-05-01' and '2025-07-31' -- and visit_date <= '2025-04-01'


--=============================================================================================================================

select  count(distinct person_id)
from report.family_planning_dpl_test

where  facility_id= 'ZW090A17' and  event_date >= '2025-01-01'


--======================================================================================================================




'8a2a064c-7d0b-4663-871f-a5289e0bcf4b',
'37ec0ba5-1283-4856-9ff9-4e04b6d57a94',
'c2dc5426-4ec7-41a5-8b04-9020ade452f0'




select * from report.person_demographic
where person_id = '613f2adb-4c6f-4cff-a4d4-a02143bc4c3a'




select * from report.patient_register
         where patient_id ='7a970e47-795a-489f-9e2a-f45924f149b4'



select * from report.patient_register
where person_id = '000894c3-2c3b-4292-adcb-5a0de1e5188d'





--===========================================================================
    select * from consultation.dispense limit 500


    select p.patient_id, er.patient_id
        from consultation.prescription p
        join report.family_planning_enrollment_register er
        on p.patient_id = er.patient_id

        select * from consultation.prescription
             where patient_id = '344ccd2f-9a8a-4616-b306-f6939910dee5'

    where medicine_id in ('C001', 'C002', 'ADN123', 'G03AC06')



--======================================================================
select * from report.family_planning_enrollment_register limit 5

--========================================================================
select * from report.family_planning_report
where patient_id = 'fd9ffdbb-6419-4186-a77e-efe5c93b8384' --limit 5



--==================================================================================
select er.person_id, pp.person_id

from report.family_planning_enrollment_register er
left join consultation.person_procedure pp
on er.person_id = pp.person_id

--========================================================================

select * from consultation.person_investigation pi

         where person_id = '000633f5-263c-4741-9301-3bf7b6c7d1a0'

where pi.test IN ('VIAC', 'Pap Smear', 'Syphilis' ,'Syphilis Test')


select distinct test from consultation.person_investigation pi

select * from report.investigation_register limit 500






--===============================================================

SELECT
    fcp.*,
    COALESCE(prev.short_term_method, prev.long_term_method, prev.permanent_method) AS previous_method
FROM report.family_planning_care_plan_register fcp
LEFT JOIN report.family_planning_care_plan_register prev
    ON prev.family_planning_enrollment_id = fcp.family_planning_enrollment_id
    AND prev.care_plan_number = fcp.care_plan_number - 1
WHERE fcp.care_plan_number > 1

--==================================================================================================================

select pl.patient_id, er.patient_id

    from report.family_planning_enrollment_register er
left join consultation.patient_linkage pl
on er.patient_id = pl.patient_id

--============================================================================================================

select fpr.patient_id,
       hts.patient_id
         from report.family_planning_enrollment_register fpr
        left join consultation.hts hts
        on fpr.patient_id = hts.patient_id



WITH RankedResults AS (
    SELECT
        f.person_id,
        pi.result,
        pi.test, pi.date, pi.sample,
        ROW_NUMBER() OVER (PARTITION BY f.person_id ORDER BY pi.date DESC) AS rn
    FROM
        report.family_planning_enrollment_register f
    LEFT JOIN
        consultation.person_investigation pi ON f.person_id = pi.person_id
    WHERE
        pi.test = 'HIV'
        AND pi.result IS NOT NULL
)

SELECT
    person_id,date, result, sample,
    CASE
        WHEN result = 'POSITIVE' OR result = 'Positive' THEN 'Positive'
        WHEN result = 'NEGATIVE' OR result = 'Negative' THEN 'Negative'
        ELSE 'unknown'
    END AS hiv_client_status
FROM
    RankedResults
WHERE
    rn = 1;