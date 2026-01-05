

select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
order by task_authored_on asc;
--========================================================================================================================================
---invalid results
select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18' and result like '%Invalid%'
order by task_authored_on asc;
--=========================================================================================================================================
--Failure due to machine technical error: Collect new sample
  select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
  and result like '%Failure due to machine technical error: Collect new sample%'
order by task_authored_on asc;


--=======================================================================================================================

-- with tasks requested
select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'requested'
order by task_authored_on asc;

--==========================================================================================================================
-- with tasks accepted
select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'accepted'
order by task_authored_on asc;


--=========================================================================================================================
-- with tasks in-progress
select * from fact_lab_request_orders
where test_type  like '%Viral Load%' like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'in-progress'
order by task_authored_on asc;

--=========================================================================================================================
-- with tasks rejected
select * from fact_lab_request_orders
where test_type  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'rejected'
order by task_authored_on asc;


--=========================================================================================================================
-- with tasks completed
select * from fact_lab_request_orders
where test_type =  like '%Viral Load%' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'completed'
order by task_authored_on asc;


--==============================================================================================================================
-- Total of all statuses
SELECT
    'total orders submitted' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17'and cast(task_authored_on as date) >= '2025-02-18'



UNION ALL

SELECT 'requested' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'requested'

UNION ALL


SELECT 'received' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'received'

UNION ALL

SELECT 'accepted' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'accepted'

UNION ALL

SELECT 'in-progress' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type =  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'in-progress'

UNION ALL

SELECT 'rejected' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'rejected'


UNION ALL

SELECT 'completed' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'completed';

--==================================================================================================================================
SELECT *
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17'
  and cast(task_authored_on as date) >= '2025-02-18' AND task_status = 'completed';



--==========================================================================================================================



select *
from fact_lab_request_orders
where test_type  like '%Viral Load%' and encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18'

--========================================================================================================================================
--All records from 18 Feb upto Current date

select count(distinct lab_request_number), task_status,  encounter_facility_id
from fact_lab_request_orders
where test_type  like '%Viral Load%' and encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18'
group by task_status,  encounter_facility_id

--====================================================================================================================================

select count(distinct lab_request_number), task_status,  encounter_facility_id
from fact_lab_request_orders
where test_type  like '%Viral Load%' and encounter_facility_id = 'ZW090A17' and lab = 'MPILO' and cast(task_authored_on as date) >= '2025-02-18'
group by task_status,  encounter_facility_id


--==================================================================================================================================
---------------summary------------------------
-- total orders submitted sum of counts from all statuses
-- orders not accepted = samples in requested status
--- orders rejected = sum of order where status =  reject
---- orders accepted  = total orders submmited - orders in requested status
----- orders waiting to receive samples = orders in accepted status
------sample eligible for processing = orders accepted - (rejected orders + orders in accepted status + completed)
--------sample in processing  = samples in in-progress status
--------samples processed  =  sample in completed status
--============================================================================================================================================
--all statuses count
 select count(distinct (lab_request_number)) , task_status,
       encounter_facility_id from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) >=  '2025-02-18' and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id;

--====================================================================================================================================
-- records from 4 june upto current
 select count(distinct (lab_request_number)) , task_status,
    encounter_facility_id from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) between '2025-04-01' and '2025-06-30' and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id;

--================================================================================================================================================

     select *
     from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) between '2025-04-01' and '2025-06-30' and lab = 'MPILO' and test_type like '%Viral Load%'
  and task_status = 'rejected'


group by  encounter_facility_id;

--===================================================================================================================

select count(distinct (lab_request_number)) , task_status,
encounter_facility_id from fact_lab_request_orders
where lab = 'MPILO' and test_type like '%Viral Load%'
and cast(task_last_updated as date) >=  '2025-02-18'
group by  task_status, encounter_facility_id;



encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07' )


--====================================================================================================================================
--All records from 18 Feb upto Current date
select * from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) >=  '2025-02-18'
and lab = 'MPILO' and test_type like '%Viral Load%'

--============================================================================================================================


