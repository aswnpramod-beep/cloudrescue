\# CloudRescue Phase 2 — AWS Systems Manager Agent Setup



\## 1. Phase Objective



The objective of Phase 2 was to prepare the CloudRescue RHEL EC2 instance for secure remote management using AWS Systems Manager.



In the future CloudRescue architecture, AWS Lambda will detect a failure and use AWS Systems Manager to execute recovery commands on the EC2 instance.



The planned recovery workflow is:



```text

Failure Detected

&#x20;      ↓

AWS Lambda

&#x20;      ↓

AWS Systems Manager

&#x20;      ↓

RHEL EC2 Instance

&#x20;      ↓

Restart Apache

&#x20;      ↓

Verify Application Health

```



\---



\# 2. Infrastructure Used



| Component | Configuration |

|---|---|

| Cloud Provider | AWS |

| Compute | Amazon EC2 |

| Operating System | Red Hat Enterprise Linux 10.2 |

| Architecture | x86\_64 |

| AWS Region | ap-south-1 |

| Web Server | Apache HTTPD |

| Management Service | AWS Systems Manager |

| Agent | Amazon SSM Agent |



\---



\# 3. Verify Operating System



\## Command



```bash

cat /etc/redhat-release

```



\## Actual Output



```text

Red Hat Enterprise Linux release 10.2 (Coughlan)

```



\## Explanation



This command was used to verify the operating system version running on the CloudRescue EC2 instance.



The project server is running Red Hat Enterprise Linux 10.2.



\---



\# 4. Verify System Architecture



\## Command



```bash

uname -m

```



\## Actual Output



```text

x86\_64

```



\## Explanation



The command was used to identify the processor architecture of the EC2 instance.



The instance uses the x86\_64 architecture. Therefore, the x86\_64 version of the AWS Systems Manager Agent was used.



\---



\# 5. Identify the AWS Region



The AWS region was required to download the appropriate AWS Systems Manager Agent package.



\## Initial Command



```bash

curl -s http://169.254.169.254/latest/meta-data/placement/region

```



\## Result



No output was returned.



\## Explanation



The EC2 instance uses Instance Metadata Service Version 2 (IMDSv2). IMDSv2 requires an authentication token to access instance metadata.



\---



\## 5.1 Request an IMDSv2 Token



\### Command



```bash

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \\

\-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

```



\### Explanation



This command requests a temporary metadata token from the EC2 Instance Metadata Service.



The token is valid for 21,600 seconds.



\---



\## 5.2 Retrieve the AWS Region



\### Command



```bash

curl -H "X-aws-ec2-metadata-token: $TOKEN" \\

\-s http://169.254.169.254/latest/meta-data/placement/region

```



\### Actual Output



```text

ap-south-1

```



\### Explanation



The EC2 instance is running in the AWS Asia Pacific (Mumbai) region.



The region code is:



```text

ap-south-1

```



\---



\# 6. Check Whether the SSM Agent Was Installed



\## Command



```bash

sudo systemctl status amazon-ssm-agent

```



\## Actual Output



```text

Unit amazon-ssm-agent.service could not be found.

```



\## Explanation



The AWS Systems Manager Agent was not initially installed on the RHEL EC2 instance.



The package was also not available through the currently enabled DNF repositories.



\---



\# 7. Troubleshooting SSM Agent Installation



\## Initial Installation Attempt



\### Command



```bash

sudo dnf install -y amazon-ssm-agent

```



\### Result



```text

No match for argument: amazon-ssm-agent

Error: Unable to find a match: amazon-ssm-agent

```



\## Explanation



The `amazon-ssm-agent` package was not available in the currently enabled RHEL repositories.



Therefore, the AWS Systems Manager Agent was installed using the official AWS RPM package instead of the DNF repository.



\---



\# 8. Download the AWS Systems Manager Agent



The EC2 instance was identified as:



```text

Operating System: RHEL 10.2

Architecture: x86\_64

Region: ap-south-1

```



The appropriate SSM Agent RPM package was downloaded for the Mumbai AWS region and x86\_64 architecture.



\## Command



```bash

curl -o amazon-ssm-agent.rpm \\

https://s3.ap-south-1.amazonaws.com/amazon-ssm-ap-south-1/latest/linux\_amd64/amazon-ssm-agent.rpm

```



\## Explanation



This command downloads the AWS Systems Manager Agent RPM package from the AWS S3 distribution endpoint.



\---



\# 9. Install the SSM Agent



\## Command



```bash

sudo dnf install -y ./amazon-ssm-agent.rpm

```



\## Result



The AWS Systems Manager Agent was successfully installed on the RHEL EC2 instance.



\---



\# 10. Start the SSM Agent



\## Command



```bash

sudo systemctl start amazon-ssm-agent

```



\## Explanation



