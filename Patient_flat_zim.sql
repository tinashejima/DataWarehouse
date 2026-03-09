CREATE OR REPLACE VIEW patient_flat_zim AS
SELECT P.id AS pat_id, P.active, PN.family, PNG AS given, P.gender,
        P.deceased.Boolean AS deceased,
        YEAR(current_date()) - YEAR(P.birthDate) AS age,
        YEAR(P.birthDate) AS DOB_YEAR,
        PA.country, PA.city, PG.practitionerId AS practitioner_id,
        P.managingOrganization.organizationId AS organization_id,
        PI.value, PI.system AS identifier_system1,PIC.system AS identifier_system2,PIC.code,PI.type.text
      FROM Patient AS P LATERAL VIEW OUTER explode(name) AS PN
        LATERAL VIEW OUTER explode(PN.given) AS PNG
        LATERAL VIEW OUTER explode(P.address) AS PA
        LATERAL VIEW OUTER explode(P.generalPractitioner) AS PG
        LATERAL VIEW OUTER explode(P.identifier) AS PI
        LATERAL VIEW OUTER explode(PI.type.coding) AS PIC;