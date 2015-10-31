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

  context "#dropper" do
    it "instantiates a Drop object" do
      args = {table_name: "table_name"}
      expect(Drop).to receive(:new).with(args)
      extractor.send(:dropper)
    end
  end

  context "#drop" do
    it "runs the drop_sql in the database" do
      destination_connection = double
      expect(extractor).to receive(:destination_connection).and_return(destination_connection)
      expected_sql = "drop table if exists table_name;"
      expect(destination_connection).to receive(:exec).with expected_sql
      extractor.send(:drop)
    end
  end

  context "#create" do
    it "creates a database table" do
      destination_connection = double
      expect(extractor).to receive(:destination_connection).and_return(destination_connection)
      expected_sql = "create_sql"
      expect(destination_connection).to receive(:exec).with expected_sql
      extractor.send(:create)
    end
  end

  context "#copier" do
    it "instantiates an Copy object" do
      args = {
        data_source: "copy_data_source",
        table_name: "table_name",
        aws_access_key_id: "aws_access_key_id",
        aws_secret_access_key: "aws_secret_access_key"
      }
      expect(Copy).to receive(:new).with(args)
      extractor.send(:copier)
    end
  end

  context "#copy" do
    it "runs the copy sql command" do
      destination_connection = double
      expect(extractor).to receive(:destination_connection).and_return(destination_connection)
      expected_sql = "copy table_name from 'copy_data_source' credentials 'aws_access_key_id=aws_access_key_id;aws_secret_access_key=aws_secret_access_key' manifest dateformat 'auto' timeformat 'auto' blanksasnull emptyasnull escape gzip removequotes delimiter '|';"
      expect(destination_connection).to receive(:exec).with expected_sql
      extractor.send(:copy)
    end
  end

  context "#destination_connection" do
    it "establishes a connection with the destination database" do
      expect(PGconn).to receive(:connect).with("database_config_destination")
      extractor.send(:destination_connection)
    end
  end

  context "#source_connection" do
    it "establishes a connection with the source database" do
      expect(PGconn).to receive(:connect).with("database_config_source")
      extractor.send(:source_connection)
    end
  end

end; end

