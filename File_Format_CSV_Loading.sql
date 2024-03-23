-- Creating Schema for file_formats
CREATE
OR REPLACE SCHEMA file_formats;
-- Creating File Format Objects
CREATE
OR REPLACE FILE FORMAT my_file_format;
-- Properties of file format object
DESC FILE FORMAT my_file_format;
--Altering File formatting objects created
-- By default skip header = 0, we can create a new file format or set the existing one to 1
ALTER FILE FORMAT my_file_format
SET
    SKIP_HEADER = 1;
-- Replacing file type
    CREATE
    OR REPLACE FILE FORMAT my_file_format TYPE = JSON,
    TIME_FORMAT = AUTO;