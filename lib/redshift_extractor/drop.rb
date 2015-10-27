module RedshiftExtractor; class Drop

  attr_reader :table_name

  def initialize(args)
    @table_name = args.fetch(:table_name)
  end

  def drop_sql
    "drop table if exists #{table_name};"
  end

end; end

