CREATE OR REPLACE VIEW  vaccinations_flat as
select imf.patient_id, imf.vaccine_code, imf.dateTime, month(imf.dateTime) as recorded_date_month,
year(imf.dateTime) as recorded_date_year,
 pf.birthDate, pf.gender, floor(datediff(imf.dateTime, pf.birthDate)/365) as age_at_vaccination, pf.organization_id
from patient_flat_2 pf, immunization_flat imf where pf.pat_id=imf.patient_id
and imf.vaccine_code in ('A11CA', 'L03AX03' 'COVID-19 Vaccine Janssen (JNJ-78436735 Ad26.COV2.S)',
'COVID-19 Vaccine AstraZeneca (AZD1222)', 'J07BH01','SINOPHARM','SINOVAC',
'Comirnaty (BNT162b2)', 'Moderna COVID?19 Vaccine (mRNA-1273)',
'J07AM51', 'SARSCoV2VC', 'COVAXIN', 'J07BH01', 'J07CA11', 'J07BF04',
'J07AL02', 'J07BF03', 'J07AP03', 'PH002', 'J07AM01', 'J07BD53');