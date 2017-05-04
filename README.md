# Xchedule API
[![Dependency Status](https://gemnasium.com/badges/github.com/SS-X-Ray/Xchedule-API.svg)](https://gemnasium.com/github.com/SS-X-Ray/Xchedule-API)
[ ![Codeship Status for SS-X-Ray/Xchedule-API](https://app.codeship.com/projects/76ec62b0-1244-0135-9dbc-4a1a20133278/status?branch=master)](https://app.codeship.com/projects/216992)

This API is for the Xchedule App. You can retrieve, search and store data with specific route.


## Routes
#### Account Related Routes
* GET `/`
Check whether API is alive

* GET `api/v1/account/:id`
**Provide**: *Account ID*
**Get**: *Account Info*

* POST `api/v1/account/`
**Provide**: *{ username: "", email: "", password: "" }*
**Return**: *nil*

* GET `api/v1/account/participants/:account_id`
**Provide**: *Account ID*
**Get**: *Activities that the Account participate in*

* POST `api/v1/account/authenticate`
**Provide**: *{ email: "", password: "" }*
**Return**: *Account Object*

#### Activity Related Routes
* GET `api/v1/activity/:id`
**Provide**: *Activity ID*
**Get**: *Activity info*

* POST `api/v1/activity/`
**Provide**: *{ organizer_id: "", name: "", location: "" }*
**Get**: *nil*

* POST `api/v1/participant/`
**Provide**: *{ participant_id: "", activity_id: "" }*
**Get**: *nil*

* PATCH `api/v1/activity`
**Provide**: *{ update_data: {activity_id: "", possible_time: "", result_time: ""} }*
**Get**: *nil*
Update the database with the selected activity.
`activity_id` is necessary, other columns are optional.

## API Running @
https://xcheduleapi.herokuapp.com/

## Install
Install this API by cloning the relevant branch and installing required gems:
```
$ bundle install
```

## Testing
Test this API by running:
```
$ RACK_ENV=test rake db:migrate
$ bundle exec rake spec
```

## Develop
Run this API during development:
```
$ rake db:migrate
$ bundle exec rackup
```

or use autoloading during development:
```
$ bundle exec rerun rackup
```
