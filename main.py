from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
import uuid

app = FastAPI(
    title="GEN AI Demo API testing",
    description="A simple FastAPI app to showcase GEN AI error-fixing capabilities.",
    version="1.0.0",
)


# ---------- Models ----------
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    quantity: int = 0


class ItemResponse(BaseModel):
    id: str
    name: str
    description: Optional[str]
    price: float
    quantity: int
    created_at: str


# ---------- In-memory store ----------
items_db: dict[str, dict] = {}


# ---------- Routes ----------
@app.get("/")
def root():
    return {
        "message": "Welcome to the GEN AI Demo API.",
        "status": "running",
        "timestamp": datetime.utcnow().isoformat(),
    }


@app.get("/health")
def health_check():
    return {"status": "healthy", "uptime": "ok"}


@app.post("/items", response_model=ItemResponse, status_code=201)
def create_item(item: Item):
    item_id = str(uuid.uuid4())[:8]
    record = {
        "id": item_id,
        "name": item.name,
        "description": item.description,
        "price": item.price,
        "quantity": item.quantity,
        "created_at": datetime.utcnow().isoformat(),
    }
    items_db[item_id] = record
    return record


@app.get("/items")
def list_items():
    return {"items": list(items_db.values()), "count": len(items_db)}


@app.get("/items/{item_id}", response_model=ItemResponse)
def get_item(item_id: str):
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    return items_db[item_id]


@app.delete("/items/{item_id}")
def delete_item(item_id: str):
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    del items_db[item_id]
    return {"message": "Item deleted", "id": item_id}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)