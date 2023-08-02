# Ansible playbook to install Apache SkyWalking

- Save the ssh key file path to a variable for future use

```shell
SSH_KEY_FILE=$(terraform -chdir=../aws output -raw ssh-user-key-file)
echo $SSH_KEY_FILE
```

You should see a file path similar to `/Users/kezhenxu94/.ssh/skywalking.pem`.

- Test connectivity to the EC2 instances

```shell
ANSIBLE_HOST_KEY_CHECKING=False ansible -m ping all -u ec2-user --private-key "$SSH_KEY_FILE"
```

You should see output similar to the following, note the `SUCCESS` status:

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

- Install Apache SkyWalking!

```shell
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key "$SSH_KEY_FILE" playbooks/install-skywalking.yml
```
