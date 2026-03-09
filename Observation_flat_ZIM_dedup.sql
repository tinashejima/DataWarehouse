CREATE OR REPLACE VIEW observation_flat_ZIM_dedup AS
SELECT * FROM observation_flat_zim
WHERE (category_code="social-history" AND display IS NOT NULL) OR
      (display IS NOT NULL AND result_display IS NOT NULL AND code_sys ="urn:impilo:id" AND val_sys ="urn:impilo:id") OR
      (display IS NOT NULL AND string IS NOT NULL AND code_sys ="urn:impilo:id");


//HIV DNA PCR (Yes)
//HIV (yes)
//Rapid) (Yes)
//Hiv/Syphilis Duo Test (Yes)
//HIV-1 Rapid Recency (NO)
//Self test (N0)
