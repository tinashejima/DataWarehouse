select lr.investigation_group_id , count(laboratory_request_order_id), tenant_id  as facility, lr.date_sample_taken, laboratory from consultation.laboratory_request_order lr
where lr.investigation_group_id is not null
group by lr.investigation_group_id, tenant_id, lr.date_sample_taken, laboratory
having count(laboratory_request_order_id) > 1;

--====================================================================================================
select lr.investigation_group_id , count(laboratory_request_order_id), tenant_id  as count, lr.date_sample_taken from consultation.laboratory_request_order lr
where lr.investigation_group_id is not null
group by lr.investigation_group_id, tenant_id, lr.date_sample_taken
having count(laboratory_request_order_id) > 1;

--=======================================================================================================

select lr.investigation_group_id , lr.laboratory_request_number, count(laboratory_request_order_id), tenant_id  as count, lr.date_sample_taken from consultation.laboratory_request_order lr
where lr.investigation_group_id is not null
group by lr.investigation_group_id, tenant_id, lr.date_sample_taken, lr.laboratory_request_number
having count(laboratory_request_order_id) > 1;

--===========================================================

select * from consultation.laboratory_request_order
where tenant_id = 'ZW090A12' and laboratory = 'MPILO' and date_sample_taken >= '2025-06-01'

--===========================================================


select * from consultation.laboratory_request_order lr
where investigation_group_id = '713bdc59-fbe4-4658-a44a-013fe1de6806'


select * from consultation.laboratory_request_order
 where  investigation_group_id = '713bdc59-fbe4-4658-a44a-013fe1de6806'

--========================================================================

    select * from consultation.laboratory_request_order
    where tenant_id = 'ZW090A17' and date_sample_taken >= '2025-05-01' and laboratory = 'MPILO'

--=======================================================================

select * from consultation.investigation_group_order
where investigation_group_id = '585ca322-1d35-4d70-bbe3-1206a66319cf'


--===========================================================================
select * from client.person
where person_id = '8aa55368-13be-4bfb-8d5e-4edb756cfa75'

--==========================================================================

select * from consultation.laboratory_request_order
where laboratory_request_number_short_code is not null and tenant_id = 'ZW090A17' limit 5

--==========================================================================

select laboratory_request_order_id, laboratory_request_number, investigation_group_id, from consultation.laboratory_request_order
where investigation_group_id = 'd6bf93e2-930c-43ef-bf46-08cb0994784d'

SELECT *
FROM consultation.investigation_group_order where name = 'Viral Load'

select * from report.investigation_register
where patient_id = '85a4362d-9165-4537-b0d2-1993690d2d12'


select * from consultation.laboratory_request_order
where date_sample_taken = '2025-09-14' and facility_id in ('ZW090A17','ZW090A12')

--===============================================================================================================================

select * from consultation.laboratory_request_order
where created_at >= '2025-08-01' and  created_at <= '2025-08-22'  and  tenant_id = 'ZW090A17'
and laboratory = 'MPILO'
order by created_at asc

--=====================================================================================================================
select * from report.lab_request_orders


select * from consultation.laboratory_request_order
where laboratory_request_number_short_code = '97173X'


select lr.investigation_group_id , count(laboratory_request_order_id), tenant_id  as count, lr.date_sample_taken, lr.laboratory_request_number_short_code
from consultation.laboratory_request_order lr
where lr.laboratory_request_number_short_code is not null
group by lr.investigation_group_id, tenant_id, lr.date_sample_taken, lr.laboratory_request_number_short_code
having count(laboratory_request_number_short_code) > 1;



