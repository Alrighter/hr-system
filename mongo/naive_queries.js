// 1. Отримання резюме користувача. Отримую City, Name, Positions, Summary.
db.users.aggregate([
    {$match: {login: "maksym.boiko"}},
    {$lookup: {
        from: "resumes",
        localField: "_id",
        foreignField: "user_id",
        as: "resume"
    }},
    {$unwind: "$resume"},
    {$lookup: {
        from: "cities",
        localField: "resume.city_id",
        foreignField: "_id",
        as: "city"
    }},
    {$unwind: "$city"},
    {$lookup :{
        from: "experiences",
        localField: "resume._id",
        foreignField: "resume_id",
        as: "experience"
    }},
    {$unwind: "$experience"},
    {$group: {
        _id: "$_id",
        name: {
            $first: "$resume.full_name"
        },
        city: {
            $first: "$city.name"
        },
        summary: {
            $first: "resume.summary"
        },
        positions: {
            $push: "$experience.position"
        }
    }},
    {$project: {_id: 0, name: 1, city: 1, summary: 1, positions: 1}},
]);

// 2. Хобі унікальні, які зустрічаються в резюме.
db.resume_hobbies.aggregate([
    {"$lookup": {
        from: "hobbies",
        localField: "hobby_id",
        foreignField: "_id",
        as: "hobby"
    }},
    {
    "$unwind": "$hobby"
    },
    {$group: {_id: "$hobby.name"}},
    {
    "$project": {
        _id: 0,
        name: "$_id"
    },
}]);

// 3. Унікальні міста в резюме.
db.resumes.aggregate([
    {
        "$lookup": {
            from: "cities",
            localField: "city_id",
            foreignField: "_id",
            as: "city"
        }
    },
    {
        "$unwind": "$city"
    },
    {
        "$group": {
            _id: "$city.name"
        }
    },
    {
        "$project": {
            _id: 0,
            city_name: "$_id"
        }
    }
])

// 4. Хобі в резюме в користувачів певного міста.
db.cities.aggregate([
    {$match: {"name": "Київ"}},
    {$lookup: {
        from: "resumes",
        localField: "_id",
        foreignField: "city_id",
        as: "resume"
    }},
    {$unwind: "$resume"},
    {$lookup: {
        from: "resume_hobbies",
        localField: "resume._id",
        foreignField: "resume_id",
        as: "rh"
    }},
    {$unwind: "$rh"},
    {$lookup: {
        from: "hobbies",
        localField: "rh.hobby_id",
        foreignField: "_id",
        as: "hobby"
    }},
    {$unwind: "$hobby"},
    {$group: {_id: "$hobby.name"}},
    {$project: {_id: 0, hobby: "$_id"}}
]);

// 5. Компанії і люди які працювали разом.
db.experiences.aggregate([
    {$lookup: {
        from: "companies",
        localField: "company_id",
        foreignField: "_id",
        as: "company"
    }},
    {$unwind: "$company"},
    {
        $lookup: {
            from: "resumes",
            localField: "resume_id",
            foreignField: "_id",
            as: "resume"
        }
    },
    {$unwind: "$resume"},
    {$group: {_id: "$company.name", people: {$addToSet: "$resume.full_name"}}},
    {$project: {_id: 0, company: "$_id", people: "$people"}}
]);
