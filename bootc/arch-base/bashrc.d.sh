
if [[ -d /etc/bashrc.d ]]; then
  for rc in /etc/bashrc.d/*; do
    . $rc
  done
  unset rc
fi