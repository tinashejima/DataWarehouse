CREATE OR REPLACE VIEW encounter_general_flat as
select efz.*, pf2.birthDate, pf2.organization_id, pf2.gender,
floor(datediff(efz.period_start, pf2.birthDate)/365) as age_at_encounter, floor(datediff(efz.period_start, pf2.birthDate)/30) as age_in_months,
DATE_SUB(efz.period_start, Pmod(DAYOFWEEK(efz.period_start) - 2, 7)) AS encounter_week_start_date,
 DATE_ADD(efz.period_start, Pmod(8 - DAYOFWEEK(efz.period_start), 7)) AS encounter_week_end_date,
 weekofyear(efz.period_start) as encounter_start_date_week,
  month(efz.period_start) as encounter_start_date_month,
   year(efz.period_start) as encounter_start_date_year
        from encounter_flat_zim efz, patient_flat_2 pf2
    where efz.patient_id=pf2.pat_id