--calculating turn_around_time
select lab_request_number, task_status, result,  task_authored_on, task_last_updated, datediff(task_last_updated, task_authored_on) as turn_around_time_in_days,
       encounter_facility_id
from fact_lab_request_orders
where test_type like '%Viral Load%' and task_status = 'completed' and encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) >= '2025-02-18'


--==========================================================================================================================================
select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
from fact_lab_request_orders
WHERE
    encounter_facility_id = 'ZW090A17'
  AND cast(last_updated as date) between  '2025-02-18' and '2025-06-12'
  AND test_type = 'Viral Load'
  AND lab = 'MPILO'
  AND task_status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         gender;

--=======================================================================================================================
----RESULTS FOR MULTIPLE FACILITIES

select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
from fact_lab_request_orders
WHERE
    encounter_facility_id = 'ZW090A17'
  AND cast(last_updated as date) between  '2025-02-18' and '2025-06-12'
  AND test_type = 'Viral Load'
  AND lab = 'MPILO'
  AND task_status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         gender;


--================================================================================================================================================================

select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       CASE
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) < 1 THEN '<1'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 1 AND 4 THEN '1-4'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 5 AND 9 THEN '5-9'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 10 AND 14 THEN '10-14'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 15 AND 19 THEN '15-19'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 20 AND 24 THEN '20-24'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 25 AND 29 THEN '25-29'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 30 AND 34 THEN '30-34'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 35 AND 39 THEN '35-39'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 40 AND 44 THEN '40-44'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 45 AND 49 THEN '45-49'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 50 AND 54 THEN '50-54'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 55 AND 59 THEN '55-59'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 60 AND 64 THEN '60-64'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) >= 65 THEN '65+'
           ELSE 'Unknown Age'
           END AS age_category,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
    -- month(last_updated) as month, year(last_updated) as year
from fact_lab_request_orders
WHERE
    encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
  AND cast(last_updated as date) >=  '2025-02-18' AND cast(last_updated as date) <=  '2025-09-30'
  AND test_type = 'Viral Load'
  AND lab = 'MPILO'
  AND task_status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression,  age_category
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         age_category,
         gender;


--========================================================================================================================================
select *
from fact_lab_request_orders
where test_type  like '%Viral Load%' and encounter_facility_id = 'ZW090A17' and cast(task_last_updated as date) >= '2025-06-04'
and cast(task_last_updated as date) <= '2025-06-12'


--===========================================================================================================================================

---Reporting period April to June 2025
select count(distinct (lab_request_number)) , task_status,
encounter_facility_id from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17' and cast(task_authored_on as date) between '2025-04-01' and '2025-06-30'
and cast(task_last_updated as date) between '2025-04-01' and '2025-06-30'
and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id;






-- duplicated records

SELECT t.*
FROM fact_lab_request_orders AS t
JOIN (
  SELECT lab_request_number
  FROM fact_lab_request_orders
  WHERE lab = 'MPILO'
  GROUP BY lab_request_number
  HAVING COUNT(*) > 1
) dup
  ON t.lab_request_number = dup.lab_request_number
WHERE t.lab = 'MPILO';



select * from fact_lab_request_orders limit 5

select * from default.fact_lab_request_orders limit 6


----------------------------------------------------------------------------------------------------------------

select * from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07' ) and cast(task_authored_on as date) >=  '2025-02-18'
and lab = 'MPILO' and test_type like '%Viral Load%'
-----------------------------------------------------------------------------------------------------------------------------------------

select * from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07' ) and cast(task_authored_on as date) >  '2025-07-28'
and lab = 'MPILO' and test_type like '%Viral Load%'




--------------------------------------------------------------------------------------------------------------------------------------------

select distinct(encounter_facility) from fact_lab_request_orders
where  cast(task_authored_on as date) <= '2025-02-18' and lab = 'MPILO' and test_type like '%Viral Load%' and task_status = 'requested'


show tables from default
--------------------------------------------------------------------------------
select * from fact_lab_request_orders limit 11


select * from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17') and cast(task_authored_on as date) =  '2025-09-16'
and lab = 'MPILO' and test_type like '%Viral Load%' and task_status = 'requested'


