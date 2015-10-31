module RedshiftExtractor; class Copy

  attr_reader :aws_access_key_id, :aws_secret_access_key, :copy_data_source, :table_name

  def initialize(args)
    @aws_access_key_id = args.fetch(:aws_access_key_id)
    @aws_secret_access_key = args.fetch(:aws_secret_access_key)
    @copy_data_source = args.fetch(:copy_data_source)
    @table_name = args.fetch(:table_name)
  end

  def copy_sql
    %{
      copy #{table_name} from '#{copy_data_source}'
      credentials '#{credentials}'
      manifest dateformat 'auto' timeformat 'auto' blanksasnull emptyasnull escape gzip removequotes delimiter '|';
    }
  end

  def credentials
    "aws_access_key_id=#{aws_access_key_id};aws_secret_access_key=#{aws_secret_access_key}"
  end

end; end

