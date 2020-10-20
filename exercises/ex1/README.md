# Exercise 1 - Add Planar Geometries Based on WGS84 Geometries

In our current dataset, we have a column of type [`ST_Geometry`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a1f0883787c101495ac9074d9bf3923.html) holding latitude and longitude values.

We can view latitude and longitude as double values by selecting [`ST_X()`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a290e0d787c10149429b3677c80c5a5.html) and [`ST_Y()`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a295b1d787c1014b19cb803454504b4.html) from our geometry columnn.
```sql
SELECT 
	"geometry_GEO".ST_X() AS LONGITUDE, 
	"geometry_GEO".ST_Y() AS LATITUDE 
FROM LONDON_VERTICES;
```

Geometries can be represented in different [Spatial Reference Systems (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system). The given latitude and longitude values are based on a round-earth model and the corresponding spatial reference system is [WGS84 (id 4326)](https://de.wikipedia.org/wiki/World_Geodetic_System_1984).

For performance reasons, it is recommended to use a projected spatial reference system instead of a round-earth model. This way euclidean geometry can be used for spatial calculations, which is less expensive than calculations on the sphere. The second general recommendation when dealing with spatial data is to persist the base geometries. This way, in-database optimizations such a spatial indices can be leveraged.

Check out this brief [Youtube Video](https://www.youtube.com/watch?v=s48iAbBrYBI&list=PL6RpkC85SLQA8za7iX9FRzewU7Vs022dl&index=2) to get an overview of the concept of Spatial Reference Systems.

## Exercise 1.1 - Create Planar Spatial Reference System <a name="subex1"></a>
---
**Create the spatial reference system with id 32630.**

---

SAP HANA is already aware of more than 9000 spatial reference systems - including the spatial reference system defined by [EPSG](https://epsg.org/). A suitable projected spatial reference system for UK is the [SRS with id 32630](http://epsg.io/32630).

Before, we can create our first column using this SRS, we need to install it on SAP HANA. Installation has to be done only the first time we are using this SRS. Since 32630 is part of EPSG and already known to HANA, we can issue our [creation statement](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/9ebcad604e8d4c43a802d08cfdbe8ab2.html) referencing only the id of the SRS.

```sql
CREATE PREDEFINED SPATIAL REFERENCE SYSTEM IDENTIFIED BY 32630;
```

A list of all installed SRS can be found in table [`ST_SPATIAL_REFERENCE_SYSTEMS`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a2ea357787c101488ecd1b725836f07.html). To confirm, that the above statement has installed SRS 32630, you can check the result set of following statement.

```sql
SELECT * FROM ST_SPATIAL_REFERENCE_SYSTEMS WHERE SRS_ID = 32630;
```

Continue with the next step, if there is one record in the result set.

## Exercise 1.2 - Add Column with Type ST_Geometry <a name="subex2"></a>
---
**Add a column named `SHAPE` of type `ST_Geometry`, that is able to hold geometries with srs 32630.**

---

Before we can actually persist the geometry data with the now installed srs, we need to create a column for storing this data. We will enhance the existing tables by using the [`ALTER TABLE`](https://help.sap.com/viewer/c1d3f60099654ecfb3fe36ac93c121bb/2020_03_QRC/en-US/20d329a6751910149d5fdbc4800f92ff.html) statement.

```sql
ALTER TABLE LONDON_POI ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_EDGES ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_VERTICES ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_TUBE_CONNECTIONS ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_TUBE_STATIONS ADD (SHAPE ST_Geometry(32630));
```

## Exercise 1.3 - Persist Projected Geometries <a name="subex3"></a>
---
**Fill column `SHAPE` with geometries in srs 32630 constructed out of the existing WGS84 geometries.**

---

To transform geometries from one spatial reference system into another, function [`ST_Transform`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/e2b1e876847a47de86140071ba487881.html) can be used. To transform the existing geometries to srs 32630 and persist the result in column `SHAPE` the following statements need to be issued.

```sql
UPDATE LONDON_POI SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_EDGES SET SHAPE = "geometry_GEO".ST_Transform(32630);
UPDATE LONDON_VERTICES SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_TUBE_CONNECTIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);
UPDATE LONDON_TUBE_STATIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);
```

## Summary

You've now enhanced the existing data model by a planar projection of the WGS84 geometries.

Continue to - [Exercise 2 - Determine Distance to Target Point of Interest (POI)](../ex2/README.md)

