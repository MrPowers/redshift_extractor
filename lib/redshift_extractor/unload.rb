module RedshiftExtractor; class Unload

  attr_reader :aws_access_key_id, :aws_secret_access_key, :s3_destination, :select_sql

  def initialize(args)
    @aws_access_key_id = args.fetch(:aws_access_key_id)
    @aws_secret_access_key = args.fetch(:aws_secret_access_key)
    @s3_destination = args.fetch(:s3_destination)
    @select_sql = args.fetch(:select_sql)
  end

  def unload_sql
    "UNLOAD('#{escaped_extract_sql}') to '#{s3_destination}' CREDENTIALS '#{credentials}' MANIFEST GZIP ADDQUOTES ESCAPE;"
  end

  def escaped_extract_sql
    select_sql.gsub("'", "\\\\'")
  end

  def credentials
    "aws_access_key_id=#{aws_access_key_id};aws_secret_access_key=#{aws_secret_access_key}"
  end

end; end

