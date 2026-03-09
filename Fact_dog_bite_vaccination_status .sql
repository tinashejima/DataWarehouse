Create or Replace view fact_dog_bite_vaccination_status as
 select obs_id, patient_id, status, code, display, string, result_display,
        obs_date, issued, lastUpdated
 from observation_flat_zim
 where display = "DOG_BITE_VACCINATION_STATUS"
