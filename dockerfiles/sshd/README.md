# Dockfile for ssh-server instances.

This docker container is that basis for other services.

Features:

- Initializes a user account called *service*.
- Adds SSH authorized_keys to both *root* and *service* account so you can ssh without a password.

    ssh service@localhost -p PORT -i id_rsa_ssdh
