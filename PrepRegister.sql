SELECT rpr.person_id, rpd.firstname, rpd.lastname, rpd.address, rpd.phone_number as client_phone_number,- rpd.sex,
       date_part('year', age(rpr.date,rpd.birthdate)) AS age,rpr.prep_type, rpr.prep_number, rpr.client_eligible_for_prep,
       rht.client_profile, rpr.client_agree_prep_initiation,rpr.client_first_time_on_prep, rpfr.visit_date as initial_visit_date,
       rht.date as date_tested_for_hiv, rht.result, rht.test_purpose as purpose_of_hiv_testing, rht.refered_service as hts_entry_point,
        rir.result
FROM report.prep_register  rpr
LEFT JOIN report.person_demographic  rpd
ON rpr.person_id = rpd.person_id
LEFT JOIN report.prep_followup_visit_register  rpfr
ON rpr.prep_id = rpfr.prep_id
LEFT JOIN report.hts_register  rht
ON rpr.person_id = rht.person_id
LEFT JOIN report.investigation_register  rir
ON rpr.person_id = rir.person_id
    WHERE rir.investigation_type = 'PREGNANCY';

-- ======================================================================================================================================================================


select rpfv.prep_followup_visit_id as encounter_id,(rpic.patient_id), rpic.client_agree_prep_initiation as does_client_agree_to_initiate_prep, rpic.client_eligible_for_prep as is_client_eligible_for_prep
       , rpic.client_first_time_on_prep as is_it_client_first_initiation_on_prep_this_year,rpic.prep_type, rpic.consent_date as prep_start_date,
         rpic.tenant_id as facility_id, rhr.date as date_tested_for_hiv,rhr.result as hiv_test_result, rhr.client_profile, rhr.test_purpose as purpose_of_hiv_testing,
                   rhr.refered_service as hts_entry_point,
           rhr.refered_service ,rpfv.visit_date as intial_visit_date, rpd.firstname as client_firstname, rpd.lastname as client_username, rpd.sex,
         rpd.phone_number, rpd.address, date_part('year', age(rpic.consent_date,rpd.birthdate)) AS age, rpir.number as client_id_number,  rss.name as sti_screening,
         rco.name as creatinine_clearance, rprc.name as risk_assessment , rpd.person_id, rir.result as pregnacy_results, rpr.prep_number,
         rpr.withdrawal_date as date_of_client_opt_out_or_clinician_withdrawal, rpr.withdrawal_reason as reason_for_opt_out_or_withdrawal

from report.prep_initiation_consent_register rpic
left join report.prep_risk_assessment_register rpra
    on rpic.patient_id = rpra.patient_id

left join report.hts_register  rhr
on rpra.patient_id = rhr.patient_id

join report.person_demographic  rpd
on rhr.person_id = rpd.person_id

left join report.prep_followup_visit_register  rpfv
on rhr.patient_id = rpfv.patient_id

left join report.sti_outcome_screening   rss
on rpra.sti_outcome_id = rss.outcome_id

left join report.creatinine_outcomes  rco
on rpra.creatinine_outcome_id = rco.id

left join report.investigation_register rir
on rpd.person_id = rir.person_id

left join report.prep_register rpr
on rpd.person_id = rpr.person_id

left join report.person_identification_report rpir
on rpd.person_id = rpir.person_id

left join report.prep_risk_assessment_conclusion rprc
on rpra.risk_assessment_outcome_id = rprc.id

where rir.investigation_type = 'PREGNANCY'
;
-- ===========================================================================================================================================================================



create view report.prep_dpl as


