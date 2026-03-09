CREATE OR REPLACE  VIEW Servicerequest_flat AS
 select ST.id as service_requestId, ST.language, STI.system, STI.value AS labreqnum,
 ST.status, ST.intent, STCOC.code AS category_code, STCOC.display AS category,
 STCC.code , STCC.display as service, STOC.code as orderdetail_code,
 STOC.display  AS orderdetail, ST.quantity.quantity.value as quantity, ST.subject.patientId,
 ST.encounter.encounterId, ST.occurrence.dateTime as date, ST.authoredOn,
  ST.requester.organizationId AS requester_organization,
 STPC.code as performerTypecode, STPC.display as perfomerType,
 STLC.code as locationCode, STLC.display AS location,
 STRC.code AS reasoncode, STRC.display AS reason , STS. specimenId,
 STBC.code as bodysitecode,   STBC.display as body_site, ST.patientInstruction
 FROM servicerequest AS ST
 LATERAL VIEW OUTER explode(ST.identifier) AS STI
 lATERAL VIEW OUTER explode(ST.category) AS STC
 lATERAL VIEW OUTER explode(STC.coding) AS STCOC
 LATERAL VIEW OUTER explode(ST.code.coding) AS STCC
 lATERAL VIEW OUTER explode(ST.orderDetail) AS STO
 LATERAL VIEW OUTER explode(STO.coding) AS STOC
 LATERAL VIEW OUTER explode(ST.performerType.coding) AS STPC
 LATERAL VIEW OUTER explode(ST.locationCode) AS STL
 LATERAL VIEW OUTER explode(STL.coding) AS STLC
 LATERAL VIEW OUTER explode(ST.reasonCode) AS STR
 LATERAL VIEW OUTER explode(STR.coding) AS STRC
 LATERAL VIEW OUTER explode(ST.specimen) AS STS
 LATERAL VIEW OUTER explode(ST.bodysite) AS STB
 LATERAL VIEW OUTER explode(STB.coding) AS STBC;
