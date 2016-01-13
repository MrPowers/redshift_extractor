module RedshiftExtractor; class Extractor

  def initialize(args)
    @args = args
  end

  def config
    @config ||= OpenStruct.new(@args)
  end

  def run
    unload
    drop
    create
    copy
  end

  private

  def unloader
    Unload.new(
      aws_access_key_id: config.aws_access_key_id,
      aws_secret_access_key: config.aws_secret_access_key,
      s3_destination: config.unload_s3_destination,
      select_sql: config.unload_select_sql
    )
  end

  def unload
    source_connection.exec(unloader.unload_sql)
  end

  def dropper
    Drop.new(
      destination_schema: config.destination_schema,
      destination_table: config.destination_table
    )
  end

  def drop
    destination_connection.exec(dropper.drop_sql)
  end

  def create
    destination_connection.exec(config.create_sql)
  end

  def copier
    Copy.new(
      aws_access_key_id: config.aws_access_key_id,
      aws_secret_access_key: config.aws_secret_access_key,
      data_source: config.copy_data_source,
      destination_schema: config.destination_schema,
      destination_table: config.destination_table
    )
  end

  def copy
    destination_connection.exec(copier.copy_sql)
  end

  def destination_connection
    PGconn.connect(config.database_config_destination)
  end

  def source_connection
    PGconn.connect(config.database_config_source)
  end

end; end
