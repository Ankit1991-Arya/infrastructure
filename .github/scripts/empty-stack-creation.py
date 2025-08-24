import base64
import os
import re
from github import Github
import yaml

cloud_service_name = os.getenv("CLOUD_SERVICE_NAME", default="")
infrastructure_type = os.getenv("INFRA_TYPE", default="")
if infrastructure_type == "-":
    print("Please provide infrastructure type - Terraform or Cloudformation")
    exit(1)
account = os.getenv("ACCOUNT", default="")
region = os.getenv("REGION", default="")
main_directory_name = os.getenv("MAIN_DIRECTORY_NAME", default="")
sub_directory_name = os.getenv("SUB_DIRECTORY_NAME", default="")
cf_stack_name = os.getenv("CF_STACK_NAME", default="")
maintainer_team_name = os.getenv("MAINTAINER_NAME", default="")
maintainer_team_email = os.getenv("MAINTAINER_EMAIL", default="")
github_actor_name = os.getenv("GH_ACTOR", default="")

gh_token = os.getenv("GH_TOKEN", "")
gh = Github(gh_token)
org = gh.get_organization("inContact")

def check_valid_maintainer(maintainer_github_team_name, maintainer_github_team_email):
    """
    This function checks if the maintainer exists in gitHub org.
    :param maintainer_github_team_name: gitHub team name
    :param maintainer_github_team_email: team email
    :return: None
    """
    if not re.search(r"^[a-zA-Z0-9_.+&-]+@nice.com$|[a-zA-Z0-9_.+-]+@niceincontact.com$", maintainer_github_team_email):
        print(f"Email ID provided is incorrect: {maintainer_github_team_email}")
        exit(1)
    try:
        admin_team = org.get_team_by_slug("kubernetes-admins")
        team = org.get_team_by_slug(maintainer_github_team_name)
        print(f"{team} exist in inContact organization")
        admin_team_actors = []
        team_actors = []
        for admin_actor in admin_team.get_members():
            admin_team_actors.append(admin_actor.login)
        for actor in team.get_members():
            team_actors.append(actor.login)
        if github_actor_name not in admin_team_actors:
            if not github_actor_name in team_actors:
                print(f"Github actor {github_actor_name} should be part of the team {team.name}..")
                exit(1)
    except Exception as e:
        print(f"Error: {e}")
        print(f"Github Team Name is not correct: {maintainer_github_team_name}")
        exit(1)

def get_existing_aws_integrations():
    """
    This method gets all the existing spacelift aws integrations with regions.
    :return: aws integrations map
    """
    repository = org.get_repo('aws-account-setup')
    try:
        file_content = base64.b64decode(repository.get_contents(f'infrastructure-live/{account}/spacelift.yaml').content)
    except:
        print(f"Account {account} does not exist.")
        exit(1)
    actual_region =yaml.safe_load(file_content).get("env", {}).get("AWS_REGION", "")
    print(f"region:{region}")

    if account == "ic-prod":
        if not region in ["ap-northeast-1","ap-southeast-2","ca-central-1","eu-central-1","eu-west-2","us-west-2"]:
            print(f"Region {region} does not exist")
            exit(1)
    else:
        if not region == actual_region:
            print(f"Region {region} does not exist.")
            exit(1)



def get_s3_template_bucket_name(account_name):
    """
    This method gets the s3 template bucket name for the specified account
    :param account_name: name of the account
    :return: template bucket name
    """
    repository = org.get_repo('admin-iam-entities')
    file_content = base64.b64decode(repository.get_contents(f'{account_name}/CF-cicd-iam-service-roles/spacelift.yaml').content)
    try:
        return yaml.safe_load(file_content)["cloudformation"]["template_bucket"]
    except:
        print(f"Cannot get the template bucket name for the account {account_name}")
        return ""

def cf_default_spacelift(account_name, region_name, bucket, maintainer_github_team_name, maintainer_github_team_email):
    """
    This method returns spacelift content if its cloudformation spacelift stack
    :param account_name: name of the account
    :param region_name: name of the region
    :param bucket: template bucket
    :param maintainer_github_team_name: gitHub team name
    :param maintainer_github_team_email: team email
    :return: spacelift content
    """
    return {
        "platform": "cloudformation",
        "maintainers": [{"name": maintainer_github_team_name, "email": maintainer_github_team_email}],
        "integrations": {"aws": account_name},
        "cloudformation": {"stack_name": cf_stack_name, "entry_template_file": "main.cf.yaml", "region": region_name,
                           "template_bucket": bucket}}

def aws_tf_default_spacelift(account_name, maintainer_github_team_name, maintainer_github_team_email):
    """
    This method returns spacelift content if its aws terraform spacelift stack
    :param account_name: name of the account
    :param maintainer_github_team_name: gitHub team name
    :param maintainer_github_team_email: team email
    :return: spacelift content
    """
    return {
        "maintainers": [{"name": maintainer_github_team_name, "email": maintainer_github_team_email}],
        "integrations": {"aws": account_name},
        "before_init": ["cat /mnt/workspace/github.netrc >> ~/.netrc", "chmod 600 ~/.netrc"],
        "contexts": {"cxossp-github-personal-access-token": 0},
        "terraform_version": "1.9.1"
    }

