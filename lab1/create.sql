-- Create tables

CREATE TABLE IF NOT EXISTS Person (
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    house_id INT NOT NULL, 
    age INT NOT NULL,
    gender FLOAT4 NOT NULL
);

CREATE TABLE IF NOT EXISTS Item (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    function VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    UNIQUE(owner_id),
    FOREIGN KEY(owner_id) REFERENCES Person(person_id),
    is_part_of_heritage BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS Location (
    location_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    description VARCHAR(69) NOT NULL,
    coords POINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Building (
    building_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    occupant VARCHAR(69) NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY(location_id) REFERENCES Location(location_id)
);

CREATE TABLE IF NOT EXISTS Infrastructure (
    infrastructure_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY(location_id) REFERENCES Location(location_id),
    height INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Vehicle (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    speed FLOAT8 NOT NULL,
    owner VARCHAR(69) NOT NULL
);

CREATE TABLE IF NOT EXISTS VehicleUsage (
    usage_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    FOREIGN KEY(person_id) REFERENCES Person(person_id),
    vehicle_id INT NOT NULL,
    FOREIGN KEY(vehicle_id) REFERENCES Vehicle(vehicle_id),
    UNIQUE (person_id, vehicle_id),
    timestamp TIME NOT NULL
);

-- Insert values

INSERT INTO Person (name, house_id, age, gender) VALUES
    ('Dr Floyd', 1, 69, 0.5),
    ('HAPIHAPIHAPICAT', 2, 2, 2.2),
    ('Alexey', 3, 46, 0.0),
    ('Maxwell', 4, 3, -2.1);

INSERT INTO Item (name, function, owner_id, is_part_of_heritage) VALUES
    ('flashlight', 'enlighten the surroundings', 1, TRUE),
    ('keychain', 'carefully store finely picked keys', 2, FALSE),
    ('Sergey', 'no specific purpose', 4, FALSE),
    ('heart', 'be brave', 3, TRUE);

INSERT INTO Location (name, description, coords) VALUES
    ('Florida plane', 'Florida plane', POINT(44.3340, 38.0437)),
    ('saint petersburg', 'pain pain pain', POINT(59.8, 30.3)),
    ('gelendzhik', 'mostly paradise', POINT(180.0, 180.0));

INSERT INTO Building (name, occupant, location_id) VALUES
    ('itmo', 2, 2),
    ('dvorets', 4, 1),
    ('panelka1', 3, 3),
    ('panelka2', 1, 2);

INSERT INTO Infrastructure (name, location_id, height) VALUES
    ('crane', 1, 25),
    ('projector', 1, 5),
    ('dock', 2, 2);

INSERT INTO Vehicle (name, speed, owner) VALUES
    ('plane', 456.7, 'pilot'),
    ('spaceship', 356785678.2, 'aliens'),
    ('car', 111.0, 'Dr Floyd');

INSERT INTO VehicleUsage (person_id, vehicle_id, timestamp) VALUES
    (1, 2, '04:05:06'),
    (1, 1, '08:05:00'),
    (2, 3, '23:45:11'),
    (3, 3, '16:02:24'),
    (4, 1, '24:02:22');