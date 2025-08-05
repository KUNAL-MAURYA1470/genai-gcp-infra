FROM python:3.11

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./main.py /code/main.py
COPY ./retail_toy_dataset.csv /code/retail_toy_dataset.csv

CMD ["python", "main.py"]
