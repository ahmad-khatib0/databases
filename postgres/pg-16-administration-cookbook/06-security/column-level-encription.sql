-- ## Using column-level encryption
-- ++ In order to create and manage Pretty Good Privacy (PGP) keys, you also need the 
--    well-known GnuPG command-line utility,
-- # 1- install pgcrypto 
-- # 2- You also need to have PGP keys set up:
-- $ gpg --gen-key
-- # Answer some questions here (the defaults are OK unless you are an expert), 
--   select the key type as DSA and Elgamal, and enter an empty password.
-- # 3- Now, export the keys: 
-- $ gpg -a --export "PostgreSQL User (test key for PG Cookbook) <pguser@somewhere.net>" > public.key
-- $ gpg -a --export-secret-keys "PostgreSQL User (test key for PG Cookbook) <pguser@somewhere.net>" > secret.key
-- # 4- Make sure only you and the postgres database user have access to the secret key:
-- $ sudo chgrp postgres secret.key
-- $ chmod 440 secret.key

-- To ensure that secret keys are never visible in database logs, you should write a wrapper function
-- to retrieve the keys from the file. You need to create a SECURITY DEFINER function as a user who
-- has the pg_read_server_files privilege or role assigned to them. For convenience, below is an
-- example that illustrates how to write a function to read a key from a secret file

CREATE OR REPLACE FUNCTION get_my_public_key() RETURNS TEXT
SECURITY DEFINER
LANGUAGE SQL
AS
$function_body$
  SELECT pg_read_file ('/home/pguser/public.key');
$function_body$;

REVOKE ALL ON FUNCTION get_my_public_key() FROM PUBLIC;

CREATE OR REPLACE FUNCTION get_my_secret_key() RETURNS TEXT
SECURITY DEFINER
LANGUAGE SQL
AS
$function_body$
  SELECT pg_read_file ('/home/pguser/secret.key');
$function_body$;


REVOKE ALL ON FUNCTION get_my_secret_key() FROM PUBLIC;


-- This can also be fully implemented in PL/pgSQL, using the built-in pg_read_file (filename)
-- PostgreSQL system function. To use this function, you must place the files in the data directory,
-- as required by that function for added security, so that the database user cannot access the rest
-- of the filesystem directly. However, using that file needs pg_read_server_files privilege unless
-- granted via a role or accessed using security definer functions.

-- If you don’t want other database users to be able to see the keys, you also need to write wrapper
-- functions for encryption and decryption, and then give end users access to these wrapper functions.
-- The encryption function could look like this:

create or replace function encrypt_using_my_public_key(
  cleartext text,
  ciphertext out bytea
)
AS $$
DECLARE
  pubkey_bin bytea;
BEGIN
-- text version of public key needs to be passed through function dearmor() to get to raw key
  pubkey_bin := dearmor(get_my_public_key());
  ciphertext := pgp_pub_encrypt(cleartext, pubkey_bin);
END;
$$ language plpgsql security definer;

revoke all on function encrypt_using_my_public_key(text) from public;
grant execute on function encrypt_using_my_public_key(text) to bob;


-- The decryption function could look like this:
create or replace function decrypt_using_my_secret_key(
  ciphertext bytea,
  cleartext out text
)
AS $$
DECLARE
  secret_key_bin bytea;
BEGIN
-- text version of secret key needs to be passed through function dearmor() to get to raw binary key
  secret_key_bin := dearmor(get_my_secret_key());
  cleartext := pgp_pub_decrypt(ciphertext, secret_key_bin);
END;
$$ language plpgsql security definer;

revoke all on function decrypt_using_my_secret_key(bytea) from public;
grant execute on function decrypt_using_my_secret_key(bytea) to bob;



-- ##########################3
-- Finally, we test the encryption:
select encrypt_using_my_public_key('X marks the spot!');
-- This function returns a bytea (that is, raw binary) result that looks something like this:
-- \301\301N\003\223o\215\2125\203\252;\020\007\376-z\233\211H...

-- To see that it actually works, you must run both commands:
select decrypt_using_my_secret_key(encrypt_using_my_public_key('X marks the spot!'));
-- X marks the spot!


-- #############################
-- There’s more...
-- A higher level of security is possible with more complex procedures and architecture,

-- In those cases, you can use public-key cryptography, also known as asymmetric cryptography,
-- and carry out only the encryption part on the database server. This also means that you only have
-- the encryption key on the database host and not the key needed for decryption. Alternatively, you
-- can deploy a separate, extra-secure encryption server in your server infrastructure that provides
-- just the encrypting and decrypting functionality as a remote call.


-- For really, really, really sensitive data:
-- For even more sensitive data, you may never want the data to leave the client’s computer un-
-- encrypted; therefore, you need to encrypt the data before sending it to the database. In that
-- case, PostgreSQL receives already encrypted data and never sees the unencrypted version. This
-- also means that the only useful indexes you can have are for use in WHERE encrypted_column =
-- encrypted_data and to ensure uniqueness.



