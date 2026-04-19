-- Eski ve yeni sql kodlarına bakıp sizin kendi dosyanızda kullandığınız kodlar neler karşılaştırın yapılan değişiklik size uygun mu kontrol edin 
--uygun gördüğünüz sql kodlarını da buraya ekleyelelim
--ben experience tablosunda interview_questionsu çıkartmayı öneriyorum
--diğer kodların değiştirilmesi çok gerekli değil istediğiniz şekliyle ekleyebilir veya başka ekleme çıkarma da yapmak istiyorsanız bunları da yazabilirsiniz son hali burada dursun

--php kodlarında mentorship_db ismiyle bağlanılsın dediğimiz için sql adını bu şekilde seçtim, kodları buraya geçirip kararlaştırdıktan sonra diğer schema sqlleri silelim
--xampp de sql kısmında admine girip diğer versiyonu silip bu dosyayı eklediğimizde yeni haliyle işlem yapmış olacağız 
--php kodları xampp içerisinde htdocs klasorunde oluşturduğunuz proje dosyasında veya nerede oluşturduysanız kalmaya devam edebilir burada değişikliğe ihtiyaç yok 
--sadece kodu değiştirmeye/güncellemeye karar verdiyseniz sql ile uyumlu olup olmadığını da kontrol etmek gerekli olabilir

--sql tabloları son hali:
CREATE TABLE auth_logs (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NULL,
    is_success BOOLEAN DEFAULT FALSE,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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
