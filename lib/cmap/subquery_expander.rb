module Cmap; class SubqueryExpander

  attr_reader :table_name, :schema_name, :subquery_gsubs

  def initialize(args)
    @table_name = args.fetch(:table_name)
    @schema_name = args.fetch(:schema_name)
    @subquery_gsubs = args.fetch(:subquery_gsubs, [])
  end

  def update_query?(edge)
    edge.value != query(edge)
  end

  def query(edge)
    r = edge.value
    destination_column = ColumnParser.new(edge.destination_vertex).column
    origin_column = ColumnParser.new(edge.origin_vertex).column
    replacements = [["+table_name+", table_name], ["+schema_name+", schema_name], ["+destination_vertex+", destination_column], ["+origin_vertex+", origin_column]]
    (subquery_gsubs + replacements).each {|gsub| r = r.gsub(*gsub)}
    r
  end

end; end

