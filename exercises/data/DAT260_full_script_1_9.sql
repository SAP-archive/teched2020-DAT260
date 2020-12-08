SET SCHEMA DAT260;

-- exercise 1
SELECT
	"geometry_GEO".ST_X() AS LONGITUDE,
	"geometry_GEO".ST_Y() AS LATITUDE
FROM LONDON_VERTICES;

CREATE PREDEFINED SPATIAL REFERENCE SYSTEM IDENTIFIED BY 32630;

SELECT * FROM ST_SPATIAL_REFERENCE_SYSTEMS WHERE SRS_ID = 32630;

ALTER TABLE LONDON_POI ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_EDGES ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_VERTICES ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_TUBE_CONNECTIONS ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_TUBE_STATIONS ADD (SHAPE ST_Geometry(32630));

UPDATE LONDON_POI SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_EDGES SET SHAPE = "geometry_GEO".ST_Transform(32630);
UPDATE LONDON_VERTICES SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_TUBE_CONNECTIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);
UPDATE LONDON_TUBE_STATIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);

-- exercise 2
SELECT ST_GeomFromText('POINT(-0.026859 51.505748)', 4326) FROM DUMMY;

SELECT ST_GeomFromText('POINT(-0.026859 51.505748)', 4326)
    .ST_Transform(32630)
    .ST_AsWKT()
FROM DUMMY;

SELECT ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630) FROM DUMMY;

SELECT *
FROM LONDON_POI lp
WHERE LOWER("name") LIKE '%blues kitchen%' AND "amenity" = 'bar';

SELECT "osmid", SHAPE.ST_Transform(4326).ST_AsWKT()
FROM LONDON_POI lp
WHERE LOWER("name") LIKE '%blues kitchen%' AND "amenity" = 'bar';

SELECT * FROM LONDON_POI lp WHERE "osmid" = 6274057185;

SELECT SHAPE.ST_Distance(
        ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630)
    )
FROM LONDON_POI lp
WHERE "osmid" = 6274057185;

-- exercise 3
SELECT
	ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630) AS START_PT,
	SHAPE AS TARGET_PT
FROM LONDON_POI lp
WHERE "osmid" = 6274057185;

SELECT ST_MakeLine(START_PT, TARGET_PT) AS CONN_LINE
FROM
(
SELECT
	ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630) AS START_PT,
	SHAPE AS TARGET_PT
FROM LONDON_POI lp
WHERE "osmid" = 6274057185
);

SELECT CONN_LINE.ST_LineInterpolatePoint(0.5) AS CENTER_PT
FROM
(
SELECT ST_MakeLine(START_PT, TARGET_PT) AS CONN_LINE
FROM
(
SELECT
	ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630) AS START_PT,
	SHAPE AS TARGET_PT
FROM LONDON_POI lp
WHERE "osmid" = 6274057185
)
);

SELECT CENTER_PT.ST_Buffer(4835) AS AREA
FROM
(
SELECT CONN_LINE.ST_LineInterpolatePoint(0.5) AS CENTER_PT
FROM
(
SELECT ST_MakeLine(START_PT, TARGET_PT) AS CONN_LINE
FROM
(
SELECT
	ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630) AS START_PT,
	SHAPE AS TARGET_PT
FROM LONDON_POI lp
WHERE "osmid" = 6274057185
)
)
);

SELECT
    ST_MakeLine(
        ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630),
        SHAPE
    )
    .ST_LineInterpolatePoint(0.5)
    .ST_Buffer(5000) AS AREA
FROM LONDON_POI
WHERE "osmid" = 6274057185;

ALTER TABLE LONDON_VERTICES ADD (IN_SCOPE INTEGER);

MERGE INTO LONDON_VERTICES lv
USING
(
	-- previous statement begin --
	SELECT
    	ST_MakeLine(
        	ST_GeomFromText('POINT (706327.107445 5710259.94449)', 32630),
        	SHAPE
    	)
    	.ST_LineInterpolatePoint(0.5)
    	.ST_Buffer(5000) AS AREA
	FROM LONDON_POI
	WHERE "osmid" = 6274057185
    	-- previous statement end --
) circle ON 1=1
WHEN MATCHED THEN UPDATE SET lv.IN_SCOPE = CIRCLE.AREA.ST_Intersects(SHAPE);

