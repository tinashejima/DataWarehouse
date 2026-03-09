create or replace view opd_general_condition_v2 as
select  ogcv1.patient_id, ogcv1.description, ogcv1.code, ogcv1.verification_status, ogcv1.recorded_date ,
      concat(year(ogcv1.recorded_date), "-", lpad(month(ogcv1.recorded_date), 2, '0')) as month_year_concaternated,
      month(ogcv1.recorded_date) as month, year(ogcv1.recorded_date) as year
from opd_general_condition_v1 ogcv1;
