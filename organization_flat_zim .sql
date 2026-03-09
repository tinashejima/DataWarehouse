 create or replace view organization_flat_zim as
   select o.id as organization_id, o.name, o.implicitRules, o.language, o.active, otc.code as organization_type_code, otc.system as organisation_type_code_system,
          otc.display as organization_type_code_system
       from organization  as  o
           lateral view outer explode (o.type)  as ot
           lateral view outer explode (ot.coding) as otc