SELECT SHAPE FROM LONDON_VERTICES WHERE IN_SCOPE = 1;

SELECT le.*
FROM LONDON_EDGES le
JOIN LONDON_VERTICES u ON le.SOURCE = u."osmid"
JOIN LONDON_VERTICES v ON le.TARGET = v."osmid"
WHERE u.IN_SCOPE = 1 AND v.IN_SCOPE = 1 AND le."highway" = 'cycleway';

SELECT ST_UnionAggr(le.SHAPE).ST_AsSVG(Attribute=>'stroke="red" stroke-width="0.1%"')
FROM LONDON_EDGES le
JOIN LONDON_VERTICES u ON le.SOURCE = u."osmid"
JOIN LONDON_VERTICES v ON le.TARGET = v."osmid"
WHERE u.IN_SCOPE = 1 AND v.IN_SCOPE = 1 AND le."highway" = 'cycleway';

SELECT *
FROM LONDON_POI
WHERE "amenity" = 'bicycle_repair_station';

SELECT
	"osmid" ,
    SHAPE,
	ST_VoronoiCell(SHAPE, 10.0) OVER () AS CATCHMENT_AREA
FROM LONDON_POI
WHERE "amenity" LIKE 'bicycle_repair_station';

-- exercise 5
ALTER TABLE LONDON_VERTICES ADD (VORONOI_CELL ST_Geometry(32630));

MERGE INTO LONDON_VERTICES
USING
(
	SELECT "osmid", ST_VoronoiCell(shape, 10.0) OVER () AS CELL
	FROM LONDON_VERTICES
) v ON LONDON_VERTICES."osmid" = v."osmid"
WHEN MATCHED THEN UPDATE SET LONDON_VERTICES.VORONOI_CELL = v.CELL;

ALTER TABLE LONDON_POI ADD (SHAPE_CENTROID ST_GEOMETRY(32630));

UPDATE LONDON_POI
SET SHAPE_CENTROID =
    CASE
        WHEN SHAPE.ST_GeometryType() = 'ST_Point'
        THEN SHAPE
        ELSE SHAPE.ST_Centroid()
    END;

ALTER TABLE LONDON_POI ADD (VERTEX_OSMID BIGINT);

MERGE INTO LONDON_POI lp
USING LONDON_VERTICES lv
ON lv.VORONOI_CELL.ST_Intersects(lp.SHAPE_CENTROID) = 1
WHEN MATCHED THEN UPDATE SET lp.VERTEX_OSMID = lv."osmid";

-- exercise 6
ALTER TABLE "DAT260"."LONDON_EDGES" ADD PRIMARY KEY("ID");
ALTER TABLE "DAT260"."LONDON_VERTICES" ADD PRIMARY KEY("osmid");

ALTER TABLE "DAT260"."LONDON_EDGES" ALTER("SOURCE" BIGINT NOT NULL REFERENCES "DAT260"."LONDON_VERTICES" ("osmid") ON UPDATE CASCADE ON DELETE CASCADE);
ALTER TABLE "DAT260"."LONDON_EDGES" ALTER("TARGET" BIGINT NOT NULL REFERENCES "DAT260"."LONDON_VERTICES" ("osmid") ON UPDATE CASCADE ON DELETE CASCADE);

CREATE GRAPH WORKSPACE "DAT260"."LONDON_GRAPH"
	EDGE TABLE "DAT260"."LONDON_EDGES"
		SOURCE COLUMN "SOURCE"
		TARGET COLUMN "TARGET"
		KEY COLUMN "ID"
	VERTEX TABLE "DAT260"."LONDON_VERTICES"
		KEY COLUMN "osmid";

