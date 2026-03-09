CREATE OR REPLACE VIEW fact_dog_bite_vaccination_status_v1 AS
 SELECT
    fdbvs.patient_id, fdbvs.status, fdbvs.code, fdbvs.result_display,
    CAST(fdbvs.obs_date AS DATE) AS recorded_date, pf2.gender,
    floor(DATEDIFF(fdbvs.obs_date , pf2.birthDate) / 365) AS age_at_test,
    pf2.organization_id
 FROM
    fact_dog_bite_vaccination_status fdbvs
    LEFT JOIN patient_flat_2 pf2
        ON fdbvs.patient_id = pf2.pat_id

