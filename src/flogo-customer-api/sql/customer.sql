
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,  -- SERIAL provides automatic, incrementing IDs
    name VARCHAR(255) NOT NULL, -- Name, up to 255 characters, required
    email VARCHAR(255) UNIQUE NOT NULL, -- Email, up to 255 characters, unique, required
    age INTEGER, -- Age, integer, can be NULL
    city VARCHAR(255) -- City, up to 255 characters, can be NULL
);

-- Example data insertion (you can add more rows as needed)
INSERT INTO customers (name, email, age, city) VALUES
('John Doe', 'john.doe@example.com', 30, 'New York'),
('Jane Smith', 'jane.smith@example.com', 25, 'London'),
('David Lee', 'david.lee@example.com', 40, 'Paris'),
('Alice Johnson', 'alice.johnson@example.com', 22, 'Tokyo'),  
('Bob Williams', 'bob.williams@example.com', 35, 'Sydney');