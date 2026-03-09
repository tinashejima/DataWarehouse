CREATE OR REPLACE VIEW fact_viral_load_testing_final AS
SELECT obs_id, encounter_id, type_code, start, concat(year(start), '-', lpad(month(start), 2, '0') ) AS month_year_concatenated,
test_type,viral_suppression as result, code, reason_code from fact_viral_load_testing;