FROM python:3.10

WORKDIR /data

RUN pip install django==3.2

COPY . .


RUN python manage.py migrate

COPY env env.local

EXPOSE 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]