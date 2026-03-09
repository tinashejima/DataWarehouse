CREATE OR REPLACE view fact_covid_19_testing as
select patient_id, code, status, display, string , cast(obs_date as date) as obs_date, category_code
from observation_flat_zim where display = 'COVID'