CREATE OR REPLACE VIEW patient_flat_zim_dedup2 AS
SELECT pat_id,active,family,given,gender,deceased,age,DOB_YEAR,city,organization_id,
    MAX(value) FILTER (WHERE identifier_system1 = "http://hapifhir.io/fhir/NamingSystem/mdm-golden-resource-enterprise-id") AS golden_id,
    MAX(value) FILTER (WHERE identifier_system1 = "moha:gov:zw:passport") AS passport,
    MAX(value) FILTER (WHERE identifier_system1 = "urn:impilo:uid") AS impilo_uid,
    MAX(value) FILTER (WHERE identifier_system1 = "urn:impilo:ZW000B03:uid") AS impilo_facility_uid,
    MAX(value) FILTER (WHERE identifier_system1 = "urn:impilo:ZW000B03:art") AS impilo_facility_artid,
    MAX(code) FILTER (WHERE text = "Passport") AS passport_code
    from patient_flat_zim
    group by pat_id,active,family,given,gender,deceased,age,DOB_YEAR,city,organization_id;