-- exercise 7
CREATE TYPE "DAT260"."TT_SPOO_EDGES" AS TABLE (
    "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE)
;

CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOO"(
    IN i_startVertex BIGINT,       -- INPUT: the ID of the start vertex
    IN i_endVertex BIGINT,         -- INPUT: the ID of the end vertex
    IN i_direction NVARCHAR(10),   -- INPUT: the direction of the edge traversal: OUTGOING (default), INCOMING, ANY
    OUT o_path_length BIGINT,      -- OUTPUT: the hop distance between start and end
    OUT o_edges "DAT260"."TT_SPOO_EDGES" -- OUTPUT: a table containing the edges that make up a shortest path between start and end
    )
LANGUAGE GRAPH READS SQL DATA AS BEGIN
    -- Create an instance of the graph, referring to the graph workspace object
    GRAPH g_all = Graph("DAT260", "LONDON_GRAPH");
  -- Using the IN_SCOPE attribute created in "Exercise 3 Identify Relevant Area for Transportation Network" to narrow down the search scope
  GRAPH g = SubGraph(:g_all, v IN Vertices(:g_all) WHERE :v."IN_SCOPE" == 1);
    -- Create an instance of the start/end vertex
    VERTEX v_start = Vertex(:g, :i_startVertex);
    VERTEX v_end = Vertex(:g, :i_endVertex);
    -- Runnning shortest path one-to-one based hop distance, i.e. the minimum number of edges between start and end
    WeightedPath<BIGINT> p = Shortest_Path(:g, :v_start, :v_end, :i_direction);
    o_path_length = LENGTH(:p);
    o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
END;

-- Look up VERTEX_OSMID of POI Blues kitchen
SELECT VERTEX_OSMID FROM "DAT260"."LONDON_POI" WHERE "name" = 'Blues Kitchen' AND "osmid" = 6274057185;
CALL "DAT260"."GS_SPOO"(i_startVertex => 1433737988, i_endVertex => 1794145673, i_direction => 'ANY', o_path_length => ?, o_edges => ?);
-- or in short
CALL "DAT260"."GS_SPOO"(1433737988, 1794145673, 'ANY', ?, ?);

DO ( OUT o_edges "DAT260"."TT_SPOO_EDGES" => ? ) LANGUAGE GRAPH
BEGIN
    GRAPH g = Graph("DAT260", "LONDON_GRAPH");
    VERTEX v_start = Vertex(:g, 14680080L);
    VERTEX v_end = Vertex(:g, 7251951621L);
    WeightedPath<BIGINT> p = Shortest_Path(:g, :v_start, :v_end, 'ANY');
    o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
END;

-- exercise 8
ALTER TABLE "DAT260"."LONDON_EDGES" ADD("SPEED_MPH" INT);
UPDATE "DAT260"."LONDON_EDGES"
    SET "SPEED_MPH" = TO_INT(REPLACE("maxspeed", ' mph', ''))
    WHERE REPLACE("maxspeed", ' mph', '') <> "maxspeed" ;
SELECT "SPEED_MPH", COUNT(*) AS C FROM "DAT260"."LONDON_EDGES" GROUP BY "SPEED_MPH" ORDER BY C DESC;
-- let's add a default value on the segments that do not have a speed information
UPDATE "DAT260"."LONDON_EDGES" SET "SPEED_MPH" = 30 WHERE "SPEED_MPH" IS NULL;

CREATE TYPE "DAT260"."TT_SPOO_WEIGHTED_EDGES" AS TABLE (
    "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE, "SPEED_MPH" INT
);

CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOO_WEIGHTED"(
    IN i_startVertex BIGINT,         -- INPUT: the ID of the start vertex
    IN i_endVertex BIGINT,             -- INPUT: the ID of the end vertex
    IN i_direction NVARCHAR(10),     -- INPUT: the direction of the edge traversal: OUTGOING (default), INCOMING, ANY
    OUT o_path_length BIGINT,        -- OUTPUT: the hop distance between start and end
    OUT o_path_weight DOUBLE,        -- OUTPUT: the path weight/cost
    OUT o_edges "DAT260"."TT_SPOO_WEIGHTED_EDGES"  -- OUTPUT: the edges that make up the path
    )
LANGUAGE GRAPH READS SQL DATA AS BEGIN
    -- Create an instance of the graph, referring to the graph workspace object
    GRAPH g = Graph("DAT260", "LONDON_GRAPH");
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

