# 练习1-基于WGS84空间参考系添加平面几何实体

在当前数据集中，我们有一列[`ST_Geometry`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a1f0883787c101495ac9074d9bf3923.html)类型的列，其中包含纬度和经度值。  

通过从几何列中选择[`ST_X()`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a290e0d787c10149429b3677c80c5a5.html)和[`ST_Y()`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a295b1d787c1014b19cb803454504b4.html)，我们可以将纬度和经度视为双值。

```sql
SELECT 
	"geometry_GEO".ST_X() AS LONGITUDE, 
	"geometry_GEO".ST_Y() AS LATITUDE 
FROM LONDON_VERTICES;
```

几何实体可以用不同的空间参考系[Spatial Reference Systems (SRS)](https://en.wikipedia.org/wiki/Spatial_reference_system)表示。 给定的纬度和经度值基于圆形地球模型，并且相应的空间参考系统为[WGS84 (id 4326)](https://de.wikipedia.org/wiki/World_Geodetic_System_1984)。

出于性能原因，建议使用投影空间参考系统而不是圆形地球模型。 这样，欧几空间可以被用于空间计算，这比在球体上的计算简单。 处理空间数据时的第二个建议是保留基本几何形状。 这样，可以利用数据库内优化（例如空间索引）。

观看这段简短的[YouTube视频](https://www.youtube.com/watch?v=s48iAbBrYBI&list=PL6RpkC85SLQA8za7iX9FRzewU7Vs022dl&index=2)，以了解空间参考系统的概念。

## 练习1.1-创建平面空间参考系统

---
**创建具有ID 32630的空间参考系统。**

---

SAP HANA已经内置了9000多个空间参考系统-包括通过[EPSG](https://epsg.org/)定义的空间参考系统。 适用于英国的投影空间参考系统是[SRS with id 32630](http://epsg.io/32630)。

在我们可以使用此SRS创建我们的第一个空间几何列之前，我们需要将其安装在SAP HANA上。 安装仅需要在我们第一次使用此SRS时完成。 由于32630是EPSG的一部分，并且已知存在于HANA中，因此我们可以发布仅参考SRS ID的创建语句[creation statement](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/9ebcad604e8d4c43a802d08cfdbe8ab2.html)。

```sql
CREATE PREDEFINED SPATIAL REFERENCE SYSTEM IDENTIFIED BY 32630;
```

可以在表[ST_SPATIAL_REFERENCE_SYSTEMS](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/7a2ea357787c101488ecd1b725836f07.html)中找到所有已安装的SRS的列表。 为了确认上述语句已安装SRS 32630，可以检查以下语句的结果集。

```sql
SELECT * FROM ST_SPATIAL_REFERENCE_SYSTEMS WHERE SRS_ID = 32630;
```

如果结果集中有一个记录，请继续下一步。 

## 练习1.2-添加类型为ST_Geometry的列

---
**添加一个名为 `SHAPE` 的类型为 `ST_Geometry` 的列，该列能够使用SRS 32630保存几何实体。**

---

在我们可以使用现在安装的SRS持久保存几何数据之前，我们需要创建一列来存储此数据。 我们将使用[`ALTER TABLE`](https://help.sap.com/viewer/c1d3f60099654ecfb3fe36ac93c121bb/2020_03_QRC/en-US/20d329a6751910149d5fdbc4800f92ff.html)语句增强现有的表。

```sql
ALTER TABLE LONDON_POI ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_EDGES ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_VERTICES ADD (SHAPE ST_Geometry(32630));

ALTER TABLE LONDON_TUBE_CONNECTIONS ADD (SHAPE ST_Geometry(32630));
ALTER TABLE LONDON_TUBE_STATIONS ADD (SHAPE ST_Geometry(32630));
```

## 练习1.3-储存投影后的几何形状

---
**在SRS 32630中使用由现有WGS84几何实体构成的几何图形来填充列 `SHAPE`。**

---

要将几何形状从一个空间参考系转换为另一个空间参考系，可以使用方法[`ST_Transform`](https://help.sap.com/viewer/bc9e455fe75541b8a248b4c09b086cf5/2020_03_QRC/en-US/e2b1e876847a47de86140071ba487881.html)。 要将现有几何转换为SRS 32630并将结果保留在 `SHAPE` 列中，需要运用以下语句。

```sql
UPDATE LONDON_POI SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_EDGES SET SHAPE = "geometry_GEO".ST_Transform(32630);
UPDATE LONDON_VERTICES SET SHAPE = "geometry_GEO".ST_Transform(32630);

UPDATE LONDON_TUBE_CONNECTIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);
UPDATE LONDON_TUBE_STATIONS SET SHAPE = SHAPE_4326.ST_Transform(32630);
```

## 总结

现在，您已经通过WGS84几何图形的平面投影增强了现有数据模型。

继续到-[练习2-确定到目标兴趣点（POI）的距离](../ex2/README.md)
