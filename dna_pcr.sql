
create view report.site_pcr_dpl as

with base as (select ir.patient_id,
                     pd.person_id,
                     pd.tenant_id as facility_id,
                     pd.birthdate,
                     pd.sex,
                     date_part('year', age(ir.date,pd.birthdate)) AS age_at_visit,
                     date_part('year', age(ir.date, pd.birthdate)) AS age_years,
                     -- Total months from birth to event date
                     date_part('year', age(ir.date, pd.birthdate)) * 12 + date_part('month', age(ir.date, pd.birthdate)) AS age_months,
                     -- Total days from birth to event date
                     (ir.date - pd.birthdate) AS age_days,
                     ir.laboratory_investigation_id,
                     ir.date,
                     ir.date as event_date,
                     ir.result,
                     ir.result_date as date_result_received_from_site,
                     ir.date as date_specimen_collected,
                     ir.updated_at
       from report.investigation_register ir
       left join report.person_demographic pd
       on ir.person_id = pd.person_id

       where ir.investigation_type = 'HIV_DNA_PCR'
       group by pd.person_id,   ir.laboratory_investigation_id, pd.tenant_id, pd.birthdate, pd.sex, ir.date,
                ir.result, ir.result_date, ir.date, ir.date_result_issued, ir.updated_at, ir.patient_id

),
    hts as (select hr.person_id, hr.patient_id, hr.laboratory_investigation_id,
                   hr.care_giver_result_date as date_care_giver_will_collect_result,
                   hr.refered_service as entry_point,
                   CASE WHEN linkages = 'OI/ART' and hr.result = 'POSITIVE' or hr.result = 'Positive' THEN
                       'Yes' ELSE 'No' END as if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No,
                   hr.note as comment,
                   hr.retest


            from report.hts_register hr
            ),
    lab_request as (SELECT lro.investigation_register_laboratory_investigation_id,
                           lro.laboratory_request_number as patient_laboratory_request_number,
                           lovr.investigation_order_id,
    MAX(CASE
        WHEN lovr.label IN ('typeOfSpecimen', 'typeOfBlood') AND label_value = 'b2ce7202-db97-11ee-9f0b-0242ac120006' THEN 'Whole blood'
        WHEN lovr.label IN ('typeOfSpecimen', 'typeOfBlood') AND label_value = '87668519-db97-11ee-9f0b-0242ac120006' THEN 'Dry blood spot'
    END) as sample_type_whole_blood_or_dry_blood_spot,
    MAX(CASE
        WHEN lovr.label = 'testPlatform' AND label_value = '41bf6a5e-fd7d-11e6-9840-000c29c7ff5e' THEN 'mPIMA'
        WHEN lovr.label = 'testPlatform' AND label_value = '41bf6ad0-fd7d-11e6-9840-000c29c7ff5e' THEN 'G-Expert'
        WHEN lovr.label = 'testPlatform' AND label_value = '41bf6afc-fd7d-11e6-9840-000c29c7ff5e' THEN 'Conventional'
    END) as testing_platform
FROM report.laboratory_request_order_register lro
LEFT JOIN report.laboratory_request_order_value_register lovr
    ON lro.investigation_register_laboratory_investigation_id = lovr.investigation_order_id
GROUP BY
    lro.investigation_register_laboratory_investigation_id,
    lro.laboratory_request_number,
    lovr.investigation_order_id, lro.laboratory_request_number, lro.investigation_register_laboratory_investigation_id)


select distinct base.laboratory_investigation_id, base.patient_id, base.person_id , base.facility_id, birthdate, date, event_date, age_at_visit,
         age_years,age_months, age_days, lab_request.patient_laboratory_request_number,
         lab_request.testing_platform,  base.date_specimen_collected,
         coalesce(sample_type_whole_blood_or_dry_blood_spot, 'Blood') as sample_type_whole_blood_or_dry_blood_spot,


-- Less than or equal to 72 hours (≤3 days) - Initial test
CASE
    WHEN age_years = 0 AND age_months = 0 AND age_days >= 0 AND age_days <= 3 THEN
        CASE
            WHEN hts.retest = true THEN 'I'
            ELSE NULL
        END
    ELSE NULL
END AS less_or_equal_to_72_hours_initial,

-- Less than or equal to 72 hours (≤3 days) - Retest
CASE
    WHEN age_years = 0 AND age_months = 0 AND age_days >= 0 AND age_days <= 3 THEN
        CASE
            WHEN hts.retest = false THEN 'R'
            ELSE NULL
        END
    ELSE NULL
END AS less_or_equal_to_72_hours_retest,

-- 73 hours to 2 months - Initial test
CASE
    WHEN age_years = 0 AND age_days > 3 AND age_months <= 2 THEN
        CASE
            WHEN hts.retest = true THEN 'I'
            ELSE NULL
        END
    ELSE NULL
END AS seventy_three_hours_to_two_months_initial,

-- 73 hours to 2 months - Retest
CASE
    WHEN age_years = 0 AND age_days > 3 AND age_months <= 2 THEN
        CASE
            WHEN hts.retest = false THEN 'R'
            ELSE NULL
        END
    ELSE NULL
END AS seventy_three_hours_to_two_months_retest,

