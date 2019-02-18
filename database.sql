CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL
);

CREATE TABLE todos (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255),
  user_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES user(id)
);

CREATE TABLE subtasks (
  id INTEGER PRIMARY KEY,
  content VARCHAR(255) NOT NULL,
  todo_id INTEGER,

  FOREIGN KEY(todo_id) REFERENCES todos(id)
);

-- INSERT INTO
--   users (id, name)
-- VALUES
--   (1, "nader");

-- INSERT INTO
--   todos (id, title,body,user_id)
-- VALUES
--   (1, "finish project","destroy it",1),(2, "sleep","just do it",1);

-- INSERT INTO
--   subtasks (id, content,todo_id)
-- VALUES
--   (1, "just dont die",1),(2, "you need it",2);