// 1. Отримання повного резюме користувача.
db.users.aggregate([
    {$match: {login: "maksym.boiko"}},
    {$project: {_id: 0, login: 0, password_hash: 0}}
])

// 2. Хобі унікальні, які зустрічаються в резюме.
db.users.aggregate([
    {$unwind: "$resume.hobbies"},
    {$group: {_id: "$resume.hobbies"}},
    {$project: {_id: 0, hobbies: "$_id"}}
]);

// 3. Унікальні міста в резюме.
db.users.aggregate([
    {$unwind: "$resume.city.name"},
    {$group: {_id: "$resume.city.name"}},
    {$project: {_id: 0, cities: "$_id"}}
]);

// 4. Хобі в резюме в користувачів певного міста.
db.users.aggregate([
    {$match: {"resume.city.name": "Київ"}},
    {$unwind: "$resume.hobbies"},
    {$group: {_id: "$resume.hobbies"}},
    {$project: {_id: 0, hobby: "$_id"}}
]);

// 5. Компанії і люди які працювали разом.
db.users.aggregate([
  {"$unwind": "$resume.experience"},
  {"$group": {"_id": "$resume.experience.company_id", "company": {"$first": "$resume.experience.company"}, "people": {"$addToSet": "$resume.full_name"}}},
  {"$project": {"_id": 0, "company": 1, "people": 1}}
]);