with base as (select distinct rpr.prep_id , rpr.prep_number,
                        rpr.withdrawal_date as date_of_client_opt_out_or_clinician_withdrawal,
                        rpr.withdrawal_reason as reason_for_opt_out_or_withdrawal,
                        rpr.person_id, rpr.date as initial_visit_date,
                        rp.date,
                        rpr.date as event_date,
                        rpr.updated_at,

              rp.patient_id,rpr.tenant_id as facility_id,
              row_number() OVER (PARTITION BY rp.person_id ORDER BY rp.date DESC) AS rn1


              from report.prep_register rpr
              left join report.patient_register rp
              on rpr.person_id = rp.person_id

              ),

    initiation as (select rpic.id as prep_initiation_consent_id,
                       rpic.patient_id,
                       rpic.client_agree_prep_initiation as does_client_agree_to_initiate_prep,
                       rpic.client_eligible_for_prep as is_client_eligible_for_prep,
                       rpic.client_first_time_on_prep as is_it_client_first_initiation_on_prep_this_year,
                       rpic.prep_type,
                       rpic.consent_date as prep_start_date,
                       rpic.updated_at
              from report.prep_initiation_consent_register rpic),
     hts as (select rhr.date as date_tested_for_hiv,
                   rhr.result as hiv_test_result,
                   rhr.client_profile,
                   rhr.test_purpose as purpose_of_hiv_testing,
                   rhr.refered_service as hts_entry_point,
                   rhr.patient_id,
                   rhr.person_id,
                   row_number() OVER (PARTITION BY rhr.person_id ORDER BY rhr.date ASC) AS rn  --returning the date client was first tested

             from report.hts_register  rhr),
    demographics as (select
                            rpd.sex,
                            rpd.person_id,
                            rpd.birthdate
             from report.person_demographic  rpd),

    follow_up_visit as (select rpfv.prep_followup_visit_id,
                               rpfv.patient_id, rpfv.date as follow_up_visit_date,
                               rpfv.hiv_test_result as follow_up_hiv_test_result,
                               rpfv.visit_status as follow_up_visit_status,
                               rpfv.risk_assessment as follow_up_risk_assessment,
                               rpfv.follow_up_status as follow_up_prep_follow_up_status,
                               rpfv.prep_id,
                               row_number() OVER (PARTITION BY rpfv.prep_id ORDER BY rpfv.date DESC) AS rn2

             from report.prep_followup_visit_register  rpfv),

     investigation as (select distinct(rir.person_id) as person_id ,rir.result as pregnacy_results,

                             rir.investigation_type

             from report.investigation_register rir),


    prep_risk as (select  rpra.id, rpra.creatinine_outcome_id,
                         rpra.sti_outcome_id,
                         rpra.risk_assessment_outcome_id,
                         rpra.patient_id,
                        rss.name as sti_screening,
                        rco.name as creatinine_clearance,
                        rprc.name as risk_assessment,
                        rpra.person_id

             from report.prep_risk_assessment_register rpra
             join report.sti_outcome_screening   rss
             on rpra.sti_outcome_id = rss.outcome_id

            join report.creatinine_outcomes  rco
 on rpra.creatinine_outcome_id = rco.id

             join report.prep_risk_assessment_conclusion rprc
             on rpra.risk_assessment_outcome_id = rprc.id),

    next_review as (select ar.time as follow_up_next_visit_date,
                           ar.person_id
            from report.appointment_register ar),

    adverse_events as (select dar.type_name as follow_up_adverse_events,
                              dar.severity as follow_up_adverse_severity,
                              dar.person_id
            from report.drug_adverse_event_register dar)



select distinct base.prep_id as encounter_id,
                base.patient_id,base.person_id,base.facility_id, base.prep_number, base.event_date,
       base.initial_visit_date, initiation.prep_initiation_consent_id as prep_initiation_consent_id,
       CASE
           WHEN initiation.is_client_eligible_for_prep IS NULL THEN NULL
           WHEN initiation.is_client_eligible_for_prep = 'true' THEN 'Yes' ELSE 'No'
           end as is_client_eligible_for_prep,
       CASE
           WHEN initiation.is_it_client_first_initiation_on_prep_this_year IS NULL THEN NULL
           WHEN initiation.is_it_client_first_initiation_on_prep_this_year = 'true' THEN 'Yes'ELSE 'No'
           end as is_it_client_first_initiation_on_prep_this_year,
       CASE
           WHEN initiation.does_client_agree_to_initiate_prep IS NULL THEN NULL
           WHEN initiation.does_client_agree_to_initiate_prep = 'true' THEN 'Yes' ELSE 'No'
           end as does_client_agree_to_initiate_prep,
       initiation.prep_type,
       initiation.prep_start_date,
        hts.purpose_of_hiv_testing,
       hts.hts_entry_point,
       hts.client_profile,
       hts.date_tested_for_hiv,
       hts.hiv_test_result,
        demographics.sex,
       date_part('year', age(base.initial_visit_date,demographics.birthdate)) AS age_at_visit,
           case when investigation.investigation_type = 'PREGNANCY' then investigation.pregnacy_results else null end as pregnacy_results,
           prep_risk.risk_assessment,
       prep_risk.creatinine_clearance,
       prep_risk. sti_screening,
       follow_up_next_visit_date,
       follow_up_visit_date,
       follow_up_hiv_test_result,
       follow_up_visit_status,
       follow_up_risk_assessment,
       follow_up_prep_follow_up_status,
       adverse_events.follow_up_adverse_events,
       adverse_events.follow_up_adverse_severity,
       base.date_of_client_opt_out_or_clinician_withdrawal,
       base.reason_for_opt_out_or_withdrawal,
       base.updated_at



