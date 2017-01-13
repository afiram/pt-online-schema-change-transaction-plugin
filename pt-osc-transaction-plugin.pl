package pt_online_schema_change_plugin;

use strict;

# --alter-foreign-keys-method=drop_swap -> (FOREIGN_KEY_CHECKS=0)
#eval{  # ...
#};
#if($EVAL_ERROR){
#   die ts("Error: $EVAL_ERROR\n");
#}
# print $sql, "\n" if $o->get('print');$

sub new {
  my ($class, %args) = @_;
  my $self = { %args };
  return bless $self, $class;
}

sub before_swap_tables {
  my ($self, %args) = @_;
  print "[transaction_plugin] start ---------]\n";
  my $sql = "BEGIN;";
  print $sql, "\n" if $self->{print};
  my $dbh = $self->{cxn}->dbh;
  if ($self->{execute}) {
    $dbh->do($sql);
  }
}

sub before_update_foreign_keys {
  my ($self, %args) = @_;
  my $dbh = $self->{cxn}->dbh;
  my $sql = "set foreign_key_checks=0";
  print $sql, "\n" if $self->{print};
  if ($self->{execute}) {
    print "[transaction_plugin] Disable foreign key checks\n";
    $dbh->do($sql);
  }
}

sub after_update_foreign_keys {
  my ($self, %args) = @_;
  my $dbh = $self->{cxn}->dbh;
  if ($self->{execute}) {
    my $sql = "set foreign_key_checks=1";
    print $sql, "\n" if $self->{print};
    print "[transaction_plugin] Enable foreign key checks\n";
    $dbh->do($sql);
  }
  {
      my $sql = "COMMIT;";
      print $sql, "\n" if $self->{print};
      if ($self->{execute}) {
        $dbh->do($sql);
      }
      print "[transaction_plugin] end ---------]\n";
  }
}

1;
