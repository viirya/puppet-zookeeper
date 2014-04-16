# /etc/puppet/modules/zookeeper/manifests/master.pp

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

