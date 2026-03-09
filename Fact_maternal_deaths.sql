Create or replace view  fact_maternal_deaths as
select * from observation_flat_zim where code = 'MATERNAL_DEATH'