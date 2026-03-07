def src [] {
  nrs
  let lockfile = (ff-lockfile)
  if ($lockfile | path exists) { rm $lockfile }
  source /etc/nixos/nushell/custom.nu
}
