CREATE TABLE stats
       (id SERIAL PRIMARY KEY,
        os VARCHAR(255) NOT NULL,
        user_agent VARCHAR(255),
        ip VARCHAR(255),
        referer VARCHAR(255),
        stamp TIMESTAMP NOT NULL DEFAULT NOW());

CREATE INDEX ts_index ON stats(stamp);