from base

left join initiation on base.patient_id = initiation.patient_id
left join hts on base.person_id = hts.person_id and hts.rn=1
left join  demographics on base.person_id = demographics.person_id
left join follow_up_visit on base.prep_id = follow_up_visit.prep_id --and rn2 = 1
left join investigation on demographics.person_id = investigation.person_id
left join  prep_risk on base.person_id = prep_risk.person_id
left join next_review on base.person_id = next_review.person_id
left join adverse_events on base.person_id = adverse_events.person_id



where rn1 = 1



group by
     base.prep_id,
                base.patient_id,base.person_id,base.facility_id, base.prep_number, event_date,
       base.initial_visit_date, prep_initiation_consent_id,
       initiation.is_client_eligible_for_prep, is_it_client_first_initiation_on_prep_this_year,
       does_client_agree_to_initiate_prep,
       initiation.prep_type,
       prep_start_date,
        hts.purpose_of_hiv_testing,
       hts.hts_entry_point,
       hts.client_profile,
       hts.date_tested_for_hiv,
       hts.hiv_test_result,
       demographics.sex,
       demographics.birthdate,
          pregnacy_results,
           prep_risk.risk_assessment,
       prep_risk.creatinine_clearance,
       prep_risk. sti_screening,
        follow_up_next_visit_date,
       follow_up_visit_date,
       follow_up_hiv_test_result,
       follow_up_visit_status,
       follow_up_risk_assessment,
       follow_up_prep_follow_up_status,
       follow_up_adverse_events,
       follow_up_adverse_severity,
       base.date_of_client_opt_out_or_clinician_withdrawal,
       base.reason_for_opt_out_or_withdrawal,
        base.updated_at,
       investigation_type;

;


-- ==================================================================================================================================
select facility_id, initial_visit_date,prep_number, count(initial_visit_date)
from report.prep_dpl

where  facility_id= 'ZW000B03' and   initial_visit_date >=  '2025-01-01'

group by facility_id, initial_visit_date, initial_visit_date, prep_number
order by initial_visit_date

--=================================================================================================================================================================

select  count(distinct person_id)
from report.prep_dpl

where  facility_id= 'ZW040189' and   initial_visit_date between  '2025-01-01' and '2025-05-19'

--====================================================================================================================================================================



--=========================================================================================================
select  * from report.appointment_register
where person_id = '6901b431-308b-4991-9863-414c9c9259ca'


select  * from client.person
where person_id = '660a7d03-124b-45fe-a31a-e17be067b978'

  select * from report.prep_followup_visit_register limit 500


  select * from report.prep_register limit 5




-- ========================================================================================================================================
select rp.date, ar.visit_date
    from report.patient_register rp
         left join report.appointment_register ar
         on rp.person_id = ar.person_id limit  20



select rp.date, pvr.date
    from report.patient_register rp
         left join report.prep_followup_visit_register pvr
         on rp.patient_id = pvr.patient_id limit  20



select * from report.prep_dpl
where initial_visit_date between '2024-08-01' and '2024-12-30'



select tenant_id, initial_visit_date, count(initial_visit_date)
    from report.prep_dpl

where  tenant_id= 'ZW090A12'and   initial_visit_date >=  '2025-01-01'

group by tenant_id, initial_visit_date
order by initial_visit_date














--=====================================================================================================================================================================================
SELECT rpr.consent_date, rpi.date, rpi.consent_date
    from report.prep_initiation_consent_register  rpr
LEFT JOIN report.prep_register  rpi
ON rpr.patient_id = rpi.patient_id

--========================================================================================



--==================================================================================================











select * from report.prep_initiation_consent_register
where id > '1';

--==============================================================================================================================================================
select * from report.investigation_register
         where person_id = 'db8d3ea9-5149-46bf-8504-8e95193bb3b2'


select * from report.prep_dpl limit 200


