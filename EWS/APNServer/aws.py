import boto

s3 = boto.connect_s3()
bucket = s3.create_bucket()

s
