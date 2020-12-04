# DAT260 - 使用SAP HANA Cloud进行多模式数据处理

## 说明

此代码库包含SAP TechEd 2020动手实验室的资料，本课程为DAT260-使用SAP HANA Cloud进行多模式数据处理。

## 概要

本次会议向与会者介绍了如何处理 **空间** 和 **网络** 数据。 在整个练习中，我们使用来自OpenStreetMap的数据. 它包括了来自伦敦区域的 **道路网络** 与兴趣点 (**POI**) 数据. 这个练习的数据是利用 [osmnx](https://github.com/gboeing/osmnx) python 包来准备的，并且利用此 [Python Machine Learning Client for SAP HANA](https://pypi.org/project/hana-ml/) 工具库载入HANA Cloud。 在单元1-5中，您将主要处理数据集的几何实体。 这包括处理HANA表中的空间数据，距离计算，以及将POI“捕捉”到街道网络的空间方法。 在单元6-9中，我们将探索该网络中的不同路径，生成等时线，并计算简单的集中度度量。

## 前置条件

对于此代码库中的练习，对SQL的基本理解非常有帮助. 为了充分利用内容，我们建议您花一些时间来“阅读”并理解SQL语句和存储过程-不仅仅是复制/粘贴和执行 ;-)。 所解释的某些概念可以在许多不同的场景中重复使用。
此外，您还需要设置自己的环境来运行练习。 它包括一个 **SAP HANA Cloud** 系统和 DBeaver (开源数据库工具).不用担心，安装并不复杂。 请务必按照 [开始准备](ex0/README.md)章节进行。


## 练习

- [开始准备](exercises/ex0/)
    - [设置SAP HANA Cloud试用实例](exercises/ex0#subex1)
    - [基本数据 & 演示场景](exercises/ex0#subex2)
    - [空间可视化](exercises/ex0#subex3)
    - [练习的总体结构](exercises/ex0#subex4)
    - [参考资料](exercises/ex0#subex5)
- [练习 1 - 根据WGS84参考系添加平面几何实体](exercises/ex1/)
    - [练习 1.1 - 创建平面空间参考系统](exercises/ex1#subex1)
    - [练习 1.2 - 添加类型为ST_Geometry的列](exercises/ex1#subex2)
    - [练习 1.3 - 储存投影后的几何实体](exercises/ex1#subex3)
- [练习 2 - 确定到目标兴趣点的距离(POI)](exercises/ex2/)
    - [练习 2.1 - 通过SQL语句选择一个位置](exercises/ex2#subex1)
    - [练习 2.2 - 选择目标兴趣点POI](exercises/ex2#subex2)
    - [练习 2.3 - 使用ST_Distance计算距离](exercises/ex2#subex3)
- [练习 3 - 确定交通网络的相关区域](exercises/ex3/)
    - [练习 3.1 - 为相关区域创建圆区域](exercises/ex3#subex1)
    - [练习 3.2 - 为圆内所有节点添加标识](exercises/ex3#subex2)
- [练习 4 - 查看这个地区是否适合骑自行车](exercises/ex4/)
    - [练习 4.1 - 确定骑行路线](exercises/ex4#subex1)
    - [练习 4.2 - 创建可缩放矢量图形（SVG）以可视化自行车道](exercises/ex4#subex2)
    - [练习 4.3 - 使用Voronoi确定自行车维修站的覆盖范围](exercises/ex4#subex3)
- [练习 5 - 将POI捕捉到街道网络的节点](exercises/ex5/)
    - [练习 5.1 - 持久化所有节点的Voronoi Cells](exercises/ex5#subex1)
    - [练习 5.2 - 持久化每个兴趣点的质心](exercises/ex5#subex2)
    - [练习 5.3 - 使用节点参考增强POI表](exercises/ex5#subex3)
- [练习 6 -  为图引擎准备数据并创建图工作区](exercises/ex6/)
    - [练习 6.1 在表上定义所需的约束](exercises/ex6#subex1)
    - [练习 6.2 创建一个 Graph Workspace](exercises/ex6#subex2)
- [练习 7 - 使用图储存过程计算街道网络上的最短路径](exercises/ex7/)
    - [练习 7.1 定义程序所需的表类型](exercises/ex7#subex1)
    - [练习 7.2 创建用于最短路径计算的图储存过程](exercises/ex7#subex2)
    - [练习 7.3 匿名块-临时运行GRAPH代码 <a name="subex3"></a> ](exercises/ex7#subex3)
- [练习 8 - 使用一个更复杂的费用函数计算最短路径](exercises/ex8/)
    - [练习 8.1 生成一个数字列，其中包含允许的最大速度信息](exercises/ex8#subex1)
    - [练习 8.2 计算最短路径，以最小化从头到尾花费的时间](exercises/ex8#subex2)
    - [练习 8.3 寻找酒吧和自行车道](exercises/ex8#subex3)
    - [练习 8.4 在表函数中包装存储过程](exercises/ex8#subex4)
- [练习 9 - 计算等时线和接近中心性](exercises/ex9/)
    - [练习 9.1 使用Shortest_Path_One_To_All](exercises/ex9#subex1)
    - [练习 9.2 使用遍历BFS实现接近中心性](exercises/ex9#subex2)

## 如何获得支持

在本次TechED会议的此动手实验室的在线时间，您可以获得在线支持。否则, 您可以通过 [Issues](../../issues) 选项卡获得支持。

## 授权
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
