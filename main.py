from fastapi import FastAPI
from pydantic import BaseModel
import pymongo
import json

myclient = pymongo.MongoClient("mongodb+srv://admin-lucas:yawyeet123@tamuhack2020-dqplj.mongodb.net/tamuhackDB")

mydb = myclient["tamuhackDB"]

people = mydb["people"]
animal = mydb["animal"]

print(myclient.list_database_names())
print(mydb.list_collection_names())

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool = None

class People(BaseModel):
    name: str
    lat: float
    lg: float

# class PeopleListView(BaseModel):
#     body: List[People]

class Animal(BaseModel):
    lat: float
    lg: float
    species: str
    endangered: int = -1
    status: int = -1
    animalID: str
    


# @app.get("/")
# async def read_root():
#     return {"Hello": "World"}

# @app.get("/items/{item_id}")
# async def read_item(item_id: int, q: str = None):
#     return {"item_id": item_id, "q": q}

# @app.put("/items/{item_id}")
# async def update_item(item_id: int, item: Item):
#     return {"item_price": item.price, "item_id": item_id}

# @app.post("/items")
# async def update_item(item: Item):
#     return item

@app.post("/animals/")
async def create_item(item: Animal):
    mydict = {"lat": float(item.lat), "lg":(item.lg), "species": str(item.species), "endangered": int(item.endangered),
     "status": int(item.status), "animalID": str(item.animalID)}
    x = animal.insert_one(mydict)
    return item

@app.post("/persons/")
async def create_item(item: People):

    mydict = {"name": str(item.name), "lat": float(item.lat), "lg": float(item.lg)}
    x = people.insert_one(mydict)
    return item

# get a list of persons
@app.get("/persons/")
async def read_persons():
    peeps = []
    for i in people.find({}, {'_id': False}):
        print(type(i))
        peeps.append(i)
    print(peeps)
    dict = {}
    dict["people"] = peeps
    print(dict)
    return dict
    # return {"people": [{"name":"ANOOJ","ads":None},{"name":"Lucas","ads":None}]}


@app.get("/animals/{item_id}")
async def read_item(item_id: str, status: str = None):
    result = animal.find_one({"animalID": str(item_id)}, {"status": 1})
    print(result["status"])
    status = result["status"]
    return {"item_id": item_id, "status": status}


# get a list of persons
@app.get("/animals/")
async def read_animals():
    animals = []
    for i in animal.find({}, {'_id': False}):
        print(type(i))
        animals.append(i)
    print(animals)
    dict = {}
    dict["animals"] = animals
    print(dict)
    return dict
    # return {"people": [{"name":"ANOOJ","ads":None},{"name":"Lucas","ads":None}]}

# payload = {"lat":30.30,"lg":-30.10,"species":"Dog","endangered":True}
# x = animal.insert_one(payload)
# print(x)
