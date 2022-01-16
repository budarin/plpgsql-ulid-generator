CREATE OR REPLACE FUNCTION ulid(dt timestamptz = NULL)
RETURNS uuid
AS $$
DECLARE
  -- Crockford's Base32
  encoding   BYTEA = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  timestamp  BYTEA = E'\\000\\000\\000\\000\\000\\000';
  output     uuid;

  unix_time  BIGINT;
  ulid       BYTEA;
  at_now    timestamptz;
BEGIN
  if (dt is NULL) then
  	at_now = current_timestamp;
  else
  	at_now = dt;
  end if;

  -- 6 timestamp bytes
  unix_time = (EXTRACT(EPOCH FROM at_now) * 1000)::BIGINT;
  timestamp = SET_BYTE(timestamp, 0, (unix_time >> 40)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 1, (unix_time >> 32)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 2, (unix_time >> 24)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 3, (unix_time >> 16)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 4, (unix_time >> 8)::BIT(8)::INTEGER);
  timestamp = SET_BYTE(timestamp, 5, unix_time::BIT(8)::INTEGER);

  -- 10 entropy bytes
  if (dt is NULL) then
  	ulid = timestamp || gen_random_bytes(10);
  else
  	ulid = timestamp || '\x00000000000000000000';
  end if;

  output = CAST(substring(ulid::text from 3) AS uuid);

RETURN output;
END
$$
LANGUAGE plpgsql
VOLATILE;