------------------------------------------------------------------------------------

SELECT 'requested' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and
      cast(task_authored_on as date) >= '2025-06-01' AND task_status = 'requested'

------------------------------------------------------------------------------------


SELECT 'requested' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and
      cast(task_authored_on as date) in ("2025-03-05","2025-03-10", "2025-03-11", "2025-05-19","2025-05-20"
) AND task_status = 'requested'

---------------------------------------------------------------------------------------------


SELECT 'requested' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17' and
      cast(task_authored_on as date) = "2025-03-05" AND task_status = 'requested'


------------------------------------------------------------------------------------------------

SELECT *
FROM fact_lab_request_orders
WHERE test_type  like '%Viral Load%' AND patient_managing_organization_id = 'ZW090A17'  and lab = 'MPILO'and
      cast(task_authored_on as date) = "2025-03-05" AND task_status = 'requested'




-------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Facility_Last_Sync AS

SELECT
    encounter_facility,
    encounter_facility_id,
    MAX(CAST(task_authored_on AS DATE)) AS Last_Date_Since_Last_Sync
FROM
    fact_lab_request_orders
WHERE
    encounter_facility_id IN (
        'ZW03030A', 'ZW020326', 'ZW070566', 'ZW040189', 'ZW080324',
        'ZW030339', 'ZW010539', 'ZW080592', 'ZW050406', 'ZW080726',
        'ZW090A17', 'ZW000A01', 'ZW000B03', 'ZW060627', 'ZW090A12',
        'ZW070445', 'ZW000A23', 'ZW090A27', 'ZW03020A', 'ZW000A01',
        'ZW000A27', 'ZW000A09', 'ZW000A45', 'ZW00021', 'ZW000A15',
         'ZW090A02', 'ZW090A14'
    )
GROUP BY
    encounter_facility,
    encounter_facility_id
ORDER BY
    encounter_facility DESC;


show columns from  lab_orders

show columns from  lab_results

show columns from  fact_lab_request_orders limit 6

select * from fact_lab_request_orders limit 6

select * from Facility_Last_Sync limit 100


select count(distinct (lab_request_number)) , task_status,encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >=  '2025-07-06' and cast(task_authored_on as date) <=  '2025-08-22' --and cast(task_last_updated as date) <=  '2025-08-27'
and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id;


-- statuses as at 7 Aug 2025

select distinct lab_request_number, task_authored_on ,encounter_facility, encounter_facility_id,  task_status , COUNT(*) AS count
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-02-18'
  and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id, encounter_facility, encounter_facility_id, task_authored_on, lab_request_number;


-----------------------------------------------------------------------------------------------------------------------------------------
select *
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-08-01' and  cast(task_authored_on as date) <= '2025-08-31'
and lab = 'MPILO' and test_type like '%Viral Load%'


-------------------------------------------------------------------------------------------------------------------------------

select *
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-07-27'
and lab = 'MPILO' and test_type like '%Viral Load%'

-----------------------------------------------------------------------------------------------------------------------------------
select encounter_facility, encounter_facility_id, task_status ,count(distinct (lab_request_number)) as number_orders
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A12', 'ZW090A02' , 'ZW090A17', 'ZW090A66', 'ZW090A14')
  and cast(last_updated as date) >= '2025-08-21' and lab = 'MPILO' and test_type like '%Viral Load%'
group by  encounter_facility_id, encounter_facility, task_status;

----------------------------------------------------------------------------------------------------------
select *
from fact_lab_request_orders
where encounter_facility_id = ('ZW090A17')
and cast(task_authored_on as date) >=  '2025-08-01' and cast(task_authored_on as date) <=  '2025-08-22' --and cast(task_last_updated as date) <=  '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'
order by task_authored_on asc

---------------------------------------------------------------------------------------------------------------------------------
--where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')


select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_last_updated as date) < '2025-08-01'
and task_status not in ('completed', 'rejected', 'requested', 'cancelled')
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'

------------------------------------------------------------------------------------------------------------------------

select *
from fact_lab_request_orders
where encounter_facility_id = ('ZW090A17')
and cast(task_authored_on as date) between '2025-08-01' and '2025-08-22' --and cast(task_last_updated as date) <=  '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'
and task_status not in ('requested')

