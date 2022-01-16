# plpgsql-ulid-generator

PostgreSQL function for generating ULID as UUID on  plpgsql

```sql
select ulid();                          --017e61c1-d833-4af7-70c7-8444ae1d207a
select ulid('2022-01-16 05:48:00');     --017e616d-9a80-0000-0000-000000000000
```

Used for monotonic ids and for partitioning by it

```plpgsql
CREATE TABLE "table" (
  id text primary key not null default ulid(),
  ...
) partition by range (id);

CREATE TABLE table_2021 partition of "table" for values
  from
    (ulid('2021-01-01'))
  to
    (ulid('2022-01-01'));
```
