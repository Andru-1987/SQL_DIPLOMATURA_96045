CREATE DATABASE IF NOT EXISTS portfolio_saas;
USE portfolio_saas;

CREATE TABLE themes (
    theme_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    font_family VARCHAR(200),
    primary_color VARCHAR(200),
    layout_type VARCHAR(200)
);

CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(200) NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(200) NOT NULL
);

CREATE TABLE profiles (
    profile_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    full_name VARCHAR(200) NOT NULL,
    title VARCHAR(200),
    bio VARCHAR(200),
    profile_image VARCHAR(200),
    subdomain VARCHAR(200) NOT NULL UNIQUE,
    theme_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (theme_id) REFERENCES themes(theme_id)
);

CREATE TABLE social_links (
    social_link_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    platform VARCHAR(200) NOT NULL,
    url VARCHAR(200) NOT NULL,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE skills (
    skill_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(200)
);

CREATE TABLE profile_skills (
    profile_skill_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    skill_id BIGINT,
    level VARCHAR(200),
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

CREATE TABLE projects (
    project_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    title VARCHAR(200) NOT NULL,
    description VARCHAR(200),
    url VARCHAR(200),
    repository_url VARCHAR(200),
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE project_images (
    image_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT,
    image_url VARCHAR(200) NOT NULL,
    sort_order INT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE experiences (
    experience_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    company_name VARCHAR(200) NOT NULL,
    role VARCHAR(200) NOT NULL,
    start_date DATE,
    end_date DATE,
    description VARCHAR(200),
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE education (
    education_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    institution VARCHAR(200) NOT NULL,
    degree VARCHAR(200) NOT NULL,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE plans (
    plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    monthly_price DECIMAL(10,2) NOT NULL,
    features VARCHAR(200)
);

CREATE TABLE subscriptions (
    subscription_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    plan_id BIGINT,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(200) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

CREATE TABLE payments (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(200) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status VARCHAR(200) NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE visits (
    visit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT,
    visit_date DATE NOT NULL,
    visitor_country VARCHAR(200),
    device_type VARCHAR(200),
    referrer VARCHAR(200),
    duration_seconds INT,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE notifications (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    message VARCHAR(200) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
