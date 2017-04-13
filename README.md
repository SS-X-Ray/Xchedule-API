# Xchedule API
[![Dependency Status](https://gemnasium.com/badges/github.com/SS-X-Ray/Xchedule-API.svg)](https://gemnasium.com/github.com/SS-X-Ray/Xchedule-API)

This API is for the Xchedule App. You can retrieve, search and store data with specific route.


## Routes
* GET `/`
Check whether API is alive

* GET `api/v1/schedule`
Retrieve all the schedules with it's ID

* GET `api/v1/schedule/:id.json`
Retrieve the specific schedule of the ID in the parameter

* POST `api/v1/schedule`
Pass a JSON body with the post request to store the schedule in our API DB
