module RedshiftExtractor; class Drop

  attr_reader :destination_schema, :destination_table

  def initialize(args)
    @destination_schema = args.fetch(:destination_schema)
    @destination_table = args.fetch(:destination_table)
  end

  def drop_sql
    "drop table if exists #{destination_schema}.#{destination_table};"
  end

end; end

