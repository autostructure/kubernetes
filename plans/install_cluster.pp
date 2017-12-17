plan kubernetes::install_cluster(
  Enum['false', 'true'] $install_kubeadm = 'false',
  Enum['false', 'true'] $install_heapster = 'true',
  Enum['false', 'true'] $install_dashboard = 'true',
  String[1] $master,
  String[1] $worker_nodes,
) {
  # $install_kubeadm_bol = str2bool($install_kubeadm)
  # $install_heapster_bol = str2bool($install_heapster)
  # $install_dashboard_bol = str2bool($install_dashboard)


  if $install_kubeadm {
    # Worker nodes array
    $worker_nodes_array = split($worker_nodes, ',')

    # Install puppet and kubeadm_init
    notice("Installing kubeadm on master ${master}.")

    $kubeadm_master_install_results = run_script('kubernetes/install_kubeadm.sh', $master)

    $kubeadm_master_install_results.each |$node, $result| {
      case $result {
        Error : {
          fail("${node} errored with message ${result.message}")
        }
        default: {
          notice("Kubeadm install complete on master ${node}.")
        }
      }
    }

    notice "Installing kubeadm on nodes ${worker_nodes}."

    $kubeadm_nodes_install_results = run_script('kubernetes/install_kubeadm.sh', $worker_nodes_array)

    $kubeadm_nodes_install_results.each |$node, $result| {
      case $result {
        Error : {
          fail("${node} errored with message ${result.message}")
        }
        default: {
          notice("Kubeadm install complete on node ${node}.")
        }
      }
    }
  }

  # Initialize the master
  $kubeadm_init_results = run_task('kubernetes::kubeadm_init', $master,
                                    { pod_network_cidr => '10.244.0.0/16', skip_preflight_checks => 'true' } )

  notice $kubeadm_init_results

  $kubeadm_init_results.each |$node, $result| {
    case $result {
      Error : {
        fail("${node} errored with message ${result.message}")
      }
      default: {
        notice("Kubeadm initialization complete on master ${node}.")
      }
    }
  }

  notice("The init results ${kubeadm_init_results}")

  $token = $kubeadm_init_results[$master]['token']
  $discovery_token_ca_cert_hash = $kubeadm_init_results[$master]['discovery-token-ca-cert-hash']

  notice('Record these values. They are required to join future nodes to the cluster.')
  notice("Token: ${token}")
  notice("Discovery Token CA Cert Hash. ${discovery_token_ca_cert_hash}")

  # Install flannel
  $kubectl_flannel_results = run_task('kubernetes::kubectl_apply', $master,
                              { filename => 'https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml' })

  $kubectl_flannel_results.each |$node, $result| {
    case $result {
      Error : {
        fail("${node} errored with message ${result.message}")
      }
      default: {
        notice("Flannel network installed on master ${node}.")
      }
    }
  }
  # run_script('kubernetes/install_flannel_network.sh', $master)

  # Join the nodes
  $kubadm_join_results = run_task('kubernetes::kubeadm_join', $worker_nodes_array,
            { token => $token, discovery_token_ca_cert_hash => $discovery_token_ca_cert_hash })

  $kubadm_join_results.each |$node, $result| {
    case $result {
      Error : {
        fail("${node} errored with message ${result.message}")
      }
      default: {
        notice("${node} joined the master.")
      }
    }
  }

  if $install_heapster {
    run_task('kubernetes::kubectl_apply', $master,
      { filename => 'https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml' })

    run_task('kubernetes::kubectl_apply', $master,
      { filename => 'https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml' })

    run_task('kubernetes::kubectl_apply', $master,
      { filename => 'https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml' })

    run_task('kubernetes::kubectl_apply', $master,
      { filename => 'https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml' })
  }

  if $install_dashboard {
    $kubectl_dashboard_results = run_task('kubernetes::kubectl_apply', $master,
                                { filename => 'https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml' })

    $kubectl_dashboard_results.each |$node, $result| {
      case $result {
        Error : {
          fail("${node} errored with message ${result.message}")
        }
        default: {
          notice('Kubernetes dashboard installed.')
        }
      }
    }
  }
}
