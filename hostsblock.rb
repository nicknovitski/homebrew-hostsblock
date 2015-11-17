class Hostsblock < Formula
  desc "ad- and malware-blocking cronscript"
  homepage "https://gaenserich.github.io/hostsblock/"
  head "https://github.com/gaenserich/hostsblock.git"

  depends_on "gnu-sed"
  depends_on "homebrew/dupes/grep"
  depends_on "p7zip" => :optional

  def install
    inreplace Dir["src/*"], "/etc/hostsblock/", "#{etc}/hostsblock/"
    %w[sed grep].each do |c|
      inreplace Dir["src/*"], /([^\w])#{c}/, "\\1g#{c}"
    end

    inreplace "src/hostsblock-common.sh" do |s|
      s.gsub!("unzip -B", "unzip")
      s.gsub!('\e', '\\\033')
      s.gsub!("/bin/true", "/usr/bin/true")
    end
    lib.install "src/hostsblock-common.sh"

    commands = %w[hostsblock] # do not install urlcheck yet
    inreplace commands.map { |c| "src/#{c}.sh" }, "/usr/local/lib", lib
    commands.each { |command| bin.install "src/#{command}.sh" => command }

    inreplace "conf/hostsblock.conf" do |s|
      s.gsub!("/etc/hostsblock", "#{etc}/hostsblock")
      s.gsub!("/dev/shm", "/tmp")
    end
    mkdir_p etc/"hostsblock"
    %w[black.list hostsblock.conf white.list].each do |f|
      etc.install "conf/#{f}" => "hostsblock/#{f}"
    end

    suffix = File.exist?("#{etc}/hostsblock/hosts.head") ? "pre-hostsblock" : "head"
    cp "/etc/hosts", "#{etc}/hostsblock/hosts.#{suffix}", :verbose => true
  end

  def caveats; <<-EOS.undent
    Edit the documented config file at `#{etc}/hostsblock/hostsblock.conf`,
    then run `sudo hostsblock` to overwrite `/etc/hosts` with the configured
    sources.

    The provided launchd service will update the hosts file once a day.
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/hostsblock</string>
          <string>-f</string>
          <string>#{etc}/hostsblock/hostsblock.conf</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>KeepAlive</key>
        <false/>
        <key>StartCalendarInterval</key>
        <dict>
            <key>Hour</key>
            <integer>04</integer>
            <key>Minute</key>
            <integer>12</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
