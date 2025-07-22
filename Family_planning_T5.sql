create view report.T5_family_planning_report as

WITH base as (
    select fer.patient_family_planning_enrollment_id, fer.patient_id, fer.person_id,
           client_type, pd.sex, fer.tenant_id as facility_id, fer.enrollment_date as visit_date,
           fer.enrollment_date as event_date,
           date_part('year', age(fer.enrollment_date, pd.birthdate)) as age
    FROM report.family_planning_enrollment_register fer
    left join report.person_demographic pd
    on fer.person_id = pd.person_id
),
     family_plan_care as (
    select cpr.family_planning_enrollment_id, cpr.care_plan_number, cpr.family_visit_reason
    from report.family_planning_care_plan_register cpr
),
     dispense_prescription as (
    select distinct d.patient_id, p.medicine_id, p.drug_route
    from report.dispense_report d
    left join consultation.prescription p
    on d.patient_id = p.patient_id
    where p.medicine_id in ('G03AC06', 'XC89OP',
                          'C002', 'ADN123', 'G03AC',
                          'G03AC03','G03AA07', 'C001', 'G02BA01', 'G02BA02', 'G02BA03')
),
     person_procedure as (
    select distinct person_id, procedure_id
    from consultation.person_procedure
    where procedure_id in ('65', '64')
),
    sundries as (
    select distinct patient_id, sundry_code
    from report.sundry_issued_register
    where sundry_code ILIKE ANY (ARRAY['%05/4405D%', '%10/1440D%', '%10/4111D%', '%10/4112D%', '%05/4405P%', '%10/4111P%',
                                      '%05/4408D%', '%10/1439D%', '%05/4408P%'])
),
    all_conditions as (
    SELECT DISTINCT
        base.patient_id,event_date,visit_date,
         UNNEST(ARRAY[
            -- First Time User
            CASE WHEN base.client_type = 'FIRST_TIME_FP_USER'
                 THEN 'Total First Time Family Planning User for All methods' END,
            -- Injectables
            CASE WHEN (dp.medicine_id = 'G03AC06' OR dp.medicine_id = 'XC89OP')
                  AND dp.drug_route = 'Intramuscular(im)'
                 THEN 'Injectables-DMPA Intramuscular' END,
            CASE WHEN (dp.medicine_id = 'G03AC06' OR dp.medicine_id = 'XC89OP')
                  AND dp.drug_route = 'Subcutaneous'
                 THEN 'Injectables-DMPA Subcutaneous' END,
            -- 3 years implants
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'FAMILY_PLANNING_INITIATION'
                 THEN 'Implants - 3 years - New Insertions' END,
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'RESUPPLY'
                 THEN 'Implants - 3 years - Repeat Insertions' END,
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'REMOVAL'
                 THEN 'Implants - 3 years - Removals' END,
            -- 5 years implants
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'FAMILY_PLANNING_INITIATION'
                 THEN 'Implants - 5 years - New Insertions' END,
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'RESUPPLY'
                 THEN 'Implants - 5 years - Repeat Insertions' END,
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'REMOVAL'
                 THEN 'Implants - 5 years - Removals' END,
            -- Other methods
            CASE WHEN dp.medicine_id IN ('C002', 'ADN123', 'G03AC')
                 THEN 'Progestogen Only Pills' END,
            CASE WHEN dp.medicine_id IN ('G03AC03','G03AA07')
                 THEN 'Emergency Contraceptives' END,
            CASE WHEN dp.medicine_id = 'C001'
                 THEN 'Combined Oral Pills' END,
            CASE WHEN dp.medicine_id IN ('G02BA01', 'G02BA02', 'G02BA03')
                 THEN 'IUCD (Intra-uterine Device) - Copper T (Non hormonal)' END,
            CASE WHEN dp.medicine_id IN ('G02BA01', 'G02BA02', 'G02BA03')
                 THEN 'IUCD (Intra-uterine Device) - LNG-IUS (Hormonal)' END,
            -- Procedures
            CASE WHEN pp.procedure_id = '65'
                 THEN 'Tubal Ligation' END,
            CASE WHEN pp.procedure_id = '64'
                 THEN 'Vasectomy' END,
            -- Condoms
            CASE WHEN ss.sundry_code ILIKE ANY (ARRAY['%05/4405D%', '%10/1440D%', '%10/4111D%', '%10/4112D%', '%05/4405P%', '%10/4111P%'])
                 THEN 'Condoms Male' END,
            CASE WHEN ss.sundry_code ILIKE ANY (ARRAY['%05/4408D%', '%10/1439D%', '%05/4408P%'])
                 THEN 'Condoms Female' END
             ]) AS family_planning_method,
        CASE
            WHEN fpc.care_plan_number = 1 AND base.client_type = 'FIRST_TIME_FP_USER' THEN 'New User'
            WHEN fpc.care_plan_number > 1 OR base.client_type = 'REPEAT_FP_USER' THEN 'Repeat User'
            ELSE NULL
        END AS client_status,age,base.sex,
        CASE
            WHEN age < 10 THEN 'Below 10 Years'
            WHEN age BETWEEN 10 AND 14 THEN '10 - 14 years'
            WHEN age BETWEEN 15 AND 19 THEN '15 - 19 years'
            WHEN age BETWEEN 20 AND 24 THEN '20-24 years'
            WHEN age BETWEEN 25 AND 49 THEN '25-49 years'
            WHEN age >= 50 THEN '50+ years'
            ELSE NULL
        END AS age_group,facility_id
    FROM base
    LEFT JOIN family_plan_care fpc ON base.patient_family_planning_enrollment_id = fpc.family_planning_enrollment_id
    LEFT JOIN dispense_prescription dp ON base.patient_id = dp.patient_id
    LEFT JOIN person_procedure pp ON base.person_id = pp.person_id
    LEFT JOIN sundries ss ON base.patient_id = ss.patient_id
)

