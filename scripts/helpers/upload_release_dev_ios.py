import firebase_admin
import sys
from firebase_admin import credentials, firestore, storage

cred=credentials.Certificate('kahero-staging-service-account.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'kahero-build'
})
db = firestore.client()
bucket = storage.bucket()
blob = bucket.blob('staging/kahero-pos-dev-' + sys.argv[1] + '.ipa')
outfile='/Users/kahero/builds/ssPBrYgL/0/kahero-team/pos/ios/Runner.ipa'
with open(outfile, 'rb') as my_file:
    blob.upload_from_file(my_file)

