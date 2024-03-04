EXPLAIN ANALYZE SELECT 
  s.businessentityid AS salesPersonId ,
  st.name AS storeName ,
  concat(p.firstname,' ',p.lastname) AS salesPerson,
  CONCAT (cp.firstname,' ',cp.lastname) AS customerName,
  soh.salesorderid ,
  soh.duedate,
  soh.STATUS,
  sod.orderqty,
  sod.unitprice,
  sod.unitpricediscount
FROM person.person p
  JOIN sales.salesperson s ON p.businessentityid =s.businessentityid 	 
  JOIN "store" st ON st.salespersonid=s.businessentityid
  JOIN customer c ON c.storeid=st.businessentityid 
  JOIN person.person cp ON c.personid=cp.businessentityid 
  JOIN salesorderheader soh ON soh.customerid=c.customerid 
  JOIN salesorderdetail sod ON sod.salesorderid=soh.salesorderid
  JOIN production.product prod ON prod.productid=sod.productid
WHERE STATUS=5
ORDER BY soh.duedate DESC LIMIT 100
 
