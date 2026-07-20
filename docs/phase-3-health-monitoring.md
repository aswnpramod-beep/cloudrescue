\# Phase 3: Health Monitoring and Failure Detection



\## 1. Objective



The objective of Phase 3 was to implement automated health monitoring for the CloudRescue application.



The system was designed to:



\- Check the application health endpoint.

\- Detect healthy and unhealthy states.

\- Run health checks automatically.

\- Record health-check results in system logs.



\---



\## 2. Health Check Endpoint



The CloudRescue application provides the following health endpoint:



```text

http://localhost/health



When the application is healthy:



OK

\## 3. Create Health Check Script



A Bash script was created to monitor the application health.



Script Location

/usr/local/bin/cloudrescue-health-check.sh



Script



\#!/bin/bash



HEALTH\_URL="http://localhost/health"



if curl -fs "$HEALTH\_URL" > /dev/null; then

&#x20;   echo "$(date): CloudRescue application is HEALTHY"

&#x20;   exit 0

else

&#x20;   echo "$(date): CloudRescue application is UNHEALTHY"

&#x20;   exit 1

fi



The script returns:



0 → Healthy

1 → Unhealthy





\## 4. Make the Script Executable

sudo chmod +x /usr/local/bin/cloudrescue-health-check.sh



The script was successfully given execute permissions.



\## 5. Manual Health Check Test



The script was executed manually:



sudo /usr/local/bin/cloudrescue-health-check.sh

Healthy Result

CloudRescue application is HEALTHY



The script returned exit code:



0



This confirmed that the application was healthy.



\## 6. Failure Detection Test



To simulate an application failure, the Apache service was stopped:



sudo systemctl stop httpd



The service status was verified:



sudo systemctl is-active httpd

Result

inactive



The health-check script was executed again:



sudo /usr/local/bin/cloudrescue-health-check.sh

Result



CloudRescue application is UNHEALTHY



The script returned exit code:



1



\###This confirmed that the health-check script successfully detected the application failure.



\## 7. Restore the Application



Apache was started again:



sudo systemctl start httpd



The service status was verified:



sudo systemctl is-active httpd



Result



active



The application health endpoint was also tested:



curl -f http://localhost/health

Result

OK

\## 8. Automated Health Monitoring



To run the health check automatically, a systemd service was created.



Service File

/etc/systemd/system/cloudrescue-health-check.service

Service Configuration



\[Unit]

Description=CloudRescue Application Health Check



\[Service]

Type=oneshot

ExecStart=/usr/local/bin/cloudrescue-health-check.sh



A systemd timer was also created.



Timer File

/etc/systemd/system/cloudrescue-health-check.timer



Timer Configuration



\[Unit]

Description=Run CloudRescue Health Check Every Minute



\[Timer]

OnBootSec=1min

OnUnitActiveSec=1min

Unit=cloudrescue-health-check.service



\[Install]

WantedBy=timers.target



\## 9. Enable Automatic Monitoring



The systemd configuration was reloaded:



sudo systemctl daemon-reload



The timer was enabled and started:



sudo systemctl enable --now cloudrescue-health-check.timer



The timer was verified using:



systemctl list-timers --all | grep cloudrescue



The timer successfully executed the health-check service approximately every minute.



\## 10. Automated Failure Detection Test



Apache was intentionally stopped:



sudo systemctl stop httpd



The systemd timer automatically executed the health-check service.



The logs were checked using:



sudo journalctl -u cloudrescue-health-check.service --no-pager

Failure Result



CloudRescue application is UNHEALTHY



The service reported:



status=1/FAILURE



\###This was expected because the health-check script correctly detected the failed application.



\## 11. Recovery Verification



Apache was started again:



sudo systemctl start httpd



After the next automatic health check, the logs showed:



CloudRescue application is HEALTHY



The final application health was verified:



curl -f http://localhost/health

Result



OK



\## 12. Phase 3 Final Result



Phase 3 successfully implemented automated health monitoring and failure detection for the CloudRescue application.



Completed Tasks

\[✓] Health-check Bash script created

\[✓] Script made executable

\[✓] Healthy application detected

\[✓] Apache failure simulated

\[✓] Unhealthy application detected

\[✓] systemd service created

\[✓] systemd timer created

\[✓] Automatic health checks configured

\[✓] Failure recorded in systemd journal

\[✓] Application restored

\[✓] Healthy state verified again





Skills Practiced

Bash scripting

Linux exit codes

Apache service management

systemd services

systemd timers

Automated monitoring

journalctl log analysis

Linux troubleshooting



Phase 3 completed successfully.

