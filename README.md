# Description

This project is a simple receipt processor app which is created using Ruby on Rails. 

In the [receipts_controller.rb](/app/controllers/receipts_controller.rb) we have 2 main methods: 

- The create method receives a receipt objects, assigns an id to it, calculates the points based on the rules we have in the `calculate_points` method and stores the id along with the points in the rails cache. We could use Redis for caching purpose, but I preferred to use Rails cache because it is a built in feature in rails and we don't need to have a separate server for Redis. 

- The points method is responsible to search for an id it gets in the rails cache and return the point. 

Since everything is stored in the rails cache, we don't have and don't need a database. The default expiration time is set to 1 hour and the data will be removed by stopping the server. 


# Setup Guide

- Build docker image `docker build -t receipt_processor .`
- Run container `docker run -p 3000:3000 --name receipt_processor_api receipt_processor`

# End points

### [POST] http://localhost:3000/receipts/process

Sample payload
```
{
  "retailer": "Target",
  "purchaseDate": "2022-01-01",
  "purchaseTime": "13:01",
  "items": [
    {
      "shortDescription": "Mountain Dew 12PK",
      "price": "6.49"
    },{
      "shortDescription": "Emils Cheese Pizza",
      "price": "12.25"
    },{
      "shortDescription": "Knorr Creamy Chicken",
      "price": "1.26"
    },{
      "shortDescription": "Doritos Nacho Cheese",
      "price": "3.35"
    },{
      "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
      "price": "12.00"
    }
  ],
  "total": "35.35"
}
```


Sample response 
```
{
    "retailer": "Target",
    "purchaseDate": "2022-01-01",
    "purchaseTime": "13:01",
    "items": [
        {
            "shortDescription": "Mountain Dew 12PK",
            "price": "6.49"
        },
        {
            "shortDescription": "Emils Cheese Pizza",
            "price": "12.25"
        },
        {
            "shortDescription": "Knorr Creamy Chicken",
            "price": "1.26"
        },
        {
            "shortDescription": "Doritos Nacho Cheese",
            "price": "3.35"
        },
        {
            "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
            "price": "12.00"
        }
    ],
    "total": "35.35",
    "controller": "receipts",
    "action": "create",
    "receipt": {
        "retailer": "Target",
        "purchaseDate": "2022-01-01",
        "purchaseTime": "13:01",
        "items": [
            {
                "shortDescription": "Mountain Dew 12PK",
                "price": "6.49"
            },
            {
                "shortDescription": "Emils Cheese Pizza",
                "price": "12.25"
            },
            {
                "shortDescription": "Knorr Creamy Chicken",
                "price": "1.26"
            },
            {
                "shortDescription": "Doritos Nacho Cheese",
                "price": "3.35"
            },
            {
                "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
                "price": "12.00"
            }
        ],
        "total": "35.35"
    },
    "id": "ab74623f-e4f3-42be-a90a-062cec815774"
}

```

### [GET] http://localhost:3000/receipts/:id/points

Sample response 
```
{
    "points": 28
}
```