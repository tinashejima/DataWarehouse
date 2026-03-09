
CREATE OR REPLACE VIEW observations_general AS
select ofz.obs_id, ofz.patient_id,
        ofz.encounter_id,
        ofz.status, ofz.code, ofz.code_system,
        ofz.code_display, ofz.val_string, ofz.val_code_display,
        ofz.val_quantity,
        ofz.val_code, ofz.val_sys,
        cast(ofz.effective_date as date) as effective_date,  floor(datediff(ofz.effective_date, pf2.birthDate)/365) as age_at_effective_date,
        cast(ofz.date_issued as date) as date_issued, floor(datediff(ofz.date_issued, pf2.birthDate)/365) as age_at_date_issued,
        ofz.category_code,
        ofz.category_system,
        ofz.category_display,
       ofz.lastUpdated, ofz.component_code, ofz.component_system, ofz.component_display, ofz.has_value,
    pf2.pat_id, pf2.active, pf2.family, pf2.given, pf2.gender, pf2.deceased,
  pf2.birthDate,

  pf2.country, pf2.practitioner_id, pf2.organization_id, 
  DATE_SUB(ofz.effective_date, Pmod(DAYOFWEEK(ofz.effective_date) - 2, 7)) AS effective_week_start_date,
 DATE_ADD(ofz.effective_date, Pmod(8 - DAYOFWEEK(ofz.effective_date), 7)) AS effective_week_end_date,
  DATE_SUB(ofz.date_issued, Pmod(DAYOFWEEK(ofz.date_issued) - 2, 7)) AS issued_week_start_date,
 DATE_ADD(ofz.date_issued, Pmod(8 - DAYOFWEEK(ofz.date_issued), 7)) AS issued_week_end_date,
 weekofyear(ofz.effective_date) as effective_week_of_year,
   weekofyear(ofz.date_issued) as issued_week_of_year,
   month(ofz.effective_date) as effective_month_of_year,
   month(ofz.date_issued) as issued_month_of_year,
   year(ofz.effective_date) as effective_year_of_year,
   year(ofz.date_issued) as issued_year_of_year
  
from
 observation_flat_zim ofz join patient_flat_2 pf2 on ofz.patient_id = pat_id;
