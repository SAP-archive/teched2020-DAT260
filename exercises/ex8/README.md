# Exercise 8 - Calculate Shortest Paths with a more complex cost function

In the previous exercise we have use hop distance to calculate a shortest path. Now we will use a more meaningful cost function - we will take the time it takes to traverse a street segment. The EDGES table contains a "length" and "maxspeed" column. "maxspeed" is a string column with values like '30 mph'. We will create a new numeric column "SPEED_MPH" and extract the number part of "maxspeed" into this column. We will then re-write our procedure to take the expression "length"/"SPEED_MPH" as cost function.

## Exercise 8.1 Generate a numeric column that contains the maximum speed allowed information.

---
**Add an integer column to the LONDON_BIKE_EDGES table. Extract the number part of "maxspeed".**

---

```sql
ALTER TABLE "DAT260"."LONDON_BIKE_EDGES" ADD("SPEED_MPH" INT);
UPDATE "DAT260"."LONDON_BIKE_EDGES"
	SET "SPEED_MPH" = TO_INT(REPLACE("maxspeed", ' mph', ''))
	WHERE REPLACE("maxspeed", ' mph', '') <> "maxspeed" ;
SELECT "SPEED_MPH", COUNT(*) AS C FROM "DAT260"."LONDON_BIKE_EDGES" GROUP BY "SPEED_MPH" ORDER BY C DESC;
-- let's add a default value on the segments that do not have a speed information
UPDATE "DAT260"."LONDON_BIKE_EDGES" SET "SPEED_MPH" = 30 WHERE "SPEED_MPH" IS NULL;
```
## Exercise 8.2 Calculate Shortest Paths, minimizing the time it takes to get from start to end

Just like in the previous example, we define a table type and a procedure. This time, we are using "length"/SPEED_MPH" as cost function. Syntactically, the cost function is a lambda function like this:
```sql
(Edge e) => DOUBLE{ return :e."length"/DOUBLE(:e."SPEED_MPH"); }
```

```sql
CREATE TYPE "DAT260"."TT_SPOO_WEIGHTED_EDGES" AS TABLE (
    "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE, "SPEED_MPH" INT
);

CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOO_WEIGTHED"(
	IN i_startVertex BIGINT, 		-- INPUT: the ID of the start vertex
	IN i_endVertex BIGINT, 			-- INPUT: the ID of the end vertex
	IN i_direction NVARCHAR(10), 	-- INPUT: the direction of the edge traversal: OUTGOING (default), INCOMING, ANY
	OUT o_path_length BIGINT,		-- OUTPUT: the hop distance between start and end
	OUT o_path_weight DOUBLE,		-- OUTPUT: the path weight/cost
	OUT o_edges "DAT260"."TT_SPOO_WEIGHTED_EDGES"  -- OUTPUT: the edges that make up the path
	)
LANGUAGE GRAPH READS SQL DATA AS BEGIN
	-- Create an instance of the graph, referring to the graph workspace object
	GRAPH g = Graph("DAT260", "BIKE_GRAPH");
	-- Create an instance of the start/end vertex
	VERTEX v_start = Vertex(:g, :i_startVertex);
	VERTEX v_end = Vertex(:g, :i_endVertex);
	--WeightedPath<DOUBLE> p = Shortest_Path(:g, :v_start, :v_end, (Edge e) => DOUBLE{ return :e."length"; }, :i_direction);
	WeightedPath<DOUBLE> p = Shortest_Path(:g, :v_start, :v_end,
		(Edge e) => DOUBLE{
			return :e."length"/DOUBLE(:e."SPEED_MPH");
		}, :i_direction);
	o_path_length = LENGTH(:p);
	o_path_weight = WEIGHT(:p);
	o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length", :e."SPEED_MPH" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
END;
```

Call the procedure.

```sql
CALL "DAT260"."GS_SPOO_WEIGTHED"(14680080, 7251951621, 'ANY', ?, ?, ?);
```

TODO: add image

## Summary

We have used an expression in the built-in shortest path function to calculated the fastest path between start and end.

Continue to - [Exercise 9 - Excercise 9 ](../ex9/README.md)