This command starts the AWS Systems Manager Agent service immediately.



The agent must be running for the EC2 instance to communicate with AWS Systems Manager.



\---



\# 11. Enable the SSM Agent at Boot



\## Command



```bash

sudo systemctl enable amazon-ssm-agent

```



\## Explanation



This command configures the SSM Agent to start automatically whenever the EC2 instance boots.



This is important for CloudRescue because the recovery system must continue working after an instance restart.



\---



\# 12. Verify the SSM Agent



\## Command



```bash

sudo systemctl status amazon-ssm-agent

```



\## Actual Result



```text

Active: active (running)

```



\## Explanation



The AWS Systems Manager Agent is running successfully on the CloudRescue RHEL EC2 instance.



\---



\## Additional Verification



\### Command



```bash

sudo systemctl is-active amazon-ssm-agent

```



\### Expected Result



```text

active

```



\### Explanation



The command confirms that the SSM Agent service is currently active.



\---



\# 13. Phase 2 Architecture



The completed Phase 2 architecture is:



```text

┌──────────────────────────┐

│      AWS Cloud           │

│                          │

│  AWS Systems Manager     │

└────────────┬─────────────┘

&#x20;            │

&#x20;            │ SSM Agent

&#x20;            │

┌────────────▼─────────────┐

│       EC2 Instance       │

│                          │

│  RHEL 10.2               │

│  x86\_64                  │

│                          │

│  ┌────────────────────┐  │

│  │  SSM Agent         │  │

│  │  Active            │  │

│  │  Enabled at Boot   │  │

│  └────────────────────┘  │

│                          │

│  Apache Web Server       │

│  CloudRescue Application │

└──────────────────────────┘

```



\---



\# 14. Phase 2 Result



The following tasks were completed successfully:



\- RHEL 10.2 operating system verified.

\- x86\_64 architecture verified.

\- AWS region identified as `ap-south-1`.

\- IMDSv2 metadata access was successfully used.

\- SSM Agent installation through DNF was tested.

\- DNF installation failed because the package was unavailable in the enabled repositories.

\- The official AWS SSM Agent RPM package was used instead.

\- SSM Agent was successfully installed.

\- SSM Agent was started.

\- SSM Agent was enabled to start automatically at boot.

\- SSM Agent status was verified.



\---



\# 15. Phase 2 Completion Status



```text

\[✓] RHEL operating system verified

\[✓] System architecture verified

\[✓] AWS region identified

\[✓] IMDSv2 access tested

\[✓] SSM Agent installation issue identified

\[✓] SSM Agent RPM downloaded

\[✓] SSM Agent installed

\[✓] SSM Agent started

\[✓] SSM Agent enabled at boot

\[✓] SSM Agent status verified

```



\---



\# 16. Lessons Learned



During this phase, the following concepts were learned:



\## Linux



\- Checking the operating system version.

\- Checking system architecture.

\- Managing services using `systemctl`.

\- Starting services.

\- Enabling services at boot.

\- Verifying service status.



\## AWS EC2



\- Accessing the EC2 Instance Metadata Service.

\- Understanding IMDSv2.

\- Retrieving the AWS region from instance metadata.



\## AWS Systems Manager



\- Understanding the purpose of the SSM Agent.

\- Installing the SSM Agent on a Linux EC2 instance.

\- Starting and enabling the SSM Agent.

\- Preparing an EC2 instance for Systems Manager management.



\## Troubleshooting



\- Identifying that a package is unavailable in DNF repositories.

\- Using an alternative installation method.

\- Installing software using an RPM package.



\---



\# 17. Next Phase



The next step is to configure the required IAM permissions.



The next architecture will be:



```text

IAM Role

&#x20;   ↓

EC2 Instance

&#x20;   ↓

SSM Agent

&#x20;   ↓

AWS Systems Manager

&#x20;   ↓

Managed Node

```



After IAM configuration, the EC2 instance will appear in AWS Systems Manager as a managed node.



Then we will test:



```text

AWS Systems Manager

&#x20;       ↓

Send Command

&#x20;       ↓

RHEL EC2

&#x20;       ↓

Check Apache Status

&#x20;       ↓

Restart Apache

&#x20;       ↓

Verify /health Endpoint

```



This will establish the remote recovery capability required for the CloudRescue project.

\#### Explanation



The EC2 instance uses the x86\_64 architecture. Therefore, the x86\_64 version of the AWS Systems Manager Agent is required.



\---



\### 4.4 Retrieve AWS Region



\#### Initial Command



```bash

curl -s http://169.254.169.254/latest/meta-data/placement/region

```



\#### Actual Output



```text

No output returned.

```



\#### Explanation



The EC2 instance uses IMDSv2, which requires an authentication token to access instance metadata. Therefore, the region must be retrieved using an IMDSv2 token.





