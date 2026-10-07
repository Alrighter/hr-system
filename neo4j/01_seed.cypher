// Граф HR-системи. Запуск: cypher-shell -f 01_seed.cypher
// (у docker-compose виконується автоматично сервісом neo4j-seed). Скрипт ідемпотентний.

MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT user_login IF NOT EXISTS FOR (u:User) REQUIRE u.login IS UNIQUE;
CREATE CONSTRAINT city_name IF NOT EXISTS FOR (c:City) REQUIRE c.name IS UNIQUE;
CREATE CONSTRAINT hobby_name IF NOT EXISTS FOR (h:Hobby) REQUIRE h.name IS UNIQUE;
CREATE CONSTRAINT company_name IF NOT EXISTS FOR (c:Company) REQUIRE c.name IS UNIQUE;

// Довідники
UNWIND ['Київ', 'Львів', 'Харків', 'Одеса', 'Дніпро', 'Івано-Франківськ'] AS name CREATE (:City {name: name});
UNWIND ['теніс', 'біг', 'шахи', 'фотографія', 'кулінарія', 'подорожі', 'читання', 'гітара', 'велоспорт', 'настільні ігри'] AS name CREATE (:Hobby {name: name});
UNWIND ['SoftServe', 'EPAM', 'GlobalLogic', 'Ciklum', 'Intellias', 'N-iX', 'MacPaw'] AS name CREATE (:Company {name: name});

