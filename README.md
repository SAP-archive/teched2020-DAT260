# DAT260 - Multimodel Data Processing: SAP HANA Cloud and SAP HANA

## Description

This repository contains the material for the SAP TechEd 2020 session called Session ID - Session Title. 

## Overview

This session introduces attendees to...

## Requirements

The requirements to follow the exercises in this repository are...

## Exercises

Provide the exercise content here directly in README.md using [markdown](https://guides.github.com/features/mastering-markdown/) and linking to the specific exercise pages, below is an example.

- [Getting Started](exercises/ex0/)
- [Exercise 1 - First Exercise Description](exercises/ex1/)
    - [Exercise 1.1 - Exercise 1 Sub Exercise 1 Description](exercises/ex1#exercise-11-sub-exercise-1-description)
    - [Exercise 1.2 - Exercise 1 Sub Exercise 2 Description](exercises/ex1#exercise-12-sub-exercise-2-description)
- [Exercise 2 - Second Exercise Description](exercises/ex2/)
    - [Exercise 2.1 - Exercise 2 Sub Exercise 1 Description](exercises/ex2#exercise-21-sub-exercise-1-description)
    - [Exercise 2.2 - Exercise 2 Sub Exercise 2 Description](exercises/ex2#exercise-22-sub-exercise-2-description)

Planned structure of Exercises:
* Explore data
* Add planar geometries (starting from 4326 geometries)
    * create planar srs
    * add columns
    * update columns with st_tranform
* Calculate the direct distance between 'your location' and the destination POI
    * select your location with sql stmt
    * select target poi
    * use st_distance
* Identify relevant area for route finding/transportation network
    * create circle for relevant area (+ buffer 250m, maybe)
    * set flag "in_scope = true" for all node in circle
* Check in how far the area is suitable for bike rides
    * identify cycleways
    * st_unionaggr + visualization
    * simple voronoi with bicycle repair stations
* Snapping: Connect pois and nodes/edges (via Voronoi)
    * persists voronoi cells for each node
    * add column to poi table which refers to associated node
* pre-process data for use with graph engine
    * simplify network?
* calculate shortest path from start to target
* calculate low-cost path from start to target
    * pub index? cycle way usage? bicycle repair stations?
* something about centrality, subnetworks?

**OR** Link to the PDF document stored in your github repo for example...

Start the exercises [here](exercises/myPDFDoc.pdf).
    
**OR** Link to the Tutorial Navigator for example...

Start the exercises [here](https://developers.sap.com/tutorials/abap-environment-trial-onboarding.html).

**IMPORTANT**

Your repo must contain the .reuse and LICENSES folder and the License section below. DO NOT REMOVE the section or folders/files. Also, remove all unused template assets(images, folders, etc) from the exercises folder. 

## How to obtain support

Support for the content in this repository is available during the actual time of the online session for which this content has been designed. Otherwise, you may request support via the [Issues](../../issues) tab.

## License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