------------------------------------------------------------------------------------------------------------------------------------
select distinct lab_request_number, task_authored_on ,encounter_facility, encounter_facility_id,  task_status , COUNT(*) AS count
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) between '2025-08-16' and '2025-08-22' --and cast(task_last_updated as date) <=  '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'
and task_status not in ('requested')
group by lab_request_number, task_authored_on ,encounter_facility, encounter_facility_id,  task_status


-----------------------------LIMS RECONCILIATION ------------------------------------------------------------------------------------------
---     Orders still in requested status due to LIMS system downtime
select *
from fact_lab_request_orders
where encounter_facility_id = ('ZW090A17')
and cast(task_authored_on as date) in ('2025-03-05', '2025-03-10', '2025-03-11', '2025-05-19', '2025-05-20')
and lab = 'MPILO' and test_type like '%Viral Load%'

------------------------------------------------------------------------------------------------------------------------
--------processed before 1 AUG NKETA------------------

select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) between '2025-02-18' and '2025-07-31' and (cast(task_last_updated as date) >= '2025-08-01')
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'

------------------------------------------------------------------------------------------------------------------------
----------processed after 1 AUG NKETA
select *
from fact_lab_request_orders
where encounter_facility_id ='ZW090A17'
and cast(task_authored_on as date) between '2025-08-01' and '2025-08-22' --and cast(task_last_updated as date) <= '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'

------------------------------------------------------------------------------------------------------------------------
-----  Orders requested and processed before  and after 1 AUG upto AUG 22

--   NKETA
select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) between '2025-02-18' and '2025-07-31' and (cast(task_last_updated as date) >= '2025-08-01')
or cast(task_authored_on as date) between '2025-08-01' and '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'
and task_status!= 'requested'


-- 3 facilities
select *
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12')
and cast(task_authored_on as date) between '2025-02-18' and '2025-07-31' and (cast(task_last_updated as date) >= '2025-08-01')
or cast(task_authored_on as date) between '2025-08-01' and '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'
and task_status!= 'requested'


-- Nketa, PMR and Tshabalala
select lab_request_number, task_status, sample_type, cast(task_authored_on as date) as task_authored_on,
       cast(date_sample_taken as date) as date_sample_taken, cast(task_last_updated as date) as task_last_updated, encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12')
and cast(task_authored_on as date) between '2025-08-01' and '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'
and  task_status != 'requested'



-- from feb to aug
select *
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12')
and cast(task_authored_on as date) between '2025-02-18' and '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'


--- authored before 1 aug and last modified between 1 - 22 aug
select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) between '2025-02-18' and '2025-07-31' and cast(task_last_updated as date) between '2025-08-01' and '2025-08-22'
--and task_status not in ('completed', 'rejected', 'requested')
and lab = 'MPILO' and test_type like '%Viral Load%'


-- 28 July to 16 Aug
    select lab_request_number, task_status, sample_type, cast(task_authored_on as date) as task_authored_on,
       cast(date_sample_taken as date) as date_sample_taken, cast(task_last_updated as date) as task_last_updated, encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12')
and cast(task_authored_on as date) between '2025-07-28' and '2025-08-16'
and lab = 'MPILO' and test_type like '%Viral Load%'




---- 1 july
select lab_request_number, task_status, sample_type, cast(task_authored_on as date) as task_authored_on,
       cast(date_sample_taken as date) as date_sample_taken, cast(task_last_updated as date) as task_last_updated, encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17')
and cast(date_sample_taken as date) between '2025-07-01' and '2025-08-22'
and lab = 'MPILO' and test_type like '%Viral Load%'


------------------------------------------------------------------------------------------------------------------------

select *
from fact_lab_request_orders
where encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) between '2025-08-01' and '2025-08-22' --and cast(task_last_updated as date) <= '2025-08-22'
--and task_status not in ('completed', 'rejected', 'requested')
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'

-----------------------------------------------------------------------------------------------------------------------------

