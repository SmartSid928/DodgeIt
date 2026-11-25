from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="DodgeIt API",
    description="Road condition monitoring and pothole mapping API",
    version="1.0.0"
)

# Development CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def home():
    return {
        "message": "Welcome to DodgeIt API!",
        "status": "running"
    }


@app.get("/api/health")
def health_check():
    return {
        "application": "DodgeIt",
        "backend": "online",
        "database": "not connected yet"
    }
