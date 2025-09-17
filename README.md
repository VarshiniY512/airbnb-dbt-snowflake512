# airbnb-dbt-snowflake512
Airbnb Data Warehouse using dbt &amp; Snowflake — end-to-end data modeling project with staging, fact, and dimension tables, plus testing and documentation for self-service analytics. Running dbt docs serve will launch the documentation hosted in a web server, which contains the updated lineage.

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

How it Works:

1) Load raw Airbnb datasets into Snowflake.

2) Run dbt transformations:

   a) Staging models clean and standardize the data.
   b) Core models apply Slowly Changing Dimension (SCD) logic and cleansed dimensions.
   c) Data marts produce curated fact tables.

4) Run dbt tests to ensure data quality.

5) Launch dbt docs serve to explore documentation and lineage.

🔗 Resources

[dbt Documentation](https://docs.getdbt.com/)

[dbt Discourse Q&A](https://discourse.getdbt.com/)

[dbt Slack Community](https://www.getdbt.com/community)
