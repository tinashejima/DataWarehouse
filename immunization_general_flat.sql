create or replace view immunization_general_flat as
select ifz.patient_id, ifz.vaccineCode, ifz.Vaccine as vaccine_name, ifz.vaccine_code_system, cast(ifz.occurence_dateTime as date) as occurence_date, ifz.dose_number_string,
  imf.date_criterion_value,   imf.date_criterion_system, imf.date_criterion_code, pf2.birthDate, pf2.gender, pf2.organization_id, floor(datediff(ifz.occurence_dateTime, pf2.birthDate)/365) as age_at_immunization,  floor(datediff(imf.date_criterion_value, pf2.birthDate)) as days
,  DATE_SUB(ifz.occurence_dateTime, Pmod(DAYOFWEEK(ifz.occurence_dateTime) - 2, 7)) AS occurence_week_start_date,
 DATE_ADD(ifz.occurence_dateTime, Pmod(8 - DAYOFWEEK(ifz.occurence_dateTime), 7)) AS occurence_week_end_date,
 weekofyear(ifz.occurence_dateTime) as occurence_week,
  month(ifz.occurence_dateTime) as occurence_month,
   year(ifz.occurence_dateTime) as occurence_year from immunization_flat_zim ifz,
immunizationrecommendation_flat_zim imf, patient_flat_2 pf2
         where ifz.patient_id = imf.patient and ifz.VaccineCode = imf.vaccine_code
and ((imf.dose_number_string is null and ifz.dose_number_string is null ) or (imf.dose_number_string = ifz.dose_number_string)) and
    imf.patient = pf2.pat_id

