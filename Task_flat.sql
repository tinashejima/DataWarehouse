CREATE OR REPLACE VIEW task_flat as
select T.id as task_id, T.language,
TI.period as period, TI.value  as  labrequestno, TB.resourceId as basednresourceId,
TB.reference as basedOn, TB.type as basedOntype, T.status, T.intent, T.priority, T.for.reference as for,
T.encounter.encounterId as encounterId, T.executionPeriod.start as executionStartDate, T.executionPeriod.end as executionEndDate,
T.authoredOn, T.lastModified, T.location.locationId as locationId,  TIN.id as inputId, TINC.system as system, TINC.code as inputTypeCode,
TINC.display as inputType, TO.id as outputId From task as T
LATERAL VIEW OUTER explode(T.identifier) AS TI
LATERAL VIEW OUTER explode(T.basedOn) AS TB
LATERAL VIEW OUTER explode(T.input) AS TIN
LATERAL VIEW OUTER explode(TIN.type.coding) AS TINC
LATERAL VIEW OUTER explode(T.output) AS TO;