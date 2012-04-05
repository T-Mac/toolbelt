CREATE TABLE stats
       (id SERIAL PRIMARY KEY,
        os VARCHAR(255) NOT NULL,
        stamp TIMESTAMP NOT NULL DEFAULT NOW());

CREATE INDEX ts_index ON stats(stamp);
