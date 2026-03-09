create or replace view immunization_flat_zim as
select  im.id, im.status,
imvc.code as vaccineCode, imvc.display as Vaccine, imvc.system as vaccine_code_system, im.patient.patientId as patient_id,
im.occurrence.dateTime as occurence_dateTime, im.recorded, im.lotNumber, manufacturer.organizationId as manufacturer_organizationId , manufacturer.id as manufacturer_id ,manufacturer.type as manufacturer_type,
expirationDate ,ims.system as site_system, ims.code as site_code, ims.display as site_display, doseQuantity.value as dose_quanity_value, doseQuantity.comparator as dose_quanity_comparator,
doseQuantity.unit as dose_quantity_unit, doseQuantity.system as dose_quantity_system, doseQuantity.code as dose_quantity_code,
ip.doseNumber.positiveInt AS dose_number, ip.doseNumber.string AS dose_number_string
from immunization AS im
    LATERAL VIEW OUTER explode(im.statusReason.coding) AS imsc
    LATERAL VIEW OUTER explode(im.vaccineCode.coding) AS imvc
    LATERAL VIEW OUTER explode(im.site.coding) AS ims
    LATERAL VIEW OUTER explode(im.protocolApplied) AS ip ;
