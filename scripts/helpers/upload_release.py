import firebase_admin
import sys
from firebase_admin import credentials, firestore, storage

cred=credentials.Certificate('kahero-staging-service-account.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'kahero-staging.appspot.com'
})
db = firestore.client()
bucket = storage.bucket()
blob = bucket.blob('releases/kahero-pos-' + sys.argv[1] + '.apk')
outfile='build/app/outputs/apk/release/app-release.apk'
with open(outfile, 'rb') as my_file:
    blob.upload_from_file(my_file)