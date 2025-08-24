import os
import requests

from colorama import Fore
from github import Github

stack_id = os.getenv("STACK_ID", "")
spacelift_key_id = os.getenv("SPACELIFT_API_KEY_ID", "")
spacelift_key_secret = os.getenv("SPACELIFT_API_KEY_SECRET", "")
spacelift_url = os.getenv("SPACELIFT_API_KEY_ENDPOINT", 'https://incontact.app.spacelift.io/graphql')
github_actor_name = os.getenv("GH_ACTOR", default="")

gh_token = os.getenv("GH_TOKEN", "")
gh = Github(gh_token)
org = gh.get_organization("inContact")

delete_stack = delete_resources = False
delete_option = os.getenv("DELETE_OPTION", "")
if delete_option == "delete-both-stack-and-resources":
    delete_stack = True
    delete_resources = True
elif delete_option == "delete-stack-and-orphan-the-resources":
    delete_stack = True
    delete_resources = False
elif delete_option == "delete-resources-and-keep-the-stack":
    delete_stack = False
    delete_resources = True

def get_spacelift_jwt_token(key_id, secret_id):
    """
    This method creates the spacelift jwt token for auth.
    :param key_id: spacelift key id
    :param secret_id: spacelift key secret
    :return: jwt token
    """
    query = '''
        mutation generateJWT($keyId: ID!, $keySecret: String!){
            apiKeyUser(id: $keyId, secret: $keySecret){
            jwt
            }
        }
        '''
    variables = {
        "keyId": key_id,
        "keySecret": secret_id
    }
    headers = {
        'Content-Type': 'application/json'
    }
    try:
        response = requests.post(url=spacelift_url, headers=headers, json={'query': query, 'variables': variables},timeout=5)
        return response.json()["data"]["apiKeyUser"]["jwt"]
    except Exception as E:
        print(Fore.RED + f"Cannot generate jwt token, error:{E}")
        exit(1)

def check_if_spacelift_stack_already_exist(jwt):
    """
    This method checks if spacelift stack already exist or not
    :param jwt: jwt token
    :return: boolean
    """
    query = '''
        fragment stackVendorConfig on Stack {
          vendorConfig {
            __typename
            ... on StackConfigVendorPulumi {
              loginURL
              stackName
              __typename
            }
            ... on StackConfigVendorTerraform {
              version
              workspace
              useSmartSanitization
              externalStateAccessEnabled
              workflowTool
              __typename
            }
            ... on StackConfigVendorCloudFormation {
              stackName
              entryTemplateFile
              templateBucket
              region
              __typename
            }
            ... on StackConfigVendorKubernetes {
              namespace
              kubectlVersion
              kubernetesWorkflowTool
              __typename
            }
            ... on StackConfigVendorAnsible {
              playbook
              __typename
            }
            ... on StackConfigVendorTerragrunt {
              terraformVersion
              terragruntVersion
              tool
              effectiveVersions {
                effectiveTerragruntVersion
                effectiveTerraformVersion
                __typename
              }
              useRunAll
              useSmartSanitization
              __typename
            }
          }
        }
        
        query GetStack($id: ID!) {
          stack(id: $id) {
            id
            labels
		    protectFromDeletion
            ...stackVendorConfig
          }
        }
        '''
    variables = {
        "id": stack_id
    }
    headers = {
        'Authorization': f'Bearer {jwt}',
        'Content-Type': 'application/json'
    }
    response = None
    try:
        response = requests.post(url=spacelift_url, headers=headers, json={'query': query, 'variables': variables},timeout=5)
        if response.json()["data"]['stack']['id'] == stack_id:
            return True, response.json()["data"]['stack']['vendorConfig'], response.json()["data"]['stack']['labels'], response.json()["data"]['stack']['protectFromDeletion']
        return False, {}, [], True
    except:
        print(Fore.RED + f"stack:{stack_id} not present error:{response.text}")
        return False, {}, [], True

def delete_spacelift_stack(jwt, is_delete_resources):
    """
    This method deletes the stack
    :param is_delete_resources: keep the resources or not
    :param jwt: spacelift jwt token
    :return: None
    """
    query = '''
        mutation DeleteStack($id: ID!, $destroyResources: Boolean!){
            stackDelete(id: $id, destroyResources: $destroyResources){
                id
            }
        }
        '''

    variables = {
        "id": stack_id,
        "destroyResources": is_delete_resources
    }
    headers = {
        'Authorization': f'Bearer {jwt}',
        'Content-Type': 'application/json'
    }
    response = None
    try:
        response = requests.post(url=spacelift_url, headers=headers, json={'query': query, 'variables': variables},timeout=5)
        print(response.text)
        if "stack is protected from deletion" in response.text:
            print(Fore.YELLOW + f"WARNING::deletion protection is turned on for the stack {stack_id}. In order to disable the deletion protection, the below attribute needs to be added to the spacelift.yaml file which is responsible for the stack creation..\n\n\n" + Fore.GREEN + "disable_deletion_protection: True")
        try:
            if response.json()["data"]['stackDelete']['id']:
                print(Fore.GREEN + f"deleting stack:{stack_id}..\n\ncheck this link for status {'/'.join(spacelift_url.split('/')[:-1])}/stack/{stack_id}")
                set_priority_for_run(jwt, response.json()["data"]['stackDelete']['id'])
        except:
            pass
    except Exception as E:
        print(f"cannot delete the stack:{stack_id}, error:{E} {response.text}")

