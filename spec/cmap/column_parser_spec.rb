require 'spec_helper'

module Cmap; describe ColumnParser do

  context "#column" do
    it "removes the denoted character and the subsequent text" do
      column_name = "value_total_:_real"
      cp = ColumnParser.new(column_name)

      expect(cp.column).to eql("value_total")
    end

    it "removes the denoted character (with alternative space formatting) and the subsequent text" do
      alternative_spacing_formats = ["value_total:real", "value_total:_real", "value_total_:real"]

      alternative_spacing_formats.each do |column_name|
        cp = ColumnParser.new(column_name)
        expect(cp.column).to eql("value_total")
      end
    end

    it "returns the original column name if no denoted character is found" do
      column_name = "value_total"
      cp = ColumnParser.new(column_name)

      expect(cp.column).to eql("value_total")
    end
  end

  context "#type" do
    it "defaults to int2 if no denoted character is found" do
      column_name = "value_total"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("int2")
    end

    it "defaults to the specified type if denoted character is found" do
      column_name = "value_total_:_real"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("real")
    end

    it "defaults to int2 if denoted character is found and no value is passed in after the denoted character" do
      column_name = "value_total_:_"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("int2")
    end
  end

end; end

