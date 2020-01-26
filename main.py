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


@app.get("/")
async def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
async def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}

@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item):
    return {"item_price": item.price, "item_id": item_id}

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

# payload = {person1}
# x = people.insert_one(json.dumps(payload))
