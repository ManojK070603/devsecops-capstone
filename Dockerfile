FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

RUN useradd --system --no-create-home appuser

COPY --chown=appuser:appuser app.py .

USER appuser

EXPOSE 5050

CMD ["python", "app.py"]