def azure_tf_default_spacelift(account_name, maintainer_github_team_name, maintainer_github_team_email):
    """
    This method returns spacelift content if its azure terraform spacelift stack
    :param account_name: name of the account
    :param maintainer_github_team_name: gitHub team name
    :param maintainer_github_team_email: team email
    :return: spacelift content
    """
    return {
        "maintainers": [{"name": maintainer_github_team_name, "email": maintainer_github_team_email}],
        "integrations": {"azure": account_name.upper()},
        "terraform_version": "1.9.1"
    }

def write_files(iac_file, content):
    """
    This function creates cf or tf file with spacelift contents
    :param iac_file: file name
    :param content: spacelift content
    :return: None
    """
    terraform_code = \
    """terraform {
  required_version = ">= 1.6.0"
  required_providers {
  }
}"""
    if "tf" in iac_file:
        with open(iac_file, "w") as tf_content:
            tf_content.write(terraform_code)
    else:
        with open(iac_file, "w"):
            pass
    with open("spacelift.yaml", 'w') as outfile:
        yaml.dump(content, outfile)

def check_account_region_path_or_create(path):
    """
    This function check if account or region path can be created or not
    :param path: path name
    :return: None
    """
    if not os.path.isdir(path):
        os.mkdir(path)
        os.chdir(path)
    else:
        os.chdir(path)

def check_path_or_create(path, message):
    """
    This function checks if path is present or create one.
    :param path: path name
    :param message: message
    :return: None
    """
    try:
        os.chdir(path)
    except:
        print(message)
        os.mkdir(path)
        os.chdir(path)

def change_path_or_error(path, message):
    """
    This function checks if path exist or exit
    :param path: path name
    :param message: error message
    :return: None
    """
    try:
        os.chdir(path)
    except:
        print(message)
        exit(1)

if __name__ == '__main__':
    check_valid_maintainer(maintainer_team_name, maintainer_team_email)
    if cloud_service_name == "aws":
        get_existing_aws_integrations()
        if sub_directory_name == "":
            print("sub_directory_name should be provided")
            exit(1)
        if infrastructure_type == "cloudformation":
            if cf_stack_name == "":
                print("cloudformation stack name should be provided")
                exit(1)
            os.chdir("cloudformation")
        elif infrastructure_type == "terraform":
            os.chdir(f"terraform/{cloud_service_name}")

        check_account_region_path_or_create(account)
        check_account_region_path_or_create(region)
        check_path_or_create(main_directory_name, f"No directory exist in cloudformation/{account}/{region}. Creating one..")

        if os.path.isdir(sub_directory_name):
            print(f"Sub directory cloudformation/{account}/{region}/{main_directory_name}/{sub_directory_name} already exist")
            exit(1)
        else:
            print(f"No sub directory exist in cloudformation/{account}/{region}/{main_directory_name}. Creating one..")
            os.mkdir(sub_directory_name)
            os.chdir(sub_directory_name)
        if infrastructure_type == "cloudformation":
            template_bucket = get_s3_template_bucket_name(account)
            write_files("main.cf.yaml", cf_default_spacelift(account, region,template_bucket, maintainer_team_name, maintainer_team_email))
        elif infrastructure_type == "terraform":
            write_files("main.tf", aws_tf_default_spacelift(account, maintainer_team_name, maintainer_team_email))
    elif cloud_service_name == "azure":
        os.chdir(f"terraform/{cloud_service_name}")
        change_path_or_error(account, f"No directory for account:{account} present already. "
                                                   f"Create the account directory manually for the first time or check with CNC team questions channel.")
        change_path_or_error(region, f"No region:{region} present already inside account {account}. "
                                                  f"Create the account directory manually for the first time or check with CNC team questions channel.")
        check_path_or_create(main_directory_name, f"No directory exist in terraform/azure/{account}/{region}. Creating one..")
        write_files("main.tf", azure_tf_default_spacelift(account, maintainer_team_name, maintainer_team_email))

    pr_branch = main_directory_name.replace(" ", "_").lower() + "-" +  sub_directory_name.replace(" ", "_").lower() + "-" +  region +  "-" + account 
    pr_branch = pr_branch[:90]
    if "GITHUB_OUTPUT" in os.environ:
        with open(os.environ["GITHUB_OUTPUT"], "a") as f:
            print(f"branch_name={pr_branch}", file=f)
            print(f"cloud_service={cloud_service_name}", file=f)
            print(f"account={account}", file=f)
            print(f"region={region}", file=f)
            print(f"infrastructure_type={infrastructure_type}", file=f)
            print(f"gh_maintainer_name={maintainer_team_name}", file=f)