CALL "DAT260"."GS_SPOO_WEIGHTED"(1433737988, 1794145673, 'ANY', ?, ?, ?);

ALTER TABLE "DAT260"."LONDON_EDGES" ADD ("PUBINESS" DOUBLE DEFAULT 0);

MERGE INTO "DAT260"."LONDON_EDGES"
    USING (
        SELECT e."ID", COUNT(*) AS "PUBINESS" FROM
            (SELECT * FROM "DAT260"."LONDON_POI" WHERE "amenity" ='pub') AS pubs
            LEFT JOIN
            (SELECT "ID", "SHAPE" AS "EDGESHAPE" FROM "DAT260"."LONDON_EDGES") AS e
            ON pubs."SHAPE".ST_WithinDistance(e."EDGESHAPE", 100) = 1
            GROUP BY e."ID" ORDER BY "PUBINESS" DESC)    AS U
    ON "DAT260"."LONDON_EDGES"."ID" = U."ID"
WHEN MATCHED THEN UPDATE SET "DAT260"."LONDON_EDGES"."PUBINESS" = U."PUBINESS";

SELECT "PUBINESS", COUNT(*) AS C FROM "DAT260"."LONDON_EDGES" GROUP BY "PUBINESS" ORDER BY "PUBINESS" ASC;

CREATE TYPE "DAT260"."TT_SPOO_MULTI_MODE" AS TABLE (
        "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE, "SPEED_MPH" INT, "highway" NVARCHAR(5000)
);

CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOO_MULTI_MODE"(
    IN i_startVertex BIGINT,         -- the ID of the start vertex
    IN i_endVertex BIGINT,             -- the ID of the end vertex
    IN i_direction NVARCHAR(10),     -- the the direction of the edge traversal: OUTGOING (default), INCOMING, ANY
    IN i_mode NVARCHAR(10),         -- hop, time, bike
    OUT o_path_length BIGINT,        -- the hop distance between start and end
    OUT o_path_weight DOUBLE,        -- the path weight/cost based on the WEIGHT attribute
    OUT o_edges "DAT260"."TT_SPOO_MULTI_MODE"
    )
LANGUAGE GRAPH READS SQL DATA AS BEGIN
    GRAPH g = Graph("DAT260", "LONDON_GRAPH");
    VERTEX v_start = Vertex(:g, :i_startVertex);
    VERTEX v_end = Vertex(:g, :i_endVertex);
    -- mode=bike means cycleway preferred
    IF (:i_mode == 'bike') {
        WeightedPath<DOUBLE> p = Shortest_Path(:g, :v_start, :v_end,
        (EDGE e, DOUBLE current_path_weight)=> DOUBLE{
              IF(:e."highway" == 'cycleway') { RETURN :e."length"/10.0; }
        ELSE { RETURN :e."length"; }
      }, :i_direction);
        o_path_length = LENGTH(:p);
        o_path_weight = DOUBLE(WEIGHT(:p));
        o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length", :e."SPEED_MPH", :e."highway" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
    }
    -- mode=pub means street with pubs around preferred
    IF (:i_mode == 'pub') {
        WeightedPath<DOUBLE> p = Shortest_Path(:g, :v_start, :v_end, (Edge e) => DOUBLE{
            RETURN :e."length"/(5.0*:e."PUBINESS"+1.0);
        }, :i_direction);
        o_path_length = LENGTH(:p);
        o_path_weight = DOUBLE(WEIGHT(:p));
        o_edges = SELECT :e."ID", :e."SOURCE", :e."TARGET", :EDGE_ORDER, :e."length", :e."SPEED_MPH", :e."highway" FOREACH e IN Edges(:p) WITH ORDINALITY AS EDGE_ORDER;
    }
END;

CALL "DAT260"."GS_SPOO_MULTI_MODE"(1433737988, 1794145673, 'ANY', 'pub', ?, ?, ?);
CALL "DAT260"."GS_SPOO_MULTI_MODE"(1433737988, 1794145673, 'ANY', 'bike', ?, ?, ?);

