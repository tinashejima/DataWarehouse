CREATE OR REPLACE VIEW condition_flat_sti AS
select cf.patient_id, cf.code, month(cf.recorded_date) as recorded_date_month, year(cf.recorded_date) as recorded_date_year, cf.recorded_date, pf.birthDate, pf.gender,
floor(datediff(cf.recorded_date, pf.birthDate)/365) as age_at_diagnosis, pf.organization_id
from patient_flat_2 pf, condition_flat_zim cf where pf.pat_id=cf.patient_id and cf.code_system='urn:impilo:id'
and cf.code in ('AAO1', 'PH213' 'PH026', 'N739', 'PH004') and pf.organization_id not in ('ZW000A10', 'ZW000A09');
