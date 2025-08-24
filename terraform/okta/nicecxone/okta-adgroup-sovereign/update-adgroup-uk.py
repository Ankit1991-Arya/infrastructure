import sys
import json
import requests

def usage():
    print("Usage: update_okta_group.py <oktagroupid> <ApiToken>")
    sys.exit(1)

if len(sys.argv) != 3:
    usage()

oktagroupid = sys.argv[1]
api_token = sys.argv[2]

api_url = f"https://nicecxone-admin.okta.com/api/v1/apps/0oapyiaq3jk25v9yv697/groups/{oktagroupid}"
headers = {
    "Authorization": f"SSWS {api_token}",
    "Content-Type": "application/json"
}
body = {
    "profile": {
        "organizationalUnit": "OU=uk_okta_users,DC=cxsov1,DC=uk"
    }
}

response = requests.put(api_url, headers=headers, json=body)

if response.status_code != 200:
    print(json.dumps({"error": f"Error occurred: {response.status_code}"}))
else:
    print(json.dumps({"message": f"{oktagroupid} has successfully been assigned to AD"}))