CREATE TYPE "DAT260"."TT_EDGES_SPOO_F" AS TABLE (
        "ID" VARCHAR(5000), "SOURCE" BIGINT, "TARGET" BIGINT, "EDGE_ORDER" BIGINT, "length" DOUBLE, "SHAPE" ST_GEOMETRY(32630)
);

CREATE OR REPLACE FUNCTION "DAT260"."F_SPOO_EDGES"(
    IN i_startVertex BIGINT,
    IN i_endVertex BIGINT,
    IN i_direction NVARCHAR(10),
    IN i_mode NVARCHAR(10)
    )
  RETURNS "DAT260"."LONDON_EDGES"
LANGUAGE SQLSCRIPT READS SQL DATA AS
BEGIN
    DECLARE o_path_length DOUBLE;
    DECLARE o_path_weight DOUBLE;
  CALL "DAT260"."GS_SPOO_MULTI_MODE"(:i_startVertex, :i_endVertex, :i_direction, :i_mode, o_path_length, o_path_weight, o_edges);
  RETURN SELECT lbe.* FROM :o_edges AS P LEFT JOIN "DAT260"."LONDON_EDGES" lbe ON P."ID" = lbe."ID";
END;

SELECT AVG("PUBINESS")
    FROM "DAT260"."F_SPOO_EDGES"(1433737988, 1794145673, 'ANY', 'pub');

-- Compare two paths
SELECT "ID", "SHAPE" FROM "DAT260"."F_SPOO_EDGES"(1433737988, 1794145673, 'ANY', 'pub')
UNION
SELECT "ID", "SHAPE" FROM "DAT260"."F_SPOO_EDGES"(1433737988, 1794145673, 'ANY', 'bike');

-- exercise 9
CREATE TYPE "DAT260"."TT_SPOA_VERTICES" AS TABLE ("osmid" BIGINT, "CALCULATED_COST" DOUBLE);

CREATE OR REPLACE PROCEDURE "DAT260"."GS_SPOA"(
    IN i_startVertex BIGINT,         -- the key of the start vertex
    IN i_max DOUBLE,                -- the maximum distance/cost
    OUT o_vertices "DAT260"."TT_SPOA_VERTICES"
    )
LANGUAGE GRAPH READS SQL DATA AS
BEGIN
    GRAPH g = Graph("DAT260", "LONDON_GRAPH");
    VERTEX v_start = Vertex(:g, :i_startVertex);
    -- Running shortest paths one to all, which returns a subgraph. The WEIGHT based path length to a vertex is stored in the attribute CALCULATED_COST
    GRAPH g_spoa = SHORTEST_PATHS_ONE_TO_ALL(:g, :v_start, "CALCULATED_COST",
        (EDGE e, DOUBLE current_path_cost) => DOUBLE{
              IF(:current_path_cost < :i_max) { RETURN :e."length"/(DOUBLE(:e."SPEED_MPH")*0.44704); }
            ELSE { END TRAVERSE; }
          });
    o_vertices = SELECT :v."osmid", :v."CALCULATED_COST" FOREACH v IN Vertices(:g_spoa);
END;

-- Where can we go in 300 seconds starting Canary Wharf
CALL "DAT260"."GS_SPOA" (1433737988, 300, ?);

CREATE OR REPLACE FUNCTION "DAT260"."F_SPOA_VERTICES"(
    IN i_startVertex BIGINT,         -- the key of the start vertex
    IN i_max DOUBLE,                -- the maximum distance/cost
    IN i_resultType NVARCHAR(20)    -- indicates if the result should be POINTS, CONVEXHULL, or HEXAGON
    )
    RETURNS TABLE("ID" BIGINT, "SHAPE" ST_GEOMETRY(32630), "CALCULATED_COST" DOUBLE)