select *
from fact_lab_request_orders
where encounter_facility_id = ('ZW090A02')
and cast(task_authored_on as date) in ('2025-03-05', '2025-03-10', '2025-03-11', '2025-05-19', '2025-05-20')
and lab = 'MPILO' and test_type like '%Viral Load%'

----------------------------------------------------------------------------------------------------------------------------------
 select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) < '2025-08-01' and (cast(task_last_updated as date) < '2025-08-01' or cast(task_last_updated as date) > '2025-08-01')
and task_status not in ('completed', 'rejected', 'requested')
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'




    select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) between '2025-08-01' and '2025-07-31' and (cast(task_last_updated as date) < '2025-08-01'
or cast(task_last_updated as date) between '2025-08-01' and '2025-08-22')
--and task_status not in ('completed', 'rejected', 'requested')
and lab = 'MPILO' and test_type like '%Viral Load%' and sample_type = 'Blood'


received
rejected
completed
cancelled
requested
accepted
in-progress

SELECT *
FROM fact_lab_request_orders
WHERE encounter_facility_id in ('ZW090A17', 'ZW090A02', 'ZW090A12')
  AND lab = 'MPILO'
  AND test_type LIKE '%Viral Load%'
  And task_status not in ( 'requested')
  AND (
    (DATE(task_authored_on) BETWEEN DATE('2025-02-18') AND DATE('2025-07-31')
        AND last_updated >= TIMESTAMP('2025-08-01'))
        OR
    DATE(task_authored_on) BETWEEN DATE('2025-08-01') AND DATE('2025-08-22')
    );



select * from fact_lab_request_orders limit 5
where task_status = 'cancelled'


select distinct lab_request_number, task_authored_on ,encounter_facility, encounter_facility_id,  task_status, date_sample_taken
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-02-18'
and lab = 'MPILO' and test_type like '%Viral Load%'


group by  task_status, encounter_facility_id, encounter_facility, encounter_facility_id, task_authored_on, date_sample_taken, lab_request_number;




select count(distinct (task_authored_on)) , task_status, task_authored_on ,encounter_facility
encounter_facility_id from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-09-11'
and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, task_authored_on ,encounter_facility;





select count(distinct (task_authored_on)) , task_status, task_authored_on ,encounter_facility
encounter_facility_id from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-09-10' and cast(task_authored_on as date) <= '2025-09-12'
and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, task_authored_on ,encounter_facility;


select count(distinct lab_request_number) as count, encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-02-18'
group by encounter_facility_id


 SELECT encounter_facility_id, COUNT(DISTINCT lab_request_number) AS total_orders,
               MAX(task_authored_on) AS last_request
        FROM fact_lab_request_orders
        WHERE encounter_facility_id IN ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
            AND lab = 'MPILO'
            AND test_type LIKE '%Viral Load%'
        GROUP BY encounter_facility_id



 select * from fact_lab_request_orders
 WHERE encounter_facility_id = 'ZW090A17' AND lab = 'MPILO'
            AND test_type LIKE '%Viral Load%'
 and cast(task_authored_on as date) >= '2025-02-18' and task_authored_on <= '2025-09-30'

 ----=================================================================================================================
 -- Turnaround time
     SELECT lab_request_number, date_sample_taken, task_execution_start_date as impilo_registration_date,
          task_authored_on AS shr_date, diagnostic_report_date_issued, test_type, task_status, encounter_facility_id,
          datediff(cast(task_authored_on as date), cast(task_execution_start_date as date))  as turn_around_time_in_days,
       ROUND(
               (UNIX_TIMESTAMP(task_authored_on, "yyyy-MM-dd'T'HH:mm:ssXXX") -
                UNIX_TIMESTAMP(task_execution_start_date, "yyyy-MM-dd'T'HH:mm:ssXXX")) / 3600
       ) AS turn_around_time_in_hours
   FROM fact_lab_request_orders
   WHERE
      CAST(task_authored_on AS DATE) >= '2025-02-18' AND encounter_facility_id = 'ZW090A17'
     AND lab = 'MPILO' AND task_status = 'cancelled'
     AND test_type LIKE '%Viral Load%' order by task_authored_on desc




