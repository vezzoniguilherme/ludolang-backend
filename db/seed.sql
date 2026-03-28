-- Inserções básicas para que o backend não dê erro ao selecionar cursos
-- (Requer que a tabela 'course' já tenha os cursos 1, 2 e 3 inseridos)

-- ==========================================
-- CURSO 1: FRENCH (course_id = 1)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (1, 1, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (1, 'Unit 1', 'Learn basic French', 1, 1, 1, '/animations/unit1.json', '#52CD00');
INSERT INTO path_icons (unit_id, icon) VALUES (1, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (1, 'Lesson 1', 1, 1, 'Lesson', 'vocabulary');

-- Cria um exercício básico caso tente abrir a lição
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (1, 1, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (1, 'Bonjour', 1, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (2, 'Merci', 1, null, 0);

-- ==========================================
-- CURSO 2: GERMAN (course_id = 2)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (2, 2, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (2, 'Unit 1', 'Learn basic German', 2, 1, 2, '/animations/unit2.json', '#1CB0F6');
INSERT INTO path_icons (unit_id, icon) VALUES (2, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (2, 'Lesson 1', 2, 1, 'Lesson', 'vocabulary');

-- Cria um exercício básico caso tente abrir a lição
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (2, 2, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (3, 'Hallo', 2, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (4, 'Danke', 2, null, 0);

-- ==========================================
-- CURSO 3: SPANISH (course_id = 3)
-- ==========================================
INSERT INTO sections (id, course_id, order_index, title) VALUES (3, 3, 1, 'Section 1 - Basics');
INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) 
  VALUES (3, 'Unit 1', 'Learn basic Spanish', 3, 1, 3, '/animations/unit3.json', '#FF4B4B');
INSERT INTO path_icons (unit_id, icon) VALUES (3, 'star');
INSERT INTO lessons (id, title, unit_id, order_index, type, lesson_type) 
  VALUES (3, 'Lesson 1', 3, 1, 'Lesson', 'vocabulary');

-- Cria um exercício básico caso tente abrir a lição
INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES (3, 3, 'TRANSLATION', 'Translate "Hello"', 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (5, 'Hola', 3, null, 1);
INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES (6, 'Gracias', 3, null, 0);
