CREATE TABLE brew_type(
    brewId INT AUTO_INCREMENT PRIMARY KEY,
    brew_name VARCHAR(100) NOT NULL
);

CREATE TABLE team(
    teamId INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

CREATE TABLE user(
    userId INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(70) NOT NULL UNIQUE,
    phone varchar(20),
    password VARCHAR(70),
    teamId INT,
    CONSTRAINT fk_team
    FOREIGN KEY (teamId) 
        REFERENCES team(teamId)
);

CREATE TABLE preference(
    prefId INT AUTO_INCREMENT PRIMARY KEY,
    brewId INT,
    sugar INT,
    CONSTRAINT fk_brew_type
    FOREIGN KEY (brewId) 
        REFERENCES brew_type(brewId),
    userId INT,
    CONSTRAINT fk_user
    FOREIGN KEY (userId) 
        REFERENCES user(userId)
);