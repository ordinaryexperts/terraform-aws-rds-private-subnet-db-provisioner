FROM python:3.11-slim

RUN pip install poetry


COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN poetry install

COPY main.py main.py

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "main.handler" ]
