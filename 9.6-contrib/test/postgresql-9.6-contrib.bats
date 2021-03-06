#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/test_helper.sh"

@test "It should install PostgreSQL 9.6.8" {
  /usr/lib/postgresql/9.6/bin/postgres --version | grep "9.6.8"
}

@test "It should support PLV8" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION plv8;"
  sudo -u postgres psql --command "CREATE EXTENSION plls;"
  sudo -u postgres psql --command "CREATE EXTENSION plcoffee;"
}

@test "It should support plpythonu" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION plpythonu;"
}

@test "It should support plpython2u" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION plpython2u;"
}

@test "It should support plpython3u" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION plpython3u;"
}

@test "It should support mysql_fdw" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION mysql_fdw;"
}

@test "It should support multicorn" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE EXTENSION multicorn;"
}

@test "It should support plperl" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE LANGUAGE plperl;"
}

@test "It should support plperlu" {
  initialize_and_start_pg
  sudo -u postgres psql --command "CREATE LANGUAGE plperlu;"
}

@test "It should support pglogical" {
  dpkg-query -l postgresql-${PG_VERSION}-pglogical
  initialize_and_start_pg
  sudo -u postgres psql --command "ALTER SYSTEM SET shared_preload_libraries='pglogical';"
  restart_pg
  sudo -u postgres psql --command "CREATE EXTENSION pglogical;"
}

@test "It should support pg-safeupdate" {
  initialize_and_start_pg
  sudo -u postgres psql --command "ALTER SYSTEM SET shared_preload_libraries='safeupdate';"
  restart_pg
  sudo -u postgres psql --command "CREATE TABLE foo (i int);"
  sudo -u postgres psql --command "INSERT INTO foo VALUES (1234);"
  run sudo -u postgres psql --command "DELETE FROM foo;"
  [ "$status" -eq "1" ]
  [ "${lines[0]}" = "ERROR:  DELETE requires a WHERE clause" ]
}

@test "It should support pgaudit" {
  dpkg-query -l "postgresql-${PG_VERSION}-pgaudit"
  initialize_and_start_pg
  sudo -u postgres psql --command "ALTER SYSTEM SET shared_preload_libraries='pgaudit';"
  restart_pg
  sudo -u postgres psql --command "CREATE EXTENSION pgaudit;"
}
