--RIVERS STATE REAL ESTATE ANALYSIS SQL QUERIES 
--AUTHOUR: OVUNDAH CHIDINDU TEMPLE
--mysql workbench

--use of database

use real_estate;

--creation of table

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    neighbourhood VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    avg_price_per_sqm DECIMAL(15,2)
);

CREATE TABLE properties (
    property_id INT PRIMARY KEY,
    title VARCHAR(255),
    property_type VARCHAR(50),
    bedrooms INT,
    bathrooms INT,
    size_sqm DECIMAL(10,2),
    location_id INT,
    listing_price DECIMAL(15,2),
    status VARCHAR(50),
    listed_date DATE,

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    property_id INT,
    transaction_date DATE,
    transaction_price DECIMAL(15,2),
    transaction_type VARCHAR(50),
    agent_id INT,

    FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
);


-- Query 1: Verify Row Counts

SELECT COUNT(*) AS total_locations
FROM locations;

SELECT COUNT(*) AS total_properties
FROM properties;

SELECT COUNT(*) AS total_transactions
FROM transactions;

--Query 2: Average Transaction Price by Neighborhood

SELECT
    l.neighbourhood,
    ROUND(AVG(t.transaction_price), 2) AS avg_transaction_price,
    COUNT(*) AS transaction_count
FROM transactions t
JOIN properties p
    ON t.property_id = p.property_id
JOIN locations l
    ON p.location_id = l.location_id
GROUP BY l.neighbourhood
ORDER BY avg_transaction_price DESC;

-- Query 3: Average Price per Square Meter by Neighborhood

SELECT
    l.neighbourhood,
    ROUND(AVG(t.transaction_price / p.size_sqm), 2) AS avg_price_per_sqm,
    COUNT(*) AS transaction_count
FROM transactions t
JOIN properties p
    ON t.property_id = p.property_id
JOIN locations l
    ON p.location_id = l.location_id
GROUP BY l.neighbourhood
ORDER BY avg_price_per_sqm DESC;

-- Query 4: Average Price per Square Meter by Neighborhood (Volume

SELECT
    l.neighbourhood,
    ROUND(AVG(t.transaction_price / p.size_sqm), 2) AS avg_price_per_sqm,
    COUNT(*) AS transaction_count,
    ROUND(AVG(t.transaction_price), 2) AS avg_transaction_price
FROM transactions t
JOIN properties p
    ON t.property_id = p.property_id
JOIN locations l
    ON p.location_id = l.location_id
GROUP BY l.neighbourhood
ORDER BY avg_price_per_sqm DESC;

-- Query 5: Revenue by Property Type

SELECT
    property_type,
    COUNT(*) AS transactions,
    ROUND(AVG(transaction_price), 2) AS avg_transaction_price,
    ROUND(SUM(transaction_price), 2) AS total_revenue
FROM transactions t
JOIN properties p
    ON t.property_id = p.property_id
GROUP BY property_type
ORDER BY total_revenue DESC;


-- Query 6: Market Trend Analysis

SELECT
    YEAR(STR_TO_DATE(transaction_date, '%Y-%m-%d')) AS year,
    COUNT(*) AS transactions,
    ROUND(AVG(transaction_price), 2) AS avg_price,
    ROUND(SUM(transaction_price), 2) AS total_market_value
FROM transactions
GROUP BY YEAR(STR_TO_DATE(transaction_date, '%Y-%m-%d'))
ORDER BY year;
