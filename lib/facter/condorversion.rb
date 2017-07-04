Facter.add('condorversion') do

  confine :operatingsystem => "CentOS"

  setcode do

    result = "000000"
    if File.exists?("/usr/bin/condor_status")

      #cmdline = "/usr/bin/condor_status -collector -format \"%s\" CondorVersion 2>/dev/null | awk '{print $2}'"
      cmdline = "/usr/bin/rpm -q --qf '%{Version}' condor | grep -Eo '[0-9]+.[0-9]+.[0-9]+'"
      verStr = Facter::Util::Resolution.exec(cmdline)

      verTuple = verStr.split(".")
      while verTuple.length < 3 do
        verTuple.push("0")
      end

      result = "%02d%02d%02d" % verTuple

    end

    result

  end
end
