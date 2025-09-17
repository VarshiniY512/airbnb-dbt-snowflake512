# airbnb-dbt-snowflake512
Airbnb Data Warehouse using dbt &amp; Snowflake — end-to-end data modeling project with staging, fact, and dimension tables, plus testing and documentation for self-service analytics.
Running dbt docs serve will launch the documentation hosted in a web server, which contains the updated lineage.

This is a rough list of all objects at initial commit.

Raw Layer
airbnb.reviews
airbnb.listings
airbnb.hosts
seed_full_moon_dates

Staging Layer
src_reviews
src_listings
src_hosts

Core Layer
scd_raw_listings
dim_hosts_cleansed
dim_listings_cleansed
dim_listings_w_hosts

Data Mart Layer
mart_fullmoon_reviews
Ad Hoc Layer (/analyses)
full_moon_no_sleep

Windows Setup
For this project, I installed and configured the following:

Python 3.11.3 https://www.python.org/downloads/
dbt (dbt-core 1.8.5 and dbt-snowflake 1.8.3)
pip install dbt-snowflake

dbt init dbtlearn

    Choose [1] Snowflake
    
    account:    <Snowflake URL, e.g. psxanuf-ja60125>
    user:       dbt
    password:   dbtPassword123
    role:       transform
    warehouse:  COMPUTE_WH
    database:   airbnb
    schema:     raw
    threads:    4
    
    Profile dbtlearn written to <your root folder>\.dbt\profiles.yml using target's 
    profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.
    
Snowflake Setup (Database / Data Warehouse)
Run the following scripts in Snowflake.

Create User and Roles for Data Transformation
-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS transform;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
 PASSWORD='dbtPassword123'
 LOGIN_NAME='dbt'
 MUST_CHANGE_PASSWORD=FALSE
 DEFAULT_WAREHOUSE='COMPUTE_WH'
 DEFAULT_ROLE='transform'
 DEFAULT_NAMESPACE='AIRBNB.RAW'
 COMMENT='DBT user used for data transformation';
GRANT ROLE transform to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS AIRBNB;
CREATE SCHEMA IF NOT EXISTS AIRBNB.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE transform;
GRANT ALL ON DATABASE AIRBNB to ROLE transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE AIRBNB to ROLE transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE AIRBNB to ROLE transform;
GRANT ALL ON ALL TABLES IN SCHEMA AIRBNB.RAW to ROLE transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA AIRBNB.RAW to ROLE transform;
Import Airbnb data from public S3 bucket

-- Set up the defaults
USE WAREHOUSE COMPUTE_WH;
USE DATABASE airbnb;
USE SCHEMA RAW;

-- Create our three tables and import the data from S3
CREATE OR REPLACE TABLE raw_listings
    (id integer,
    listing_url string,
    name string,
    room_type string,
    minimum_nights integer,
    host_id integer,
    price string,
    created_at datetime,
    updated_at datetime);

COPY INTO raw_listings (id,
    listing_url,
    name,
    room_type,
    minimum_nights,
    host_id,
    price,
    created_at,
    updated_at)
    from 's3://dbtlearn/listings.csv'
    FILE_FORMAT = (type = 'CSV' skip_header = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"');

CREATE OR REPLACE TABLE raw_reviews
    (listing_id integer,
    date datetime,
    reviewer_name string,
    comments string,
    sentiment string);

COPY INTO raw_reviews (listing_id, date, reviewer_name, comments, sentiment)
    from 's3://dbtlearn/reviews.csv'
    FILE_FORMAT = (type = 'CSV' skip_header = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"');

CREATE OR REPLACE TABLE raw_hosts
    (id integer,
    name string,
    is_superhost string,
    created_at datetime,
    updated_at datetime);

COPY INTO raw_hosts (id, name, is_superhost, created_at, updated_at)
    from 's3://dbtlearn/hosts.csv'
    FILE_FORMAT = (type = 'CSV' skip_header = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
    
Create User and Roles for Reporting (Preset)
-- Reporting User
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS REPORTER;
CREATE USER IF NOT EXISTS PRESET
    PASSWORD='presetPassword123'
    LOGIN_NAME='preset'
    MUST_CHANGE_PASSWORD=FALSE
    DEFAULT_WAREHOUSE='COMPUTE_WH'
    DEFAULT_ROLE='REPORTER'
    DEFAULT_NAMESPACE='AIRBNB.DEV'
    COMMENT='Preset user for creating reports';

GRANT ROLE REPORTER TO USER PRESET;
GRANT ROLE REPORTER TO ROLE TRANSFORM;
GRANT ROLE REPORTER TO ROLE ACCOUNTADMIN;

GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE REPORTER;
GRANT USAGE ON DATABASE AIRBNB TO ROLE REPORTER;
GRANT USAGE ON SCHEMA AIRBNB.DEV TO ROLE REPORTER;

Resources:
Learn more about dbt in the docs
Check out Discourse for commonly asked questions and answers
Join the chat on Slack for live discussions and support
Find dbt events near you
Check out the blog for the latest news on dbt's development and best practices
