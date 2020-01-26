from fastapi import FastAPI
from pydantic import BaseModel
import pymongo
import json
import smtplib, ssl


myclient = pymongo.MongoClient("mongodb+srv://admin-lucas:yawyeet123@tamuhack2020-dqplj.mongodb.net/tamuhackDB")

mydb = myclient["tamuhackDB"]

people = mydb["people"]
animal = mydb["animal"]

print(myclient.list_database_names())
print(mydb.list_collection_names())

app = FastAPI()

# email configuration
port = 465  # For SSL
smtp_server = "smtp.gmail.com"
sender_email = "johnjaydeveloper14@gmail.com"  # Enter your address
receiver_email = "charleslucasrollo@gmail.com"  # Enter receiver address
password = input("Type your password and press enter: ")
body =
message = """\
Subject: HELP the Koalas!!

This message is sent from ur mom."""
# make the email

# Create a secure SSL context
context = ssl.create_default_context()

with smtplib.SMTP_SSL("smtp.gmail.com", port, context=context) as server:
    server.login("johnjaydeveloper14@gmail.com", password)
    server.sendmail(sender_email, receiver_email, message)


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
