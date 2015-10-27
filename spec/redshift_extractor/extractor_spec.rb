require 'spec_helper'

module RedshiftExtractor; describe Extractor do

  context ".new" do
    it "can be instantiated without blowing up" do
      args = {
        database_config_source: "something",
        database_config_destination: "something",
        unload_s3_destination: "something",
        unload_select_sql: "something",
        table_name: "something",
        create_sql: "something",
        copy_data_source: "something",
        aws_access_key_id: "something",
        aws_secret_access_key: "something"
      }

      Extractor.new(args)
    end
  end

  context "#unloader" do
    it "instantiates an Unload object" do
      args = {
        database_config_source: "something",
        database_config_destination: "something",
        unload_s3_destination: "something",
        unload_select_sql: "something",
        table_name: "something",
        create_sql: "something",
        copy_data_source: "something",
        aws_access_key_id: "something",
        aws_secret_access_key: "something"
      }

      extractor = Extractor.new(args)
      extractor.send(:unloader)
    end
  end

end; end

