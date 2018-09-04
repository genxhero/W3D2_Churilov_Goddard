PRAGMA foreign_keys = ON;

DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE questions;
DROP TABLE replies;
DROP TABLE users;


CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255),
  author INTEGER,
  FOREIGN KEY (author) REFERENCES users(id)
);

CREATE TABLE question_follows(
  user_id  INT NOT NULL,
  question_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INT,
  parent_id INT,
  replier_id INT NOT NULL,
  subject VARCHAR(255) NOT NULL,
  body VARCHAR(500),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
  --attempt to associate parent reply with child reply
);

CREATE TABLE question_likes(
  user_id INT NOT NULL,
  question_id INT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN Key (user_id) REFERENCES users(id)
);

INSERT INTO 
users (fname, lname)
  VALUES
  ('Artemis', 'Entreri'), ('Bilbo', 'Baggins'), ('Harry', 'Potter'), ('Hiro', 'Protagonist');

INSERT INTO 
questions (title, body, author)
VALUES 
 ('How does this thing work?', "I can't figure this out, can someone please help me? Anyone but You. Know. WHo", 1),
 ('What have I got in my pocket?', 'Oh bother. It"s dark. I can scarcely tell what is in my waistcoat pocket', 2),
 ('Hiring Practices', 'Seriously, stop assigning villains to the Defense against the Dark Arts department!', 3),
 ('Pizza delivery in the FInancial District', 'Where are we supposed to stop here? It seems every blasted spot is a no stopping zone@', 4);
 
 INSERT INTO 
 replies (question_id, parent_id, replier_id, subject, body)
 VALUES
 (1, NULL, 2, 'Darkness', "I wish I could help you, but I can't see more than the pale glow of my mobile device"),
 (1, 1, 1, "", ""),
 (1, 2, 1, "Reply", "To Reply");
 
 INSERT INTO
 question_likes (user_id, question_id)
 VALUES (4, 3), (2, 3), (4, 1), (1, 3), (3, 3);
 
 INSERT INTO
 question_follows (user_id, question_id)
 VALUES (3, 2), (1, 2), (1, 4);
 
 INSERT INTO 
 users (fname, lname)
VALUES
   ('Hiro', 'Yuuy'), 
   ('Frodo', 'Baggins');
 
 