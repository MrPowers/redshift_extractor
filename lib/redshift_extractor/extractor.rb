module RedshiftExtractor; class Extractor

  def initialize(args)
    @args = args
  end

  def config
    @config ||= OpenStruct.new(@args)
  end

  def run
    unload
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

  def copy
    copier.run
  end

  def copier
    args = {
      schema: config.destination_schema,
      table: config.destination_table,
      create_sql: config.create_sql,
      aws_access_key_id: config.aws_access_key_id,
      aws_secret_access_key: config.aws_secret_access_key,
      s3_path: config.copy_data_source,
      db_config: config.database_config_destination,
      copy_command_options: "manifest dateformat 'auto' timeformat 'auto' blanksasnull emptyasnull escape gzip removequotes delimiter '|';"
    }
    RedshiftCopier::Copy.new(args)
  end

  def source_connection
    PGconn.connect(config.database_config_source)
  end

end; end
