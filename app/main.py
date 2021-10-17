import sys
import ffmpeg
from fastapi import FastAPI

version = f"{sys.version_info.major}.{sys.version_info.minor}"

app = FastAPI()


@app.get("/")
async def read_root():
    message = f"Hello world! From FastAPI running on Uvicorn with Gunicorn. Using Python {version}"
    return {"message": message}

@app.get("/movie")
async def get_movie():
    try:
        probe = ffmpeg.probe('movies/original.mov')
        video_info = next((stream for stream in probe['streams'] if stream['codec_type'] == 'video'), None)
        return video_info 
    except ffmpeg.Error as e:
        print(e.stderr.decode(), file=sys.stderr)
        return {"error": e.stderr.decode()}
