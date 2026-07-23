CloudRescue – Self-Healing Cloud Application Recovery System
Project Overview

CloudRescue is a cloud-based self-healing application monitoring and recovery system built on Amazon Web Services (AWS) and Red Hat Enterprise Linux (RHEL).

The system monitors an Apache web server running on an EC2 instance. When the application becomes unhealthy, CloudRescue automatically detects the failure, attempts to recover the service, records the recovery event, publishes a custom CloudWatch metric, and sends an email notification through Amazon SNS.

The main goal of this project is to demonstrate how cloud infrastructure can automatically detect failures, recover services, and notify administrators without requiring immediate manual intervention.

Architecture
                    ┌──────────────────────┐
                    │      Administrator    │
                    │      Email Alert      │
                    └──────────▲───────────┘
                               │
                               │ Email
                               │
                    ┌──────────┴───────────┐
                    │      Amazon SNS      │
                    │  CloudRescue-Alerts  │
                    └──────────▲───────────┘
                               │
                               │ Alarm Action
                               │
                    ┌──────────┴───────────┐
                    │    Amazon CloudWatch  │
                    │                       │
                    │  Custom Metric       │
                    │  RecoveryAttempt     │
                    │                       │
                    │  CloudWatch Alarm     │
                    │ CloudRescue-Recovery │
                    └──────────▲───────────┘
                               │
                         Metric Published
                               │
                    ┌──────────┴───────────┐
                    │      Amazon EC2      │
                    │      RHEL Instance   │
                    │                       │
                    │     Apache HTTPD     │
                    │           │           │
                    │  CloudRescue Script  │
                    │           │           │
                    │    Health Detection  │
                    │           │           │
                    │  Automatic Recovery  │
                    └──────────────────────┘
AWS Services Used
1. Amazon EC2

Amazon EC2 provides the virtual server where the CloudRescue application runs.

EC2 Responsibilities
Hosts the RHEL operating system
Runs the Apache HTTP server
Executes the CloudRescue health-check script
Performs automatic service recovery
Publishes recovery metrics to CloudWatch
2. Amazon CloudWatch

CloudWatch is used for monitoring and alerting.

CloudWatch Components Used
Custom Metric
Namespace: CloudRescue
Metric Name: RecoveryAttempt
Statistic: Sum
Period: 1 minute

The metric records when CloudRescue performs an automated recovery attempt.

CloudWatch Alarm
Alarm Name: CloudRescue-Recovery-Alarm
Condition: RecoveryAttempt >= 1
Period: 1 minute

When a recovery attempt occurs, the alarm changes to the ALARM state.

3. Amazon SNS

Amazon Simple Notification Service is used to send notifications.

SNS Configuration
Topic Name: CloudRescue-Alerts
Protocol: Email
Status: Confirmed

The CloudWatch alarm sends an alert to the SNS topic, which delivers the notification to the confirmed email subscription.

4. AWS Systems Manager

AWS Systems Manager was used for remote management and command execution on the EC2 instance.

Systems Manager Features Used
Run Command
Remote command execution
Instance connectivity verification
Service status checking

Example command:

systemctl is-active httpd
5. AWS IAM

IAM provides the permissions required for AWS services to communicate securely.

IAM permissions were used to allow the EC2 instance and AWS services to perform required operations such as:

Publishing CloudWatch metrics
Sending notifications through SNS
Using Systems Manager
Managing EC2 resources where required
Linux Technologies Used
Operating System
Red Hat Enterprise Linux (RHEL)
Web Server
Apache HTTP Server (httpd)
Scripting
Bash Shell Scripting
Service Management
systemd
systemctl
Scheduling
systemd timers
Logging
/var/log/cloudrescue-recovery.log
journalctl
CloudRescue Recovery Workflow
1. Apache service fails
          ↓
2. Health check detects failure
          ↓
3. CloudRescue marks application UNHEALTHY
          ↓
4. Recovery process starts
          ↓
5. Apache service is restarted
          ↓
6. Application health is verified
          ↓
7. RecoveryAttempt metric is published
          ↓
8. CloudWatch alarm is triggered
          ↓
9. SNS sends email notification
Core CloudRescue Script

The health-check script verifies whether Apache is running.

/usr/local/bin/cloudrescue-health-check.sh

The script:

Checks Apache service status
Detects unhealthy conditions
Starts automated recovery
Restarts Apache
Verifies successful recovery
Writes recovery logs
Publishes the recovery event to CloudWatch
Systemd Configuration

CloudRescue uses systemd to automate health checks.

Service
cloudrescue-health-check.service

The service executes the CloudRescue health-check script.

Timer
cloudrescue-health-check.timer

The timer executes the health-check service periodically.

Example verification:

sudo systemctl status cloudrescue-health-check.timer
sudo systemctl list-timers --all | grep cloudrescue
Failure Recovery Example

Apache was intentionally stopped:

sudo systemctl stop httpd

The service became unhealthy:

sudo systemctl is-active httpd

Output:

inactive

CloudRescue detected the failure:

CloudRescue application is UNHEALTHY
Starting automated recovery

The recovery was successful:

CloudRescue recovery successful

Apache was automatically restored:

sudo systemctl is-active httpd

Output:

active
Monitoring and Alerting Result

After the recovery event, CloudWatch received the custom metric:

RecoveryAttempt = 2

The CloudWatch alarm changed state:

INSUFFICIENT_DATA → ALARM

The SNS action was successfully executed:

Successfully executed action:
CloudRescue-Alerts

An email notification was received successfully.

Project Phases
Phase 1 – Infrastructure Setup
Created AWS infrastructure
Created EC2 instance
Configured RHEL
Installed Apache
Configured basic application environment
Phase 2 – AWS and Linux Integration
Configured Systems Manager
Verified EC2 connectivity
Practiced remote command execution
Tested Linux service management
Phase 3 – Health Monitoring
Created CloudRescue health-check script
Checked Apache service health
Implemented healthy and unhealthy status detection
Phase 4 – Automated Recovery
Implemented automatic Apache recovery
Created systemd service
Created systemd timer
Added recovery logging
Tested failure simulation and automatic recovery
Phase 5 – Cloud Monitoring and Alerting
Created CloudWatch custom metric
Created CloudWatch alarm
Created SNS topic
Configured email subscription
Tested alarm state transitions
Verified SNS email notifications
Project Features
Automated application health monitoring
Automatic Apache service recovery
Self-healing infrastructure capability
Linux systemd automation
Custom CloudWatch metrics
CloudWatch alarm monitoring
SNS email notifications
Centralized recovery logging
Failure simulation and testing
AWS and Linux integration
Project Skills Demonstrated
AWS Cloud Engineering
Amazon EC2
Amazon CloudWatch
Amazon SNS
AWS Systems Manager
AWS IAM
RHEL Administration
Linux Troubleshooting
Apache Administration
Bash Scripting
systemd Services
systemd Timers
Monitoring and Alerting
Automated Recovery
Self-Healing Infrastructure
Repository Structure
CloudRescue/
│
├── README.md
│
├── documentation/
│   ├── phase2-documentation.txt
│   ├── phase3-documentation.txt
│   ├── phase4-documentation.txt
│   └── phase5-documentation.txt
│
├── scripts/
│   └── cloudrescue-health-check.sh
│
└── systemd/
    ├── cloudrescue-health-check.service
    └── cloudrescue-health-check.timer

