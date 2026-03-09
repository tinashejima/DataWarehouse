CREATE OR REPLACE VIEW appointment_general_flat as
select afz.*, pf2.birthDate, pf2.organization_id, pf2.gender,
floor(datediff(afz.appointment_start_date, pf2.birthDate)/365) as age_at_appointment,
DATE_SUB(afz.appointment_start_date, Pmod(DAYOFWEEK(afz.appointment_start_date) - 2, 7)) AS appointment_week_start_date,
 DATE_ADD(afz.appointment_start_date, Pmod(8 - DAYOFWEEK(afz.appointment_start_date), 7)) AS appointment_week_end_date,
 weekofyear(afz.appointment_start_date) as appointment_start_date_week,
  month(afz.appointment_start_date) as appointment_start_date_month,
   year(afz.appointment_start_date) as appointment_start_date_year
        from Appointment_flat_zim afz, patient_flat_2 pf2
    where afz.actor_patient_id=pf2.pat_id