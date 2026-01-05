
with base_anc as (select pr.patient_id, anc.anc_id, anc.anc_number, anc.first_booking, anc.date,
                    date_part('year', age(anc.date, pd.birthdate)) as age
                  from report.anc_register anc
                  left join report.patient_register pr
                  on anc.person_id = pr.person_id
                  left join client.person pd
                  on anc.person_id = pd.person_id
                  ),

    hts as (select
                from report.anc_register anc
                left join report.anc_visit_register anv
                on anc.anc_id = anv.anc_id
                left join report.hts_register hts
                on anv.patient_id = hts.patient_id
                ),
---====================================================================================================================================================


-- P1. Pregnant women booking for ANC contact (1st ANC booking)

select anc.person_id,date_part('year', age(anc.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P1. Pregnant women booking for ANC contact (1st ANC booking)' as condition
from report.anc_register anc
left join client.person pd
on anc.person_id = pd.person_id
where anc.first_booking = 'True'

-- P2. Pregnant women booking for first ANC contact with known HIV positive result
select anc.person_id,date_part('year', age(anc.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P2. Pregnant women booking for first ANC contact with known HIV positive result' as condition, art.date_enrolled
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.art_register art on anc.person_id = art.person_id
where anc.first_booking = 'True' and art.date_enrolled < anc.date and art.date_enrolled is not null

-- P3. Pregnant women HIV tested for the First time in ANC and received results
select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
'P3. Pregnant women HIV tested for the First time in ANC and received results ' as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.anc_visit_register av on anc.anc_id = av.anc_id
left join report.hts_register hts on av.patient_id = hts.patient_id
where anc.first_booking = 'True' and hts.results_issued = true and hts.result is not null and hts.pregnancytest = 'FIRST_TEST'
order by hts.date desc


-- P4. Pregnant women newly testing HIV Positive in ANC
select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
'P4. Pregnant women newly testing HIV Positive in ANC' as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.anc_visit_register av on anc.anc_id = av.anc_id
left join report.hts_register hts on av.patient_id = hts.patient_id
where anc.first_booking = 'True' and hts.result is not null and hts.result = 'POSITIVE' and hts.pregnancytest = 'FIRST_TEST'
order by hts.date desc


-- P5. Pregnant women retested for HIV in ANC and received results
select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
'P5. Pregnant women retested for HIV in ANC and received results' as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.anc_visit_register av on anc.anc_id = av.anc_id
left join report.hts_register hts on av.patient_id = hts.patient_id
where hts.results_issued = true and hts.result is not null and hts.pregnancytest = 'RETEST'
order by hts.date desc


-- P6. Pregnant women testing HIV Positive at retest in ANC
select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
'P6. Pregnant women testing HIV Positive at retest in ANC' as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.anc_visit_register av on anc.anc_id = av.anc_id
left join report.hts_register hts on av.patient_id = hts.patient_id
where anc.first_booking = 'True' and hts.results_issued = true and hts.result is not null and hts.result = 'POSITIVE' and hts.pregnancytest = 'RETEST'
order by hts.date desc


-- P7. HIV negative pregnant women eligible for PrEP
select anc.person_id,date_part('year', age(anc.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P7. HIV negative pregnant women eligible for PrEP' as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.prep_register pr on anc.person_id = pr.person_id
left join report.person_investigation_report pir on anc.person_id = pir.person_id
where pr.client_eligible_for_prep = true and pir.result = 'NEGATIVE' or pir.result = 'Negative'


-- P8. HIV Negative Pregnant women initiated on PrEP
-- select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
-- 'P8. HIV Negative Pregnant women initiated on PrEP' as condition
-- from report.anc_register anc
-- left join client.person pd
-- on anc.person_id = pd.person_id
-- left join report.prep_register pr
-- on anc.person_id = pr.person_id and pr.initiation_date is not null
-- left join report.person_investigation_report pir
-- on anc.person_id = pir.person_id
-- left join report.anc_visit_register av
-- on anc.anc_id = av.anc_id
-- where pr.client_eligible_for_prep = true and pir.result = 'NEGATIVE' or pir.result = 'Negative' and pr.initiation_date is not null



-- P9. Pregnant women booking for ANC already on ART
select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, av.date as visit_date, anc.tenant_id,
'P9. Pregnant women booking for ANC already on ART'as condition
from report.anc_register anc
left join client.person pd on anc.person_id = pd.person_id
left join report.anc_visit_register av on anc.anc_id = av.anc_id
left join report.art_register art on anc.person_id = art.person_id
where anc.partner_id is not null and art.date_enrolled < anc.date


-- P10. HIV positive pregnant women initiated on ART in ANC < 36 weeks GA
select anc.person_id,date_part('year', age(anc.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P10. HIV positive pregnant women initiated on ART in ANC < 36 weeks GA' as condition
from report.art_register art
left join client.person pd on art.person_id = pd.person_id
join report.anc_register anc on art.person_id = anc.person_id
where anc.lnmp is not null
AND ((art.date_enrolled - anc.lnmp) / 7) between 0 and 35

-- P11. HIV positive pregnant women initiated on ART ANC >= 36 weeks GA
select anc.person_id,date_part('year', age(anc.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P11. HIV positive pregnant women initiated on ART in ANC >= 36 weeks GA' as condition
from report.art_register art
left join client.person pd on art.person_id = pd.person_id
join report.anc_register anc on art.person_id = anc.person_id
where anc.lnmp is not null
AND ((art.date_enrolled - anc.lnmp) / 7) between 36 and 43

-- P12.HIV positive pregnant women with a VL test done for the first time in ANC
select anc.person_id,date_part('year', age(ir.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P12.HIV positive pregnant women with a VL test done for the first time in ANC' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.investigation_register ir on anv.patient_id = ir.patient_id
left join client.person pd on anc.person_id = pd.person_id
where anc.first_booking = 'True' and ir.investigation_type = 'VIRAL_LOAD'
and ir.result = 'POSITIVE' or ir.result = 'Positive'


-- P13. Pregnant women tested for Syphilis for the first time in ANC
select anc.person_id,date_part('year', age(ir.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P13. Pregnant women tested for Syphilis for the first time in ANC' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.investigation_register ir on anv.patient_id = ir.patient_id
left join client.person pd on anc.person_id = pd.person_id
where anc.first_booking = 'True' and ir.investigation_type = 'SYPHILIS_TEST' or  ir.investigation_type = 'HIV_SYPHILIS_DUO'


-- P14. Pregnant women testing Syphilis Positive in ANC
select anc.person_id,date_part('year', age(anv.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P14. Pregnant women testing Syphilis Positive in ANC' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.investigation_register ir on anv.patient_id = ir.patient_id
left join client.person pd on anc.person_id = pd.person_id
where anc.first_booking = 'True' and ir.investigation_type = 'SYPHILIS_TEST' or  ir.investigation_type = 'HIV_SYPHILIS_DUO'
and ir.result = 'POSITIVE' or ir.result = 'Positive'


-- P15. Pregnant women who received treatment for Syphilis (at least one dose)
select distinct anc.person_id,date_part('year', age(anv.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P15. Pregnant women who received treatment for Syphilis (at least one dose)' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.dispense_register dr on anc.person_id = dr.person_id
left join client.person pd on anc.person_id = pd.person_id
where dr.medicine in ('BENZATHINE BENZYLPENICILLIN', 'BENZATHINE PENICILLINE', 'ERYTHROMYCIN') and dr.medicine is not null
group by anc.person_id, age, visit_date, anc.tenant_id,condition
having COUNT(dr.medicine) >= 1


-- P16. Pregnant Women tested for Hepatitis B in ANC
select anc.person_id,date_part('year', age(anv.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P16. Pregnant Women tested for Hepatitis B in ANC' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.investigation_register ir on anv.patient_id = ir.patient_id
left join client.person pd on anc.person_id = pd.person_id
where ir.investigation_type = 'HEPATITIS_B'

-- P17. Pregnant women testing Positive for Hepatitis B in ANC
select anc.person_id,date_part('year', age(anv.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
'P17. Pregnant women testing Positive for Hepatitis B in ANC' as condition
from report.anc_visit_register anv
left join report.anc_register anc on anv.anc_id = anc.anc_id
left join report.investigation_register ir on anv.patient_id = ir.patient_id
left join client.person pd on anc.person_id = pd.person_id
where ir.investigation_type = 'HEPATITIS_B'  and  ir.result = 'POSITIVE' and ir.result = 'Positive'










select * from report.investigation_register where person_id = 'f42b6d6b-87e5-4ffa-9813-68c49e4ed028'
where medicine = 'BENZATHINE BENZYLPENICILLIN' limit 10



select * from report.anc_register
where lnmp is not null limit 50






select * from report.art_register
where person_id = '0bf9c724-f9c9-4dfd-a6d7-c6735c6f10f0'

select * from report.person_investigation_report limit 6







select * from report.anc_visit_register limit 5










SELECT
    ar.person_id,
    ar.date_enrolled,
    anc.lnmp,
    (ar.date_enrolled - anc.lnmp) / 7 AS gestational_age_weeks
FROM
    report.art_register ar
JOIN
    report.anc_register anc
        ON ar.person_id = anc.person_id
WHERE
  anc.lnmp IS NOT NULL
          AND ((ar.date_enrolled - anc.lnmp) / 7) between 0 and 35

BETWEEN 0 AND (36 * 7)
    )

















-- P7. Pregnant women newly diagnosed HIV Positive tested for Recent Infection in ANC
-- select anc.person_id,date_part('year', age(av.date, pd.birthdate)) as age, anc.date as visit_date, anc.tenant_id,
-- case when anc.first_booking = 'True' then 'P7. Pregnant women newly diagnosed HIV Positive tested for Recent Infection in ANC' else null end as condition
-- from report.anc_register anc
-- left join client.person pd
-- on anc.person_id = pd.person_id
-- left join report.anc_visit_register av
-- on anc.anc_id = av.anc_id
-- left join report.investigation_register iv
-- on anc.person_id = iv.person_id
-- where anc.first_booking = 'True' and iv.investigation_type = 'RECENCY_TEST' and iv.hts_status = 'POSITIVE'
-- order by iv.date desc





select * from report.art_register where date_enrolled = null limit 300

select * from report.hts_register
         where lactating is not null limit 300

select * from report.investigation_register  where investigation_type = 'RECENCY_TEST' limit 30


select * from report.investigation_register LIMIT 20