SELECT
    patient_id,family_planning_method,client_status,age_group, facility_id,event_date,visit_date,
    COUNT(*) AS count
FROM all_conditions
WHERE family_planning_method IS NOT NULL
GROUP BY
    patient_id,family_planning_method,client_status,age_group, facility_id,event_date,visit_date

--===================================================================================================================

select * from consultation.prescription
where medicine_id in ('G02BA01', 'G02BA02', 'G02BA03')
--===============================================================================================================


--==========================================================================================






WITH base as (
    select fer.patient_family_planning_enrollment_id, fer.patient_id, fer.person_id,
           client_type, pd.sex, fer.tenant_id as facility_id, fer.enrollment_date as visit_date,
           fer.enrollment_date as event_date,
           date_part('year', age(fer.enrollment_date, pd.birthdate)) as age
    FROM report.family_planning_enrollment_register fer
    left join report.person_demographic pd
    on fer.person_id = pd.person_id
),
     family_plan_care as (
    select cpr.family_planning_enrollment_id, cpr.care_plan_number, cpr.family_visit_reason
    from report.family_planning_care_plan_register cpr
),
     dispense_prescription as (
    select distinct d.patient_id, p.medicine_id, p.drug_route  -- Added DISTINCT here
    from report.dispense_report d
    left join consultation.prescription p
    on d.patient_id = p.patient_id
    where p.medicine_id in ('G03AC06', 'XC89OP',
                          'C002', 'ADN123', 'G03AC',
                          'G03AC03','G03AA07', 'C001', 'G02BA01', 'G02BA02', 'G02BA03')
),
     person_procedure as (
    select distinct person_id, procedure_id  -- Added DISTINCT here
    from consultation.person_procedure
    where procedure_id in ('65', '64')
),
    sundries as (
    select distinct patient_id, sundry_code  -- Added DISTINCT here
    from report.sundry_issued_register
    where sundry_code ILIKE ANY (ARRAY['%05/4405D%', '%10/1440D%', '%10/4111D%', '%10/4112D%', '%05/4405P%', '%10/4111P%',
                                      '%05/4408D%', '%10/1439D%', '%05/4408P%'])
),
    all_conditions as (
    SELECT DISTINCT
        base.patient_id,
        event_date,
        visit_date,
         UNNEST(ARRAY[
            -- First Time User
            CASE WHEN base.client_type = 'FIRST_TIME_FP_USER'
                 THEN 'Total First Time Family Planning User for All methods' END,
            -- Injectables
            CASE WHEN (dp.medicine_id = 'G03AC06' OR dp.medicine_id = 'XC89OP')
                  AND dp.drug_route = 'Intramuscular(im)'
                 THEN 'Injectables-DMPA Intramuscular' END,
            CASE WHEN (dp.medicine_id = 'G03AC06' OR dp.medicine_id = 'XC89OP')
                  AND dp.drug_route = 'Subcutaneous'
                 THEN 'Injectables-DMPA Subcutaneous' END,
            -- 3 years implants
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'FAMILY_PLANNING_INITIATION'
                 THEN 'Implants - 3 years - New Insertions' END,
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'RESUPPLY'
                 THEN 'Implants - 3 years - Repeat Insertions' END,
            CASE WHEN base.age = 3 AND fpc.family_visit_reason = 'REMOVAL'
                 THEN 'Implants - 3 years - Removals' END,
            -- 5 years implants
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'FAMILY_PLANNING_INITIATION'
                 THEN 'Implants - 5 years - New Insertions' END,
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'RESUPPLY'
                 THEN 'Implants - 5 years - Repeat Insertions' END,
            CASE WHEN base.age = 5 AND fpc.family_visit_reason = 'REMOVAL'
                 THEN 'Implants - 5 years - Removals' END,
            -- Other methods
            CASE WHEN dp.medicine_id IN ('C002', 'ADN123', 'G03AC')
                 THEN 'Progestogen Only Pills' END,
            CASE WHEN dp.medicine_id IN ('G03AC03','G03AA07')
                 THEN 'Emergency Contraceptives' END,
            CASE WHEN dp.medicine_id = 'C001'
                 THEN 'Combined Oral Pills' END,
            CASE WHEN dp.medicine_id IN ('G02BA01', 'G02BA02', 'G02BA03')
                 THEN 'IUCD (Intra-uterine Device) - Copper T (Non hormonal)' END,
            CASE WHEN dp.medicine_id IN ('G02BA01', 'G02BA02', 'G02BA03')
                 THEN 'IUCD (Intra-uterine Device) - LNG-IUS (Hormonal)' END,
            -- Procedures
            CASE WHEN pp.procedure_id = '65'
                 THEN 'Tubal Ligation' END,
            CASE WHEN pp.procedure_id = '64'
                 THEN 'Vasectomy' END,
            -- Condoms
            CASE WHEN ss.sundry_code ILIKE ANY (ARRAY['%05/4405D%', '%10/1440D%', '%10/4111D%', '%10/4112D%', '%05/4405P%', '%10/4111P%'])
                 THEN 'Condoms Male' END,
            CASE WHEN ss.sundry_code ILIKE ANY (ARRAY['%05/4408D%', '%10/1439D%', '%05/4408P%'])
                 THEN 'Condoms Female' END
             ]) AS family_planning_method,
        CASE
            WHEN fpc.care_plan_number = 1 AND base.client_type = 'FIRST_TIME_FP_USER' THEN 'New User'
            WHEN fpc.care_plan_number > 1 OR base.client_type = 'REPEAT_FP_USER' THEN 'Repeat User'
            ELSE NULL
        END AS client_status,
        age,
        base.sex,
        CASE
            WHEN age < 10 THEN 'Below 10 Years'
            WHEN age BETWEEN 10 AND 14 THEN '10 - 14 years'
            WHEN age BETWEEN 15 AND 19 THEN '15 - 19 years'
            WHEN age BETWEEN 20 AND 24 THEN '20-24 years'
            WHEN age BETWEEN 25 AND 49 THEN '25-49 years'
            WHEN age >= 50 THEN '50+ years'
            ELSE NULL
        END AS age_group,
        facility_id
    FROM base
    LEFT JOIN family_plan_care fpc ON base.patient_family_planning_enrollment_id = fpc.family_planning_enrollment_id
    LEFT JOIN dispense_prescription dp ON base.patient_id = dp.patient_id
    LEFT JOIN person_procedure pp ON base.person_id = pp.person_id
    LEFT JOIN sundries ss ON base.patient_id = ss.patient_id
)