--===================================================================================================================
select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       CASE
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) < 1 THEN '<1'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 1 AND 4 THEN '1-4'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 5 AND 9 THEN '5-9'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 10 AND 14 THEN '10-14'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 15 AND 19 THEN '15-19'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 20 AND 24 THEN '20-24'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 25 AND 29 THEN '25-29'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 30 AND 34 THEN '30-34'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 35 AND 39 THEN '35-39'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 40 AND 44 THEN '40-44'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 45 AND 49 THEN '45-49'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 50 AND 54 THEN '50-54'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 55 AND 59 THEN '55-59'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 60 AND 64 THEN '60-64'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) >= 65 THEN '65+'
           ELSE 'Unknown Age'
           END AS age_category,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
    -- month(last_updated) as month, year(last_updated) as year
from fact_lab_request_orders
WHERE
    encounter_facility_id in('ZW090A17')
  AND cast(last_updated as date) >=  '2025-02-18' AND cast(last_updated as date) <=  '2025-09-30'
  AND test_type = 'Viral Load'
  AND lab = 'MPILO'
  AND task_status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression,  age_category
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         age_category,
         gender;

refresh table organization

refresh views
 --===================================================================================================================
 --Cancelled on 16 Aug to clear backlog


  SELECT lab_request_number, date_sample_taken, task_execution_start_date as impilo_registration_date,
          task_authored_on AS shr_date, diagnostic_report_date_issued, test_type, task_status, encounter_facility_id,
          datediff(cast(task_authored_on as date), cast(task_execution_start_date as date))  as turn_around_time_in_days,
       ROUND(
               (UNIX_TIMESTAMP(task_authored_on, "yyyy-MM-dd'T'HH:mm:ssXXX") -
                UNIX_TIMESTAMP(task_execution_start_date, "yyyy-MM-dd'T'HH:mm:ssXXX")) / 3600
       ) AS turn_around_time_in_hours
   FROM fact_lab_request_orders
   WHERE
      CAST(task_authored_on AS DATE) between '2025-02-18' AND '2025-9-30' and  encounter_facility_id = 'ZW090A17'
     AND lab = 'MPILO' AND task_status = 'cancelled'
     AND test_type LIKE '%Viral Load%' order by task_authored_on desc

--====================================================================================================================
  SELECT lab_request_number, date_sample_taken, task_execution_start_date as impilo_registration_date,
          cast(task_authored_on as date) AS shr_date, cast(last_updated as date) as last_updated, task_status, encounter_facility_id,
          datediff(cast(task_authored_on as date), cast(task_execution_start_date as date))  as turn_around_time_in_days,
       ROUND(
               (UNIX_TIMESTAMP(task_authored_on, "yyyy-MM-dd'T'HH:mm:ssXXX") -
                UNIX_TIMESTAMP(task_execution_start_date, "yyyy-MM-dd'T'HH:mm:ssXXX")) / 3600
       ) AS turn_around_time_in_hours
   FROM fact_lab_request_orders
   WHERE
      CAST(task_authored_on AS DATE) between '2025-02-18' AND '2025-9-30' and  encounter_facility_id = 'ZW090A17'
     AND lab = 'MPILO' AND task_status = 'cancelled'
     AND test_type LIKE '%Viral Load%' order by task_authored_on desc



--===================================================================================================================
 select distinct *
from fact_lab_request_orders limit 5
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >= '2025-07-28'
and lab = 'MPILO' and test_type like '%Viral Load%'


select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) >=  '2025-02-18' and cast(task_authored_on as date) <= '2025-09-30'
and lab = 'MPILO' and test_type like '%Viral Load%'


select count(distinct (lab_request_number)) , task_status,encounter_facility_id
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) >=  '2025-02-18' and cast(task_authored_on as date) <= '2025-09-30'
and lab = 'MPILO' and test_type like '%Viral Load%'
group by  task_status, encounter_facility_id;
---------------------------------------------------------------------------------------------------------------------
select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) >=  '2025-02-18' and cast(task_authored_on as date) <= '2025-09-30'
and test_type like '%Viral Load%'

