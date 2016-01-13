# RedshiftExtractor

redshift_extractor moves data from one Amazon Redshift cluster to another.  Here is how it works:

- Source database

  1. [UNLOAD](http://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html) - runs a SELECT query and exports the results to CSV files in S3.

- Destination database

  2. Drop - Drops a database table (the table in the destination database where the data will be stored).

  3. Create - Creates a database table.

  4. [COPY](http://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html) - Loads data from S3 into a Redshift database.

One database connection is established with the source database to UNLOAD the data to S3.  After the data is UNLOADed, a second database connection is establed with the destination database to drop/create the database table that will store the data.  The final step is to COPY the data from the S3 files to the destination table.

## Running the Code

The `RedshiftExtractor::Extractor` class is instantiated with a long hash of arguments ([sorry Sandi Metz!](https://robots.thoughtbot.com/sandi-metz-rules-for-developers)).

```ruby
args = {
  database_config_source: "database_config_source",
  database_config_destination: "database_config_destination",
  unload_s3_destination: "unload_s3_destination",
  unload_select_sql: "unload_select_sql",
  destination_schema: "destination_schema",
  destination_table: "destination_table",
  create_sql: "create_sql",
  copy_data_source: "copy_data_source",
  aws_access_key_id: "aws_access_key_id",
  aws_secret_access_key: "aws_secret_access_key"
}

extractor = RedshiftExtractor::Extractor.new(args)
extractor.run
```

Here is a description of the parameters:

- database_config_source: A hash that's acceptable for the [Ruby Postgres gem](https://bitbucket.org/ged/ruby-pg/wiki/Home).  Here's an example:

```ruby
{
  dbname: "db_name",
  user: "username",
  password: "password",
  host: "host",
  sslmode: 'require',
  port: 5439
}
```

- unload_s3_destination: A S3 path, something like `"s3://bucket_name/something_else/"`

- unload_select_sql: A SQL SELECT query that will be run on the source table

- destination_schema, destination_table: The table that will be dropped, recreated, and populated with data from the COPY command

- create_sql: The SQL that creates the destination_schema.destination_table table (this SQL is run to recreate the table in the step above)

- copy_data_source: This is typically `"#{unload_s3_destination}manifest"`.  The UNLOAD command automatically creates a manifest file that can be used by the COPY command to load the data.

- aws_keys: The keys you get from AWS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redshift_extractor'
```

And then execute:

    $ bundle

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MrPowers/redshift_extractor.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

