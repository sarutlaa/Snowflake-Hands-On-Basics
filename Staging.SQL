-- Creating External Staging Area from S3
create
or replace stage my_external_stage_from_s3 URL = 's3://dw-snowflake-course-sravya' CREDENTIALS = (
    AWS_KEY_ID = 'AKIAYBV6JB2WQONCMSNB
' AWS_SECRET_KEY = '5P1CRy895/7/G1tnJuvOHYIB9ftkztqISBPgKYGl'
) -- Description of the stage - Connected S3 bucket to the SnowflakeDB.
DESC stage my_external_stage_from_s3;
-- Altering external stage - When we want to alter AWS access keys
ALTER stage my_external_stage_from_s3
SET
    CREDENTIALS = (AWS_KEY_ID = '' AWS_SECRET_KEY = '') -- CREATE OR REPLACE stage my_external_stage_from_s3
    -- -- If the bucket is public, then directly it can be accessed.
    create
    or replace stage my_external_stage_from_s3 URL = 's3://bucketsnowflakes3';
    -- Listing the contents in the external stage
    LIST @my_external_stage_from_s3 -- Creating the Orders table in the SnowflakeDB.
    CREATE
    OR REPLACE table orders (
        order_id varchar(30),
        amount int,
        profit int,
        quantity int,
        category varchar(30),
        subcategory varchar(30)
    );
select
    *
from
    orders;
    -- Loading Orders table details from the staging area
    COPY INTO orders
from
    @my_external_stage_from_s3 file_format = (type = csv field_delimiter = "," skip_header = 1) files = ('OrderDetails.csv') -- Changing the data type or choosing only specific columns from
    -- the staging area
    CREATE
    OR REPLACE table orders_ex (order_id varchar(30), amount int);
COPY INTO orders_ex
from
    (
        select
            s.$1,
            s.$2
        from
            @my_external_stage_from_s3 s
    ) file_format = (type = csv field_delimiter = "," skip_header = 1) files = ('OrderDetails.csv')
select
    *
from
    orders_ex;
    -- Altering, grouping, filtering
    CREATE
    OR REPLACE table orders_ex1 (
        order_id varchar(30),
        amount int,
        profit int,
        category_substring varchar(15)
    );
COPY INTO orders_ex1
from
    (
        select
            s.$1,
            s.$2,
            s.$3,
            case
                when CAST(s.$3 as int) < 0 then 'Not Profit'
                else 'Profitable'
            end
        from
            @my_external_stage_from_s3 s
    ) file_format = (type = csv field_delimiter = ',' skip_header = 1) files = ('OrderDetails.csv')
select
    *
from
    orders_ex1;