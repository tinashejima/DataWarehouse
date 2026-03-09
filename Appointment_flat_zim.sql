create or replace view Appointment_flat_zim as
select a.appointment_id,
       a.language,
       a.implicitRules,
       a.text.status as text_status,
       a.text.div,
       ai.use as identifier_use,
       aitc.system as identifier_coding_system,
       aitc.code as identifier_coding_code,
       aitc.display as identifier_coding_display,
       aitc.version as identifier_coding_version,
       a.status, acc.system  as cancelationReason_coding_system,
       acc.code  as cancelationReason_code,
       acc.display as cancelationReason_code_display,
       atc.system as appointment_type_coding_system,
       atc.display as appointment_type_code_display,
       arcc.system as reason_code_system,
       arcc.code as reason_code,
       arcc.display as reason_code_display,
       a.priority, a.description, a.start , a.end, a.minutesDuration,
       ap.id as participant_id,
       aptc.system as participant_type_coding_system,
       aptc.code as participant_type_code,
       aptc.display as participant_type_code_display,
       ap.actor.deviceId as actor_device_id,
       ap.actor.healthcareServiceId as actor_health_care_service_id,
       ap.actor.locationId as actor_location_id,
ap.actor.patientId as actor_patient_id,
ap.actor.relatedPersonId as actor_related_person_id,
ap.actor.reference as actor_reference,
ap.actor.type as actor_type


from appointment AS a
    LATERAL VIEW outer explode(a.identifier) as ai
    LATERAL VIEW outer explode (ai.type.coding) as aitc
    LATERAL VIEW outer explode (a.cancelationReason.coding) as acc
    LATERAL VIEW outer explode (a.appointmentType.coding) as atc
    LATERAL VIEW outer explode (a.reasonCode) as arc
    LATERAL VIEW outer explode (arc.coding) as arcc
    LATERAL VIEW outer explode (a.participant) as ap
    LATERAL VIEW outer explode (ap.type) as apt
    LATERAL VIEW outer explode (apt.coding) as aptc
    ----------------------------------------------------------------------------------------
  CREATE OR REPLACE VIEW appointment_general
       select afz.id as appointment_id, afz.status, afz.reason_code,
            cast(afz.start as date) as appointment_date,
            cast(afz.end as date) as end_date, afz.participant_id, afz.actor_patient_id as patient_id,
            pf2.birthDate, pf2.age, pf2.gender, pf2.organization_id, dd.reporting_week_of_year, dd.reporting_month,
            dd.reporting_year, dd.reporting_month_year_concatenated, dd.reporting_quarter
    from Appointment_flat_zim afz
    join patient_flat_2 pf2
    on afz.actor_patient_id = pf2.pat_id
    join dim_date dd
    on afz.appointment_date = dd.date







