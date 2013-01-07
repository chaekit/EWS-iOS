from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, ForeignKey, MetaData

engine = create_engine('sqlite:///apns.db', echo=True)
metadata = MetaData()

devices = Table('devices', metadata,
    Column('id', Integer, primary_key=True),
    Column('udid', String),
    Column('access_token', String)
)

labs = Table('labs', metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String),
    Column('max_capacity', Integer),
    Column('current_usage', Integer),
    Column('device_id', None, ForeignKey('devices.id'))
)


metadata.create_all(engine)


inserts = [
    labs.insert().values(name="DCL L416", max_capacity=29, current_usage=0),
    labs.insert().values(name="DCL L440", max_capacity=26, current_usage=0),
    labs.insert().values(name="DCL L529", max_capacity=41, current_usage=0),
    labs.insert().values(name="EH 406B1", max_capacity=40, current_usage=0),
    labs.insert().values(name="EH 406B8", max_capacity=40, current_usage=0),
    labs.insert().values(name="EVRT 252", max_capacity=39, current_usage=0),
    labs.insert().values(name="GELIB 057", max_capacity=40, current_usage=0),
    labs.insert().values(name="GELIB 4th", max_capacity=39, current_usage=0),
    labs.insert().values(name="MEL 1001", max_capacity=25, current_usage=0),
    labs.insert().values(name="MEL 1009", max_capacity=40, current_usage=0),
    labs.insert().values(name="SIEBL 0218", max_capacity=21, current_usage=0),
    labs.insert().values(name="SIEBL 0220", max_capacity=21, current_usage=0),
    labs.insert().values(name="SIEBL 0222", max_capacity=21, current_usage=0)
]

print inserts



conn = engine.connect()
