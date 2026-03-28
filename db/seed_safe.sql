-- Esse script usa 'INSERT IGNORE' para ignorar registros duplicados ou conflitos de ID.
-- Se o Railway parou a execução de 'seed.sql' no meio do caminho por conta de um erro na tabela 'course' ou 'sections',
-- este script vai pular o erro e inserir apenas o que está faltando.

INSERT IGNORE INTO course (id, image_src, title) VALUES 
(1, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/7488bd7cd28b768ec2469847a5bc831e.svg', 'FRENCH'),
(2, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/097f1c20a4f421aa606367cd33893083.svg', 'GERMAN'),
(3, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/40a9ce3dfafe484bced34cdc124a59e4.svg', 'SPANISH');

INSERT IGNORE INTO sections (id, course_id, order_index, title) VALUES 
(1, 1, 1, 'Section 1 - Basics'),
(2, 2, 1, 'Section 1 - Basics'),
(3, 3, 1, 'Section 1 - Basics');

INSERT IGNORE INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) VALUES 
(1, 'Unit 1', 'Learn basic French', 1, 1, 1, '/animations/unit1.json', '#52CD00'),
(2, 'Unit 1', 'Learn basic German', 2, 1, 2, '/animations/unit2.json', '#1CB0F6'),
(3, 'Unit 1', 'Learn basic Spanish', 3, 1, 3, '/animations/unit3.json', '#FF4B4B');

INSERT IGNORE INTO path_icons (unit_id, icon) VALUES 
(1, 'star'), 
(2, 'star'), 
(3, 'star');

INSERT IGNORE INTO lessons (id, title, unit_id, order_index, type, lesson_type) VALUES 
(1, 'Lesson 1', 1, 1, 'Lesson', 'vocabulary'),
(2, 'Lesson 1', 2, 1, 'Lesson', 'vocabulary'),
(3, 'Lesson 1', 3, 1, 'Lesson', 'vocabulary');

INSERT IGNORE INTO exercises (id, lesson_id, type, prompt, order_index) VALUES 
(1, 1, 'TRANSLATION', 'Translate "Hello"', 1),
(2, 2, 'TRANSLATION', 'Translate "Hello"', 1),
(3, 3, 'TRANSLATION', 'Translate "Hello"', 1);

INSERT IGNORE INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES 
(1, 'Bonjour', 1, null, 1),
(2, 'Merci', 1, null, 0),
(3, 'Hallo', 2, null, 1),
(4, 'Danke', 2, null, 0),
(5, 'Hola', 3, null, 1),
(6, 'Gracias', 3, null, 0);
