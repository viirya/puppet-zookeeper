
# Puppet module for deploying Apache Zookeeper in clustered setup

This module deploys Apache Zookeeper cluster. It is tested with Apache Zookeeper 3.4.5 under puppet agent/master environment.

# Usage

After installing this module in puppet master node, in site.pp, defining:

    node 'server1' {
        include java
        class {'zookeeper::cluster':
            server_id => '1',
        }
    }
    
    node 'server2' {
        include java
        class {'zookeeper::cluster':
            server_id => '2',
        }
    }
    
    node 'server3' {
        include java
        class {'zookeeper::cluster':
            server_id => '3',
        }
    }

Downloading Apache Zookeeper package and putting the file under 'files' subdir of this module.

Please also modify parameters such as 'servers' in manifests/params.pp.

