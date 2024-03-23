-- Creating stage for json
create
or replace stage json_stage URL = 's3://bucketsnowflake-jsondemo';
-- Creating json file format object
CREATE
OR REPLACE FILE FORMAT json_format TYPE = JSON;
-- Checking the contents in json_stage
LIST @json_stage;
-- Creating DB
CREATE database our_first_db;
-- Creating table for storing json data.
create
or replace table our_first_db.public.JSON_RAW(raw_file variant);
-- Loading the data from json_stage into JSON_RAW table
COPY INTO our_first_db.public.JSON_RAW
from
    @json_stage file_format = our_first_db.public.json_format files = ('HR_data.json');
select
    *
from
    our_first_db.public.JSON_RAW;
//Now each row has documented Key values for all the entries.
    -- Flattening the unstructured data into the structured data.
select
    raw_file:city,
    raw_file: first_name
from
    our_first_db.public.JSON_RAW;
    //OR
select
    $1:city CITY,
    $1: first_name First_Name
from
    our_first_db.public.JSON_RAW;
-- For removing "" and re writing into the string
select
    $1:city::string CITY,
    $1: first_name::string First_Name
from
    our_first_db.public.JSON_RAW;
-- Extracting further more columns
SELECT
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::string as first_name,
    RAW_FILE:last_name::String as last_name,
    RAW_FILE:gender::String as gender
FROM
    our_first_db.public.JSON_RAW;
-- Accessing the nested values from the JSON file
SELECT
    RAW_FILE: job as job
from
    our_first_db.public.JSON_RAW;
SELECT
    RAW_FILE:job.salary::float as sal,
    RAW_FILE:job.title::string as title
from
    our_first_db.public.JSON_RAW;
-- Extracting the listed values
SELECT
    RAW_FILE: prev_company as prev_company
from
    our_first_db.public.JSON_RAW;
SELECT
    RAW_FILE: prev_company [1]::string as prev_company
from
    our_first_db.public.JSON_RAW;
-- List of Nested Arrays
SELECT
    RAW_FILE: spoken_languages as spoken_languages
from
    our_first_db.public.JSON_RAW;
CREATE
    OR REPLACE TABLE LANGUAGES AS
SELECT
    RAW_FILE:first_name::String as first_name,
    f.value:language::STRING language,
    f.value:level::STRING level
from
    our_first_db.public.JSON_RAW,
    table(flatten(RAW_FILE:spoken_languages)) f
select
    *
from
    LANGUAGES;