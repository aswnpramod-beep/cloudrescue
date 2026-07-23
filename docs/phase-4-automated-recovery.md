\# Phase 4: Automated Recovery



\## 1. Objective



The objective of Phase 4 was to implement automated recovery for the CloudRescue application.



In Phase 3, the system could detect when the application became unhealthy.



In Phase 4, the system was enhanced to automatically recover the failed Apache service.



The target workflow was:



Application Failure

&#x20;       ↓

Health Check Detects Failure

&#x20;       ↓

Recovery Script Executes

&#x20;       ↓

Apache Service Restarted

&#x20;       ↓

Application Health Verified

&#x20;       ↓

Application Restored



\---



\## 2. Recovery Script



A recovery script was created:



```text

/usr/local/bin/cloudrescue-recovery.sh

The script checks whether Apache is running.



If Apache is inactive, it attempts to restart the service.



Recovery Script

\#!/bin/bash



LOG\_FILE="/var/log/cloudrescue-recovery.log"



echo "$(date): Recovery process started" >> "$LOG\_FILE"



if ! systemctl is-active --quiet httpd; then



&#x20;   echo "$(date): Apache is not running. Attempting recovery..." >> "$LOG\_FILE"



&#x20;   systemctl restart httpd



&#x20;   sleep 5



&#x20;   if systemctl is-active --quiet httpd; then

&#x20;       echo "$(date): Apache recovery successful" >> "$LOG\_FILE"

&#x20;   else

&#x20;       echo "$(date): Apache recovery FAILED" >> "$LOG\_FILE"

&#x20;   fi



else



&#x20;   echo "$(date): Apache is already running. No recovery required." >> "$LOG\_FILE"



fi

3\. Script Permissions



The recovery script was made executable:



sudo chmod +x /usr/local/bin/cloudrescue-recovery.sh



The permissions were verified using:



ls -l /usr/local/bin/cloudrescue-recovery.sh

4\. Manual Recovery Test



The recovery script was first tested while Apache was running.



Apache status:



sudo systemctl is-active httpd



Result:



active



The recovery script was executed:



sudo /usr/local/bin/cloudrescue-recovery.sh



The recovery log was checked:



sudo cat /var/log/cloudrescue-recovery.log



Result:



Apache is already running. No recovery required.



This confirmed that the recovery script does not unnecessarily restart a healthy service.



5\. Manual Failure Recovery Test



Apache was intentionally stopped:



sudo systemctl stop httpd



The service status was verified:



sudo systemctl is-active httpd



Result:



inactive



The recovery script was then executed:



sudo /usr/local/bin/cloudrescue-recovery.sh



The recovery log showed:



Apache is not running. Attempting recovery...

Apache recovery successful



Apache was automatically restarted.



The service status was verified:



sudo systemctl is-active httpd



Result:



active



This confirmed that the recovery script successfully restored the stopped Apache service.



6\. Integration with Health Monitoring



The existing health-check script was updated to automatically call the recovery script when the application health check failed.



Health Check Script

/usr/local/bin/cloudrescue-health-check.sh



The health check performs the following process:



Checks the application health endpoint.

If healthy, reports HEALTHY.

If unhealthy, starts the recovery process.

Waits for recovery.

Checks the application again.

Reports recovery success or failure.



The application health endpoint is:



http://localhost/health

7\. Automated Recovery Workflow



The complete CloudRescue recovery process is:



systemd Timer

&#x20;     ↓

Health Check Script

&#x20;     ↓

Application Health Check

&#x20;     ↓

&#x20;     ├── HEALTHY

&#x20;     │      ↓

&#x20;     │   Continue Monitoring

&#x20;     │

&#x20;     └── UNHEALTHY

&#x20;            ↓

&#x20;     Recovery Script

&#x20;            ↓

&#x20;     Restart Apache

&#x20;            ↓

&#x20;     Verify Application

&#x20;            ↓

&#x20;     HEALTHY

8\. Fully Automated Recovery Test



Apache was stopped manually to simulate an application failure:



sudo systemctl stop httpd



The systemd timer automatically executed the health-check service.



The logs were checked using:



sudo journalctl -u cloudrescue-health-check.service --no-pager -n 30



The following results were observed:



CloudRescue application is UNHEALTHY

Starting automated recovery

CloudRescue recovery successful



The next health check confirmed:



CloudRescue application is HEALTHY



The Apache service was verified:



sudo systemctl is-active httpd



Result:



active



The application health endpoint was also verified:



curl -f http://localhost/health



Result:



OK

9\. Final Test Result



The automated recovery test successfully demonstrated:



Apache Running

&#x20;     ↓

Apache Stopped

&#x20;     ↓

Health Check Detects Failure

&#x20;     ↓

UNHEALTHY Detected

&#x20;     ↓

Recovery Script Automatically Executed

&#x20;     ↓

Apache Restarted

&#x20;     ↓

Recovery Successful

&#x20;     ↓

HEALTHY Detected

&#x20;     ↓

Health Endpoint Returns OK

10\. Phase 4 Completed Tasks

&#x20;Recovery script created

&#x20;Recovery script made executable

&#x20;Healthy service test completed

&#x20;Unhealthy service simulated

&#x20;Manual recovery tested

&#x20;Apache automatically restarted

&#x20;Recovery logging implemented

&#x20;Recovery integrated with health monitoring

&#x20;Automatic recovery tested through systemd timer

&#x20;Application health verified after recovery

11\. Skills Practiced

Bash scripting

Linux service management

Apache recovery

systemd timers

systemd services

Automated failure recovery

Log file management

journalctl log analysis

Linux troubleshooting

Self-healing infrastructure concepts

Phase 4 Result



Phase 4 successfully transformed CloudRescue from a monitoring system into a basic self-healing system.



The application can now:



Detect failure.

Automatically attempt recovery.

Restart the failed Apache service.

Verify the recovery.

Return the application to a healthy state.



Phase 4 – Self-Healing and Cloud Monitoring
Objective

The objective of Phase 4 was to enhance CloudRescue with automated recovery and CloudWatch monitoring capabilities.

Implementation

A health-check script was created to monitor the Apache HTTPD service. When Apache was running, the application was marked as HEALTHY.

When Apache was stopped, CloudRescue detected the failure and automatically:

Detected that Apache was not running.
Started the recovery process.
Restarted the Apache service.
Verified that the service was running again.
Recorded the recovery event in the recovery log.

The recovery process was tested successfully by manually stopping Apache.

CloudWatch Monitoring

The CloudRescue recovery log was connected to Amazon CloudWatch Logs.

A metric filter was created to detect the following recovery event:

Apache is not running. Attempting recovery...

A custom CloudWatch metric was created:

Namespace: CloudRescue
Metric Name: RecoveryAttempt

A CloudWatch alarm was then created to trigger when:

RecoveryAttempt >= 1
SNS Notification

The CloudWatch alarm was connected to an Amazon SNS topic:

CloudRescue-Alerts

The SNS email subscription was confirmed successfully, and an email notification was received when the CloudWatch alarm entered the ALARM state.

Phase 4 Result

CloudRescue successfully became a basic self-healing and monitoring system.

The complete workflow is:

Apache Failure
      ↓
CloudRescue Detects Failure
      ↓
Automatic Recovery
      ↓
Apache Restarted
      ↓
Recovery Logged
      ↓
CloudWatch Metric Created
      ↓
CloudWatch Alarm Triggered
      ↓
SNS Email Notification Sent
Phase 4 Status

Phase 4 completed successfully.

