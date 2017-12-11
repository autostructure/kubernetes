plan kubernetes::install_cluster(
  Variant[String[1], Array[String[1]]  $kubectl_users,
  Variant[String[1], Array[String[1]]  $masters,
  Variant[String[1], Array[String[1]]  $nodes,
) {
# (
#   String[1]                            $load_balancer,
#   Variant[String[1], Array[String[1]]  $frontends,
#   Variant[String[1], Array[String[1]]  $backends,
# ) {
#
#   # process frontends
#   run_task('mymodule::lb_remove', $load_balancer, frontends => $frontends)
#   run_task('mymodule::update_frontend_app', $frontends, version => '1.2.3')
#   run_task('mymodule::lb_add', $load_balancer, frontends => $frontends)

  $join_values = run_task('kubernetes::kubeadm_init', $masters)
  $values2 = run_task('kubernetes::tester_reader', $master) # , major => $values['major'], minor => $values['minor'])
}
