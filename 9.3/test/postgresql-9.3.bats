#!/usr/bin/env bats

@test "It should install PostgreSQL 9.3.22" {
  /usr/lib/postgresql/9.3/bin/postgres --version | grep "9.3.22"
}
