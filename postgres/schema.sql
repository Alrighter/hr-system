CREATE TABLE users (
    id            serial PRIMARY KEY,
    login         text NOT NULL UNIQUE,
    password_hash text NOT NULL
);

CREATE TABLE cities (
    id   serial PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE resumes (
    id         serial PRIMARY KEY,
    user_id    int  NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    full_name  text NOT NULL,
    birth_date date,
    summary    text,
    city_id    int  NOT NULL REFERENCES cities(id)
);

CREATE TABLE hobbies (
    id   serial PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE resume_hobbies (
    resume_id int REFERENCES resumes(id) ON DELETE CASCADE,
    hobby_id  int REFERENCES hobbies(id),
    PRIMARY KEY (resume_id, hobby_id)
);

CREATE TABLE companies (
    id   serial PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE experiences (
    id         serial PRIMARY KEY,
    resume_id  int  NOT NULL REFERENCES resumes(id) ON DELETE CASCADE,
    company_id int  NOT NULL REFERENCES companies(id),
    position   text NOT NULL,
    start_date date NOT NULL,
    end_date   date               
);