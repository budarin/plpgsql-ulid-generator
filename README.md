# plpgsql-ulid-generator

PostgreSQL function for generating ULID as UUID on  plpgsql

```sql
select ulid('2022-01-01');     -- 017e12ef-9c00-0000-0000-000000000000
select ulid();                 -- 017e61c1-d833-4af7-70c7-8444ae1d207a
```

Used for monotonic ids and for partitioning tables using on them

```plpgsql
CREATE TABLE "table" (
  id uuid primary key not null default ulid(),
  ...
) partition by range (id);


CREATE TABLE table_2021 partition of "table" for values
  from
    (ulid('2021-01-01'))
  to
    (ulid('2022-01-01'));
```

The UUID format in Postgres is more compact than text as in ULID specification