def run_delete_resource_task(jwt, command):
    """
    This method run tasks to delete resource
    :param command: command to run
    :param jwt: spacelift jwt token
    :return: None
    """
    query = '''
        mutation stackDetails($stackId: ID!, $command: String!){
          taskCreate(stack: $stackId, command: $command) {
                id
          }
        }
        '''

    variables = {
        "stackId": stack_id,
        "command": command
    }
    headers = {
        'Authorization': f'Bearer {jwt}',
        'Content-Type': 'application/json'
    }
    response = None
    try:
        response = requests.post(url=spacelift_url, headers=headers, json={'query': query, 'variables': variables},timeout=5)
        if response.json()["data"]['taskCreate']['id']:
            print(Fore.GREEN + f"task run:{response.json()['data']['taskCreate']['id']} started..\n\ncheck this link for status {'/'.join(spacelift_url.split('/')[:-1])}/stack/{stack_id}/run/{response.json()['data']['taskCreate']['id']}")
            return response.json()['data']['taskCreate']['id']
        return ""
    except Exception as E:
        print(f"cannot run task in stack:{stack_id}, error:{E} {response.text}")
        exit(1)

def set_priority_for_run(jwt, run):
    """
    This method set priority to true
    :param run: run id
    :param jwt: spacelift jwt token
    :return: None
    """
    query = '''
        mutation SetPriority($stack: ID!, $run: ID!, $prioritize: Boolean!){
          runPrioritizeSet(stack: $stack, run: $run, prioritize: $prioritize) {
            id
          }
        }
        '''

    variables = {
        "stack": stack_id,
        "run": run,
        "prioritize": True
    }
    headers = {
        'Authorization': f'Bearer {jwt}',
        'Content-Type': 'application/json'
    }
    response = None
    try:
        response = requests.post(url=spacelift_url, headers=headers, json={'query': query, 'variables': variables},timeout=5)
        if response.json()["data"]['runPrioritizeSet']['id']:
            print(f"priority set for stack:{stack_id} run:{response.json()['data']['runPrioritizeSet']['id']}")
    except:
        print(f"priority cannot set for stack:{stack_id} run:{response.json()['data']['runPrioritizeSet']['id']}, error:{response.text}")
        exit(1)


def check_if_actor_is_valid(stack_labels):
    """
    Check if the valid actor is performing the stack action
    :param stack_labels: stack labels
    :return: None
    """
    try:
        admin_team_actors = []
        admin_team = org.get_team_by_slug("kubernetes-admins")
        for admin_actor in admin_team.get_members():
            admin_team_actors.append(admin_actor.login)
        if github_actor_name in admin_team_actors:
            return None
    except:
        pass
    is_valid_actor_triggering_stack = False
    valid_teams_for_trigger_stack = []
    for stack_label in stack_labels:
        if stack_label.startswith("access:write:"):
            valid_teams_for_trigger_stack.append(stack_label.split(":")[-1])
    print(f"stack:{stack_id}'s valid teams:{','.join(valid_teams_for_trigger_stack)}")
    for valid_team_for_trigger_stack in valid_teams_for_trigger_stack:
        try:
            team = org.get_team_by_slug(valid_team_for_trigger_stack)
            team_actors = []
            for actor in team.get_members():
                team_actors.append(actor.login)
            if github_actor_name in team_actors:
                is_valid_actor_triggering_stack = True
                break
        except Exception as e:
            print(f"Error: {e}")
            exit(1)
    if not is_valid_actor_triggering_stack:
        print(Fore.RED + f"{github_actor_name} do not have permission to trigger the stack {stack_id}..{github_actor_name} should be part of below teams to trigger the stack..\n\n" + Fore.BLUE + f"{','.join(valid_teams_for_trigger_stack)}")
        exit(1)

if __name__ == '__main__':
    spacelift_jwt_token = get_spacelift_jwt_token(spacelift_key_id, spacelift_key_secret)
    stack_exist, vendor_config, labels, protect_from_deletion = check_if_spacelift_stack_already_exist(spacelift_jwt_token)
    if not stack_exist:
        exit(1)
    check_if_actor_is_valid(labels)
    if delete_stack:
        if protect_from_deletion:
            print(Fore.YELLOW + f"WARNING::deletion protection is turned on for the stack {stack_id}. In order to disable the deletion protection, the below attribute needs to be added to the spacelift.yaml file which is responsible for the stack creation..\n\n\n" + Fore.GREEN + "disable_deletion_protection: True")
            exit(1)
        delete_spacelift_stack(spacelift_jwt_token, delete_resources)
    else:
        if "allow_delete_commands" not in labels:
            if "execute_only_selected_commands" in labels:
                print(Fore.RED + f"WARNING::either the allow_delete_command label needs to be added or execute_only_selected_commands label needs to be removed..")
                exit(1)
        if vendor_config["__typename"] == "StackConfigVendorTerraform":
            print(f"applying terraform destroy command..")
            run_id = run_delete_resource_task(spacelift_jwt_token, "terraform destroy --auto-approve")
            if run_id != "":
                set_priority_for_run(spacelift_jwt_token, run_id)
        elif vendor_config["__typename"] == "StackConfigVendorCloudFormation":
            print(f"deleting the cloudformation stack {vendor_config['stackName']}..")
            run_id = run_delete_resource_task(spacelift_jwt_token, "aws cloudformation delete-stack --stack-name $CF_METADATA_STACK_NAME")
            if run_id != "":
                set_priority_for_run(spacelift_jwt_token, run_id)
