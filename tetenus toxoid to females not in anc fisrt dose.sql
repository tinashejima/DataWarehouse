SELECT count(distinct (imm1.patient_id)),
       imm1.age_at_immunization,
       imm1.gender,
       imm1.occurence_month,
       imm1.occurence_year,
       imm1.vaccine_name,
       imm1.organization_id
FROM immunization_general_flat imm1
LEFT JOIN immunization_general_flat imm2
ON (imm1.patient_id = imm2.patient_id AND imm2.vaccine_name = 'TETANUS TOXOID' AND imm2.occurence_date BETWEEN imm1.birthDate AND imm1.occurence_date)
LEFT JOIN appointment_general ag
ON (imm1.patient_id = ag.actor_patient_id AND ag.reason_code = 'ANC_VISIT' AND ag.appointment_start_date_month= imm1.occurence_month AND ag.appointment_start_date_year= imm1.occurence_year)
WHERE
imm1.vaccine_name = 'TETANUS TOXOID'
AND imm1.age_at_immunization BETWEEN 15 AND 49
AND imm1.gender = 'female'
AND imm2.patient_id IS NOT NULL
AND ag.id IS NULL
GROUP BY imm1.gender,
         imm1.occurence_month,
         imm1.occurence_year,
         imm1.vaccine_name,
         imm1.organization_id,
         imm1.age_at_immunization
HAVING COUNT(imm1.patient_id)=1;