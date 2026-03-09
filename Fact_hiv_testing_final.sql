CREATE OR REPLACE VIEW fact_hiv_testing_final AS
SELECT obs_id,patient_id, enc_id, type_code, start, concat(year(start), '-', lpad(month(start), 2, '0') ) AS month_year_concatenated, test_type,result,code, reason_code_display from fact_hiv_testing

//ADD VL HERE