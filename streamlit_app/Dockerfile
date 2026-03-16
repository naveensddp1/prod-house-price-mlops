FROM python:3.9-slim

WORKDIR /app 

COPY streamlit_app/app.py  streamlit_app/requirements.txt . 

RUN pip install -r requirements.txt 

EXPOSE 8501

CMD [ "streamlit", "run", "app.py", "--server.address=0.0.0.0" ]