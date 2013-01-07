from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, ForeignKey, MetaData

engine = create_engine('sqlite:///apns.db', echo=True)
metadata = MetaData()

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()


class Lab(Base):
    __tablename__ = 'labs'
    id = Column('id', Integer, primary_key=True)
    name =  Column('name', String)
    capacity = Column('max_capacity', Integer)
    current_usage = Column('current_usage', Integer)
    device_ids = Column('device_id', None, ForeignKey('devices.id'))

class Device(Base):
    __tablename__ = 'devices'
    id = Column('id', Integer, primary_key=True)
    udid = Column('udid', String)
    access_token = Column('access_token', String)


def create_all():
    metadata.create_all(engine)
