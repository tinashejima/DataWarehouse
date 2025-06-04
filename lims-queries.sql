--All records from 18 Feb upto Current date

select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
order by task_authored_on asc;

--=======================================================================================================================

-- with tasks requested
select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'requested'
order by task_authored_on asc;

--==========================================================================================================================
-- with tasks accepted
select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'accepted'
order by task_authored_on asc;


--=========================================================================================================================
-- with tasks in-progress
select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'in-progress'
order by task_authored_on asc;

--=========================================================================================================================
-- with tasks rejected
select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'rejected'
order by task_authored_on asc;


--=========================================================================================================================
-- with tasks completed
select * from fact_lab_request_orders
where test_type = 'Viral Load' and patient_managing_organization_id = 'ZW090A17' and task_authored_on >= '2025-02-18'
and task_status = 'completed'
order by task_authored_on asc;


--==============================================================================================================================
-- Total of all statuses
SELECT
    'total orders submitted' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18'
    AND task_status IN ('requested', 'accepted', 'in-progress', 'rejected', 'completed' )


UNION ALL

SELECT 'requested' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18' AND task_status = 'requested'

UNION ALL

SELECT 'accepted' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18' AND task_status = 'accepted'

UNION ALL

SELECT 'in-progress' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18' AND task_status = 'in-progress'

UNION ALL

SELECT 'rejected' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18' AND task_status = 'rejected'


UNION ALL

SELECT 'completed' AS task_status, COUNT(*) AS count
FROM fact_lab_request_orders
WHERE test_type = 'Viral Load' AND patient_managing_organization_id = 'ZW090A17' AND task_authored_on >= '2025-02-18' AND task_status = 'completed'

--================================================================================================================================================================

