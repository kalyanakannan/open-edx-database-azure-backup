# open-edx-database-azure-backup
script for backup openedx databases both mysql and mongodb. and store in azure storage account.
for daily backup add following line in your crontab

<code>crontab -e</code>
<code>@daily  sudo sh /path/open-edx-database-azure-backup.sh</code>
