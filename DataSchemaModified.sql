-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE IF EXISTS social_support CASCADE;
DROP TABLE IF EXISTS motivational_literature CASCADE;
DROP TABLE IF EXISTS recommended_literature CASCADE;
DROP TABLE IF EXISTS psychological_state CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS platform CASCADE;

-- Створення таблиці platform
CREATE TABLE platform (
    platform_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор платформи
    name VARCHAR(255) NOT NULL UNIQUE, -- Назва платформи
    purpose VARCHAR(255) NOT NULL -- Призначення платформи
);

-- Створення таблиці users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    preferences VARCHAR(255) NOT NULL,
    -- Жанрові та активні уподобання користувача
    therapy_results VARCHAR(500) -- Результати терапевтичних сесій користувача
);

-- Створення таблиці psychological_state
CREATE TABLE psychological_state (
    state_id SERIAL PRIMARY KEY,
    -- Унікальний ідентифікатор психологічного стану
    name VARCHAR(255) NOT NULL UNIQUE, -- Назва психологічного стану
    description VARCHAR(500), -- Опис емоційного стану
    user_id INT REFERENCES NonExistentTable(user_id)
    ON DELETE CASCADE -- Посилання на користувача
);

-- Створення таблиці recommended_literature
CREATE TABLE recommended_literature (
    literature_id SERIAL PRIMARY KEY,
    -- Унікальний ідентифікатор рекомендованої літератури
    genre VARCHAR(255) NOT NULL, -- Жанр рекомендованої літератури
    rating FLOAT CHECK (rating >= 0.0 AND rating <= 5.0), -- Рейтинг
    user_id INT REFERENCES users (user_id)
    ON DELETE CASCADE, -- Посилання на користувача
    platform_id INT REFERENCES platform (platform_id)
    ON DELETE CASCADE -- Посилання на платформу
);

-- Створення таблиці motivational_literature
CREATE TABLE motivational_literature (
    motivational_id SERIAL PRIMARY KEY,
    -- Унікальний ідентифікатор мотивуючої літератури
    title VARCHAR(255) NOT NULL UNIQUE, -- Назва мотивуючої літератури
    author VARCHAR(255), -- Автор мотивуючої літератури
    user_id INT REFERENCES users (user_id)
    ON DELETE CASCADE -- Посилання на користувача
);

-- Створення таблиці social_support
CREATE TABLE social_support (
    support_id SERIAL PRIMARY KEY,
    -- Унікальний ідентифікатор соціальної підтримки
    support_type VARCHAR(255) NOT NULL, -- Тип соціальної підтримки
    user_id INT REFERENCES users (user_id)
    ON DELETE CASCADE, -- Посилання на користувача
    platform_id INT REFERENCES platform (platform_id)
    ON DELETE CASCADE -- Посилання на платформу
);

-- Обмеження на вміст атрибутів таблиці users
ALTER TABLE users ADD CONSTRAINT check_preferences CHECK (preferences <> '');
ALTER TABLE users ADD CONSTRAINT check_therapy_results CHECK
(therapy_results IS NULL OR LENGTH(therapy_results) <= 500);
