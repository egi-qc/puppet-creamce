Facter.add(:istorqueinstalled) do

  confine :operatingsystem => "CentOS"
  
  setcode do
    if File.exists?("/var/lib/torque/server_priv/serverdb")
      true
    else
      false
    end
  end
  
end
