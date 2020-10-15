# Getting Started

This section should get you started by going through all technical pre-requisites. Additionally you will be introduced to the dataset and some background information and material will be given.

## Setup SAP HANA Cloud Trial Instance <a name="subex1"></a>

SAP HANA Cloud is a service on the SAP Cloud Platform.
First of all, you need to register for the 30-days free trial of SAP HANA Cloud.
To do so, click on this [link](https://www.sap.com/registration/trial.9a2d77fd-9c7a-48d7-b618-5b83ba9d0445.html) and follow the process.

After registering for the SAP HANA Cloud trial, here's how to access your SAP HANA Cloud trial:

  1. Go to the [SAP Cloud Platform trial home](https://account.hanatrial.ondemand.com/register). This takes you to the SAP Cloud Platform Cockpit.

  2. Click on the "Enter Your Trial Account" button. This takes you to the SAP Cloud Platform 

  3. Click on the "trial" subaccount tile.

  4. Under Spaces, click on the "dev" space.

  5. Click on "SAP HANA Cloud" in the left navigation menu. 

You're now in the SAP HANA Cloud trial! 


- graph and spatial is there
- create user other than dbadmin and assign right for importing catalog objects
![](images/privilege_assignment.png)
- access db explorer

## Base Data & Demo Scenario <a name="subex2"></a>
The data for the exercises is packaged as a HANA database export. The [export file](../data/DAT260.tar.gz) is in the data folder. Please download the file to your local computer.

Once you downloaded the export file, you can use the Database Explorer to connect to your HANA Cloud system. Right-click "Catalog" and choose "import catalog objects" to start the wizard.

![](images/import_catalog_objects.png)
- execute test script to see that spatial and graph is working

After import, you'll find 5 tables in the schema "DAT260". There is **LONDON_POI** which contains 90k points of interest in the London area. This includes pubs and bike repair shops. The street network data is in **LONDON_EDGES**, which represents the actual 1.5 million street segments, and **LONDON_VERTICES**, which describes the 800,000 road junctions. Finally, there are two tables containing data of the London Tube system - station and connections.

The data was downloaded using the [osmnx](https://github.com/gboeing/osmnx) python package and imported into HANA using the [Python Machine Learning Client for SAP HANA](https://pypi.org/project/hana-ml/).

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
