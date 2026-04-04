import pg from 'pg';
const { Client } = pg;

const DB_URL = "postgresql://ludolang_db_user:b3F1eW5gLhBwN55NZ7fL2MHIADOozIQj@dpg-d77t1af5r7bs739jgm7g-a.oregon-postgres.render.com/ludolang_db";

const SQL = `
INSERT INTO course (id, image_src, title) VALUES
  (1, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/7488bd7cd28b768ec2469847a5bc831e.svg', 'FRENCH'),
  (2, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/097f1c20a4f421aa606367cd33893083.svg', 'GERMAN'),
  (3, 'https://d35aaqx5ub95lt.cloudfront.net/images/borderlessFlags/40a9ce3dfafe484bced34cdc124a59e4.svg', 'SPANISH')
ON CONFLICT DO NOTHING;

INSERT INTO sections (id, course_id, order_index, title) VALUES
  (1, 1, 1, 'Section 1 - Basics'),
  (2, 2, 1, 'Section 1 - Basics'),
  (3, 3, 1, 'Section 1 - Basics')
ON CONFLICT DO NOTHING;

INSERT INTO units (id, title, description, section_id, order_index, course_id, animation_path, color) VALUES
  (1, 'Unit 1', 'Learn basic French', 1, 1, 1, '/animations/unit1.json', 'GREEN'),
  (2, 'Unit 1', 'Learn basic German', 2, 1, 2, '/animations/unit2.json', 'BLUE'),
  (3, 'Unit 1', 'Learn basic Spanish', 3, 1, 3, '/animations/unit3.json', 'PINK')
ON CONFLICT DO NOTHING;

INSERT INTO lessons (id, title, unit_id, order_index, lesson_type) VALUES
  (1, 'Lesson 1', 1, 1, 'vocabulary'),
  (2, 'Lesson 1', 2, 1, 'vocabulary'),
  (3, 'Lesson 1', 3, 1, 'vocabulary')
ON CONFLICT DO NOTHING;

INSERT INTO exercises (id, lesson_id, type, prompt, order_index) VALUES
  (1, 1, 'TRANSLATION', 'Translate "Hello"', 1),
  (2, 1, 'TRANSLATION', 'Translate "Thank you"', 2),
  (3, 1, 'TRANSLATION', 'Translate "Goodbye"', 3),
  (4, 2, 'TRANSLATION', 'Translate "Hello"', 1),
  (5, 2, 'TRANSLATION', 'Translate "Thank you"', 2),
  (6, 2, 'TRANSLATION', 'Translate "Goodbye"', 3),
  (7, 3, 'TRANSLATION', 'Translate "Hello"', 1),
  (8, 3, 'TRANSLATION', 'Translate "Thank you"', 2),
  (9, 3, 'TRANSLATION', 'Translate "Goodbye"', 3)
ON CONFLICT DO NOTHING;

INSERT INTO exercise_options (id, content, exercise_id, image_url, is_correct) VALUES
  (1, 'Bonjour', 1, null, true),
  (2, 'Merci', 1, null, false),
  (3, 'Au revoir', 1, null, false),
  (4, 'Merci', 2, null, true),
  (5, 'Bonjour', 2, null, false),
  (6, 'Oui', 2, null, false),
  (7, 'Au revoir', 3, null, true),
  (8, 'Bonjour', 3, null, false),
  (9, 'Merci', 3, null, false),
  (10, 'Hallo', 4, null, true),
  (11, 'Danke', 4, null, false),
  (12, 'Nein', 4, null, false),
  (13, 'Danke', 5, null, true),
  (14, 'Hallo', 5, null, false),
  (15, 'Ja', 5, null, false),
  (16, 'Tschuss', 6, null, true),
  (17, 'Hallo', 6, null, false),
  (18, 'Danke', 6, null, false),
  (19, 'Hola', 7, null, true),
  (20, 'Adios', 7, null, false),
  (21, 'Gracias', 7, null, false),
  (22, 'Gracias', 8, null, true),
  (23, 'Hola', 8, null, false),
  (24, 'Por favor', 8, null, false),
  (25, 'Adios', 9, null, true),
  (26, 'Hola', 9, null, false),
  (27, 'Si', 9, null, false)
ON CONFLICT DO NOTHING;

INSERT INTO quest_definition (id, code, target, reward_points, active) VALUES
  (1, 'STREAK', 3, 50, true),
  (2, 'PERFECT', 1, 100, true),
  (3, 'ACCURACY', 3, 50, true)
ON CONFLICT DO NOTHING;

INSERT INTO monthly_challenge_definition (id, code, target, reward_points, active) VALUES
  (1, 'MONTHLY_CHAMPION', 50, 1000, true)
ON CONFLICT DO NOTHING;
`;

const client = new Client({
  connectionString: DB_URL,
  ssl: { rejectUnauthorized: false }
});

try {
  await client.connect();
  console.log('Conectado ao banco!');
  await client.query(SQL);
  console.log('✅ Seed executado com sucesso!');
} catch (err) {
  console.error('❌ Erro:', err.message);
} finally {
  await client.end();
}
