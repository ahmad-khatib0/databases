SET CLUSTER SETTING cloudstorage.gs.default.key = '{
  "type": "service_account",
  "project_id": "ghreqs",
  "private_key_id": "048d8 Blah blah eef9fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANB SORRY I CANT SHARE THIS ykfy5cPMvVixA9etdg==\n-----END PRIVATE KEY-----\n",
  "client_email": "592053976296-compute@developer.gserviceaccount.com",
  "client_id": "112395942388993483786",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/592053976296-compute%40developer.gserviceaccount.com"
}';

BACKUP INTO 'gs://ghcrdb/full.backup' ;

-- written to a Google Cloud destination.
backup database bank into 'gs://ghcrdb/bank.backup' ;

backup database bank into 'userfile://bank.backup/';

# A full backup copies all data and all metadata
BACKUP INTO 'gs://ghcrdb/full.backup';

BACKUP INTO 'nodelocal://1/onehourago.backup/' AS OF SYSTEM TIME '-1h';

BACKUP INTO 'nodelocal://1/fullClusterBackup/';

SHOW BACKUPS IN 'nodelocal://1/fullClusterBackup/';

BACKUP TABLE movr.rides, movr.users INTO 'nodelocal://1/movr.rides.backup/';

BACKUP DATABASE movr INTO 'nodelocal://1/movr.full.backup/';
