# Getting Started

This section should get you started by going through all technical pre-requisites. Additionally you will be introduced to the dataset and some background information and material will be given

## Setup SAP HANA Cloud Trial Instance <a name="subex1"></a>
- create instance
- graph and spatial is there
- create user other than dbadmin and assign right for importing catalog objects
![](images/privilege_assignment.png)
- access db explorer

## Base Data & Demo Scenario <a name="subex2"></a>
- download data
- upload data to trial instance
- execute test script to see that spatial and graph is working
- description of data model and data source
- how data has been prepared (e.g. osmnx)

## Spatial Visualizations <a name="subex3"></a>
- dbeaver
- wicket with st_transform and st_aswkt
- st_assvg and browser (increase clob limit)

## General Structure of Exercises <a name="subex4"></a>
- exercise text and solution
- 1-5 = spatial
- 6-9 = graph

## Background Material <a name="subex5"></a>
- devtoberfest
- spatial reference
- graph reference
- blogs

## Summary
You should now have an overview of the technical pre-requisites as well as the necessary background information to master the exercises of DAT260!
 
Continue to - [Exercise 1 - Add Planar Geometries Based on WGS84 Geometries](../ex1/README.md)
