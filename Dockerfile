FROM python:3.9-alpine3.13

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app/
COPY requirements.dev.txt /app/

ARG DEV=false

RUN pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    pip install -r requirements.txt && \
    apk del .tmp-build-deps

RUN if [ "$DEV" = "true" ]; \
      then pip install -r requirements.dev.txt ; \
    fi

COPY . /app/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
