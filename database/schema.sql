-- ==========================================
-- 1. ANA TABLOLAR
-- ==========================================

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'graduate', 'admin') NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE NOT NULL,
    birth_date DATE NULL,
    gender ENUM('male', 'female', 'other') NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP NULL
);

CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    industry VARCHAR(255) NOT NULL,
    website_url VARCHAR(255),
    FULLTEXT(name)
);

CREATE TABLE positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL
);

CREATE TABLE skills (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    skill_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE forum_categories (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    name VARCHAR(100) UNIQUE NOT NULL 
);

-- ==========================================
-- 2. KULLANICI TÜRLERİ VE PROFİLLER
-- ==========================================

CREATE TABLE students (
    user_id INT PRIMARY KEY NOT NULL,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    department VARCHAR(255) NOT NULL,
    grade INT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE graduates (
    user_id INT PRIMARY KEY NOT NULL,
    graduate_year INT NOT NULL,
    document_link TEXT NULL,
    is_open_to_mentorship BOOLEAN DEFAULT FALSE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE admins (
    user_id INT PRIMARY KEY NOT NULL,
    admin_level INT DEFAULT 1 NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE profiles (
    user_id INT PRIMARY KEY NOT NULL,
    bio TEXT NULL,
    website_url VARCHAR(255) NULL,
    linkedin_url VARCHAR(255) NULL,
    current_company_id INT NULL,
    current_position_id INT NULL,
    location VARCHAR(255) NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (current_company_id) REFERENCES companies(id) ON DELETE SET NULL,
    FOREIGN KEY (current_position_id) REFERENCES positions(id) ON DELETE SET NULL,
    FULLTEXT(bio)
);

-- ==========================================
-- 3. İLİŞKİSEL TABLOLAR
-- ==========================================

CREATE TABLE user_skills (
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (user_id, skill_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
);

CREATE TABLE experiences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company_id INT NOT NULL,
    position_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE CASCADE
);


CREATE TABLE company_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    is_anonymous BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ==========================================
-- 4. MENTÖRLÜK SİSTEMİ (SADELEŞTİRİLMİŞ)
-- ==========================================
CREATE TABLE mentor_ads (
    ads_id INT PRIMARY KEY AUTO_INCREMENT,
    graduate_id INT NOT NULL, 
    expertise VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (graduate_id) REFERENCES graduates(user_id) ON DELETE CASCADE
);

CREATE TABLE mentor_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    ads_id INT NOT NULL, 
    student_id INT NOT NULL, 
    message TEXT,
    status ENUM('Waiting', 'Approved', 'Rejected') DEFAULT 'Waiting',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ads_id) REFERENCES mentor_ads(ads_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE
);


-- ==========================================
-- 5. FORUM
-- ==========================================

CREATE TABLE forum_posts (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_anonymous BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES forum_categories(id) ON DELETE CASCADE,
    FULLTEXT(title, content)
);

CREATE TABLE forum_comments (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    parent_comment_id INT NULL,
    content TEXT NOT NULL,
    is_anonymous BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES forum_comments(id) ON DELETE SET NULL
);

-- ==========================================
-- 6. MESAJLAŞMA (MENTORSHIP BAĞLI)
-- ==========================================

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mentorship_id INT NOT NULL,
    sender_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mentorship_id) REFERENCES mentorships(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ==========================================
-- 7. AUTH LOGS
-- ==========================================

CREATE TABLE auth_logs (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NULL,
    is_success BOOLEAN DEFAULT FALSE,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
/* Mevcut veritabanı şemasını sadeleştirerek mentor_ads ve mentor_applications tablolarını sildim; 
süreci daha modüler hale getirmek amacıyla mentor_requests ve mentorships olarak güncelledim. 
Mesajlaşma özelliğini doğrudan aktif eşleşmelere bağlamak için messages tablosuna mentorship_id alanını ekledim. 
Ayrıca arama performansını artırmak için ilgili tablolara FULLTEXT indeksleri tanımladım 
ve karmaşıklığı azaltmak amacıyla interview_experiences indexini experiences tablosundan çıkardım 
bu reviewslerde içeriğe ya da forumlarda konuşulabilir */





