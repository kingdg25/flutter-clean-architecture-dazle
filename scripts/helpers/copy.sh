#!/usr/bin/env bash
rm -f productionDB.json
firestore-export --accountCredentials /var/lib/jenkins/kahero/kahero-production-service-account.json --backupFile productionDB.json
firestore-import --accountCredentials /var/lib/jenkins/kahero/kahero-staging-service-account.json --backupFile productionDB.json --yes
rm -f users.json
firebase --token 1//0eg77koataadsCgYIARAAGA4SNwF-L9IrB8Yyeke1kAKzEtDIB6-Jek94-QEznDX3nvPTc_lpTJ3h8Jx32zYmxnqk_YSciBsDESk auth:export users.json --format=json --project kahero-8dfde
firebase --token 1//0eg77koataadsCgYIARAAGA4SNwF-L9IrB8Yyeke1kAKzEtDIB6-Jek94-QEznDX3nvPTc_lpTJ3h8Jx32zYmxnqk_YSciBsDESk auth:import users.json --hash-algo=scrypt --rounds=8 --mem-cost=14 --hash-key=Rm60FLCNOs3Ui0Dyq0eAbdRZOhNKsuvFkPonwL8DBouqkbe4XLwEiWJm/feIHIdx8fuYAYQ9LKi6N0TUn5L96g== --salt-separator=Bw== --project kahero-staging
gsutil -m cp -r gs://kahero-8dfde.appspot.com/items gs://kahero-staging.appspot.com/



