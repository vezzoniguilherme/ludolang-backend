SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS user_monthly_challenge;
DROP TABLE IF EXISTS user_monthly_challenge_seq;
DROP TABLE IF EXISTS user_daily_quest;
DROP TABLE IF EXISTS user_daily_quest_seq;
DROP TABLE IF EXISTS path_icons;
DROP TABLE IF EXISTS path_icons_seq;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS follows_seq;
DROP TABLE IF EXISTS user_course_progress;
DROP TABLE IF EXISTS user_course_progress_seq;
DROP TABLE IF EXISTS lesson_completions;
DROP TABLE IF EXISTS lesson_completions_seq;
DROP TABLE IF EXISTS exercise_attempt_option;
DROP TABLE IF EXISTS exercise_attempt_option_seq;
DROP TABLE IF EXISTS exercise_attempts;
DROP TABLE IF EXISTS exercise_attempts_seq;
DROP TABLE IF EXISTS exercise_options;
DROP TABLE IF EXISTS exercise_options_seq;
DROP TABLE IF EXISTS exercises;
DROP TABLE IF EXISTS exercises_seq;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS lessons_seq;
DROP TABLE IF EXISTS units;
DROP TABLE IF EXISTS units_seq;
DROP TABLE IF EXISTS sections;
DROP TABLE IF EXISTS sections_seq;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS users_seq;
DROP TABLE IF EXISTS quest_definition;
DROP TABLE IF EXISTS quest_definition_seq;
DROP TABLE IF EXISTS monthly_challenge_definition;
DROP TABLE IF EXISTS monthly_challenge_definition_seq;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS course_seq;

SET FOREIGN_KEY_CHECKS = 1;

create table course
(
    id        int          not null
        primary key,
    image_src varchar(255) null,
    title     varchar(255) null
);


create table monthly_challenge_definition
(
    id            int auto_increment
        primary key,
    code          varchar(255)         null,
    target        int                  not null,
    reward_points int                  not null,
    active        tinyint(1) default 1 not null,
    constraint code
        unique (code)
);


create table quest_definition
(
    id            int auto_increment
        primary key,
    code          varchar(255)         null,
    target        int                  not null,
    reward_points int                  not null,
    active        tinyint(1) default 1 not null,
    constraint code
        unique (code)
);


create table users
(
    id                int auto_increment
        primary key,
    username          varchar(255)                           null,
    first_name        varchar(255)                           null,
    last_name         varchar(255)                           null,
    pfp_source        varchar(255)                           null,
    points            int          default 0                 not null,
    created_at        timestamp    default CURRENT_TIMESTAMP not null,
    last_submission   timestamp                              null,
    streak_length     int          default 0                 not null,
    current_course_id int                                    null,
    email             varchar(255) default 'test@gmail.com'  not null,
    constraint id_UNIQUE
        unique (id),
    constraint username_UNIQUE
        unique (username),
    constraint fk_users_current_course
        foreign key (current_course_id) references course (id)
            on delete set null
);

create index ix_users_points_desc
    on users (points desc, id asc);


create table sections
(
    id          int auto_increment
        primary key,
    course_id   int          not null,
    order_index int          not null,
    title       varchar(255) null,
    constraint id_UNIQUE
        unique (id),
    constraint fk_sections_course
        foreign key (course_id) references course (id)
            on delete cascade
);

create table units
(
    id             int auto_increment
        primary key,
    title          varchar(255) null,
    description    varchar(255) null,
    section_id     int          not null,
    order_index    int          not null,
    course_id      int          not null,
    created_at     datetime(6)  null,
    animation_path varchar(255) null,
    color          varchar(255) null,
    constraint uq_course_order
        unique (course_id, order_index),
    constraint fk_units_course
        foreign key (course_id) references course (id)
            on delete cascade
);

create table lessons
(
    id          int auto_increment
        primary key,
    title       varchar(255)                 null,
    unit_id     int                          not null,
    order_index int                          not null,
    type        varchar(20) default 'Lesson' not null,
    lesson_type varchar(255)                 null,
    constraint id_UNIQUE
        unique (id),
    constraint fk_lessons_unit
        foreign key (unit_id) references units (id)
            on delete cascade
);

create table exercises
(
    id          int auto_increment
        primary key,
    lesson_id   int          not null,
    type        varchar(255) null,
    prompt      varchar(255) null,
    order_index int          not null,
    constraint id
        unique (id),
    constraint exercises_ibfk_1
        foreign key (lesson_id) references lessons (id)
            on delete cascade
);

create index lesson_id
    on exercises (lesson_id);

