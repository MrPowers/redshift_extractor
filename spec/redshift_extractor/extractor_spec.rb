require 'spec_helper'

module RedshiftExtractor; describe Extractor do

  let(:extractor) do
    args = {
      database_config_source: "database_config_source",
      database_config_destination: "database_config_destination",
      unload_s3_destination: "unload_s3_destination",
      unload_select_sql: "unload_select_sql",
      table_name: "table_name",
      create_sql: "create_sql",
      copy_data_source: "copy_data_source",
      aws_access_key_id: "aws_access_key_id",
      aws_secret_access_key: "aws_secret_access_key"
    }

    Extractor.new(args)
  end

  context "#run" do
    it "unloads the data, drops the table, recreates the table, and copys the data" do
      expect(extractor).to receive(:unload).ordered
      expect(extractor).to receive(:drop).ordered
      expect(extractor).to receive(:create).ordered
      expect(extractor).to receive(:copy).ordered
      extractor.run
    end
  end

  context "#unloader" do
    it "instantiates an Unload object" do
      args = {
        s3_destination: "unload_s3_destination",
        select_sql: "unload_select_sql",
        aws_access_key_id: "aws_access_key_id",
        aws_secret_access_key: "aws_secret_access_key"
      }
      expect(Unload).to receive(:new).with(args)
      extractor.send(:unloader)
    end
  end

  context "#unload" do
    it "runs the unload_sql in the database" do
      source_connection = double
      expect(extractor).to receive(:source_connection).and_return(source_connection)
      expected_sql = "UNLOAD('unload_select_sql') to 'unload_s3_destination' CREDENTIALS 'aws_access_key_id=aws_access_key_id;aws_secret_access_key=aws_secret_access_key' MANIFEST GZIP ADDQUOTES ESCAPE;"
      expect(source_connection).to receive(:exec).with expected_sql
      extractor.send(:unload)
    end
  end

end; end

