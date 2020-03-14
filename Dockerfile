FROM python:3.8.2

ADD . /local
WORKDIR /local

RUN pip install -r requirements.txt

