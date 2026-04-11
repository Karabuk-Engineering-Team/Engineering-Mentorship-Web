CREATE TABLE COMPANIES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    industry VARCHAR(255) NOT NULL,
    website_url VARCHAR(255)
);

CREATE TABLE POSITIONS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL
);

CREATE TABLE EXPERIENCES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,              
    company_id INT NOT NULL,           
    position_id INT NOT NULL,          
    start_date DATE NOT NULL,
    end_date DATE NULL,
    interview_questions TEXT NULL,
    
    CONSTRAINT fk_exp_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_exp_company FOREIGN KEY (company_id) REFERENCES COMPANIES(id) ON DELETE CASCADE,
    CONSTRAINT fk_exp_position FOREIGN KEY (position_id) REFERENCES POSITIONS(id) ON DELETE CASCADE
);

CREATE TABLE COMPANY_REVIEWS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    is_anonymous TINYINT(1) DEFAULT 0 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  
    CONSTRAINT fk_rev_company FOREIGN KEY (company_id) REFERENCES COMPANIES(id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE forum_categories (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    name VARCHAR(100) UNIQUE NOT NULL 
);

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

    INDEX (user_id),
    INDEX (category_id),
    INDEX (created_at)
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
    FOREIGN KEY (parent_comment_id) REFERENCES forum_comments(id) ON DELETE SET NULL,

    INDEX (post_id),
    INDEX (user_id),
    INDEX (post_id, parent_comment_id)
);

CREATE TABLE auth_logs (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    INDEX (user_id),
    INDEX (login_time)
);





