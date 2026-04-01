USE portfolio_saas;

-- THEMES
INSERT INTO themes (name, font_family, primary_color, layout_type) VALUES
('Minimal Dark', 'Inter', '#1a1a1a', 'single-column'),
('Creative Light', 'Poppins', '#4f46e5', 'grid'),
('Professional Blue', 'Roboto', '#2563eb', 'sidebar');

-- USERS
INSERT INTO users (email, password_hash, status) VALUES
('anderson@example.com', 'hash_123', 'active'),
('sofia@example.com', 'hash_456', 'active'),
('martin@example.com', 'hash_789', 'inactive'),
('lucia@example.com', 'hash_321', 'active'),
('juan@example.com', 'hash_654', 'active');

-- PROFILES
INSERT INTO profiles (user_id, full_name, title, bio, profile_image, subdomain, theme_id) VALUES
(1, 'Anderson Ocaña', 'Backend Developer', 'Especialista en Node.js y SQL', 'anderson.jpg', 'anderson', 1),
(2, 'Sofia Perez', 'UX/UI Designer', 'Diseño de experiencias digitales', 'sofia.jpg', 'sofia-design', 2),
(3, 'Martin Lopez', 'Data Analyst', 'Visualización y reporting', 'martin.jpg', 'martin-data', 3),
(4, 'Lucia Gomez', 'Frontend Developer', 'Vue y React developer', 'lucia.jpg', 'lucia-dev', 2),
(5, 'Juan Torres', 'Photographer', 'Portfolio visual profesional', 'juan.jpg', 'juan-photo', 1);

-- SOCIAL LINKS
INSERT INTO social_links (profile_id, platform, url) VALUES
(1, 'LinkedIn', 'https://linkedin.com/anderson'),
(1, 'GitHub', 'https://github.com/anderson'),
(2, 'Behance', 'https://behance.net/sofia'),
(3, 'LinkedIn', 'https://linkedin.com/martin'),
(4, 'GitHub', 'https://github.com/lucia'),
(5, 'Instagram', 'https://instagram.com/juan');

-- SKILLS
INSERT INTO skills (name, category) VALUES
('JavaScript', 'Programming'),
('MySQL', 'Database'),
('Vue.js', 'Frontend'),
('Figma', 'Design'),
('Python', 'Data'),
('Photography', 'Creative');

-- PROFILE SKILLS
INSERT INTO profile_skills (profile_id, skill_id, level) VALUES
(1, 1, 'Advanced'),
(1, 2, 'Advanced'),
(2, 4, 'Expert'),
(3, 5, 'Advanced'),
(4, 3, 'Advanced'),
(5, 6, 'Expert');

-- PROJECTS
INSERT INTO projects (profile_id, title, description, url, repository_url, featured) VALUES
(1, 'API REST Ecommerce', 'API con Node y MySQL', 'https://anderson.site/api', 'https://github.com/anderson/api', TRUE),
(1, 'Sistema SaaS', 'Plataforma multi tenant', 'https://anderson.site/saas', 'https://github.com/anderson/saas', TRUE),
(2, 'Rediseño App Mobile', 'UX para fintech', 'https://sofia.site/app', NULL, TRUE),
(3, 'Dashboard BI', 'KPIs de negocio', 'https://martin.site/bi', NULL, FALSE),
(4, 'Task Manager Vue', 'Gestor de tareas drag and drop', 'https://lucia.site/task', 'https://github.com/lucia/task', TRUE),
(5, 'Wedding Portfolio', 'Sesiones fotográficas', 'https://juan.site/photos', NULL, TRUE);

-- PROJECT IMAGES
INSERT INTO project_images (project_id, image_url, sort_order) VALUES
(1, 'api_1.png', 1),
(1, 'api_2.png', 2),
(2, 'saas_1.png', 1),
(3, 'ux_1.png', 1),
(4, 'dashboard_1.png', 1),
(5, 'task_1.png', 1),
(6, 'photo_1.png', 1);

-- EXPERIENCES
INSERT INTO experiences (profile_id, company_name, role, start_date, end_date, description) VALUES
(1, 'Tech Solutions', 'Backend Developer', '2023-01-01', NULL, 'Desarrollo de APIs'),
(2, 'Creative Studio', 'UX Designer', '2022-06-01', NULL, 'Diseño de interfaces'),
(3, 'Analytics Corp', 'Data Analyst', '2021-03-01', NULL, 'Dashboards ejecutivos'),
(4, 'Web Agency', 'Frontend Developer', '2024-01-01', NULL, 'Aplicaciones SPA'),
(5, 'Freelance', 'Photographer', '2020-01-01', NULL, 'Sesiones fotográficas');

-- EDUCATION
INSERT INTO education (profile_id, institution, degree, start_date, end_date) VALUES
(1, 'UTN', 'Tecnicatura en Programación', '2020-01-01', '2022-12-31'),
(2, 'UBA', 'Diseño Gráfico', '2019-01-01', '2023-12-31'),
(3, 'UADE', 'Licenciatura en Datos', '2018-01-01', '2022-12-31'),
(4, 'Coderhouse', 'Frontend Career', '2023-01-01', '2023-12-31'),
(5, 'Escuela Creativa', 'Fotografía Profesional', '2019-01-01', '2021-12-31');

-- PLANS
INSERT INTO plans (name, monthly_price, features) VALUES
('Free', 0.00, 'Subdomain + basic template'),
('Pro', 9.99, 'Custom template + analytics'),
('Premium', 19.99, 'Custom domain + premium analytics');

-- SUBSCRIPTIONS
INSERT INTO subscriptions (user_id, plan_id, start_date, end_date, status) VALUES
(1, 2, '2026-01-01', NULL, 'active'),
(2, 3, '2026-01-10', NULL, 'active'),
(3, 1, '2026-01-15', NULL, 'active'),
(4, 2, '2026-02-01', NULL, 'active'),
(5, 1, '2026-02-10', NULL, 'active');

-- PAYMENTS
INSERT INTO payments (subscription_id, amount, currency, payment_date, payment_status) VALUES
(1, 9.99, 'USD', '2026-03-01', 'paid'),
(2, 19.99, 'USD', '2026-03-01', 'paid'),
(4, 9.99, 'USD', '2026-03-05', 'paid');

-- VISITS
INSERT INTO visits (profile_id, visit_date, visitor_country, device_type, referrer, duration_seconds) VALUES
(1, '2026-03-20', 'Argentina', 'Mobile', 'Google', 120),
(1, '2026-03-21', 'Chile', 'Desktop', 'LinkedIn', 240),
(2, '2026-03-21', 'Argentina', 'Mobile', 'Instagram', 180),
(3, '2026-03-22', 'Uruguay', 'Desktop', 'Direct', 90),
(4, '2026-03-22', 'Argentina', 'Tablet', 'Google', 200),
(5, '2026-03-23', 'Brazil', 'Mobile', 'Instagram', 300);

-- NOTIFICATIONS
INSERT INTO notifications (user_id, message, is_read) VALUES
(1, 'Pago procesado correctamente', FALSE),
(2, 'Tu plan Premium está activo', TRUE),
(4, 'Nueva visita registrada en tu portfolio', FALSE);