create table exercise_options
(
    id           int auto_increment
        primary key,
    content      varchar(255) null,
    exercise_id  int          not null,
    image_url    varchar(255) null,
    is_correct   tinyint(1)   not null,
    answer_order int          null
);


create table exercise_attempts
(
    id           int auto_increment
        primary key,
    exercise_id  int                                       not null,
    option_id    int                                       not null,
    score        int                                       null,
    submitted_at timestamp(6) default CURRENT_TIMESTAMP(6) not null,
    user_id      int                                       not null,
    is_checked   tinyint(1)   default 0                    not null
);

create table exercise_attempt_option
(
    id         int auto_increment
        primary key,
    attempt_id int not null,
    option_id  int not null,
    position   int not null,
    constraint exercise_attempt_option_ibfk_1
        foreign key (attempt_id) references exercise_attempts (id)
            on delete cascade,
    constraint exercise_attempt_option_ibfk_2
        foreign key (option_id) references exercise_options (id)
);

create index attempt_id
    on exercise_attempt_option (attempt_id);

create index option_id
    on exercise_attempt_option (option_id);


create table lesson_completions
(
    user_id      int                                 not null,
    course_id    int                                 not null,
    lesson_id    int                                 not null,
    score        int                                 not null,
    completed_at timestamp default CURRENT_TIMESTAMP not null,
    primary key (user_id, lesson_id),
    constraint lesson_completions_ibfk_1
        foreign key (user_id) references users (id),
    constraint lesson_completions_ibfk_2
        foreign key (lesson_id) references lessons (id)
);

create index lesson_id
    on lesson_completions (lesson_id);


create table user_course_progress
(
    id                int auto_increment
        primary key,
    user_id           int                                  not null,
    course_id         int                                  not null,
    current_lesson_id int                                  null,
    updated_at        timestamp  default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    is_complete       tinyint(1) default 0                 not null,
    constraint user_course_progress_ibfk_1
        foreign key (user_id) references users (id)
            on delete cascade,
    constraint user_course_progress_ibfk_2
        foreign key (course_id) references course (id)
            on delete cascade,
    constraint user_course_progress_ibfk_3
        foreign key (current_lesson_id) references lessons (id)
);

create index current_lesson_id
    on user_course_progress (current_lesson_id);

create index user_id
    on user_course_progress (user_id);


create table follows
(
    id          int auto_increment
        primary key,
    follower_id int                                 not null,
    followed_id int                                 not null,
    created_at  timestamp default CURRENT_TIMESTAMP not null,
    constraint uq_follows
        unique (follower_id, followed_id),
    constraint fk_follows_followed
        foreign key (followed_id) references users (id)
            on delete cascade,
    constraint fk_follows_follower
        foreign key (follower_id) references users (id)
            on delete cascade,
    constraint chk_no_self_follow
        check (follower_id <> followed_id)
);

create index idx_follows_followed
    on follows (followed_id);

create index idx_follows_follower
    on follows (follower_id);




create table path_icons
(
    unit_id int          not null
        primary key,
    icon    varchar(255) not null,
    constraint fk_unit
        foreign key (unit_id) references units (id)
            on delete cascade
);

create table user_daily_quest
(
    user_id        int                  not null,
    quest_def_id   int                  not null,
    date           date                 not null,
    progress       int        default 0 not null,
    completed_at   timestamp            null,
    reward_claimed tinyint(1) default 0 not null,
    primary key (user_id, quest_def_id, date),
    constraint user_daily_quest_ibfk_1
        foreign key (quest_def_id) references quest_definition (id),
    constraint user_daily_quest_ibfk_2
        foreign key (user_id) references users (id)
);

create index quest_def_id
    on user_daily_quest (quest_def_id);

