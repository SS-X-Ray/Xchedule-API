# Xchedule API
[![Dependency Status](https://gemnasium.com/badges/github.com/SS-X-Ray/Xchedule-API.svg)](https://gemnasium.com/github.com/SS-X-Ray/Xchedule-API)
[ ![Codeship Status for SS-X-Ray/Xchedule-API](https://app.codeship.com/projects/76ec62b0-1244-0135-9dbc-4a1a20133278/status?branch=master)](https://app.codeship.com/projects/216992)

This API is for the Xchedule App. You can retrieve, search and store data with specific route.


## Routes
* GET `/`

Check whether API is alive

* GET `api/v1/activity/:id`

Retrieve the activity with the activity's ID

* POST `api/v1/activity/`

Send a `JSON` post request to our database with `activity name, possible time, result time, location`. (It's ok to send partial data.)

* PATCH `api/v1/activity`

Update the database with the selected activity.

`activity_id` is necessary, other columns are optional.

* GET `api/v1/participant/:activity_id`

Retrieve the participants in a selected activity with `activity_id`

* POST `api/v1/participant/`

Send a `JSON` post request to our database with `activity_id`, to join a participant to an activity.