-------------------------------------------------------------------------------------------------------------------
select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       CASE
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) < 1 THEN '<1'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 1 AND 4 THEN '1-4'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 5 AND 9 THEN '5-9'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 10 AND 14 THEN '10-14'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 15 AND 19 THEN '15-19'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 20 AND 24 THEN '20-24'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 25 AND 29 THEN '25-29'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 30 AND 34 THEN '30-34'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 35 AND 39 THEN '35-39'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 40 AND 44 THEN '40-44'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 45 AND 49 THEN '45-49'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 50 AND 54 THEN '50-54'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 55 AND 59 THEN '55-59'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) BETWEEN 60 AND 64 THEN '60-64'
           WHEN floor(datediff(cast(last_updated as date), birth_date)/365) >= 65 THEN '65+'
           ELSE 'Unknown Age'
           END AS age_category,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
    -- month(last_updated) as month, year(last_updated) as year
from fact_lab_request_orders
WHERE
   encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07', 'ZW06050A', 'ZW060627', 'ZW070445')
  AND cast(task_authored_on as date) between  '2025-11-01' AND '2025-11-30'
  AND test_type like '%Viral Load%'
  AND lab_id in (23,24)
  AND task_status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression,  age_category
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         age_category,
         gender;


refresh organization

select * from fact_lab_request_orders limit 2

-----------------------------------------------------------------------------------------------------------------------
select * from fact_lab_request_orders
    WHERE
   encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07', 'ZW06050A', 'ZW060627', 'ZW070445')
         AND cast(task_authored_on as date) between  '2025-11-01' AND '2025-11-30'
--------------------------------------------------------------------------------------------------------------------

refresh table task

select lab_request_number , task_status,encounter_facility_id, cast(task_authored_on as date) as task_authored_on
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) >=  '2025-02-18' and cast(task_authored_on as date) <= '2025-09-30'
and lab in ('Local', 'THORNGROVE', 'NAT TB LAB-MPILO') and test_type like '%Viral Load%'


select *
from fact_lab_request_orders
where encounter_facility_id = 'ZW090A17'
and cast(task_authored_on as date) >=  '2025-10-27' --and cast(task_authored_on as date) <= '2025-09-30'
and lab = 'MPILO' and test_type like '%Viral Load%'


-----==================================================================================================================

--Bulawayo sites

select encounter_facility, encounter_facility_id, lab , gender,
       count(distinct(lab_request_number)) as distinct_lab_request_numbers,
       CASE
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) < 1 THEN '<1'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 1 AND 4 THEN '1-4'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 5 AND 9 THEN '5-9'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 10 AND 14 THEN '10-14'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 15 AND 19 THEN '15-19'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 20 AND 24 THEN '20-24'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 25 AND 29 THEN '25-29'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 30 AND 34 THEN '30-34'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 35 AND 39 THEN '35-39'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 40 AND 44 THEN '40-44'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 45 AND 49 THEN '45-49'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 50 AND 54 THEN '50-54'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 55 AND 59 THEN '55-59'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) BETWEEN 60 AND 64 THEN '60-64'
           WHEN floor(datediff(cast(task_last_updated as date), birth_date)/365) >= 65 THEN '65+'
           ELSE 'Unknown Age'
           END AS age_category,
       case  when result LIKE '%-%' THEN NULL
             when upper(result) = 'TND' OR upper(result) = 'T.N.D' OR upper(result) = 'TARGET NOT DETECTED COPIES/ML' OR upper(result) LIKE '%NOT DETECTED%' OR upper(result) LIKE '%TND%' then 'Suppressed'
             when (CAST(result as INT) < 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) < 1000) then 'Suppressed'
             when (CAST(result as INT) >= 1000) OR (CAST(regexp_extract(result, '\\d+', 0) as INT) > 1000) then 'Not Suppressed'
           end as viral_suppression
    -- month(last_updated) as month, year(last_updated) as year
from fact_lab_request_order_v4

WHERE
    encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
  AND cast(task_authored_on as date) between  '2025-11-01' AND '2025-11-18'
  AND test_type like '%Viral Load%'
  AND lab in ('MPILO', 'UBH')
  AND status = 'completed'
