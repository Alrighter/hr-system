// 1. Отримання резюме користувача.
MATCH(u:User)-[:HAS_RESUME]->(r:Resume)
MATCH(r)-[ :HAS_HOBBY]->(h:Hobby)
MATCH(r)-[ :LIVES_IN]->(c:City)
MATCH(r)-[w:WORKED_AT]->(comp:Company)
WHERE(u.login = 'maksym.boiko')
RETURN r.full_name, r.birth_date, r.summary, c.name, collect(DISTINCT w.position), collect(DISTINCT h.name)


// 2 Хобі унікальні, які зустрічаються в резюме.
MATCH(r:Resume)-[ :HAS_HOBBY]->(h:Hobby)
RETURN DISTINCT h.name

// 3 Унікальні міста в резюме.
MATCH(r:Resume)-[ :LIVES_IN]->(c:City)
RETURN DISTINCT c.name

//  4 Хобі в резюме в користувачів певного міста.
MATCH(r:Resume)-[ :LIVES_IN]->(c:City)
MATCH(r)-[ :HAS_HOBBY]->(h:Hobby)
WHERE(c.name = 'Київ')
RETURN DISTINCT h.name

// 5 Компанії і люди які працювали разом.
MATCH(comp:Company)<-[w:WORKED_AT]-(r:Resume)
WITH comp, collect(DISTINCT r.full_name) as people
WHERE size(people) > 1
RETURN comp.name as company, people