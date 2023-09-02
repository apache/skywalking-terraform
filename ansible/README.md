This guide provides steps on using Ansible to install Apache SkyWalking on VM instances.

# Prerequisites

- [Ansible installed](https://docs.ansible.com/ansible/latest/installation_guide/index.html).
- A working knowledge of Ansible.
- Access to instances.

# Instructions

## Change diroectory

```shell
cd ansible
```

## Test Connectivity to the Instances

Before installing SkyWalking, ensure that you can connect to the instances:

```shell
ansible -m ping all
```

**Expected Output**:

You should see output for each IP with a `SUCCESS` status:

```text
<ip1> | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
<ip2> | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

## Install Apache SkyWalking

After confirming connectivity, proceed to install Apache SkyWalking using the Ansible playbook:

```
ansible-playbook skywalking.yml
```

## Configurations

The Ansible playbook can be customized to install Apache SkyWalking with
different configurations. The following variables can be modified to suit your
needs: 

> For full configurations, refer to the
> [roles/skywalking/vars/main.yml](roles/skywalking/vars/main.yml).
> file.

```yaml
# `skywalking_tarball` can be a remote URL or a local path, if it's a remote URL
# the remote file will be downloaded to the remote host and then extracted,
# if it's a local path, the local file will be copied to the remote host and
# then extracted.
skywalking_tarball: "https://dist.apache.org/repos/dist/release/skywalking/9.5.0/apache-skywalking-apm-9.5.0.tar.gz"

# `skywalking_ui_environment` is a dictionary of environment variables that will
# be sourced when running the skywalking-ui service. All environment variables
# that are supported by SkyWalking webapp can be set here.
skywalking_ui_environment: {}

# `skywalking_oap_environment` is a dictionary of environment variables that will
# be sourced when running the skywalking-oap service. All environment variables
# that are supported by SkyWalking OAP can be set here.
skywalking_oap_environment: {}

```

You can create a local variable file to override the default values:

```shell
cat <<EOF > local.var.yaml
skywalking_tarball: "~/workspace/skywalking/apm-dist/target/apache-skywalking-apm-bin.tar.gz"
EOF
```

And then run the playbook with the local variable file:

```shell
ansible-playbook skywalking.yml -e @local.var.yaml
```

## Accessing SkyWalking UI!

After the installation is complete, you can go back to the aws folder and get
the ALB domain name address that can be used to access the SkyWalking UI:

```shell
cd ../aws
terraform output -raw alb_dns_name
```

And you can open your browser and access the SkyWalking UI with the address.

