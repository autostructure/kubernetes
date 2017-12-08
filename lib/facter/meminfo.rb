# frozen_string_literal: true
Facter.add(:meminfo) do
  setcode do
    # Get mem usage
    memhash = {}
    meminfo = File.read('/proc/meminfo')

    meminfo.each_line do |i|
      key, val = i.split(':')

      if val.include?('kB') then val = val.gsub(/\s+kB/, ''); end

      memhash[key.to_s] = val.strip
    end

    memhash
  end
end