-- 3 to 9 months - Initial test
CASE
    WHEN age_years = 0 AND age_months >= 3 AND age_months <= 9 THEN
        CASE
            WHEN hts.retest = true THEN 'I'
            ELSE NULL
        END
    ELSE NULL
END AS three_to_nine_months_initial,

-- 3 to 9 months - Retest
CASE
    WHEN age_years = 0 AND age_months >= 3 AND age_months <= 9 THEN
        CASE
            WHEN hts.retest = false THEN 'R'
            ELSE NULL
        END
    ELSE NULL
END AS three_to_nine_months_retest,

-- 10 to 12 months - Initial test
CASE
    WHEN age_years = 0 AND age_months >= 10 AND age_months <= 12 THEN
        CASE
            WHEN hts.retest = true THEN 'I'
            ELSE NULL
        END
    ELSE NULL
END AS ten_to_twelve_months_initial,

-- 10 to 12 months - Retest
CASE
    WHEN age_years = 0 AND age_months >= 10 AND age_months <= 12 THEN
        CASE
            WHEN hts.retest = false THEN 'R'
            ELSE NULL
        END
    ELSE NULL
END AS ten_to_twelve_months_retest,

-- Greater than 12 months - Initial test
CASE
    WHEN age_years >= 1 THEN
        CASE
            WHEN hts.retest = true THEN 'I'
            ELSE NULL
        END
    ELSE NULL
END AS greater_than_twelve_months_initial,

-- Greater than 12 months - Retest
CASE
    WHEN age_years >= 1 THEN
        CASE
            WHEN hts.retest = false THEN 'R'
            ELSE NULL
        END
    ELSE NULL
END AS greater_than_twelve_months_retest,

      base.date_result_received_from_site, base.result,
              hts.date_care_giver_will_collect_result,
        hts.entry_point,
        if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No,
         hts.comment,
         updated_at


from base
left join hts on base.laboratory_investigation_id = hts.laboratory_investigation_id
left join lab_request on base.laboratory_investigation_id = lab_request.investigation_register_laboratory_investigation_id

group by base.laboratory_investigation_id, base.patient_id, base.person_id, birthdate, date, event_date, patient_laboratory_request_number,testing_platform,sample_type_whole_blood_or_dry_blood_spot,
         date_specimen_collected, facility_id, age_at_visit, age_years,age_months, age_days,
         less_or_equal_to_72_hours_initial, less_or_equal_to_72_hours_retest,
         seventy_three_hours_to_two_months_initial, seventy_three_hours_to_two_months_retest,
         three_to_nine_months_initial, three_to_nine_months_retest,
         ten_to_twelve_months_initial, ten_to_twelve_months_retest,
         greater_than_twelve_months_initial, greater_than_twelve_months_retest,
         date_result_received_from_site, result,date_care_giver_will_collect_result,
         if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No, comment, entry_point, updated_at;



--==========================================================================================================================
--validation

select  count(distinct laboratory_investigation_id)
from report.site_pcr_dpl
where  facility_id= 'ZW000B03' and  event_date >= '2025-01-01' and event_date <= '2025-06-30'



select  *
from report.site_pcr_dpl
where  facility_id= 'ZW000B03' and  event_date >= '2025-01-01' and event_date <= '2025-06-30'


select  *
from report.site_pcr_dpl
where  facility_id= 'ZW080726' and  event_date >= '2025-01-01' and event_date <= '2025-06-30'


--==========================================================================================================================

drop view report.site_pcr_dpl



select  count(person_id)
from report.dna_pcr_test

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and '2025-03-28'

--======================================================================================================================

select  *
from report.dna_pcr_test

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and  '2025-03-28'

--===================================================================================================================


select  *
from report.dna_pcr_dpl

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and  '2025-03-28'

--=========================================================================================

select * from report.investigation_register
where laboratory_investigation_id = '4bf41614-70b6-4121-8ad5-4722fc6b0eea'

    select * from report.hts_register
    where person_id = '85024bb8-f790-4d9a-a287-f73a684c6738'

--================================================================

select * from report.laboratory_request_order_register
where tenant_id = 'ZW000B03'


--=========================================================
 select * from report.laboratory_request_order_register
where tenant_id = 'ZW000B03'


--==========================================================

select * from report.laboratory_request_order_value_register
where tenant_id = 'ZW000B03'

--=====================================================================================================

select * from report.site_pcr_dpl limit 200


--======================================================================================================
select * from report.hts_register
where patient_id = '7ef2dde2-764f-4f62-bb59-4899f3975098'


select * from report.hts_register
where patient_id = '02900aba-724f-4400-9bbd-0fb364c1dc21'


select * from report.hts_register
where patient_id = '156cd750-4708-440c-92cc-030a282ad44e'


select * from report.hts_register
where person_id = 'b2378f05-6f3d-4cf6-af48-21745020b760'






--=========================================================================

select * from report.site_pcr_dpl

--==========================================================
select * from report.investigation_register
where tenant_id ='ZW000B03' and investigation_type = 'HIV_DNA_PCR'

--============================================================

select * from report.hts_register
where tenant_id ='ZW000B03' and date = '2025-06-09'















