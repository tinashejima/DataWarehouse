CREATE OR REPLACE VIEW  vaccinations_flat_v1 as
select  patient_id, vf.vaccine_code, vf.birthDate, vf.dateTime, vf.recorded_date_month, recorded_date_year,
        vf.gender, vf.age_at_vaccination, vf.organization_id,
        case when option is null then medicine
          else   concat(vs.medicine, " ", vs.option)
            end as medicine
    from vaccinations_flat vf join vaccine_schedule vs
        on vf.vaccine_code = vs.name_id