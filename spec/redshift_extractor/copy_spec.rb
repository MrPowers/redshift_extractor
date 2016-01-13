require 'spec_helper'

module RedshiftExtractor; describe Copy do

  let(:copier) do
    args = {
      destination_schema: "destination_schema",
      destination_table: "destination_table",
      data_source: "data_source",
      aws_access_key_id: "aws_access_key_id",
      aws_secret_access_key: "aws_secret_access_key"
    }

    Copy.new(args)
  end

  context "#copy_sql" do
    it "returns the COPY command SQL" do
      expected = "copy destination_schema.destination_table from 'data_source'"\
      " credentials 'aws_access_key_id=aws_access_key_id;aws_secret_access_key=aws_secret_access_key'"\
      " manifest dateformat 'auto' timeformat 'auto' blanksasnull emptyasnull escape gzip removequotes delimiter '|';"
      expect(copier.copy_sql).to eq expected
    end
  end

end; end

