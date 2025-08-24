# root-stack-provisioner

This stack is used to provision stack-provisioner stacks in https://incontact.app.spacelift.io. We create 1 stack-provisioner
per gGitHub repository which is integrated with Spacelift. For more information on this pattern see the module documentation
[here](https://github.com/inContact/terraform-spacelift-config/tree/main/modules/root-stack-provisioner).

This stack can be viewed in Spacelift [here](https://incontact.app.spacelift.io/stack/incontact-infrastructure-live-terraform-spacelift-root-stack-provisioner)

## Creating This Stack in Spacelift

Since this stack is the creator of all stack-provisioner stacks in Spacelift there is nothing that can do the initial creation of this stack.
We manually create this stack in Spacelift and then we allow the stack-provisioner for this repo to manage this stack
according to the [spacelift.yaml](spacelift.yaml)
file in this directory. Follow these steps when creating this stack for the first time:

> It is strongly recommended to disable the `Autodeploy` feature on the `BEHAVIOR` tab within the stack settings until after you've validated that the stack is working properly

1. Manually create a stack in Spacelift with settings which match the configuration in [spacelift.yaml](spacelift.yaml).
The name of the stack must be `inContact/infrastructure-live//terraform/spacelift/root-stack-provisioner`. 
2. Run the stack. This will cause the `stack-provisioner-inContact/infrastructure-live` stack to be created. This child stack will own the creation of
all stacks for the inContact/infrastructure-live repo, including the root-stack-provisioner stack. Since the root-stack-provisioner stack already
exists the `stack-provisioner-inContact/infrastructure-live` will fail to run to completion. You can resolve this failure by importing the
root-stack-provisioner stack into the terraform state. Click on the `Tasks` tab within the `stack-provisioner-inContact/infrastructure-live`
stack and run the following command:
    * `terragrunt import spacelift_stack.this[\"terraform/spacelift/root-stack-provisioner\"] incontact-infrastructure-live-terraform-spacelift-root-stack-provisioner`
4. Run the stack and ensure that everything works successfully.

Now you can modify [spacelift.yaml](spacelift.yaml) to update the configuration of this stack.