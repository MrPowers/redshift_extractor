require 'spec_helper'

module RedshiftExtractor; describe Drop do

  context "#drop_sql" do
    it "returns the SQL to drop a table" do
      dropper = Drop.new(destination_schema: "destination_schema", destination_table: "destination_table")
      expect(dropper.drop_sql).to eq "drop table if exists destination_schema.destination_table;"
    end
  end

end; end


