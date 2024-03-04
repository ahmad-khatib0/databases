-- Overnormalized address data model: To retrieve the address for a person 
-- (something we presumably do a lot) we need a five-table join:

EXPLAIN SELECT 
    p.firstname,
    p.lastname, 
    a.addressline1,
    a.city, 
    s2.name,
    c2.name
  FROM person p 
  JOIN businessentity b2 ON (p.businessentityid=b2.businessentityid )
  JOIN businessentityaddress b3 ON (b3.businessentityid=b2.businessentityid)
  JOIN address a ON (b3.addressid=a.addressid)
  JOIN stateprovince s2 ON (s2.stateprovinceid=a.stateprovinceid)
  JOIN countryregion c2 ON (c2.countryregioncode=s2.countryregioncode)
 WHERE p.businessentityid =1
