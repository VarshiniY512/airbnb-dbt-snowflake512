# airbnb-dbt-snowflake512

# Airbnb Data Warehouse using dbt & Snowflake

This project demonstrates an end-to-end data modeling pipeline using dbt and Snowflake, with Airbnb datasets as the source. The goal is to transform raw data into clean, analytics-ready tables for reporting and self-service analytics.

## Project Overview

#### Data Modeling:  
    Raw Airbnb data is organized into staging, core, and data mart layers.

#### Testing & Documentation: 
     Integrated dbt tests (uniqueness, not null) and generated lineage/documentation using dbt docs.

#### Analytics Enablement: 
     Published curated fact and dimension models for use by BI and reporting teams.

## Project Layers

Raw Layer: airbnb.reviews, airbnb.listings, airbnb.hosts, plus seed data (seed_full_moon_dates).

Staging Layer: src_reviews, src_listings, src_hosts.

Core Layer: scd_raw_listings, dim_hosts_cleansed, dim_listings_cleansed, dim_listings_w_hosts.

Data Mart Layer: mart_fullmoon_reviews.

Ad Hoc Layer (analyses): full_moon_no_sleep.

## Tech Setup

Python: 3.11.3

dbt: dbt-core 1.8.5, dbt-snowflake 1.8.3

Data Warehouse: Snowflake

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

## How it Works:

1) Load raw Airbnb datasets into Snowflake.

2) Run dbt transformations:

   a) Staging models clean and standardize the data.

   b) Core models apply Slowly Changing Dimension (SCD) logic and cleansed dimensions.

   c) Data marts produce curated fact tables.

4) Run dbt tests to ensure data quality.

5) Launch dbt docs serve to explore documentation and lineage.

## Resources

[dbt Documentation](https://docs.getdbt.com/)

[dbt Discourse Q&A](https://discourse.getdbt.com/)

[dbt Slack Community](https://www.getdbt.com/community)
