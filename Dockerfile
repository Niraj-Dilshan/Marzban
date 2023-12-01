FROM python:3.13-rc-slim

ENV PYTHONUNBUFFERED 1

WORKDIR /code

RUN apt-get update \
    && apt-get install -y curl unzip gcc python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c "$(curl -L https://github.com/Niraj-Dilshan/infinity-script/raw/master/install_latest_xray.sh)"

COPY ./requirements.txt /code/
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code

RUN apt-get remove -y curl unzip gcc python3-dev

RUN ln -s /code/infinity-cli.py /usr/bin/infinity-cli \
    && chmod +x /usr/bin/infinity-cli \
    && infinity-cli completion install --shell bash

CMD ["bash", "-c", "alembic upgrade head; python main.py"]