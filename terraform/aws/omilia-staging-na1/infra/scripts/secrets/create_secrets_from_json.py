import boto3
import json
import argparse
from botocore.exceptions import ClientError

def parse_arguments():
    """This method is used to parse arguments """
    parser = argparse.ArgumentParser(description='Smart deploy of services')
    parser.add_argument('--region', '-r', default="us-east-1", type=str,
                        help='Default region to use')
    parser.add_argument('--newpath', '-p', default="/test", type=str,
                        help='The new ssm path to create the secrets to')
    parser.add_argument('--jsonfilepath', '-j', default="secrets_template.json", type=str,
                        help='The json file containing secrets names and k/v\'s')
    parser.add_argument('--preview', action='store_true',
                        help='Preview actions without actually creating or updating secrets')
    args = parser.parse_args()
    return args

def create_secret_if_not_exists(region, json_file, new_path, preview):
    session = boto3.Session(region_name=region)

    client = session.client('secretsmanager')

    try:
        # Read information from the JSON file
        with open(json_file, 'r') as input_file:
            secret_info = json.load(input_file)

        for secret_name, secret_data in secret_info.items():
            # Generate a new secret name with the new path
            new_secret_name = f"{new_path}/{secret_name}"

            # Check if the secret already exists
            try:
                response = client.describe_secret(SecretId=new_secret_name)

                # If the secret exists, check for each key
                existing_secret_values = get_secret_values(region, new_secret_name)

                for key, value in secret_data.items():
                    if key not in existing_secret_values:
                        if not preview:
                            # Key doesn't exist, update the secret
                            add_key_to_secret(region, new_secret_name, key, value)
                        else:
                            print(f"Would add key '{key}' to secret '{new_secret_name}'")

                    else:
                        print(f"Key '{key}' already exists in secret '{new_secret_name}'. I won't touch it !")

            except ClientError as e:
                if e.response['Error']['Code'] == 'ResourceNotFoundException':
                    if not preview:
                        # Secret doesn't exist, create a new one
                        create_secret(region, new_secret_name, secret_data)
                    else:
                        print(f"Would create secret '{new_secret_name}'")
                else:
                    # Other error occurred
                    print(f"Error: {e}")

    except Exception as e:
        print(f"Error processing secrets: {e}")

def create_secret(region, secret_name, secret_values):
    session = boto3.Session(region_name=region)
    client = session.client('secretsmanager')

    try:
        response = client.create_secret(
            Name=secret_name,
            SecretString=json.dumps(secret_values)
        )
        print(f"Secret '{secret_name}' created successfully.")
    except ClientError as e:
        print(f"Error creating secret: {e}")

def add_key_to_secret(region, secret_name, key, value):
    session = boto3.Session(region_name=region)
    client = session.client('secretsmanager')

    existing_secret_values = get_secret_values(region, secret_name)
    existing_secret_values[key] = value

    try:
        response = client.update_secret(
            SecretId=secret_name,
            SecretString=json.dumps(existing_secret_values)
        )
        print(f"Key '{key}' added to secret '{secret_name}' successfully.")
    except ClientError as e:
        print(f"Error updating secret value: {e}")

def get_secret_values(region, secret_name):
    session = boto3.Session(region_name=region)
    client = session.client('secretsmanager')

    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret_values = json.loads(response['SecretString'])
        return secret_values
    except ClientError as e:
        print(f"Error retrieving secret values: {e}")
        return {}

if __name__ == "__main__":
    args = parse_arguments()
    region = args.region
    new_path = args.newpath
    json_file_path = args.jsonfilepath
    preview = args.preview

    create_secret_if_not_exists(region, json_file_path, new_path, preview)
