FROM tiangolo/uvicorn-gunicorn:python3.8

ENV buildDeps='unzip build-essential curl pkg-config'
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    $buildDeps \
    nasm \
    libmp3lame-dev \
    libopus-dev \
    libvorbis-dev \
    libvpx-dev 

COPY install_ffmpeg_supporting_openh264.sh ./
RUN chmod 755 ./install_ffmpeg_supporting_openh264.sh && ./install_ffmpeg_supporting_openh264.sh

RUN apt-get purge -y --auto-remove $buildDeps
RUN rm ./install_ffmpeg_supporting_openh264.sh

COPY . .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# CMD [ "python", "./main.py", "2>/dev/null" ]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "81", "--reload"]
