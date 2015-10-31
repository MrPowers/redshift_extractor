require 'spec_helper'

module RedshiftExtractor; describe Drop do

  context "#drop_sql" do
    it "returns the SQL to drop a table" do
      dropper = Drop.new(table_name: "table_name")
      expect(dropper.drop_sql).to eq "drop table if exists table_name;"
    end
  end

end; end