// Резюме: по одному запиту на користувача
MATCH (c:City {name: 'Харків'})
CREATE (u:User {login: 'olena.kovalenko', password_hash: '2b0b202c65c2c9194d3f69cc1c6a249344b895fcb1b33828f854187d9dd46dd7'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Олена Коваленко', birth_date: '1988-01-24', summary: 'Олена шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['фотографія', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Intellias', position: 'Project Manager', start_date: '2020-02-01', end_date: '2023-02-01'}, {company: 'EPAM', position: 'QA Engineer', start_date: '2023-02-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Дніпро'})
CREATE (u:User {login: 'andrii.shevchenko', password_hash: '465ba61f132ef2ec75b12f880deac1244ffc4a2f718abf0e2d3aa9e8329f8478'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Андрій Шевченко', birth_date: '2001-10-01', summary: 'Андрій шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['велоспорт', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'Senior .NET Developer', start_date: '2016-08-01', end_date: '2018-01-01'}, {company: 'EPAM', position: 'QA Engineer', start_date: '2018-01-01', end_date: '2021-05-01'}, {company: 'SoftServe', position: 'Project Manager', start_date: '2021-05-01', end_date: '2023-02-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Харків'})
CREATE (u:User {login: 'mariia.bondarenko', password_hash: '38d431a23f4327c990c96f2dc8ca8ddcda25f64ef618d63e8976a63c3fd08813'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Марія Бондаренко', birth_date: '1988-06-28', summary: 'Марія шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['гітара', 'кулінарія', 'настільні ігри', 'теніс']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Intellias', position: 'Data Engineer', start_date: '2015-07-01', end_date: '2018-11-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'dmytro.tkachenko', password_hash: '05437adb71fcd0e812d5cf8fc15b213c527b3f8e48b589d6f5cd89529c0c8ebe'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Дмитро Ткаченко', birth_date: '1991-12-03', summary: 'Дмитро шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'кулінарія', 'фотографія', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'EPAM', position: 'Data Engineer', start_date: '2016-02-01', end_date: '2018-06-01'}, {company: 'N-iX', position: 'Middle .NET Developer', start_date: '2018-06-01', end_date: '2020-05-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Львів'})
CREATE (u:User {login: 'iryna.kravchenko', password_hash: '0e2a38dbaa612e38c62cae32cd20a4e0c40a25dba1258128a9efa7f5e7f4b060'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Ірина Кравченко', birth_date: '1990-09-24', summary: 'Ірина шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['гітара', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'Junior .NET Developer', start_date: '2017-11-01', end_date: '2020-06-01'}, {company: 'Ciklum', position: 'Frontend Developer', start_date: '2020-06-01', end_date: '2021-06-01'}, {company: 'Intellias', position: 'Data Engineer', start_date: '2021-06-01', end_date: '2022-04-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'oleksandr.melnyk', password_hash: 'de11d7a824833e13278e8ae47a22cac746784a33af15c2b49cc24df95c7b1747'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Олександр Мельник', birth_date: '1991-11-16', summary: 'Олександр шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'гітара', 'кулінарія', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Ciklum', position: 'Project Manager', start_date: '2016-12-01', end_date: '2019-10-01'}, {company: 'Intellias', position: 'Business Analyst', start_date: '2019-10-01', end_date: '2021-03-01'}, {company: 'MacPaw', position: 'Middle .NET Developer', start_date: '2021-03-01', end_date: '2022-01-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Івано-Франківськ'})
CREATE (u:User {login: 'nataliia.oliinyk', password_hash: '019cdfd1be2535ebc1c520347015c836d7beea1178f57b0b2e77d578715b8a99'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Наталія Олійник', birth_date: '1989-11-06', summary: 'Наталія шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'настільні ігри', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'Junior .NET Developer', start_date: '2018-10-01', end_date: '2021-09-01'}, {company: 'Intellias', position: 'Frontend Developer', start_date: '2021-09-01', end_date: '2024-11-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'serhii.shevchuk', password_hash: 'f91c20409ebc34dfe8caae0f96bd10aa7dffe055ee5280eb8c548f5fceab5df7'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Сергій Шевчук', birth_date: '1995-02-10', summary: 'Сергій шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['гітара', 'теніс']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'SoftServe', position: 'Frontend Developer', start_date: '2020-12-01', end_date: '2023-09-01'}, {company: 'EPAM', position: 'Data Engineer', start_date: '2023-09-01', end_date: '2026-04-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Дніпро'})
CREATE (u:User {login: 'yuliia.polishchuk', password_hash: 'c12574a1900b5c331f45c5c9f87dc9071775bdce6d5072a4e79054433be9bb39'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Юлія Поліщук', birth_date: '1990-09-25', summary: 'Юлія шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['настільні ігри', 'подорожі']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'EPAM', position: 'Junior .NET Developer', start_date: '2018-01-01', end_date: '2020-05-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'maksym.boiko', password_hash: '96ccb7ee349d3b942bd80fba4de810545b7c09a31fc6ebc2f0c7fdda41312124'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Максим Бойко', birth_date: '1992-10-03', summary: 'Максим шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'велоспорт', 'гітара', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Ciklum', position: 'QA Engineer', start_date: '2020-08-01', end_date: '2021-10-01'}, {company: 'EPAM', position: 'Frontend Developer', start_date: '2021-10-01', end_date: '2024-12-01'}, {company: 'N-iX', position: 'Data Engineer', start_date: '2024-12-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'tetiana.lysenko', password_hash: '4d6f05cfeaa2b19a39bbc459af350a396084dda8228dba71e2fa6e83cf9342e9'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Тетяна Лисенко', birth_date: '1999-09-15', summary: 'Тетяна шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'фотографія']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'SoftServe', position: 'Middle .NET Developer', start_date: '2017-01-01', end_date: '2020-04-01'}, {company: 'SoftServe', position: 'Junior .NET Developer', start_date: '2020-04-01', end_date: '2023-04-01'}, {company: 'SoftServe', position: 'DevOps Engineer', start_date: '2023-04-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'viktor.savchenko', password_hash: '23f29bb75628db335b29a8dcc1054e7224e52c71ae05995afc853cbab430604d'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Віктор Савченко', birth_date: '1992-05-22', summary: 'Віктор шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['велоспорт', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'Project Manager', start_date: '2020-10-01', end_date: '2022-08-01'}, {company: 'Ciklum', position: 'Data Engineer', start_date: '2022-08-01', end_date: '2023-11-01'}, {company: 'Ciklum', position: 'Business Analyst', start_date: '2023-11-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Івано-Франківськ'})
CREATE (u:User {login: 'anna.rudenko', password_hash: '08719afc78d177549467e2adfe979b757d6612679e606e1a993834f93fe649c4'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Анна Руденко', birth_date: '1986-11-21', summary: 'Анна шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['теніс', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Ciklum', position: 'Senior .NET Developer', start_date: '2020-06-01', end_date: '2021-09-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'bohdan.moroz', password_hash: '5f459615a4086fb39d62aaab264cf9abbcfdc9f0e60900cd7910419057621ef1'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Богдан Мороз', birth_date: '1998-03-09', summary: 'Богдан шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'гітара']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'SoftServe', position: 'QA Engineer', start_date: '2019-02-01', end_date: '2022-01-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'kateryna.pavlenko', password_hash: '80c3876e7db86a47e0b8cf60552177706d073620629a1693b3e2af1b687549b5'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Катерина Павленко', birth_date: '1990-07-16', summary: 'Катерина шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['теніс', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'GlobalLogic', position: 'Project Manager', start_date: '2016-07-01', end_date: '2018-08-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'yevhen.honcharenko', password_hash: '08ecbc992a5b7b501ac7f52f74e02bf6ba5b446a98b6a0143db3e0495f5b0479'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Євген Гончаренко', birth_date: '2002-11-23', summary: 'Євген шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['кулінарія', 'фотографія']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'GlobalLogic', position: 'Junior .NET Developer', start_date: '2016-01-01', end_date: '2019-12-01'}, {company: 'MacPaw', position: 'DevOps Engineer', start_date: '2019-12-01', end_date: '2020-09-01'}, {company: 'Intellias', position: 'Middle .NET Developer', start_date: '2020-09-01', end_date: '2021-01-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'oksana.levchenko', password_hash: 'd33df9d8dac2e13bef5640265f1cc1239c5b0c2b965e5c5123b1622597a28a27'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Оксана Левченко', birth_date: '1990-02-20', summary: 'Оксана шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'кулінарія', 'фотографія', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'N-iX', position: 'DevOps Engineer', start_date: '2016-10-01', end_date: '2017-07-01'}, {company: 'N-iX', position: 'Data Engineer', start_date: '2017-07-01', end_date: '2019-04-01'}, {company: 'Ciklum', position: 'Senior .NET Developer', start_date: '2019-04-01', end_date: '2020-05-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'ihor.kuzmenko', password_hash: 'ad6f1b635411b5ccb74145835db02be7b307777ed5cb38015e4e6e17735bc406'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Ігор Кузьменко', birth_date: '1994-08-11', summary: 'Ігор шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'гітара']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'SoftServe', position: 'QA Engineer', start_date: '2015-09-01', end_date: '2018-06-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'svitlana.marchenko', password_hash: 'aa88dabd6db1cd3961a20e97b01ee92338a5d5dc0b0b34a1ca9539f214f6a018'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Світлана Марченко', birth_date: '1996-05-06', summary: 'Світлана шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['велоспорт', 'кулінарія', 'подорожі', 'теніс']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'GlobalLogic', position: 'Middle .NET Developer', start_date: '2019-05-01', end_date: '2020-03-01'}, {company: 'GlobalLogic', position: 'Frontend Developer', start_date: '2020-03-01', end_date: '2021-03-01'}, {company: 'EPAM', position: 'Data Engineer', start_date: '2021-03-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Харків'})
CREATE (u:User {login: 'taras.lytvynenko', password_hash: '609fb66fecb4d80850c69c78ffd95150b846a2ce76de0ff86908a689c2e2fe91'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Тарас Литвиненко', birth_date: '1991-11-21', summary: 'Тарас шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['гітара', 'кулінарія', 'настільні ігри', 'теніс']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'N-iX', position: 'Frontend Developer', start_date: '2020-07-01', end_date: '2021-03-01'}, {company: 'N-iX', position: 'Project Manager', start_date: '2021-03-01', end_date: '2022-09-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'liudmyla.karpenko', password_hash: '4921d1a1aa5d44422b64d8cbd86ac9acd79f0afa4d41f9d0b7074751480696b3'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Людмила Карпенко', birth_date: '2002-01-04', summary: 'Людмила шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['велоспорт', 'теніс', 'читання', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'GlobalLogic', position: 'Data Engineer', start_date: '2017-10-01', end_date: '2018-01-01'}, {company: 'N-iX', position: 'QA Engineer', start_date: '2018-01-01', end_date: '2019-04-01'}, {company: 'GlobalLogic', position: 'DevOps Engineer', start_date: '2019-04-01', end_date: '2022-02-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Львів'})
CREATE (u:User {login: 'roman.zakharchenko', password_hash: 'a400c910a2d4f4cacc4636ca7c659a62468de2a1fd8d0d884d76d8314313a72d'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Роман Захарченко', birth_date: '1998-10-24', summary: 'Роман шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['настільні ігри', 'шахи']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'QA Engineer', start_date: '2018-01-01', end_date: '2021-07-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Івано-Франківськ'})
CREATE (u:User {login: 'viktoriia.klymenko', password_hash: '123c3ed22011aff32b34c4652f654ddc39006573ff7c675f21ecf4729c9469ac'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Вікторія Клименко', birth_date: '1993-03-26', summary: 'Вікторія шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['теніс', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'EPAM', position: 'Junior .NET Developer', start_date: '2018-04-01', end_date: '2020-04-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Харків'})
CREATE (u:User {login: 'artem.sydorenko', password_hash: '7799798fbbd4379b03554b7ec738c6d1ed9871b3163bd8afb0f8baf67efe3f3e'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Артем Сидоренко', birth_date: '1991-07-11', summary: 'Артем шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['кулінарія', 'подорожі']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'GlobalLogic', position: 'Junior .NET Developer', start_date: '2020-09-01', end_date: '2023-09-01'}, {company: 'EPAM', position: 'Frontend Developer', start_date: '2023-09-01', end_date: '2024-05-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Одеса'})
CREATE (u:User {login: 'khrystyna.petrenko', password_hash: '7aad6913d51a52d7725e133481c8ae4af95c7cbdfe27485de54a381c8006158e'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Христина Петренко', birth_date: '1986-02-20', summary: 'Христина шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['біг', 'подорожі', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'SoftServe', position: 'DevOps Engineer', start_date: '2018-10-01', end_date: '2020-07-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Івано-Франківськ'})
CREATE (u:User {login: 'vladyslav.ivanenko', password_hash: '663605f46594c70f408b5e524ba093363c62ba32b33b35258bace6a71a075d57'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Владислав Іваненко', birth_date: '2002-11-24', summary: 'Владислав шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['подорожі', 'теніс', 'фотографія', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'N-iX', position: 'Frontend Developer', start_date: '2020-06-01', end_date: '2022-02-01'}, {company: 'Ciklum', position: 'Data Engineer', start_date: '2022-02-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Дніпро'})
CREATE (u:User {login: 'sofiia.romanenko', password_hash: '649140d15bfd5022f79cfbbba8f89891b4322da62d98225b878d310a016ce5df'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Софія Романенко', birth_date: '1997-12-10', summary: 'Софія шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['фотографія', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Intellias', position: 'Frontend Developer', start_date: '2020-07-01', end_date: '2023-10-01'}, {company: 'GlobalLogic', position: 'Frontend Developer', start_date: '2023-10-01', end_date: '2025-01-01'}, {company: 'Ciklum', position: 'Data Engineer', start_date: '2025-01-01', end_date: null}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Івано-Франківськ'})
CREATE (u:User {login: 'nazar.humeniuk', password_hash: '9d63166c098de17e78e1a7d55a85ff9c22a62ecd684072009a2c2d806998424a'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Назар Гуменюк', birth_date: '1999-08-15', summary: 'Назар шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['велоспорт', 'гітара']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'N-iX', position: 'Data Engineer', start_date: '2020-03-01', end_date: '2021-11-01'}, {company: 'N-iX', position: 'Frontend Developer', start_date: '2021-11-01', end_date: '2022-04-01'}, {company: 'EPAM', position: 'Junior .NET Developer', start_date: '2022-04-01', end_date: '2023-04-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Дніпро'})
CREATE (u:User {login: 'daryna.yakovenko', password_hash: '1801ee98074fc4f8cd562169501920f9f29092cb90214070db894f397f3bb6be'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Дарина Яковенко', birth_date: '1986-04-16', summary: 'Дарина шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['гітара', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'Ciklum', position: 'QA Engineer', start_date: '2020-10-01', end_date: '2023-08-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (c:City {name: 'Київ'})
CREATE (u:User {login: 'pavlo.ostapchuk', password_hash: '374f081c82f7c999dc9671a86972f27ff886983b521d4dd9cfc5813804436c9a'})
       -[:HAS_RESUME]->(r:Resume {full_name: 'Павло Остапчук', birth_date: '1989-11-23', summary: 'Павло шукає нову роль в IT.'})
       -[:LIVES_IN]->(c)
WITH r
MATCH (h:Hobby) WHERE h.name IN ['фотографія', 'читання']
CREATE (r)-[:HAS_HOBBY]->(h)
WITH DISTINCT r
UNWIND [{company: 'MacPaw', position: 'Middle .NET Developer', start_date: '2016-12-01', end_date: '2018-04-01'}, {company: 'N-iX', position: 'DevOps Engineer', start_date: '2018-04-01', end_date: '2020-08-01'}, {company: 'GlobalLogic', position: 'Business Analyst', start_date: '2020-08-01', end_date: '2023-10-01'}] AS j
MATCH (co:Company {name: j.company})
CREATE (r)-[:WORKED_AT {position: j.position, start_date: j.start_date, end_date: j.end_date}]->(co);

MATCH (n) RETURN labels(n)[0] AS label, count(*) AS cnt ORDER BY label;
MATCH ()-[r]->() RETURN type(r) AS type, count(*) AS cnt ORDER BY type;
