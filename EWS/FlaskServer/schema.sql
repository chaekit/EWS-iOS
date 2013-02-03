drop table if exists udids;
create table udids (
    id integer primary key autoincrement,
    udid string not null
);

drop table if exists labs;
create table labs (
    id integer primary key autoincrement,
    openLabs integer not null,
    maxLabs integer not null
);
