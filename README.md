
# Local Setup Directions

## Install Ruby and Rails
Install rbenv using [these instructions](https://github.com/rbenv/rbenv#using-package-managers) 

Using rbenv, install ruby version 2.7.2

```
rbenv install 2.7.2
```

Finally, install Rails version 5.2.8

```
gem install rails --version 5.2.8
```

## Check out source code
```
git clone git@github.com:sjmann2/fetch-take-home.git
cd fetch-take-home
```

## Install source code and run project
```
bundle install
rails db:{create,migrate}
rails server
```

# Endpoints available
## Base URL 
http://localhost3000/api/v1

## Create transaction record
POST '/transactions' requires parameters to be passed as raw JSON
```JSON
{ "payer": "DANNON", "points": 300, "timestamp": "2022-10-31T10:00:00Z" }
```
### Example response
```JSON
{
    "data": {
        "id": 18,
        "type": "transaction",
        "attributes": {
            "payer": "DANNON",
            "points": 300,
            "timestamp": "2022-10-31T10:00:00.000Z"
        }
    }
}
```

## Spend points
PATCH '/points' requires parameters to be passed as raw JSON
```JSON
{"points": 5000}
```
### Example response
```JSON
[
  { "payer": "DANNON", "points": -100 },
  { "payer": "UNILEVER", "points": -200 },
  { "payer": "MILLER COORS", "points": -4700 }
]
```

## View points balance
GET '/points'
### Example response
```JSON
{
  "DANNON": 1000,
  "UNILEVER" : 0,
  "MILLER COORS": 5300
}
```
