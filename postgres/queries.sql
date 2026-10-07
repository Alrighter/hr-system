-- 1. Отримання резюме користувача. Отримую City, Name, Positions, Summary.
SELECT r.full_name,
       r.birth_date,
       c.name AS city,
       (SELECT json_agg(h.name)
          FROM resume_hobbies rh
          INNER JOIN hobbies h ON h.id = rh.hobby_id
         WHERE rh.resume_id = r.id) AS hobbies,
       (SELECT json_agg(json_build_object(
                   'company', co.name, 'position', e.position,
                   'start', e.start_date, 'end', e.end_date))
          FROM experiences e
          INNER JOIN companies co ON co.id = e.company_id
         WHERE e.resume_id = r.id) AS experience
FROM users u
INNER JOIN resumes r ON r.user_id = u.id
INNER JOIN cities  c ON c.id = r.city_id
WHERE u.login = 'maksym.boiko';

-- 2 Хобі унікальні, які зустрічаються в резюме.
SELECT DISTINCT h.name AS hobby
FROM hobbies h
INNER JOIN resume_hobbies rh ON rh.hobby_id = h.id;

-- 3 Унікальні міста в резюме.
SELECT DISTINCT c.name AS city
FROM cities c
INNER JOIN resumes r ON r.city_id = c.id;

-- 4 Хобі в резюме в користувачів певного міста.
SELECT DISTINCT h.name AS hobby
FROM cities c
INNER JOIN resumes r         ON r.city_id = c.id
INNER JOIN resume_hobbies rh ON rh.resume_id = r.id
INNER JOIN hobbies h         ON h.id = rh.hobby_id
WHERE c.name = 'Київ';

-- 5 Компанії і люди які працювали разом.
SELECT co.name AS company,
       json_agg(DISTINCT r.full_name ORDER BY r.full_name) AS people
FROM experiences e
INNER JOIN companies co ON co.id = e.company_id
INNER JOIN resumes r    ON r.id = e.resume_id
GROUP BY co.name
HAVING COUNT(DISTINCT e.resume_id) > 1;