SELECT
    patient_id,family_planning_method,client_status,age_group, facility_id,event_date,visit_date,
    COUNT(*) AS count
FROM all_conditions
WHERE family_planning_method IS NOT NULL
GROUP BY
    patient_id,family_planning_method,client_status,age_group, facility_id,event_date,visit_date

ORDER BY
    CASE family_planning_method
        WHEN 'Total First Time Family Planning User for All methods' THEN 1
        WHEN 'Progestogen Only Pills' THEN 2
        WHEN 'Emergency Contraceptives' THEN 3
        WHEN 'Combined Oral Pills' THEN 4
        WHEN 'Injectables-DMPA Intramuscular' THEN 5
        WHEN 'Injectables-DMPA Subcutaneous' THEN 6
        WHEN 'Implants - 3 years - New Insertions' THEN 7
        WHEN 'Implants - 3 years - Repeat Insertions' THEN 8
        WHEN 'Implants - 3 years - Removals' THEN 9
        WHEN 'Implants - 5 years - New Insertions' THEN 10
        WHEN 'Implants - 5 years - Repeat Insertions' THEN 11
        WHEN 'Implants - 5 years - Removals' THEN 12
        WHEN 'IUCD (Intra-uterine Device) - Copper T (Non hormonal)' THEN 13
        WHEN 'IUCD (Intra-uterine Device) - LNG-IUS (Hormonal)' THEN 14
        WHEN 'Tubal Ligation' THEN 15
        WHEN 'Vasectomy' THEN 16
        WHEN 'Condoms Male' THEN 17
        WHEN 'Condoms Female' THEN 18
    END,
    client_status;

