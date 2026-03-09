CREATE OR REPLACE VIEW observation_flat_zim AS
SELECT O.id AS obs_id, O.subject.patientId AS patient_id,
        O.encounter.encounterId as encounter_id,
        O.status, OCC.code, OCC.`system` AS code_system,
        OCC.display as code_display, O.value.string as val_string, OVCC.display as val_code_display,
        OVCC.code as val_code,
        O.value.quantity.value AS val_quantity,  OVCC.`system` AS val_sys,
        O.effective.instant AS effective_date, issued as date_issued, OCatC.code AS category_code,
        OCatC.`system` AS category_system,
        OCatC.display AS category_display,
        O.meta.lastUpdated, OCCC.code as component_code, OCCC.system as component_system, OCCC.display as component_display,
(o.value is not null) as has_value
      FROM Observation AS O LATERAL VIEW OUTER explode(code.coding) AS OCC
        LATERAL VIEW OUTER explode(O.value.codeableConcept.coding) AS OVCC
        LATERAL VIEW OUTER explode(O.category) AS OCat
        LATERAL VIEW OUTER explode(OCat.coding) AS OCatC
        LATERAL VIEW OUTER explode(O.component) as OC
       LATERAL VIEW OUTER explode(OC.code.coding) as OCCC;
       -----------------------------------------------------------
CREATE OR REPLACE VIEW observation_flat_ZIM_dedup AS
SELECT * FROM observation_flat_zim
WHERE (category_code="social-history" AND code_display IS NOT NULL) OR
      (code_display IS NOT NULL AND val_code_display IS NOT NULL AND val_sys ="urn:impilo:id" AND code_system ="urn:impilo:id") OR
      (code_display IS NOT NULL AND val_string IS NOT NULL AND code_sys ="urn:impilo:id");


//HIV DNA PCR (Yes)
//HIV (yes)
//Rapid) (Yes)
//Hiv/Syphilis Duo Test (Yes)
//HIV-1 Rapid Recency (NO)
//Self test (N0)