LANGUAGE SQLSCRIPT READS SQL DATA AS
BEGIN
    CALL "DAT260"."GS_SPOA"(:i_startVertex, :i_max, o_path_vertices);
    IF (:i_resultType = 'POINTS') THEN
        RETURN SELECT pv."osmid" AS "ID", lv."SHAPE", pv."CALCULATED_COST"
        FROM :o_path_vertices AS pv
        LEFT JOIN "DAT260"."LONDON_VERTICES" lv ON pv."osmid" = lv."osmid";
    ELSEIF (:i_resultType = 'CONVEXHULL') THEN
        RETURN SELECT i_startVertex AS "ID", ST_CONVEXHULLAGGR("SHAPE") AS "SHAPE", :i_max AS "CALCULATED_COST" FROM (
        SELECT pv."osmid", lv."SHAPE", pv."CALCULATED_COST"
        FROM :o_path_vertices AS pv
        LEFT JOIN "DAT260"."LONDON_VERTICES" lv ON pv."osmid" = lv."osmid");
    ELSEIF (:i_resultType = 'HEXAGON') THEN
        RETURN SELECT ST_CLUSTERID() AS "ID", ST_CLUSTERCELL() AS "SHAPE", CAST(AVG("CALCULATED_COST") AS DOUBLE) AS "CALCULATED_COST" FROM (
        SELECT pv."osmid", lv."SHAPE", pv."CALCULATED_COST"
        FROM :o_path_vertices AS pv
        LEFT JOIN "DAT260"."LONDON_VERTICES" lv ON pv."osmid" = lv."osmid")
        GROUP CLUSTER BY "SHAPE" USING HEXAGON X CELLS 50;
    END IF;
END;
-- again, exploring from Canary Wharf
SELECT * FROM "DAT260"."F_SPOA_VERTICES"(1433737988, 60, 'POINTS') ORDER BY "CALCULATED_COST" DESC;
SELECT * FROM "DAT260"."F_SPOA_VERTICES"(1433737988, 60, 'CONVEXHULL') ORDER BY "CALCULATED_COST" DESC;
SELECT * FROM "DAT260"."F_SPOA_VERTICES"(1433737988, 240, 'HEXAGON') ORDER BY "CALCULATED_COST" DESC;

CREATE OR REPLACE FUNCTION "DAT260"."F_SPOA_VERTICES_MULTI" (IN i_filter NVARCHAR(5000), IN i_max DOUBLE, IN i_resultType NVARCHAR(20))
    RETURNS TABLE("ID" BIGINT, "SHAPE" ST_GEOMETRY(32630), "CALCULATED_COST" DOUBLE)
LANGUAGE SQLSCRIPT READS SQL DATA AS
BEGIN
    startPOIs = APPLY_FILTER("DAT260"."LONDON_POI", :i_filter);
    res = MAP_MERGE(:startPOIs, "DAT260"."F_SPOA_VERTICES"(:startPOIs."VERTEX_OSMID", :i_max, :i_resultType));
    RETURN SELECT * FROM :res;
END;

SELECT * FROM "DAT260"."F_SPOA_VERTICES_MULTI"(' "amenity" = ''bicycle_repair_station'' ', 180, 'CONVEXHULL');

SELECT * FROM "DAT260"."LONDON_TUBE_STATIONS";
SELECT * FROM "DAT260"."LONDON_TUBE_CONNECTIONS";

CREATE GRAPH WORKSPACE "DAT260"."TUBE_GRAPH"
    EDGE TABLE "DAT260"."LONDON_TUBE_CONNECTIONS"
        SOURCE COLUMN "SOURCE"
        TARGET COLUMN "TARGET"
        KEY COLUMN "ID"
    VERTEX TABLE "DAT260"."LONDON_TUBE_STATIONS"
        KEY COLUMN "ID";

CREATE TYPE "DAT260"."TT_RESULT_CC" AS TABLE (
    "ID" BIGINT, "CLOSENESS_CENTRALITY" DOUBLE, "NORMALIZED_CLOSENESS_CENTRALITY" DOUBLE, "HARMONIC_CENTRALITY" DOUBLE, "NORMALIZED_HARMONIC_CENTRALITY" DOUBLE
);

CREATE OR REPLACE PROCEDURE "DAT260"."GS_CC_SINGLE_SOURCE"(
    IN i_start BIGINT,
    OUT o_vertices "DAT260"."TT_RESULT_CC"
    )
