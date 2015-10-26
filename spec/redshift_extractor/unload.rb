require 'spec_helper'

module RedshiftExtractor; describe Unload do

  context "#unload_sql" do

    it "generates the sql" do
      args = {
        aws_access_key_id: "aws_access_key_id",
        aws_secret_access_key: "aws_secret_access_key",
        s3_destination: "s3_destination",
        select_sql: "select * from somewhere"
      }
      unloader = Unload.new(args)
      expected = "UNLOAD('select * from somewhere') to 's3_destination' CREDENTIALS 'aws_access_key_id=aws_access_key_id;aws_secret_access_key=aws_secret_access_key' MANIFEST GZIP ADDQUOTES ESCAPE;"
      expect(unloader.unload_sql).to eq expected
    end

  end

end; end

