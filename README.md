\*This project has been created as part of the 42 curriculum by jyap.\*

\# Inception Project

\## Description

The Inception project is a full-stack web stack that deploys a
\*\*WordPress website\*\* with a \*\*MariaDB database\*\*, served
through \*\*Nginx\*\* inside Docker containers. The goal is to simulate
a production-like environment using containerization and to understand
service orchestration, networking, and persistent storage.

\### Services Overview

\- \*\*MariaDB\*\*: Database service storing WordPress content. -
\*\*WordPress\*\*: PHP-based web application connecting to MariaDB. -
\*\*Nginx\*\*: Reverse proxy and SSL termination.

\### Design Choices

\- \*\*Virtual Machines vs Docker\*\*: Docker provides lightweight,
faster deployment with isolated services. VMs offer full OS isolation
but are heavier. - \*\*Secrets vs Environment Variables\*\*: Secrets are
used for sensitive credentials, while environment variables store
non-sensitive configuration. - \*\*Docker Network vs Host Network\*\*: A
custom Docker network isolates container traffic; host network exposes
containers to the host directly. - \*\*Docker Volumes vs Bind
Mounts\*\*: Volumes ensure persistent container storage, while bind
mounts link host directories for development convenience.

\## Instructions

\### Prerequisites

\- Docker & Docker Compose - Make - Git

\### Setup & Execution

1\. Clone the repository: \`\`\`bash git clone \<repo_url\> cd
\<repo_name\> 2. Build and start the stack: \`\`\`bash make up 3. Stop
the stack: \`\`\`bash make down 4. Access services: Website:
https://\<VM_or_Host_IP\> WordPress admin panel:
https://\<VM_or_Host_IP\>/wp-admin

\### Resources Docker Docs: https://docs.docker.com

WordPress Docs: https://wordpress.org/support/

MariaDB Docs: https://mariadb.com/kb/en/documentation/

Nginx Docs: https://nginx.org/en/docs/

AI Assistance: Used to draft Dockerfiles, Makefile commands, and
documentation structure.
