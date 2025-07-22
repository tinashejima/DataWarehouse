

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
------sample eligible for processing = orders accepted - (rejected orders + orders in accepted status + comleted)
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
    encounter_facility_id = 'ZW090A17'
  AND cast(last_updated as date) between  '2025-02-18' and '2025-06-11'
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
where encounter_facility_id in ('ZW090A17', 'ZW090A12', 'ZW090A27', 'ZW090A10', 'ZW090A02' ) and cast(task_authored_on as date) >=  '2025-02-18'
and lab = 'MPILO' and test_type like '%Viral Load%'
---------------------------------------------------------------------------------------------

select distinct(encounter_facility) from fact_lab_request_orders
where  cast(task_authored_on as date) <= '2025-02-18' and lab = 'MPILO' and test_type like '%Viral Load%' and task_status = 'requested'


show tables from default