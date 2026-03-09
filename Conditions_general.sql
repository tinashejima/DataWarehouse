create or replace view conditions_general as
 select  cfz.patient_id, cfz.cond_id, cfz.encounter_id, cfz.code, cfz.code_system, cfz.code_display,
    cfz.clinical_status, cfz.verification_status_code, cfz.verification_status_system,
  cfz.verification_status_display,
  cfz.onset_datetime, Cast(cfz.recorded_date as date) as recorded_date, cfz.category_code,
  cfz.category_display, cfz.category_system , pf2.pat_id, pf2.active, pf2.family, pf2.given, pf2.gender, pf2.deceased,
  pf2.birthDate, floor(datediff(cfz.recorded_date, pf2.birthDate)/365) as age_at_diagnosis, pf2.country, pf2.practitioner_id, pf2.organization_id,
  DATE_SUB(cfz.recorded_date, Pmod(DAYOFWEEK(cfz.recorded_date) - 2, 7)) AS recorded_week_start_date,
 DATE_ADD(cfz.recorded_date, Pmod(8 - DAYOFWEEK(cfz.recorded_date), 7)) AS recorded_week_end_date,
 weekofyear(cfz.recorded_date) as recorded_week_of_year,
  month(cfz.recorded_date) as recorded_month_of_year,
   year(cfz.recorded_date) as recorded_year_of_year
     from condition_flat_zim cfz join patient_flat_2 pf2 on  cfz.patient_id = pf2.pat_id;
