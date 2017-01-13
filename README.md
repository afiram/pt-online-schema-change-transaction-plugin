# pt-online-schema-change-transaction-plugin

https://www.percona.com/doc/percona-toolkit/2.2/pt-online-schema-change.html

* use transaction in [before_swap_tables - after_update_foreign_keys]

## Usage

```sh
pt-online-schema-change ... \
  --alter-foreign-keys-method=rebuild_constraints \
  --plugin pt-osc-transaction-plugin.pl \
  ...
```
