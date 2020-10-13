# Exercise 6 - Prepare data for the Graph Engine and create a Graph Workspace

Our graph dataset describes the London street network. Formally, a graph consists of nodes/vertices and edges/links/connections. In our case, we have street segments stored in the LONDON_BIKE_EDGES table, and intersections in the LONDON_BIKE_VERTIES table.
The HANA Graph engine requires a key on both tables, and the source and target columns of the edges table must not contain NULLs. To ensure the graph's consistency, it is also good practice to have a foreign key relationship defined on source and target column.
Once your data is prepared, you expose it to the HANA Graph engine via a GRAPH WORKSPACE.

## Exercise 6.1 Define required Constraints on the Tables <a name="subex1"></a>
---
**Create primary keys on the LONDON_BIKE_EDGES and LONDON_BIKE_VERTICES tables, and foreign keys on the SOURCE and TARGET column.**

---

```sql
RENAME COLUMN DAT260.LONDON_BIKE_EDGES."u" TO "SOURCE";
RENAME COLUMN DAT260.LONDON_BIKE_EDGES."v" TO "TARGET";

ALTER TABLE DAT260.LONDON_BIKE_EDGES ADD PRIMARY KEY("ID");
ALTER TABLE DAT260.LONDON_BIKE_VERTICES ADD PRIMARY KEY("osmid");

ALTER TABLE DAT260.LONDON_BIKE_EDGES ALTER("SOURCE" BIGINT NOT NULL REFERENCES "DAT260"."LONDON_BIKE_VERTICES" ("osmid") ON UPDATE CASCADE ON DELETE CASCADE);
ALTER TABLE DAT260.LONDON_BIKE_EDGES ALTER("TARGET" BIGINT NOT NULL REFERENCES "DAT260"."LONDON_BIKE_VERTICES" ("osmid") ON UPDATE CASCADE ON DELETE CASCADE);
```

## Exercise 6.2 Create a Graph Workspace <a name="subex2"></a> 
---
**Create a `GRAPH WORKSPACE` on top of the LONDON_BIKE_EDGES and LONDON_BIKE_VERTICES tables.**

---
The Graph Workspace exposes your data to the HANA graph engine. It is a kind of a "view" into your data. In our case, the Graph Workspace is defined directly on the tables. Note that you can also use SQL views, table functions, and remote tables as data sources. You can define multiple Graph Workspaces in one system.
```sql
CREATE GRAPH WORKSPACE "DAT260"."BIKE_GRAPH"
	EDGE TABLE "DAT260"."LONDON_BIKE_EDGES"
		SOURCE COLUMN "SOURCE"
		TARGET COLUMN "TARGET"
		KEY COLUMN "ID"
	VERTEX TABLE "DAT260"."LONDON_BIKE_VERTICES"
		KEY COLUMN "osmid";
```
## Summary

We have defined constraints on our VERTICES and EDGES tables and created a GRAPH WORKSPACE. We are all set up to run some graph stuff.

Continue to - [Exercise 7 - Use a GRAPH Procedure to calculate Shortest Paths on the street network ](../ex7/README.md)
