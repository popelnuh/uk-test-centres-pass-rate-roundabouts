# Roundabouts and Practical Driving Test Pass Rate

Is there a relationship between the number of roundabouts and the driving test pass rate?

I have decided to calculate this relationship and visualise it on a [map](http://www.popelnuh.com/roundabouts.html). 

In this project I calculate the number of roundabouts within 30km radius form the UK test centres.


### Datasets:
* Car driving test data by test centres (Car pass rates by gender, month and test centre)
[source](https://www.gov.uk/government/statistical-data-sets/car-driving-test-data-by-test-centre)
* Driving test centres
[source](https://data.gov.uk/dataset/fe19beff-5716-4ca9-be58-027e56856b48/driving-test-centres)
* Ordnance Survey OS Open Roads
[source](https://www.ordnancesurvey.co.uk/opendatadownload/products.html)


### Tools and Method:
* R - data cleaning, joining tables, running statistics.
* Postgres/PostGIS - geospatial processing.
* MapBox - Visualisation.

### TODO - There are still a few things left to do.
* (R) Investigate why some test centres were not joined.
* (R) Interpret statistics.
* (PostGIS) Use different distance cutoffs.