group by encounter_facility, encounter_facility_id, lab, gender,  viral_suppression,  age_category
order by
         encounter_facility_id,
         encounter_facility,
         viral_suppression,
         age_category,
         gender;
--------------------------------------------------------------------------------------------------------------------------------

--results by joining obsv, task and org

WITH latest_obs AS (
    SELECT
        o.patient_id,
        o.val_string,
        o.effective_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.patient_id
            ORDER BY o.effective_date DESC
        ) AS rn
    FROM observation_flat_zim o
),

task_counts AS (
    SELECT
        patient_id,
        COUNT(DISTINCT task_id) AS distinct_task_ids
    FROM task_flat_zim
    WHERE status = 'completed'
      AND task_code = 'ILT0048'
      AND task_code_system = 'urn:impilo:test:code'
      AND CAST(authoredOn AS DATE) BETWEEN '2025-11-01' AND '2025-11-18'
    GROUP BY patient_id
)

SELECT DISTINCT
    t.patient_id,
    p.birth_date,
    p.organization_id,
    t.authoredOn,
    p.gender,
    t.task_id,
    t.status,
    lo.val_string AS latest_val_string,
    tc.distinct_task_ids,


    CASE
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) < 1 THEN '<1'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 1 AND 4 THEN '1-4'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 5 AND 9 THEN '5-9'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 10 AND 14 THEN '10-14'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 15 AND 19 THEN '15-19'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 20 AND 24 THEN '20-24'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 25 AND 29 THEN '25-29'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 30 AND 34 THEN '30-34'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 35 AND 39 THEN '35-39'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 40 AND 44 THEN '40-44'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 45 AND 49 THEN '45-49'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 50 AND 54 THEN '50-54'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 55 AND 59 THEN '55-59'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) BETWEEN 60 AND 64 THEN '60-64'
        WHEN floor(datediff(cast(t.last_updated AS date), p.birth_date)/365) >= 65 THEN '65+'
        ELSE 'Unknown Age'
    END AS age_category,


    CASE
        WHEN lo.val_string LIKE '%-%' THEN NULL
        WHEN upper(lo.val_string) = 'TND'
          OR upper(lo.val_string) = 'T.N.D'
          OR upper(lo.val_string) = 'TARGET NOT DETECTED COPIES/ML'
          OR upper(lo.val_string) LIKE '%NOT DETECTED%'
          OR upper(lo.val_string) LIKE '%TND%'
        THEN 'Suppressed'

        WHEN (CAST(regexp_extract(lo.val_string, '\\d+', 0) AS INT) < 1000)
        THEN 'Suppressed'

        WHEN (CAST(regexp_extract(lo.val_string, '\\d+', 0) AS INT) >= 1000)
        THEN 'Not Suppressed'
    END AS viral_suppression

FROM task_flat_zim t
LEFT JOIN latest_obs lo
       ON t.patient_id = lo.patient_id
      AND lo.rn = 1

LEFT JOIN patient_flat_zim p
       ON t.patient_id = p.pat_id

LEFT JOIN task_counts tc
       ON tc.patient_id = t.patient_id

WHERE t.status = 'completed'
  AND t.task_code = 'ILT0048'
  AND t.task_code_system = 'urn:impilo:test:code'
  AND p.organization_id in ('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07', 'ZW060627', 'ZW06050A')
  AND CAST(t.authoredOn AS DATE) BETWEEN '2025-11-01' AND '2025-11-18'

GROUP BY
    t.patient_id,
    p.birth_date,
    p.organization_id,
    t.authoredOn,
    p.gender,
    t.task_id,
    t.status,
    lo.val_string,
    t.last_updated,
    tc.distinct_task_ids;

---------------------------------------------------------------------------------------------------------------------------------

select *
from fact_lab_request_orders
where encounter_facility_id in('ZW090A17', 'ZW090A02', 'ZW090A12', 'ZW090A14', 'ZW090A66', 'ZW090A07')
and cast(task_authored_on as date) >=  '2025-11-03'
and lab = 'MPILO' and test_type like '%Viral Load%'