CREATE TABLE user_monthly_challenge (
    user_id int NOT NULL,
    challenge_def_id int NOT NULL,
    year int NOT NULL,
    month int NOT NULL,
    progress int NOT NULL DEFAULT '0',
    completed_at timestamp NULL DEFAULT NULL,
    reward_claimed tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (user_id,challenge_def_id,year,month),
    KEY challenge_def_id (challenge_def_id),
    CONSTRAINT user_monthly_challenge_ibfk_1 FOREIGN KEY (challenge_def_id) REFERENCES monthly_challenge_definition (id),
    CONSTRAINT user_monthly_challenge_ibfk_2 FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO course (id, image_src, title) VALUES (1, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/7488bd7cd28b768ec2469847a5bc831e.svg', 'FRENCH');
INSERT INTO course (id, image_src, title) VALUES (2, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/097f1c20a4f421aa606367cd33893083.svg', 'GERMAN');
INSERT INTO course (id, image_src, title) VALUES (3, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/40a9ce3dfafe484bced34cdc124a59e4.svg', 'SPANISH');
-- Inserções básicas para que o backend não dê erro ao selecionar cursos
-- (Requer que a tabela 'course' já tenha os cursos 1, 2 e 3 inseridos)

-- ==========================================
-- CURSO 1: FRENCH (course_id = 1)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (1, 1, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (1, 'Unit 1', 'Learn basic French', 1, 1, 1, '/animations/unit1.json', 'GREEN');
INSERT INTO path_icons (unit_id, icon) VALUES (1, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (1, 'Lesson 1', 1, 1, 'Lesson', 'vocabulary');

-- Exercise 1
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (1, 1, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (1, 'Bonjour', 1, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (2, 'Merci', 1, null, 0);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (3, 'Au revoir', 1, null, 0);

-- Exercise 2
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (2, 1, 'TRANSLATION', 'Translate "Thank you"', 2);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (4, 'Merci', 2, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (5, 'Oui', 2, null, 0);

-- Exercise 3
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (3, 1, 'TRANSLATION', 'Translate "Yes"', 3);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (6, 'Oui', 3, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (7, 'Non', 3, null, 0);

-- Exercise 4
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (4, 1, 'TRANSLATION', 'Translate "Good morning"', 4);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (8, 'Bonjour', 4, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (9, 'Salut', 4, null, 0);

-- Exercise 5
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (5, 1, 'TRANSLATION', 'Translate "Goodbye"', 5);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (10, 'Au revoir', 5, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (11, 'Merci', 5, null, 0);

-- ==========================================
-- CURSO 2: GERMAN (course_id = 2)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (2, 2, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (2, 'Unit 1', 'Learn basic German', 2, 1, 2, '/animations/unit2.json', 'BLUE');
INSERT INTO path_icons (unit_id, icon) VALUES (2, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (2, 'Lesson 1', 2, 1, 'Lesson', 'vocabulary');

-- Exercise 6
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (6, 2, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (12, 'Hallo', 6, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (13, 'Danke', 6, null, 0);

-- Exercise 7
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (7, 2, 'TRANSLATION', 'Translate "Thank you"', 2);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (14, 'Danke', 7, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (15, 'Tschüss', 7, null, 0);

-- Exercise 8
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (8, 2, 'TRANSLATION', 'Translate "Yes"', 3);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (16, 'Ja', 8, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (17, 'Nein', 8, null, 0);

-- Exercise 9
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (9, 2, 'TRANSLATION', 'Translate "No"', 4);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (18, 'Nein', 9, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (19, 'Ja', 9, null, 0);

-- Exercise 10
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (10, 2, 'TRANSLATION', 'Translate "Goodbye"', 5);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (20, 'Tschüss', 10, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (21, 'Hallo', 10, null, 0);

-- ==========================================
-- CURSO 3: SPANISH (course_id = 3)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (3, 3, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (3, 'Unit 1', 'Learn basic Spanish', 3, 1, 3, '/animations/unit3.json', 'PINK');
INSERT INTO path_icons (unit_id, icon) VALUES (3, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (3, 'Lesson 1', 3, 1, 'Lesson', 'vocabulary');

-- Exercise 11
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (11, 3, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (22, 'Hola', 11, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (23, 'Adiós', 11, null, 0);

-- Exercise 12
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (12, 3, 'TRANSLATION', 'Translate "Thank you"', 2);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (24, 'Gracias', 12, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (25, 'Por favor', 12, null, 0);

-- Exercise 13
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (13, 3, 'TRANSLATION', 'Translate "Yes"', 3);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (26, 'Sí', 13, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (27, 'No', 13, null, 0);

-- Exercise 14
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (14, 3, 'CLOZE', 'Buenos {días}', 4);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (28, 'días', 14, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (29, 'noches', 14, null, 0);

-- Exercise 15
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (15, 3, 'TRANSLATION', 'Translate "Goodbye"', 5);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (30, 'Adiós', 15, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (31, 'Hola', 15, null, 0);

-- Quests
INSERT INTO quest_definition (id, code, target, reward_points, active) VALUES (1, 'STREAK', 3, 50, 1);
INSERT INTO quest_definition (id, code, target, reward_points, active) VALUES (2, 'PERFECT', 1, 100, 1);
INSERT INTO quest_definition (id, code, target, reward_points, active) VALUES (3, 'ACCURACY', 3, 50, 1);
INSERT INTO quest_definition (id, code, target, reward_points, active) VALUES (4, 'COMPLETE_QUESTS', 5, 200, 1);

-- Monthly Challenge
INSERT INTO monthly_challenge_definition (id, code, target, reward_points, active) VALUES (1, 'MONTHLY_CHAMPION', 50, 1000, 1);
