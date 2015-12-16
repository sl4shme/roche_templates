class heat::prepare_sql (
    $mysqlPass,
    $mysqlUser,
    $mysqlDb,
    $mysqlRootPwd
) {

  $realUser = "$mysqlUser@%"

  class { 'mysql::server':
    root_password    => $mysqlRootPwd,
    override_options => {
      mysqld => { bind-address => '0.0.0.0'}
    },
    notify           => Exec['restart_mysql']
  }

  exec {'restart_mysql':
    command => "/usr/sbin/service mysql restart",
    require => Class['mysql::server']
    }

  class { 'mysql::client': }

  mysql_user { $realUser:
    ensure        => present,
    password_hash => mysql_password($mysqlPass),
    require => Exec['restart_mysql']
  }

  mysql_database { $mysqlDb:
    ensure  => present,
    require => Mysql_user[$realUser]
  }

  mysql_grant { "$realUser/$mysqlDb.*":
    ensure     => present,
    privileges => ["ALL"],
    table      => "$mysqlDb.*",
    user       => "$realUser",
    require => Mysql_database[$mysqlDb]
  }
}
