Phase 5 – CloudWatch Monitoring and SNS Alerting

Objective



The objective of Phase 5 was to integrate CloudRescue recovery monitoring with Amazon CloudWatch and Amazon SNS to detect recovery events and send email notifications.



1\. CloudWatch Custom Metric



A custom CloudWatch metric was created:



Namespace: CloudRescue

Metric Name: RecoveryAttempt



The recovery script publishes a metric whenever an automated Apache recovery attempt occurs.



2\. CloudWatch Alarm



The following alarm was created:



Alarm Name: CloudRescue-Recovery-Alarm

Metric: RecoveryAttempt

Condition: RecoveryAttempt >= 1

Period: 1 minute

Statistic: Sum



The alarm detects when CloudRescue performs an automated recovery operation.



3\. SNS Notification



An SNS topic was created:



Topic Name: CloudRescue-Alerts



An email subscription was configured and successfully confirmed.



The SNS topic was connected to the CloudWatch alarm.



4\. Failure Simulation and Testing



Apache was intentionally stopped to simulate an application failure:



sudo systemctl stop httpd



The CloudRescue recovery script detected the failure and automatically restarted Apache.



The recovery logs confirmed:



Apache is not running. Attempting recovery...

Apache recovery successful



The recovery metric was then published to CloudWatch.



5\. Alarm State Verification



The CloudWatch alarm successfully changed state:



INSUFFICIENT\_DATA → ALARM



The alarm history confirmed that the SNS action was successfully executed:



Successfully executed action:

arn:aws:sns:ap-south-1:134153358151:CloudRescue-Alerts



An email notification was successfully received.



The alarm later changed state:



ALARM → INSUFFICIENT\_DATA



This confirmed that the alarm was correctly monitoring the recovery metric.



6\. End-to-End Workflow

Apache Failure

&#x20;     ↓

CloudRescue Detects Failure

&#x20;     ↓

Automatic Apache Recovery

&#x20;     ↓

RecoveryAttempt Metric Published

&#x20;     ↓

CloudWatch Alarm Changes to ALARM

&#x20;     ↓

SNS Notification Triggered

&#x20;     ↓

Email Alert Received

Skills Practiced

Amazon CloudWatch custom metrics

CloudWatch alarms

Alarm state transitions

Amazon SNS

Email notification configuration

Monitoring automated recovery

CloudWatch alarm history analysis

End-to-end cloud monitoring

Linux and AWS integration

Phase 5 Result



Phase 5 was completed successfully.



CloudRescue can now:



Detect application failures.

Automatically recover the Apache service.

Publish recovery events to CloudWatch.

Trigger a CloudWatch alarm.

Send notifications through Amazon SNS.

Notify the administrator through email.

Phase 5 Status: ✅ COMPLETED

