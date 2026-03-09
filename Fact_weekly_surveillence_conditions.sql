create or replace view fact_weekly_surveillence_conditions as
SELECT cond_id, patient_id, encounter_id, system, code, clinical_status, verification_status,
       recorded_date,
       CASE
            WHEN code IN ('P373', 'B531', 'P374', 'B53', 'B538', 'B508', 'B50', 'B500',
                                  'B509', 'B52', 'B520', 'B528', 'B529', 'B530', 'B51', 'B518',
                                  'B510', 'B519', 'PH035', 'B54') THEN 'MALARIA'
            WHEN code IN ('PH014', 'PH013', 'K591', 'K580', 'K589', 'P783') THEN 'DIARRHOEA'
            WHEN code IN ('A060', 'A030', 'B111', 'M021') THEN 'DYSENTERY'
            WHEN code IN ('J00', 'J01', 'J010', 'J011', 'J012', 'J013', 'J014', 'J018',
                                  'J019', 'J02', 'J028', 'J020', 'J029', 'J03', 'J030', 'J038',
                                  'J039', 'J04', 'J040', 'J041', 'J042', 'J05', 'J050', 'J051',
                                  'J06', 'J060', 'J068', 'J069', 'PH015', 'PH019', 'J09', 'R05',
                                  'J069', 'J06', 'J068', 'J101', 'J111', 'J00', 'J100', 'PH016',
                                  'PH017') THEN 'INFLUENZA'
            WHEN code IN ('A00', 'A000', 'A001', 'A009') THEN 'CHOLERA'
            WHEN code IN ('A01', 'A010') THEN 'TYPHOID'
            WHEN code IN ('B05', 'B050', 'B051', 'B052', 'B053', 'B054', 'B058', 'B059') THEN 'MEASLES'
            WHEN code IN ('G810', 'G820', 'G823') THEN 'ACUTE_FLACCID_PARALYSIS'
            WHEN code IN ('W54') THEN 'DOG_BITES'
            WHEN code IN ('E40', 'E44', 'E440', 'E441', 'E45', 'E64', 'E640', 'E46', 'E43') THEN 'BILATERAL_OEDEMA_KWASHIOKOR'
            WHEN code IN ('E41') THEN 'SEVERE_WASTING_MARASMUS'
            WHEN code IN ('E42') THEN 'MARASMIC_KWASHIOKOR'
            WHEN code IN ('T630', 'X20') THEN 'SNAKE_BITE'
            WHEN code IN ('B26', 'B262', 'B261', 'B263', 'B260', 'B268', 'B269', 'Z274', 'Z250') THEN 'MUMPS'
            WHEN code IN ('A22', 'A220', 'A221', 'A222', 'A227', 'A228', 'A229') THEN 'ANTHRAX'
            WHEN code IN ('Z203', 'A82', 'A829', 'A820', 'A821') THEN 'RABIES'
            WHEN code IN ('P713') THEN 'NEONATAL_TETANUS'
            WHEN code IN ('A398') THEN 'MENINGOCOCCAL_MENINGITIS'
            WHEN code IN ('B342', 'B972', 'U07.1') THEN 'COVID'
            ELSE NULL
       END AS condition_category
from condition_flat_zim
