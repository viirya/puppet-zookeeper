# /etc/puppet/modules/zookeeper/manifests/master.pp

define zookeeperprinciple {
    exec { "create Zookeeper principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey zookeeper/$name@${zookeeper::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-zookeeper-${name}",
        onlyif => "test ! -e ${zookeeper::params::keytab_path}/${name}.zookeeper.service.keytab",
    }
}
 
define zookeeperkeytab {
    exec { "create Zookeeper keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${zookeeper::params::keytab_path}/${name}.zookeeper.service.keytab zookeeper/$name@${zookeeper::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        onlyif => "test ! -e ${zookeeper::params::keytab_path}/${name}.zookeeper.service.keytab",
        alias => "create-keytab-zookeeper-${name}",
        require => [ Exec["add-princ-zookeeper-${name}"] ],
    }
}
 
define zkcliprinciple {
    exec { "create Zookeeper Client principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey zkcli/$name@${zookeeper::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-zkcli-${name}",
        onlyif => "test ! -e ${zookeeper::params::keytab_path}/${name}.zkcli.service.keytab",
    }
}
 
define zkclikeytab {
    exec { "create Zookeeper Client keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${zookeeper::params::keytab_path}/${name}.zkcli.service.keytab zkcli/$name@${zookeeper::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        onlyif => "test ! -e ${zookeeper::params::keytab_path}/${name}.zkcli.service.keytab",
        alias => "create-keytab-zkcli-${name}",
        require => [ Exec["add-princ-zkcli-${name}"] ],
    }
}
class zookeeper::cluster::kerberos {

    require zookeeper::params
 
    if $zookeeper::params::kerberos_mode == "yes" {

        file { "${zookeeper::params::keytab_path}":
            ensure => "directory",
            owner => "root",
            group => "${zookeeper::params::zookeeper_group}",
            mode => "750",
            alias => "keytab-path",
        }
 
        zookeeperprinciple { $zookeeper::params::servers: 
            require => File["keytab-path"],
        }
 
        zookeeperkeytab { $zookeeper::params::servers: 
            require => File["keytab-path"],
        }
 
        zkcliprinciple { $zookeeper::params::servers: 
            require => File["keytab-path"],
        }
 
        zkclikeytab { $zookeeper::params::servers: 
            require => File["keytab-path"],
        }
 
    } 
}

class zookeeper::cluster ($server_id) {

    require zookeeper::params

    class {'zookeeper':
        server_id => $server_id,
    }

    exec { "Launch zookeeper":
        command => "./zkServer.sh start",
        user => "${zookeeper::params::zookeeper_user}",
        cwd => "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}/bin",
        path    => ["/bin", "/usr/bin", "${zookeeper::params::zookeeper_base}/zookeeper-${zookeeper::params::version}/bin", "${java::params::java_base}/jdk${java::params::java_version}/bin"],
        require => [ File["zookeeper-myid"], File["zoo-cfg"] ],
    }
 
}

