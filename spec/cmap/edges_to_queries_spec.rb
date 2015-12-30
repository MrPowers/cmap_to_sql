require 'spec_helper'

module Cmap; describe EdgesToQueries do

  context "#expanded_graph" do
    it "returns all the graph vertices" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "ov", value: "90D", destination_vertex: "dv")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "some query that isn't changed;", destination_vertex: "ok")

      subquery_gsubs = [["90D", "some +table_name+ from +destination_vertex+ to +origin_vertex+"]]

      expander = SubqueryExpander.new(table_name: "some_table", subquery_gsubs: subquery_gsubs)

      edges_to_queries = EdgesToQueries.new([e1, e2], "some_table", expander)
      expected = ["alter table some_table add column dv int2;", "alter table some_table add column ok int2;", "some some_table from dv to ov", "update some_table set ok=(some query that isn't changed;)::int;"]
      expect(edges_to_queries.queries).to eq expected
    end

    it "uses float4 column type (real) for numeric-named columns" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "ov", value: "90D", destination_vertex: "dv")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "some value;", destination_vertex: "numeric_area")

      subquery_gsubs = [["90D", "some +table_name+ from +destination_vertex+ to +origin_vertex+"]]

      expander = SubqueryExpander.new(table_name: "some_table", subquery_gsubs: subquery_gsubs)

      edges_to_queries = EdgesToQueries.new([e1, e2], "some_table", expander)
      expected = ["alter table some_table add column dv int2;", "alter table some_table add column numeric_area float4;", "some some_table from dv to ov", "update some_table set numeric_area=(some value;)::int;"]
      expect(edges_to_queries.queries).to eq expected
    end

  end

end; end

