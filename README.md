# DAT260 - Multimodel Data Processing: SAP HANA Cloud and SAP HANA

## Description

This repository contains the material for the SAP TechEd 2020 session called Session ID - Session Title.

## Overview

This session introduces attendees to...

## Requirements

The requirements to follow the exercises in this repository are...

## Exercises

- [Getting Started](exercises/ex0/)
    - [Setup SAP HANA Cloud Trial Instance](exercises/ex0#subex1)
    - [Base Data & Demo Scenario](exercises/ex0#subex2)
    - [Spatial Visualizations](exercises/ex0#subex3)
    - [General Structure of Exercises](exercises/ex0#subex4)
    - [Background Material](exercises/ex0#subex5)
- [Exercise 1 - Add Planar Geometries Based on WGS84 Geometries](exercises/ex1/)
    - [Exercise 1.1 - Create Planar Spatial Reference System](exercises/ex1#subex1)
    - [Exercise 1.2 - Add Column with Type ST_Geometry](exercises/ex1#subex2)
    - [Exercise 1.3 - Persist Projected Geometries](exercises/ex1#subex3)
- [Exercise 2 - Determine Distance to Target Point of Interest (POI)](exercises/ex2/)
    - [Exercise 2.1 - Select a Location via SQL](exercises/ex2#subex1)
    - [Exercise 2.2 - Select Target POI](exercises/ex2#subex2)
    - [Exercise 2.3 - Determine Distance using ST_Distance](exercises/ex2#subex3)
- [Exercise 3 - Identify Relevant Area for Transportation Network](exercises/ex3/)
    - [Exercise 3.1 - Create Circle for Relevant Area](exercises/ex3#subex1)
    - [Exercise 3.2 - Add Flag for all Nodes in Circle](exercises/ex3#subex2)
- [Exercise 4 - Check out the Suitability of this Area for Bike Rides](exercises/ex4/)
    - [Exercise 4.1 - Identify Cycleways](exercises/ex4#subex1)
    - [Exercise 4.2 - Create a Scalable Vector Graphic (SVG) to Visualize Cycleways](exercises/ex4#subex2)
    - [Exercise 4.3 - Use Voronoi to Understand the Coverage of Bike Repair Stations](exercises/ex4#subex3)
- [Exercise 5 - Snap POIs to Nodes of Street Network](exercises/ex5/)
    - [Exercise 5.1 - Persist Voronoi Cells for all Nodes](exercises/ex5#subex1)
    - [Exercise 5.2 - Persist Centroid for each Point of Interest](exercises/ex5#subex2)
    - [Exercise 5.3 - Enhance POI Table with Node Reference](exercises/ex5#subex3)
- [Exercise 6 - Prepare data for the Graph Engine and create a Graph Workspace](exercises/ex6/)
    - [Exercise 6.1 Define required Constraints on the Tables](exercises/ex6#subex1)
    - [Exercise 6.2 Create a Graph Workspace](exercises/ex6#subex2)
- [Exercise 7 - Use a GRAPH Procedure to calculate Shortest Paths on the street network](exercises/ex7/)
    - [Exercise 7.1 Define required Table Type for the Procedure](exercises/ex7#subex1)
    - [Exercise 7.2 Create a GRAPH Procedure for Shortest Path Calculation](exercises/ex7#subex2)
    - [Exercise 7.3 Anonymous Blocks - Running GRAPH Code in an ad-hoc manner <a name="subex3"></a> ](exercises/ex7#subex3)
- [Exercise 8 - Calculate Shortest Paths with a more complex cost function](exercises/ex8/)
    - [Exercise 8.1 Generate a numeric column that contains the maximum speed allowed information](exercises/ex8#subex1)
    - [Exercise 8.2 Calculate Shortest Paths, minimizing the time it takes to get from start to end](exercises/ex8#subex2)
    - [Exercise 8.3 Finding Pubs and Bikelanes](exercises/ex8#subex3)
    - [Exercise 8.4 Wrapping a Procedure in a Table Function](exercises/ex8#subex4)
- [Exercise 9 - Calculate Isochrones and Closeness Centrality](exercises/ex9/)
    - [Exercise 9.1 Using Shortest_Path_One_To_All](exercises/ex9#subex1)
    - [Exercise 9.2 Using TRAVERSE BFS to implement Closeness Centrality](exercises/ex9#subex2)

## How to obtain support

Support for the content in this repository is available during the actual time of the online session for which this content has been designed. Otherwise, you may request support via the [Issues](../../issues) tab.

## License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
