import requests
import psycopg2
import json
import logging
import os
from dotenv import load_dotenv
from datetime import datetime, timedelta
import urllib.parse
import urllib.request

# Load environment
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class Settings:
    ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
    ARM_TENANT_ID = os.getenv("ARM_TENANT_ID")
    ARM_CLIENT_ID = os.getenv("ARM_CLIENT_ID")
    ARM_CLIENT_SECRET = os.getenv("ARM_CLIENT_SECRET")
    STARGATE_CONSUMER_KEY = os.getenv("API_MGMT_CONSUMER_KEY")

# Load configuration from JSON file
def load_config(filename):
    with open(filename, 'r') as f:
        return json.load(f)

def insert_job_status(cursor, step_name, start_time):
    
    logging.info("In insert_job_status()")
    
    cursor.execute(
        "INSERT INTO job_status (step_name, start_time, status) VALUES (%s, %s, %s) RETURNING id",
        (step_name, start_time, 'In Progress')
    )
    return cursor.fetchone()[0]  # Return the job status ID

def update_job_status(cursor, job_id, end_time, status, error_message=None):
    
    logging.info("In update_job_status()")
    
    cursor.execute(
        "UPDATE job_status SET end_time = %s, status = %s, error_message = %s WHERE id = %s",
        (end_time, status, error_message, job_id)
    )
    
def fetch_bearer_token() -> str:
    #logger.info("Fetching bearer token...")
    print("INFO - Fetching bearer token...")
    try:
        data = urllib.parse.urlencode({
            "client_id": os.getenv("ARM_CLIENT_ID"),
            "scope": "api://ingestion.pnsv/.default",
            "client_secret": os.getenv("ARM_CLIENT_SECRET"),
            "grant_type": "client_credentials",
        }).encode("utf-8")

        req = urllib.request.Request(
            "https://login.microsoftonline.com/05d75c05-fa1a-42e7-9cf1-eb416c396f2d/oauth2/v2.0/token", data
        )
        response = urllib.request.urlopen(req)
        response_data = json.loads(response.read().decode("utf-8"))
        return response_data["access_token"]
    except Exception as e:
        #logger.error(f"Failed to fetch bearer token: {e}")
        print(f"ERR - Failed to fetch bearer token: {e}")
        #raise HTTPException(status_code=500, detail="Failed to fetch authentication token")

def fetch_prometheus_data(query, start, end, step, prometheus_url):
    params = {
        'query': query,
        'start': start,
        'end': end,
        'step': step
    }
    
    consumer_key = Settings.STARGATE_CONSUMER_KEY
    bearer_token = fetch_bearer_token()
    #print(bearer_token, "\n\n")
    
    headers = {
        'Authorization': f'Bearer {bearer_token}',
        'Accept': 'application/json',
        'Consumer-Key': consumer_key
    }
    response = requests.get(prometheus_url, params=params, headers=headers)
    response.raise_for_status()  # Raise an error for bad responses
    return response.json()

"""
def fetch_prometheus_data_orig2(query, start, end, step, prometheus_url, bearer_token, consumer_key):
    params = {
        'query': query,
        'start': start,
        'end': end,
        'step': step
    }
    headers = {
        'Authorization': f'Bearer {bearer_token}',
        'Accept': 'application/json',
        'Consumer-Key': consumer_key
    }
    response = requests.get(prometheus_url, params=params, headers=headers)
    response.raise_for_status()  # Raise an error for bad responses
    return response.json()

def fetch_prometheus_data_orig(query, start, end, step, prometheus_url):
    params = {
        'query': query,
        'start': start,
        'end': end,
        'step': step
    }
    response = requests.get(prometheus_url, params=params)
    response.raise_for_status()  # Raise an error for bad responses
    return response.json()
"""

def insert_data_to_postgres(data, metricname, mac_app_id):
    try:
        # Connect to PostgreSQL
        '''
        conn = psycopg2.connect(
            host=POSTGRES_HOST,
            database=POSTGRES_DB,
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD
        )
        '''
        
        print("INFO - MAC App ID in insert_data_to_postgres: ", mac_app_id)

        config = load_config('config.json')
        postgres_config = config['postgres']
        conn = psycopg2.connect(
            host=postgres_config['host'],
            database=postgres_config['database'],
            user=postgres_config['user'],
            password=postgres_config['password']
        )
        cursor = conn.cursor()

        # Insert data into the table
        for result in data['data']['result']:
            for value in result['values']:
                timestamp = datetime.fromtimestamp(float(value[0]))
                truncated_timestamp = timestamp.replace(second=0, microsecond=0)
                value = float(value[1])
                
                # Prepare labels for JSONB column
                labels_json = {k: v for k, v in result['metric'].items() if k != 'metricname'}
                labels_json = json.dumps(labels_json)  # Convert to JSON string

                cursor.execute(
                    "INSERT INTO mop_time_series_data (timestamp, mac_app_id, metricname, value, labels) VALUES (%s, %s, %s, %s, %s)",
                    (truncated_timestamp, mac_app_id, metricname, value, labels_json)
                )

        # Commit the transaction
        conn.commit()
        logging.info("Data inserted successfully.")

    except Exception as e:
        logging.error(f"Error inserting data: {e}")
        raise  # Raise the exception to handle it in the main function
    finally:
        cursor.close()
        conn.close()

def main():
    # Load configuration
    config = load_config('config.json')
    
    # Extract configuration values
    prometheus_url = config['prometheus_url']
    postgres_config = config['postgres']
    mac_app_id = config['mac_app_id']
    queries = config['queries']
    step = config['step']
    
    print("INFO - mac_app_id is: ", mac_app_id)

    # Define the time range for the last day
    end_time = datetime.now()
    start_time = end_time - timedelta(days=1)
    
    # Convert to UNIX timestamps
    start_timestamp = int(start_time.timestamp())
    end_timestamp = int(end_time.timestamp())

    # Connect to PostgreSQL for job status
    conn = psycopg2.connect(
        host=postgres_config['host'],
        database=postgres_config['database'],
        user=postgres_config['user'],
        password=postgres_config['password']
    )
    cursor = conn.cursor()

    for query in queries:
        job_id = insert_job_status(cursor, query['name'], start_time)
        conn.commit()
        
        print("INFO - job_id fetched by calling insert_job_status() ", job_id)

        try:
            # Fetch data from Prometheus
            data = fetch_prometheus_data(query['promql'], start_timestamp, end_timestamp, step, prometheus_url)
            
            # Update job status to indicate data fetching completed
            update_job_status(cursor, job_id, datetime.now(), 'Metric Fetch')
            conn.commit()

            # Insert data into PostgreSQL
            #insert_data_to_postgres(data, query['metricname'], query['labels'])
            insert_data_to_postgres(data, query['metricname'], mac_app_id)

            # Update job status to indicate data insertion completed
            update_job_status(cursor, job_id, datetime.now(), 'Metric Insert Completed')
            conn.commit()

        except Exception as e:
            # Update job status to indicate an error occurred
            update_job_status(cursor, job_id, datetime.now(), 'Failed During Metric Processing', str(e))
            conn.commit()
            logging.error(f"An error occurred while processing query '{query['name']}': {e}")

    cursor.close()
    conn.close()

if __name__ == '__main__':
    main()
