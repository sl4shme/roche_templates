class heat::prepare_sql (
#    $mysqlPass,
#    $mysqlUser,
#    $mysqlDb,
    $mysqlRootPwd
) {

  class { '::mysql::server':
    root_password => $mysqlRootPwd
  }

  class { '::mysql::client': }
}
