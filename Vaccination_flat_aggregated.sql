-- Vaccination Aggregated
CREATE OR REPLACE VIEW vaccination_flat_aggregated as
select count(distinct(patient_id)) as total, organization_id, recorded_date_year,
recorded_date_month, medicine, gender, age_at_vaccination
 from vaccinations_flat_v1 group by organization_id,
 recorded_date_year,recorded_date_month, medicine, gender, age_at_vaccination;