LANGUAGE GRAPH READS SQL DATA AS
BEGIN
    GRAPH g = Graph("DAT260","TUBE_GRAPH");
  -- we need to add attributes to the vertices to store the data
    ALTER g ADD TEMPORARY VERTEX ATTRIBUTE (DOUBLE "CLOSENESS_CENTRALITY");
    ALTER g ADD TEMPORARY VERTEX ATTRIBUTE (DOUBLE "NORMALIZED_CLOSENESS_CENTRALITY");
    ALTER g ADD TEMPORARY VERTEX ATTRIBUTE (DOUBLE "HARMONIC_CENTRALITY");
    ALTER g ADD TEMPORARY VERTEX ATTRIBUTE (DOUBLE "NORMALIZED_HARMONIC_CENTRALITY");
  -- initialize the start vertex and some variables
    VERTEX v_start = Vertex(:g, :i_start);
    BIGINT v_sumNodes = 0L;
    BIGINT v_sumCost = 0L;
    DOUBLE v_sumReciprocCost = 0.0;
  -- now we are traversing the graph from the start vertex, following the edges in any direction.
  -- when a vertex is visited, the vertex is accessible as "v_visited". The "level" information is stored in "lvl".
  -- within the vertex visit event, we increase the sum of visited nodes and the sum of costs.
    TRAVERSE BFS ('ANY') :g FROM :v_start ON VISIT VERTEX (Vertex v_visited, BIGINT lvl) {
        IF (:lvl > 0L){
            v_sumNodes = :v_sumNodes + 1L;
            v_sumCost = :v_sumCost + :lvl;
            v_sumReciprocCost = :v_sumReciprocCost + 1.0/DOUBLE(:lvl);
        }
    };
  -- if the traversal is finished, we derive the final measures
    IF (:v_sumCost > 0L AND :v_sumReciprocCost > 0.0 AND :v_sumNodes > 1L){
        v_start."CLOSENESS_CENTRALITY" = 1.0/DOUBLE(:v_sumCost);
        v_start."NORMALIZED_CLOSENESS_CENTRALITY" = DOUBLE(:v_sumNodes)/DOUBLE(:v_sumCost);
        v_start."HARMONIC_CENTRALITY" = :v_sumReciprocCost;
        v_start."NORMALIZED_HARMONIC_CENTRALITY" = :v_sumReciprocCost/DOUBLE(:v_sumNodes);
    }
    MULTISET<Vertex> m_v = v IN Vertices(:g) WHERE :v."CLOSENESS_CENTRALITY" >= 0.0;
    o_vertices = SELECT :v."ID", :v."CLOSENESS_CENTRALITY", :v."NORMALIZED_CLOSENESS_CENTRALITY", :v."HARMONIC_CENTRALITY", :v."NORMALIZED_HARMONIC_CENTRALITY" FOREACH v IN :m_v;
END;

CALL "DAT260"."GS_CC_SINGLE_SOURCE"(117, ?);

CREATE OR REPLACE FUNCTION "DAT260"."F_CC_SINGLE_SOURCE"(IN i_start BIGINT)
    RETURNS "DAT260"."TT_RESULT_CC"
LANGUAGE SQLSCRIPT READS SQL DATA AS
BEGIN
    CALL "DAT260"."GS_CC_SINGLE_SOURCE"(:i_start, result);
    RETURN :result;
END;

CREATE OR REPLACE FUNCTION "DAT260"."F_CC_MAP_MERGE" ()
    RETURNS "DAT260"."TT_RESULT_CC"
LANGUAGE SQLSCRIPT READS SQL DATA AS
BEGIN
    startVertices = SELECT DISTINCT "ID" FROM "DAT260"."LONDON_TUBE_STATIONS";
    result = MAP_MERGE(:startVertices, "DAT260"."F_CC_SINGLE_SOURCE"(:startVertices."ID"));
    RETURN :result;
END;

SELECT * FROM "DAT260"."F_CC_MAP_MERGE"() ORDER BY "NORMALIZED_CLOSENESS_CENTRALITY" DESC;

SELECT *
  FROM "DAT260"."F_CC_MAP_MERGE"() AS C
    LEFT JOIN "DAT260"."LONDON_TUBE_STATIONS" AS S
  ON C."ID" = S."ID"
    ORDER BY "NORMALIZED_CLOSENESS_CENTRALITY" DESC;
