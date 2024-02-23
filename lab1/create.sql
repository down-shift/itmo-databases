-- Create tables

CREATE TABLE IF NOT EXISTS Person (
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    house_id INT 
        FOREIGN KEY REFERENCES Building(building_id), -- CHECK
    age INT NOT NULL,
    gender FLOAT4 NOT NULL
);

CREATE TABLE IF NOT EXISTS Item (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    function VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL 
        UNIQUE FOREIGN KEY REFERENCES Person(person_id),
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
    location_id INT NOT NULL
        FOREIGN KEY REFERENCES Location(location_id)
);

CREATE TABLE IF NOT EXISTS Infrastructure (
    infrastructure_id SERIAL PRIMARY KEY,
    name VARCHAR(69) NOT NULL,
    location_id INT NOT NULL
        FOREIGN KEY REFERENCES Location(location_id),
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
    person_id INT NOT NULL
        FOREIGN KEY REFERENCES Person(person_id),
    vehicle_id INT NOT NULL
        FOREIGN KEY REFERENCES Vehicle(vehicle_id),
    UNIQUE (person_id, vehicle_id),
    timestamp TIME NOT NULL
);

-- Insert values

