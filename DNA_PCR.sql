
create view report.dna_pcr_test as
with base as (select pd.person_id,
                     pd.tenant_id as facility_id,
                     pd.birthdate,
                     pd.sex,
                     date_part('year', age(ir.date,pd.birthdate)) AS age,
                     ir.laboratory_investigation_id,
                     ir.date,
                     ir.date as event_date,
                     ir.result,
                     ir.result_date as date_result_received_from_site,
                     ir.date as date_specimen_collected
       from report.investigation_register ir
       left join report.person_demographic pd
       on ir.person_id = pd.person_id

       where ir.investigation_type = 'HIV_DNA_PCR'
       group by pd.person_id,   ir.laboratory_investigation_id, pd.tenant_id, pd.birthdate, pd.sex, ir.date,
                ir.result, ir.result_date, ir.date, ir.date_result_issued
),
    hts as (select hr.person_id,
                   hr.care_giver_result_date as date_care_giver_will_collect_result,
                   hr.refered_service as entry_point,
                   CASE WHEN linkages = 'OI/ART' and hr.result = 'POSITIVE' or hr.result = 'Positive' THEN
                       'Yes' ELSE 'No' END as if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No,
                   hr.note as comment,
                   hr.retest


            from report.hts_register hr
            ),
    lab_request as (SELECT
    lro.investigation_register_laboratory_investigation_id,
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
FROM report.laboratory_request_order_value_register lovr
LEFT JOIN report.laboratory_request_order_register lro
    ON lro.investigation_register_laboratory_investigation_id = lovr.investigation_order_id
WHERE lovr.label IN ( 'typeOfBlood', 'testPlatform')
GROUP BY
    lro.investigation_register_laboratory_investigation_id,
    lro.laboratory_request_number,
    lovr.investigation_order_id)


select distinct base.person_id , base.facility_id, date, event_date,
         base.age, lab_request.patient_laboratory_request_number,
         lab_request.testing_platform,  base.date_specimen_collected,
         coalesce(sample_type_whole_blood_or_dry_blood_spot, 'Blood') as sample_type_whole_blood_or_dry_blood_spot,

    CASE
        WHEN age = 0 AND age * 12 = 0 AND age * 365 <=3 THEN
            CASE
                WHEN hts.retest = 'false' THEN 'I'

            END
        ELSE NULL
    END AS less_or_equal_to_72_hours_initial,

        CASE
        WHEN age = 0 AND age * 12 = 0 AND age * 365 <=3 THEN
            CASE
                WHEN hts.retest = 'true' THEN 'R'
            END
        ELSE NULL
    END AS less_or_equal_to_72_hours_retest,

    CASE
        WHEN age = 0 AND age * 365 > 3 AND age * 12 <= 24 THEN

            CASE
                WHEN hts.retest = 'false' THEN 'I'
            END
        ELSE NULL
    END AS seventy_three_hours_to_two_months_initial,

     CASE
        WHEN age = 0 AND age * 365 > 3 AND age * 12 <= 2 THEN

            CASE
                WHEN hts.retest = 'true' THEN 'R'
            END
        ELSE NULL
    END AS seventy_three_hours_to_two_months_retest,

    CASE
        WHEN age = 0 AND age * 12 >= 3 AND age * 12 <= 9 THEN

            CASE
                WHEN hts.retest = 'false' THEN 'I'
            END
        ELSE NULL
    END AS three_to_nine_months_initial,

     CASE
        WHEN age = 0 AND age * 12 >= 3 AND age * 12 <= 9 THEN

            CASE
                WHEN hts.retest = 'true' THEN 'R'
            END
        ELSE NULL
    END AS three_to_nine_months_retest,


      CASE
        WHEN age = 0 AND age * 12 >= 10 AND age * 12 <= 12 THEN

            CASE
                WHEN hts.retest = 'false' THEN 'I'
            END
        ELSE NULL
    END AS ten_to_twelve_months_initial,

     CASE
        WHEN age = 0 AND age * 12 >= 10 AND age * 12 <= 12 THEN

            CASE
                WHEN hts.retest = 'true' THEN 'R'
            END
        ELSE NULL
    END AS ten_to_twelve_months_retest,


    CASE
        WHEN age > 1 THEN

            CASE
                WHEN hts.retest = 'false' THEN 'I'
            END
        ELSE NULL
    END AS greater_than_twelve_months_initial,

     CASE
        WHEN age >1 THEN

            CASE
                WHEN hts.retest = 'true' THEN 'R'
            END
        ELSE NULL
    END AS greater_than_twelve_months_retest,  base.date_result_received_from_site, base.result,
              hts.date_care_giver_will_collect_result,
        hts.entry_point,
        if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No,
         hts.comment


from base
left join hts on base.person_id = hts.person_id
left join lab_request on base.laboratory_investigation_id = lab_request.investigation_register_laboratory_investigation_id

group by base.person_id, date, event_date, patient_laboratory_request_number,testing_platform,sample_type_whole_blood_or_dry_blood_spot,
         date_specimen_collected, facility_id, age,
         less_or_equal_to_72_hours_initial, less_or_equal_to_72_hours_retest,
         seventy_three_hours_to_two_months_initial, seventy_three_hours_to_two_months_retest,
         three_to_nine_months_initial, three_to_nine_months_retest,
         ten_to_twelve_months_initial, ten_to_twelve_months_retest,
         greater_than_twelve_months_initial, greater_than_twelve_months_retest,
         date_result_received_from_site, result,date_care_giver_will_collect_result,
         if_hiv_positive_referred_to_OI_or_ART_clinic_Yes_or_No, comment, entry_point;



--==========================================================================================================================

--==========================================================================================================================





select  count(distinct person_id)
from report.dna_pcr_test

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and '2025-03-28'

--======================================================================================================================

select  *
from report.dna_pcr_test limit 5

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and  '2025-03-28'

--===================================================================================================================


select  *
from report.dna_pcr_test

where  facility_id= 'ZW090A17' and   date_specimen_collected between  '2025-01-01' and  '2025-03-28'