--=================================================================================
     select  d.patient_id, p.medicine_id, p.drug_route
    from report.dispense_report d
    left join consultation.prescription p
    on d.patient_id = p.patient_id
    where p.medicine_id in ('C001')

--=====================================================================================================================================================================
select  * from report.family_planning_enrollment_register fp
 select * from report.patient_register pr
left join consultation.person_procedure pp
          on  pr.person_id = pp.person_id
                             where procedure_id in ('65', '64')


select * from report.dispense_register limit 10

select * from report.dispense_report
where medicine_id = 'G03AC06' or medicine_id = 'XC89OP'         limit 10


select * from consultation.prescription
         where drug_route = 'Subcutaneous'


         limit 1000

select * from report.dispense_register
where medicine_id = 'G02BA02'

where medicine_id in ('G02BA01', 'G02BA02', 'G02BA03')

select * from report.dispense_report
where patient_id ='691f50d7-3a36-48d7-9282-efd2092fe25b'

select * from report.sundry_issued_register limit 100

select * from consultation.person_procedure limit 4000




select distinct(test)
from consultation.person_investigation


select * from consultation.art limit 50;



--=================================================================================================================================================



--=============================================================================================================

with b as (SELECT DISTINCT pa.patient_id, pa.person_id
                       FROM report.patient_register pa
                       LEFT JOIN report.opd_general o ON o.patient_id = pa.patient_id
                       LEFT JOIN report.patient_diagnosis_report  d ON o.condition_id = d.diagnosis_id
                       WHERE pa.is_repeat = 'false'),

    c as ( SELECT ogc.code
                        FROM report.opd_general_condtions ogc
                        WHERE ogc.description IS NOT NULL
                        AND ogc.description != 'ARI Cough & Colds'


select * from consultation.prescription limit 2000


    select * from consultation.prescription
             where drug_route = 'Subcutaneous'


select * from report.dispense_report limit 200

select count(distinct patient_id)
from report.t5_family_planning_report

drop view report.T5_family_planning_report