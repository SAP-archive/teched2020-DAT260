# Exercise 7 - Use a GRAPH Procedure to calculate Shortest Paths on the street network
Once you have a GRAPH WORKSPACE defined, you can run OpenCypher queries for pattern matching workload, or create GRAPH procedures for network analysis. In this exercise we will create a database procedure that uses the built-in function to calculate a shortest path between a start and a end vertex, i.e. a street intersection.

## Exercise 7.1 Define required Table Type for the Procedure
---
**Create a `TABLE TYPE` that describes the output table of the procedure, containing ID, SOURCE, TARGET, EDGE_ORDER (BIGINT), and length (DOUBLE)**

---
If you are familiar with HANA database procedures using SQLScript, you already know how to handle table-like results. A clean way to do this is by defining and using TABLE TYPES. The same approach is valid for GRAPH procedures.

```sql
CREATE TYPE "DAT260"."TT_SPOO_EDGES" AS TABLE (
    "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE)
;
```

## Exercise 7.2 Create a GRAPH Procedure for Shortest Path Calculation
---
**Create a GRAPH procedure, using the built-in Shortest_Path function.**

---

```sql
CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOO"(
	IN i_startVertex BIGINT,       -- INPUT: the ID of the start vertex
	IN i_endVertex BIGINT,         -- INPUT: the ID of the end vertex
	IN i_direction NVARCHAR(10),   -- INPUT: the direction of the edge traversal: OUTGOING (default), INCOMING, ANY
	OUT o_path_length BIGINT,      -- OUTPUT: the hop distance between start and end
	OUT o_edges "DAT260"."TT_SPOO_EDGES" -- OUTPUT: a table containing the edges that make up a shortest path between start and end
	)
LANGUAGE GRAPH READS SQL DATA AS BEGIN
	-- Create an instance of the graph, referring to the graph workspace object
	GRAPH g = Graph("DAT260", "BIKE_GRAPH");
	-- Create an instance of the start/end vertex
	VERTEX v_start = Vertex(:g, :i_startVertex);
	VERTEX v_end = Vertex(:g, :i_endVertex);
	-- Runnning shortest path one-to-one based hop distance, i.e. the minimum number of edges between start and end
	WeightedPath<BIGINT> p = Shortest_Path(:g, :v_start, :v_end, :i_direction);
	o_path_length = LENGTH(:p);
	o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
END;
```

Note the language identifier of the procedure: "GRAPH". The database procedure is executed like any other - using a CALL statement providing the input parameters.

```sql
CALL "DAT260"."GS_SPOO"(i_startVertex => 14680080, i_endVertex => 7251951621, i_direction => 'ANY', o_path_length => ?, o_edges => ?);
-- or in short
CALL "DAT260"."GS_SPOO"(14680080, 7251951621, 'ANY', ?, ?);
```
TODO: add an image

## Exercise 7.3 Anonymous Blocks - Running GRAPH Code in an ad-hoc manner

Sometimes it is more convenient to generate and execute the GRAPH code dynamically without creating a procedure in the database. This approach is called "anonymous blocks". The code below is basically the same as in the procedure above, but this time it is execute in a DO - BEGIN - END block.
```sql
DO ( OUT o_edges "DAT260"."TT_SPOO_EDGES" => ? ) LANGUAGE GRAPH
BEGIN
	GRAPH g = Graph("DAT260", "BIKE_GRAPH");
	VERTEX v_start = Vertex(:g, 14680080L);
	VERTEX v_end = Vertex(:g, 7251951621L);
	WeightedPath<BIGINT> p = Shortest_Path(:g, :v_start, :v_end, 'ANY');
	o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
END;
```

## Summary

We have created a GRAPH procedure which calculates a hop distance shortest path between start and end vertex.

Continue to - [Exercise 8 - Excercise 8 ](../ex7/README.md)
